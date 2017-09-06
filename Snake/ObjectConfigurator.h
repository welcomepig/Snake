//
//  ObjectConfigurator.h
//  Snake
//
//  Created by Tina Chang on 2017/9/6.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GameViewController;

@interface ObjectConfigurator : NSObject

+ (ObjectConfigurator *)sharedInstanceWithScreenSize:(CGSize)size;
- (UIViewController *)gameViewController;

@end
