//
//  DJTableViewVMTextViewCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/2/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

@import Foundation;
#import "DJTableViewVMCell.h"
#import "DJTableViewVMTextViewCellRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJTableViewVMTextViewCell : DJTableViewVMCell<DJInputCellProtocol>

@property(nonatomic, strong) DJTableViewVMTextViewCellRow *rowVM;
@property(nonatomic, strong) UITextView *textView;

@end

NS_ASSUME_NONNULL_END
