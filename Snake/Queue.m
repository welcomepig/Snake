//
//  Queue.m
//  Snake
//
//  Created by Tina Chang on 2017/9/5.
//  Copyright © 2017年 Tina Chang. All rights reserved.
//

#import "Queue.h"

@interface Queue ()

@property (nonatomic, strong) NSMutableArray<id> *data;

@end

@implementation Queue

- (instancetype)init
{
    return [self initWithData:[NSMutableArray array]];
}

- (instancetype)initWithData:(NSMutableArray*)data
{
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (NSString *)description
{
    NSMutableString *desc = [NSMutableString string];
    
    for (id obj in _data) {
        [desc appendString:[obj description]];
        [desc appendString:@","];
    }
    [desc appendString:@"nil"];
    
    return [desc copy];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[Queue allocWithZone:zone] initWithData:[_data mutableCopy]];
}

#pragma mark -

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [_data countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - public

- (BOOL)isEmpty
{
    return (_data.count == 0);
}

- (NSUInteger)size
{
    return _data.count;
}

- (id)front
{
    return [self isEmpty] ? nil : [_data firstObject];
}

- (id)back
{
    return [self isEmpty] ? nil : [_data lastObject];
}

- (void)enqueue:(id)object
{
    [_data addObject:object];
}

- (id)dequeue
{
    if ([self isEmpty]) {
        return nil;
    }
    
    id obj = [_data firstObject];
    [_data removeObjectAtIndex:0];
    return obj;
}

@end
