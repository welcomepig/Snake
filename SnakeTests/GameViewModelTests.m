//
//  GameViewModelTests.m
//  Snake
//
//  Created by Tina Chang on 2017/9/7.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "GameViewModel.h"
#import "Queue.h"
#import "Map.h"
#import "Snake.h"
#import "Food.h"

@interface GameViewModelTests : XCTestCase

@property (nonatomic, strong)   Map *map;
@property (nonatomic, strong)   GameViewModel *viewModel;

@end

@implementation GameViewModelTests

- (void)setUp
{
    [super setUp];
    
    self.map = [[Map alloc] initWithScreenSize:CGSizeMake(320, 240)];
    self.viewModel = [[GameViewModel alloc] initWithMap:self.map];
}

- (void)tearDown
{
    self.viewModel = nil;
    self.map = nil;
    
    [super tearDown];
}

#pragma mark - test start function

- (void)testClickStartWillCreateSnake
{
    [self.viewModel start];
    
    XCTAssertNotNil(_viewModel.snakeHeadInScene);
    XCTAssertNotNil(_viewModel.snakeInScene);
}

- (void)testClickStartWillCreateFood
{
    [self.viewModel start];
    
    XCTAssertNotNil(_viewModel.foodInScene);
}

#pragma mark - test update function

- (void)testUpdateHitLeftWallWillDie
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(1, 0)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionLeft];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel update];
    
    XCTAssertTrue(_viewModel.status == GameStatusFailed);
}

- (void)testUpdateHitRightWallWillDie
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(self.map.column - 2, 0)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(self.map.column - 1, 0)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionRight];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel update];
    
    XCTAssertTrue(_viewModel.status == GameStatusFailed);
}

- (void)testUpdateHitDownWallWillDie
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(0, 1)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionDown];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel update];
    
    XCTAssertTrue(_viewModel.status == GameStatusFailed);
}

- (void)testUpdateHitUpWallWillDie
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(0, self.map.row - 2)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(0, self.map.row - 1)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionUp];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel update];
    
    XCTAssertTrue(_viewModel.status == GameStatusFailed);
}

- (void)testUpdateEatFood
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(3, 0)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(2, 0)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionLeft];
    Food *food = [[Food alloc] initWithPoint:CGPointMake(1, 0)];
    
    NSUInteger origSnakeSize = snake.body.size;
    
    [self.viewModel startWithSnake:snake food:food];
    [self.viewModel update];
    
    XCTAssertTrue(snake.body.size == origSnakeSize + 1);
}

- (void)testUpdateHitSelfWillDie
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(1, 1)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(1, 2)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(2, 2)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(2, 1)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionLeft];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel update];
    
    XCTAssertTrue(_viewModel.status == GameStatusFailed);
}

- (void)testUpdateMoveForward
{
    CGPoint head = CGPointMake(4, 3);
    
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(3, 3)]];
    [body enqueue:[NSValue valueWithCGPoint:head]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionRight];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel update];
    
    XCTAssertTrue(snake.head.x == head.x + 1);
    XCTAssertTrue(snake.head.y == head.y);
}

#pragma mark - test turn function

- (void)testTurnHorizontalToHorizontal
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(1, 1)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(1, 2)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionRight];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel turn:CGVectorMake(1, 0)];
    
    XCTAssertTrue(snake.direction == DirectionRight);
    
    [self.viewModel turn:CGVectorMake(-1, 0)];
 
    XCTAssertTrue(snake.direction == DirectionRight);
}

- (void)testTurnVerticalToVertical
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(2, 1)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(2, 2)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionUp];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel turn:CGVectorMake(0, 1)];
    
    XCTAssertTrue(snake.direction == DirectionUp);
    
    [self.viewModel turn:CGVectorMake(0, -1)];
    
    XCTAssertTrue(snake.direction == DirectionUp);
}

- (void)testTurnHorizontalToUp
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(1, 1)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(1, 2)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionRight];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel turn:CGVectorMake(0, 1)];
    
    XCTAssertTrue(snake.direction == DirectionUp);
}

- (void)testTurnHorizontalToDown
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(1, 1)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(1, 2)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionRight];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel turn:CGVectorMake(0, -1)];
    
    XCTAssertTrue(snake.direction == DirectionDown);
}

- (void)testTurnVerticalToRight
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(2, 1)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(2, 2)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionUp];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel turn:CGVectorMake(1, 0)];
    
    XCTAssertTrue(snake.direction == DirectionRight);
}

- (void)testTurnVerticalToLeft
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(2, 1)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(2, 2)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionUp];
    [self.viewModel startWithSnake:snake food:nil];
    [self.viewModel turn:CGVectorMake(-1, 0)];
    
    XCTAssertTrue(snake.direction == DirectionLeft);
}

@end
