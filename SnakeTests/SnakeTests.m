//
//  SnakeTests.m
//  SnakeTests
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Snake.h"
#import "Food.h"
#import "Queue.h"
#import "GameViewModel.h"
#import "GameViewModel+Test.h"

@interface SnakeTests : XCTestCase

@end

@implementation SnakeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNextDirectionRight
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(4, 1)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(5, 1)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionRight];
    
    XCTAssertTrue(snake.head.x + 1 == snake.next.x);
}

- (void)testNextDirectionLeft
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(5, 1)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(4, 1)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionLeft];
    
    XCTAssertTrue(snake.head.x - 1 == snake.next.x);
}

- (void)testNextDirectionUp
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(3, 3)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(3, 4)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionUp];
    
    XCTAssertTrue(snake.head.y + 1 == snake.next.y);
}

- (void)testNextDirectionDown
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(3, 4)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(3, 3)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionDown];
    
    XCTAssertTrue(snake.head.y - 1 == snake.next.y);
}

#pragma mark - test move function

- (void)testMoveDirectionWillCallSnakeMoved
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(4, 0)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(3, 0)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionLeft];
    
    id mockViewModel = OCMPartialMock([[GameViewModel alloc] initWithMap:nil]);
    [mockViewModel startWithSnake:snake food:nil];
    
    [[mockViewModel expect] snakeMoved];
    
    [snake move];
    [mockViewModel verify];
}

- (void)testMoveDirectionWillNotChangeBodySize
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(4, 0)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(3, 0)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionLeft];
    NSUInteger origBodySize = snake.body.size;
    [snake move];

    XCTAssertTrue(snake.body.size == origBodySize);
}

#pragma mark - test eatFood function

- (void)testEatFoodWillCallSnakeAteFood
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(4, 0)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(3, 0)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionLeft];
    Food *food = [[Food alloc] initWithPoint:CGPointMake(2, 0)];
    
    id mockViewModel = OCMPartialMock([[GameViewModel alloc] initWithMap:nil]);
    [mockViewModel startWithSnake:snake food:food];
    
    [[mockViewModel expect] snakeAteFood];
    
    [snake eatFood:food];
    [mockViewModel verify];
}

- (void)testEatFoodWillIncreaseBodySize
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(4, 0)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(3, 0)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionLeft];
    Food *food = [[Food alloc] initWithPoint:CGPointMake(2, 0)];
    
    NSUInteger origBodySize = snake.body.size;
    [snake eatFood:food];
    
    XCTAssertTrue(snake.body.size == origBodySize + 1);
}

#pragma mark - test turn function

- (void)testTurnDirection
{
    Snake *snake = [[Snake alloc] init];
    [snake turnDirection:DirectionRight];
    XCTAssertTrue(snake.direction == DirectionRight);
    XCTAssertTrue(snake.orientation == OrientationHorizon);
    
    [snake turnDirection:DirectionLeft];
    XCTAssertTrue(snake.direction == DirectionLeft);
    XCTAssertTrue(snake.orientation == OrientationHorizon);
    
    [snake turnDirection:DirectionUp];
    XCTAssertTrue(snake.direction == DirectionUp);
    XCTAssertTrue(snake.orientation == OrientationVertical);
    
    [snake turnDirection:DirectionDown];
    XCTAssertTrue(snake.direction == DirectionDown);
    XCTAssertTrue(snake.orientation == OrientationVertical);
}

#pragma mark - test isPointOnSnake function

- (void)testIsPointOnSnake
{
    Queue *body = [[Queue alloc] init];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(4, 0)]];
    [body enqueue:[NSValue valueWithCGPoint:CGPointMake(3, 0)]];
    
    Snake *snake = [[Snake alloc] initWithPoints:body direction:DirectionLeft];

    XCTAssertTrue([snake isPointOnSnake:CGPointMake(4, 0)]);
    XCTAssertTrue([snake isPointOnSnake:CGPointMake(3, 0)]);
    XCTAssertFalse([snake isPointOnSnake:CGPointMake(6, 4)]);
}

@end
