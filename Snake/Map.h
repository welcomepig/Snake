//
//  Map.h
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Map : NSObject

@property (nonatomic, assign, readonly) NSUInteger row;
@property (nonatomic, assign, readonly) NSUInteger column;

- (instancetype)initWithScreenSize:(CGSize)size;
- (BOOL)isPointInMap:(CGPoint)pos;
- (CGPoint)randomPointInMap;

@end
