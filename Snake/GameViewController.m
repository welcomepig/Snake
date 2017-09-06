//
//  GameViewController.m
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GameViewModel.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    

    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    scene.viewModel = _viewModel;
    scene.size = self.view.frame.size;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;

    [skView presentScene:scene];
    
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
