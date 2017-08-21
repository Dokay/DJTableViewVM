//
//  DJTableViewVMTextViewCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/2/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

@import Foundation;
#import "DJTableViewVMCell.h"
#import "DJTableViewVMTextViewRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJTableViewVMTextViewCell : DJTableViewVMCell

@property(nonatomic, strong) DJTableViewVMTextViewRow *rowVM;
@property(nonatomic, readonly) UITextView *textView;

@end

NS_ASSUME_NONNULL_END
