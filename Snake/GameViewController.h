//
//  GameViewController.h
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@class GameViewModel;

@interface GameViewController : UIViewController

@property (nonatomic, strong) GameViewModel *viewModel;

@end
