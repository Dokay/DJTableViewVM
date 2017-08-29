//
//  DJTableViewVMOptionsController.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/22.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJTableViewVMOptionRow.h"

@interface DJTableViewVMOptionsController : UIViewController

@property(nonatomic, strong) NSString *rightButtonTitle;
@property(nonatomic, copy) void(^rightButtonClickHandler)(NSString *selectValue);
@property(nonatomic, readonly) NSArray *optionsArray;
@property(nonatomic, readonly) BOOL multipleChoice;
@property(nonatomic, strong) NSString *separateCharater;
@property(nonatomic, assign) UITableViewStyle tableViewStyle;

- (id)initWithRow:(DJTableViewVMOptionRow *)rowVM options:(NSArray<NSString *> *)optionsArray multipleChoice:(BOOL)multipleChoice completionHandler:(void(^)(NSString *selectValue))completionHandler;

@end
