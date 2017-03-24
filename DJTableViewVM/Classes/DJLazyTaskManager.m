//
//  DJLazyTaskManager.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/10/31.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJLazyTaskManager.h"
#import "DJLog.h"

#define DJMainThreadAssert NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread!");

@interface DJLazyTask : NSObject

@property (nonatomic, weak) NSObject *target;
@property (nonatomic, weak) NSObject *param;
@property (nonatomic, assign) SEL selector;

- (instancetype)initWithTarget:(NSObject *)target selector:(SEL)selector param:(NSObject *)param;
- (void)excute;

@end

@implementation DJLazyTask

- (instancetype)initWithTarget:(NSObject *)target selector:(SEL)selector param:(NSObject *)param
{
    self = [super init];
    if (self) {
        _target = target;
        _selector = selector;
        _param = param;
    }
    return self;
}

- (void)excute
{
    //add source0 task to runloop to fire kCFRunLoopBeforeWaiting.many small tasks excute influences mode changes(ex.UITrackingRunLoopMode).
    [self.target performSelector:self.selector
                       onThread:[NSThread mainThread]
                     withObject:self.param
                  waitUntilDone:NO
                          modes:@[NSDefaultRunLoopMode]];
}

@end

@interface DJLazyTaskManager()

@property (nonatomic, strong) NSMutableArray *taskQueue;

@end

@implementation DJLazyTaskManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskQueue = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    DJLog(@"%@ dealloc",[self class]);
}

- (void)addLazyTarget:(NSObject *)target selector:(SEL)selector param:(NSObject *)param
{
    DJMainThreadAssert;
    
    DJLazyTask *lazyTask = [[DJLazyTask alloc] initWithTarget:target selector:selector param:param];
    [self.taskQueue addObject:lazyTask];
}

- (void)start
{
    DJMainThreadAssert;
    
    if (self.state == DJLazyTaskManagerStateDoing) {
        return;
    }
    
    if (self.taskQueue.count == 0) {
        return;
    }
    
    self.state = DJLazyTaskManagerStateDoing;
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFStringRef runLoopMode = kCFRunLoopDefaultMode;
    
    __weak DJLazyTaskManager *weakSelf = self;
    void (^runLoopObserverCallback)(CFRunLoopObserverRef runLoopObserver, CFRunLoopActivity activity) = ^(CFRunLoopObserverRef runLoopObserver, CFRunLoopActivity activity){
        __strong DJLazyTaskManager *strongSelf = weakSelf;
        if (!strongSelf || strongSelf.taskQueue.count == 0) {
            strongSelf.state = DJLazyTaskManagerStateDone;
            CFRunLoopRemoveObserver(runLoop, runLoopObserver, runLoopMode);
            return ;
        }
        
        DJLazyTask *lazyTask = [strongSelf.taskQueue objectAtIndex:0];
        [lazyTask excute];
        [strongSelf.taskQueue removeObjectAtIndex:0];
    };
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                                                       kCFRunLoopBeforeWaiting,
                                                                       true,
                                                                       INT_MAX,//orderID after CA transaction commits
                                                                       runLoopObserverCallback);
    CFRunLoopAddObserver(runLoop, observer, runLoopMode);
    CFRelease(observer);
}

- (void)stop
{
    DJMainThreadAssert;
    
    //CFRunLoopRemoveObserver not call here,it is called in runLoopObserverCallback.while there is not task in queue, observer will be removed in last block excutes.
    [self.taskQueue removeAllObjects];
}

@end
