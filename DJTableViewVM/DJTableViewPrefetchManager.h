//
//  DJTableViewPrefetchManager.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/7/7.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface DJTableViewPrefetchManager : NSObject

- (nonnull instancetype)initWithScrollView:(nonnull UIScrollView *)scrollView;

@property (nonatomic, copy, nullable) void(^prefetchCompletion)(NSArray * _Nullable added,NSArray * _Nullable removed);
@property (nonatomic, assign) BOOL bPreetchEnabled;

@end
