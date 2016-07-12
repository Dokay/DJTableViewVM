//
//  DJPrefetchManager.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/7/7.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface DJPrefetchManager : NSObject

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

@property (nonatomic, copy) void(^prefetchCompletion)(NSArray *added,NSArray *removed);
@property (nonatomic, assign) BOOL bPreetchEnabled;

@end
