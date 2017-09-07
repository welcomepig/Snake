//
//  Snake.m
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import "Snake.h"
#import "Queue.h"
#import "Map.h"

@interface Snake ()

@property (nonatomic, strong, readwrite) Queue *body;
@property (nonatomic, assign, readwrite) Direction direction;

@end

@implementation Snake

+ (instancetype)snakeWithDefaultPointsInMap:(Map*)map
{
    Queue* points = [[Queue alloc] init];
    NSUInteger len = map.column / 6;
    NSUInteger x = map.column / 2 - len;
    NSUInteger y = map.row / 2;
    
    while (x <= (map.column / 2  + len)) {
        [points enqueue:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        x++;
    }
    
    return [[Snake alloc] initWithPoints:points direction:DirectionRight];
}

- (instancetype)initWithPoints:(Queue *)points direction:(Direction)direction
{
    self = [super init];
    if (self) {
        _direction = direction;
        _body = points;
    }
    return self;
}

- (Orientation)orientation
{
    if (_direction == DirectionRight || _direction == DirectionLeft) {
        return OrientationHorizon;
    }
    return OrientationVertical;
}

- (CGPoint)head
{
    return [[_body back] CGPointValue];
}

- (CGPoint)next
{
    CGPoint next = self.head;
    
    switch (_direction) {
        case DirectionUp:
            next.y += 1;
            break;
        case DirectionDown:
            next.y -= 1;
            break;
        case DirectionLeft:
            next.x -= 1;
            break;
        case DirectionRight:
            next.x += 1;
            break;
        default:
            break;
    }
    
    return next;
}

- (void)move
{
    CGPoint next = [self next];
    [_body dequeue];
    [_body enqueue:[NSValue valueWithCGPoint:next]];

    [[NSNotificationCenter defaultCenter] postNotificationName:SnakeMoved object:nil];
}

- (void)eatFood:(Food*)food
{
    CGPoint next = [self next];
    [_body enqueue:[NSValue valueWithCGPoint:next]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SnakeAteFood object:nil];
}

- (void)turnDirection:(Direction)direction
{
    self.direction = direction;
}

- (BOOL)isPointOnSnake:(CGPoint)point
{
    for (NSValue *pt in _body) {
        if ([pt CGPointValue].x == point.x && [pt CGPointValue].y == point.y) {
            return YES;
        }
    }
    return NO;
}

@end
