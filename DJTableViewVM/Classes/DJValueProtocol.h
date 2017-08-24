//
//  DJValueProtocol.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/23.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DJValueProtocol <NSObject>

@required
@property(nonatomic, strong) NSString *dj_contentValue;

@end

@protocol DJRelatedPickerValueProtocol <NSObject>

@required
@property(nonatomic, strong) NSString *dj_contentValue;
@property(nonatomic, strong) NSArray *dj_childOptionsValues;

@end
