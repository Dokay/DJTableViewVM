//
//  DJTableViewVMTextFieldCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/2/16.
//  Copyright © 2017年 dj226. All rights reserved.
//

@import Foundation;
#import "DJTableViewVMCell.h"
#import "DJTableViewVMTextFieldCellRow.h"
#import "DJInputProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJTableViewVMTextFieldCell : DJTableViewVMCell<DJInputCellProtocol>

@property (nonatomic, strong) DJTableViewVMTextFieldCellRow *rowVM;
@property (nonatomic, strong) UITextField *textField;

@end

NS_ASSUME_NONNULL_END
