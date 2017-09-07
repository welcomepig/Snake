//
//  GameViewModel.h
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Queue;
@class Map;
@class Snake;
@class Food;
@class SKNode;

typedef NS_ENUM(NSUInteger, GameStatus) {
    GameStatusInitial,
    GameStatusPlaying,
    GameStatusFailed
};

@interface GameViewModel : NSObject

@property (nonatomic, strong, readonly) Queue *snakeInScene;
@property (nonatomic, strong, readonly) SKNode *snakeHeadInScene;
@property (nonatomic, strong, readonly) SKNode *foodInScene;
@property (nonatomic, assign, readonly) GameStatus status;

- (instancetype)initWithMap:(Map*)map;
- (void)start;
- (void)startWithSnake:(Snake*)snake food:(Food*)food;
- (void)update;
- (void)turn:(CGVector)move;

@end
