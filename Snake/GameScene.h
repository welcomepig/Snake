//
//  GameScene.h
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class GameViewModel;

@interface GameScene : SKScene

@property (nonatomic, strong) GameViewModel *viewModel;

@end
