//
//  Snake.h
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeft,
    DirectionUp,
    DirectionRight,
    DirectionDown
};

typedef NS_ENUM(NSUInteger, Orientation) {
    OrientationHorizon = 0,
    OrientationVertical = 1
};

static NSString *SnakeMoved = @"snakeMoved";
static NSString *SnakeAteFood = @"SnakeAteFood";

@class Map;
@class Food;
@class Queue;

@interface Snake : NSObject

@property (nonatomic, assign, readonly) CGPoint head;
@property (nonatomic, strong, readonly) Queue *body;
@property (nonatomic, assign, readonly) Direction direction;

+ (instancetype)snakeWithDefaultPointsInMap:(Map*)map;
- (instancetype)initWithPoints:(Queue *)points direction:(Direction)direction;
- (CGPoint)next;
- (void)move;
- (void)eatFood:(Food*)food;
- (void)turnDirection:(Direction)direction;
- (BOOL)isPointOnSnake:(CGPoint)point;

@end
