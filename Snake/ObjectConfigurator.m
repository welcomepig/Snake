//
//  ObjectConfigurator.m
//  Snake
//
//  Created by Tina Chang on 2017/9/6.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import "ObjectConfigurator.h"
#import "GameViewController.h"
#import "GameViewModel.h"
#import "Map.h"

@interface ObjectConfigurator ()

@property (nonatomic, assign) CGSize screenSize;

@end

@implementation ObjectConfigurator

+ (ObjectConfigurator *)sharedInstanceWithScreenSize:(CGSize)size
{
    static ObjectConfigurator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithSize:size];
    });
    
    return sharedInstance;
}

- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        _screenSize = size;
    }
    return self;
}

- (UIViewController *)gameViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    ((GameViewController *)vc).viewModel = [self gameViewModel];
    
    return vc;
}

- (GameViewModel *)gameViewModel
{
    return [[GameViewModel alloc] initWithMap:[self map]];
}

- (Map *)map
{
    return [[Map alloc] initWithScreenSize:_screenSize];
}

@end
