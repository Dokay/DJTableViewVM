//
//  DJAlertView.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/6/30.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJAlertView : UIAlertView

- (void)showWithCompletion:(void(^)(DJAlertView *alertView, NSInteger buttonIndex))completion;

@end
