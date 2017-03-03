//
//  DJInputRowProtocol.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/1.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DJInputRowProtocol <NSObject>

@required
@property(nonatomic, assign) BOOL editing;
@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, assign) UITableViewScrollPosition focusScrollPosition;

@end

@protocol DJInputCellProtocol <NSObject>


- (UIView *)inputResponder;//return a responder view.The view is used to scroll to good target offset auto.

@end
