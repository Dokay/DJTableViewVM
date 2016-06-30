//
//  DJAlertView.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/6/30.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJAlertView.h"

@interface DJAlertView()<UIAlertViewDelegate>

@property (nonatomic, copy) void(^completion)(DJAlertView *alertView, NSInteger buttonIndex);

@end

@implementation DJAlertView

//- (void)dealloc
//{
//    NSLog(@"DJAlertView dealloc");
//}

- (void)showWithCompletion:(void(^)(DJAlertView *alertView, NSInteger buttonIndex))completion
{
    self.delegate = self;
    self.completion = completion;
    [self show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(DJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.completion) {
        __weak DJAlertView *weakSelf = self;
        self.completion(weakSelf,buttonIndex);
        self.completion = nil;
    }
}

@end
