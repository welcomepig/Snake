//
//  Map.m
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import "Map.h"
#import "Constants.h"

@interface Map ()

@property (nonatomic, assign, readwrite) NSUInteger row;
@property (nonatomic, assign, readwrite) NSUInteger column;

@end

@implementation Map

- (instancetype)initWithScreenSize:(CGSize)size
{
    self = [super init];
    if (self) {
        _column = size.width / gridPointSize;
        _row = size.height / gridPointSize;
    }
    return self;
}

- (BOOL)isPointInMap:(CGPoint)pos
{
    if (pos.x < 0 || pos.x > _column - 1) return NO;
    if (pos.y < 0 || pos.y > _row - 1) return NO;
    
    return YES;
}

- (CGPoint)randomPointInMap
{
    CGPoint pos;
    
    pos.x = arc4random() % _column;
    pos.y = arc4random() % _row;
    
    return pos;
}

@end
