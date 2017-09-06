//
//  Food.h
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Map;

@interface Food : NSObject

@property (nonatomic, assign, readonly) CGPoint pos;

+ (instancetype)foodWithRandomPointInMap:(Map*)map;
- (instancetype)initWithPoint:(CGPoint)pos;

@end
