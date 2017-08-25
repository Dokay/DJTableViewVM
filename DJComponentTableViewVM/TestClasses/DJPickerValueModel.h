//
//  DJPickerValueModel.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/25.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJValueProtocol.h"

@interface DJPickerValueModel : NSObject<DJValueProtocol>

@property(nonatomic, assign) NSInteger ID;
@property(nonatomic, strong) NSString *pickerTitle;

#pragma mark - DJValueProtocol
@property(nonatomic, readonly) NSString *dj_titleValue;

@end
