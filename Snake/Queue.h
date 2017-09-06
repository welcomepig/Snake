//
//  Queue.h
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue<ObjectType> : NSObject<NSCopying, NSFastEnumeration>

- (BOOL)isEmpty;
- (NSUInteger)size;
- (ObjectType)front;
- (ObjectType)back;
- (void)enqueue:(ObjectType)object;
- (ObjectType)dequeue;

@end
