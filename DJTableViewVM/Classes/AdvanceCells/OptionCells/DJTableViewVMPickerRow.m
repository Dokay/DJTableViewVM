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
#import "DJToolBar.h"

#define KPickerViewDefaultHeight 216

@interface DJTableViewVMPickerRow()

@property(nonatomic, copy) NSArray<NSArray *> *optionsArray;
@property(nonatomic, copy) NSArray<NSArray<DJRelatedPickerValueProtocol> *> *relatedOptionsArray;

@end

@implementation DJTableViewVMPickerRow

- (id)initWithTitle:(NSString *)title value:(nullable NSArray<NSString *> *)valueArray placeholder:(NSString *)placeholder protocolOptions:(NSArray<NSArray<DJValueProtocol> *> *)optionsArray
{
    return [self initWithTitle:title value:valueArray placeholder:placeholder options:optionsArray];
}

- (id)initWithTitle:(NSString *)title value:(nullable NSArray<NSString *> *)valueArray placeholder:(NSString *)placeholder options:(NSArray<NSArray *> *)optionsArray
{
    self = [self initWithTitle:title value:valueArray placeholder:placeholder];
    if (self) {
        _optionsArray = optionsArray;
        _pickerDelegate = [[DJNormalPickerDelegate alloc] initWithOptions:_optionsArray];
        _pickerDelegate.pickerTitleColor = _pickerTitleColor;
        _pickerDelegate.pickerTitleFont = _pickerTitleFont;
        _pickerViewHight = KPickerViewDefaultHeight;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title value:(NSArray<NSString *> *)valueArray placeholder:(NSString *)placeholder relatedOptions:(NSArray<NSArray<DJRelatedPickerValueProtocol> *> *)relatedOptionsArray
{
    self = [self initWithTitle:title value:valueArray placeholder:placeholder];
    if (self) {
        _relatedOptionsArray = relatedOptionsArray;
        _pickerDelegate = [[DJRelatedPickerDelegate alloc] initWithOptions:_relatedOptionsArray];
        _pickerDelegate.pickerTitleColor = _pickerTitleColor;
        _pickerDelegate.pickerTitleFont = _pickerTitleFont;
        _pickerViewHight = KPickerViewDefaultHeight;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title value:(NSArray<NSString *> *)valueArray placeholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        self.title = title;
        self.style = UITableViewCellStyleValue1;
        self.elementEdge = UIEdgeInsetsMake(self.elementEdge.top, self.elementEdge.left, self.elementEdge.bottom, 0);
        _valueArray = valueArray;
        _placeholder = placeholder;
        _pickerTitleColor = [UIColor blackColor];
        _pickerTitleFont = [UIFont systemFontOfSize:21];
        _pickerViewHight = KPickerViewDefaultHeight;
    }
    return self;
}

- (NSArray *)selectedObjectsArray
{
    return [(DJRelatedPickerDelegate *)self.pickerDelegate selectedObjects];
}

#pragma mark - seter
- (void)setPickerTitleColor:(UIColor *)pickerTitleColor
{
    _pickerTitleColor = pickerTitleColor;
    self.pickerDelegate.pickerTitleColor = pickerTitleColor;
}

- (void)setPickerTitleFont:(UIFont *)pickerTitleFont
{
    _pickerTitleFont = pickerTitleFont;
    self.pickerDelegate.pickerTitleFont = pickerTitleFont;
}

- (void)setWidthForComponent:(CGFloat (^)(NSInteger))widthForComponent
{
    _widthForComponent = widthForComponent;
    self.pickerDelegate.widthForComponent = widthForComponent;
}

- (void)setHeightForComponent:(CGFloat (^)(NSInteger))heightForComponent
{
    _heightForComponent = heightForComponent;
    self.pickerDelegate.heightForComponent = heightForComponent;
}

@end
