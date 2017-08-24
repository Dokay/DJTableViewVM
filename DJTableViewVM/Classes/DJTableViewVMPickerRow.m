//
//  DJTableViewVMPickerRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/23.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMPickerRow.h"
#import "DJNormalPickerDelegate.h"
#import "DJRelatedPickerDelegate.h"

@interface DJTableViewVMPickerRow()

@property(nonatomic, copy) NSArray<NSArray *> *optionsArray;
@property(nonatomic, copy) NSArray<NSArray<DJRelatedPickerValueProtocol> *> *relatedOptionsArray;

@end

@implementation DJTableViewVMPickerRow

- (id)initWithTitle:(NSString *)title protocolValue:(nullable NSArray<DJValueProtocol> *)originalValueArray placeholder:(NSString *)placeholder protocolOptions:(NSArray<NSArray<DJValueProtocol> *> *)optionsArray
{
    NSMutableArray *values = [originalValueArray mutableArrayValueForKeyPath:@"dj_contentValue"];
    
    NSMutableArray *options = [NSMutableArray arrayWithCapacity:optionsArray.count];
    [optionsArray enumerateObjectsUsingBlock:^(NSArray<DJValueProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [options addObject:[obj mutableArrayValueForKeyPath:@"dj_contentValue"]];
    }];
    
    return [self initWithTitle:title value:values placeholder:placeholder options:options];
}

- (id)initWithTitle:(NSString *)title value:(nullable NSArray<NSString *> *)valueArray placeholder:(NSString *)placeholder options:(NSArray<NSArray *> *)optionsArray
{
    self = [super init];
    if (self) {
        self.title = title;
        self.style = UITableViewCellStyleValue1;
        self.elementEdge = UIEdgeInsetsMake(self.elementEdge.top, self.elementEdge.left, self.elementEdge.bottom, 0);
        _valueArray = valueArray;
        _placeholder = placeholder;
        _optionsArray = optionsArray;
        _focusScrollPosition = UITableViewScrollPositionBottom;
        _pickerDelegate = [[DJNormalPickerDelegate alloc] initWithOptions:_optionsArray];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title value:(NSArray<NSString *> *)valueArray placeholder:(NSString *)placeholder relatedOptions:(NSArray<NSArray<DJRelatedPickerValueProtocol> *> *)relatedOptionsArray
{
    self = [super init];
    if (self) {
        self.title = title;
        self.style = UITableViewCellStyleValue1;
        self.elementEdge = UIEdgeInsetsMake(self.elementEdge.top, self.elementEdge.left, self.elementEdge.bottom, 0);
        _valueArray = valueArray;
        _placeholder = placeholder;
        _relatedOptionsArray = relatedOptionsArray;
        _focusScrollPosition = UITableViewScrollPositionBottom;
        _pickerDelegate = [[DJRelatedPickerDelegate alloc] initWithOptions:_relatedOptionsArray];
    }
    return self;
}

- (NSArray<NSNumber *> *)selectIndexArray
{
    NSMutableArray *indexArray = [NSMutableArray new];
    if (self.valueArray.count > 0) {
        [self.valueArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *componentArray = self.optionsArray[idx];
            [indexArray addObject:@([componentArray indexOfObject:obj])];
        }];
    }
    return indexArray.copy;
}


@end
