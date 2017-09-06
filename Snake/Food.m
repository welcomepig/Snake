//
//  Food.m
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import "Food.h"
#import "Map.h"

@interface Food ()

@property (nonatomic, assign, readwrite) CGPoint pos;

@end

@implementation Food

+ (instancetype)foodWithRandomPointInMap:(Map*)map
{
    return [[Food alloc] initWithPoint:[map randomPointInMap]];
}

- (instancetype)initWithPoint:(CGPoint)pos
{
    self = [super init];
    if (self) {
        _pos = pos;
    }
    return self;
}

@end
