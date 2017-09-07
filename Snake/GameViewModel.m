//
//  GameViewModel.m
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewModel.h"
#import "Map.h"
#import "Snake.h"
#import "Food.h"
#import "Queue.h"
#import "Constants.h"

@interface GameViewModel ()

@property (nonatomic, strong) Map *map;
@property (nonatomic, strong) Snake *snake;
@property (nonatomic, strong) Food *food;

@property (nonatomic, strong, readwrite) Queue<SKNode*> *snakeInScene;
@property (nonatomic, strong, readwrite) SKNode *snakeHeadInScene;
@property (nonatomic, strong, readwrite) SKNode *foodInScene;
@property (nonatomic, assign, readwrite) GameStatus status;

@end

@implementation GameViewModel

#pragma mark - Public

- (instancetype)initWithMap:(Map *)map
{
    self = [super init];
    if (self) {
        _map = map;
        _status = GameStatusInitial;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(snakeMoved)
                                                     name:SnakeMoved
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(snakeAteFood)
                                                     name:SnakeAteFood object:nil];
    }
    return self;
}

- (void)startWithSnake:(Snake*)snake food:(Food*)food
{
    self.snake = snake;
    self.food = food;
    
    [self createSnakeInSceneFromSnake:self.snake];
    [self createFoodInSceneFromFood:self.food];
    
    self.status = GameStatusPlaying;
}

- (void)start
{
    Snake *snake = [Snake snakeWithDefaultPointsInMap:_map];
    Food *food = [self createRandomFood];
    
    [self startWithSnake:snake food:food];
}

- (void)update
{
    CGPoint next = [_snake next];
    
    // 1. out of map => died
    if (![_map isPointInMap:next]) {
        self.status = GameStatusFailed;
        return;
    }
    
    // 2. food
    if (_food.pos.x == next.x && _food.pos.y == next.y) {
        [_snake eatFood:_food];
        self.food = [self createRandomFood];
        [self createFoodInSceneFromFood:self.food];
        return;
    }
    
    // 3. snake body => died
    for (NSValue *val in _snake.body) {
        CGPoint point = [val CGPointValue];
        if (point.x == next.x && point.y == next.y) {
            self.status = GameStatusFailed;
            return;
        }
    }
    
    // 4. move forward
    [_snake move];
}

- (void)turn:(CGVector)move
{
    if (fabs(move.dx) > fabs(move.dy) && _snake.orientation == OrientationVertical) {
        if (move.dx > 0) {
            [self.snake turnDirection:DirectionRight];
        } else if (move.dx < 0) {
            [self.snake turnDirection:DirectionLeft];
        }
    } else if (fabs(move.dx) < fabs(move.dy) && _snake.orientation == OrientationHorizon) {
        if (move.dy > 0) {
            [self.snake turnDirection:DirectionUp];
        } else if (move.dy < 0) {
            [self.snake turnDirection:DirectionDown];
        }
    }
}

#pragma mark - Private

- (void)createSnakeInSceneFromSnake:(Snake*)snake
{
    [self willChangeValueForKey:@"snakeInScene"];
    
    _snakeInScene = [[Queue alloc] init];
    for (id obj in snake.body) {
        SKNode *node = [SKNode node];
        node.position = [self scenePointFromMapPoint:[obj CGPointValue]];
        [_snakeInScene enqueue:node];
    }
    _snakeHeadInScene = [SKNode node];
    _snakeHeadInScene.position = [self scenePointFromMapPoint:snake.head];
    
    [self didChangeValueForKey:@"snakeInScene"];
}

- (Food *)createRandomFood
{
    Food *food;
    
    do {
        food = [Food foodWithRandomPointInMap:_map];
    } while([_snake isPointOnSnake:food.pos]);
    
    return food;
}

- (void)createFoodInSceneFromFood:(Food*)food
{
    [self willChangeValueForKey:@"foodInScene"];
    
    _foodInScene = [SKNode node];
    _foodInScene.position = [self scenePointFromMapPoint:_food.pos];

    [self didChangeValueForKey:@"foodInScene"];
}

- (CGPoint)scenePointFromMapPoint:(CGPoint)point
{
    CGPoint scenePoint;
    scenePoint.x = point.x * gridPointSize;
    scenePoint.y = point.y * gridPointSize;
    return scenePoint;
}

- (void)snakeMoved
{
    [self willChangeValueForKey:@"snakeInScene"];
    
    SKNode *node = [SKNode node];
    node.position = [self scenePointFromMapPoint:[[_snake.body back] CGPointValue]];
    
    [_snakeInScene dequeue];
    [_snakeInScene enqueue:node];
    
    _snakeHeadInScene.position = node.position;
    
    [self didChangeValueForKey:@"snakeInScene"];
}

- (void)snakeAteFood
{
    [self willChangeValueForKey:@"snakeInScene"];
    
    SKNode *node = [SKNode node];
    node.position = [self scenePointFromMapPoint:[[_snake.body back] CGPointValue]];

    [_snakeInScene enqueue:node];
    
    _snakeHeadInScene.position = node.position;
    
    [self didChangeValueForKey:@"snakeInScene"];
}

@end
