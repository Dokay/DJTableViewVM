//
//  DJLazyTaskManager.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/10/31.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,DJLazyTaskManagerState){
    DJLazyTaskManagerStateDefault,
    DJLazyTaskManagerStateDoing,
    DJLazyTaskManagerStateDone,
};

@interface DJLazyTaskManager : NSObject

@property (nonatomic, assign) DJLazyTaskManagerState state;

- (void)addLazyTarget:(NSObject *)target selector:(SEL)selector param:(NSObject *)param;
- (void)cancelLazyTarget:(NSObject *)target selector:(SEL)selector param:(NSObject *)param;
- (void)start;
- (void)stop;

@end
