//
//  GameScene.m
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import "GameScene.h"
#import "GameViewModel.h"
#import "Queue.h"
#import "Constants.h"

static NSString* SnakeBodyNodeName = @"snakeBody";
static NSString* SnakeHeadNodeName = @"snakeHead";
static NSString* FoodNodeName = @"food";
static NSString* SnakeMovingActionName = @"snakeMoving";

@interface GameScene ()

@property (nonatomic, strong) SKLabelNode *startButton;
@property (nonatomic, strong) SKLabelNode *retryButton;
@property (nonatomic, strong) SKLabelNode *failedMsgLabel;
@property (nonatomic, strong) SKSpriteNode *mask;

@property (nonatomic, strong) SKShapeNode *snakeBodyNode;
@property (nonatomic, strong) SKShapeNode *snakeHeadNode;
@property (nonatomic, strong) SKShapeNode *foodNode;

@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view
{
    [self configureNodes];
    [self setupStatus];
    
    [_viewModel addObserver:self forKeyPath:@"snakeInScene" options:0 context:nil];
    [_viewModel addObserver:self forKeyPath:@"foodInScene" options:0 context:nil];
    [_viewModel addObserver:self forKeyPath:@"status" options:0 context:nil];
}

#pragma mark - Private

- (void)configureNodes
{
    _startButton = (SKLabelNode*)[self childNodeWithName:@"//startButton"];
    _startButton.zPosition = 2;

    _retryButton = (SKLabelNode*)[self childNodeWithName:@"//retryButton"];
    _retryButton.zPosition = 2;
    
    _failedMsgLabel = (SKLabelNode*)[self childNodeWithName:@"//failedMessage"];
    _failedMsgLabel.zPosition = 2;
    
    _mask = (SKSpriteNode*)[self childNodeWithName:@"//mask"];
    _mask.zPosition = 2;
    CGSize maskSize = self.size;
    maskSize.width *= 1.5;
    maskSize.height *= 1.5;
    _mask.size = maskSize;
    
    _snakeHeadNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, gridPointSize, gridPointSize)];
    _snakeHeadNode.strokeColor = [SKColor redColor];
    
    _snakeBodyNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, gridPointSize, gridPointSize)];
    _snakeBodyNode.strokeColor = [SKColor greenColor];
    
    _foodNode = [SKShapeNode shapeNodeWithRect:CGRectMake(0, 0, gridPointSize, gridPointSize)];
    _foodNode.strokeColor = [SKColor whiteColor];
}

- (void)setupStatus
{
    switch (_viewModel.status) {
        case GameStatusInitial:
            self.startButton.hidden = NO;
            self.retryButton.hidden = YES;
            self.failedMsgLabel.hidden = YES;
            self.mask.hidden = NO;
            break;
        case GameStatusPlaying:
            self.startButton.hidden = YES;
            self.retryButton.hidden = YES;
            self.failedMsgLabel.hidden = YES;
            self.mask.hidden = YES;
            [self startTimer];
            break;
        case GameStatusFailed:
            self.startButton.hidden = YES;
            self.retryButton.hidden = NO;
            self.failedMsgLabel.hidden = NO;
            self.mask.hidden = NO;
            [self stopTimer];
            break;
        default:
            break;
    }
}

- (void)drawSnake
{
    [self enumerateChildNodesWithName:SnakeBodyNodeName usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    for (SKNode *node in _viewModel.snakeInScene) {
        SKShapeNode *n = [_snakeBodyNode copy];
        n.position = node.position;
        n.name = SnakeBodyNodeName;
        n.zPosition = 0;
        [self addChild:n];
    }
    
    SKNode *oldHead = [self childNodeWithName:SnakeHeadNodeName];
    [oldHead removeFromParent];
    
    SKShapeNode *n = [_snakeHeadNode copy];
    n.position = _viewModel.snakeHeadInScene.position;
    n.name = SnakeHeadNodeName;
    n.zPosition = 1;
    [self addChild:n];
}

- (void)drawFood
{
    SKNode *oldFood = [self childNodeWithName:FoodNodeName];
    [oldFood removeFromParent];
    
    SKShapeNode *n = [_foodNode copy];
    n.position = _viewModel.foodInScene.position;
    n.name = FoodNodeName;
    n.zPosition = 1;
    [self addChild:n];
}

- (void)startTimer
{
    SKAction *wait = [SKAction waitForDuration:snakeMovingSpeedSec];
    SKAction *run = [SKAction runBlock:^() {
        [_viewModel update];
    }];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait, run]]] withKey:SnakeMovingActionName];
}

- (void)stopTimer
{
    [self removeActionForKey:SnakeMovingActionName];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:location];
    
    if ([touchedNode isEqual:_startButton] || [touchedNode isEqual:_retryButton]) {
        [self.viewModel start];
    } else {
        [self.viewModel turn:location];
    }
}

- (void)update:(CFTimeInterval)currentTime
{
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"snakeInScene"]) {
        [self drawSnake];
    } else if ([keyPath isEqualToString:@"foodInScene"]) {
        [self drawFood];
    } else if ([keyPath isEqualToString:@"status"]) {
        [self setupStatus];
    }
}

@end
