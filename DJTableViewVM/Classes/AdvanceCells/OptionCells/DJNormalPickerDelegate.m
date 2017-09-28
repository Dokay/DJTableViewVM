//
//  DJNormalPickerDelegate.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJNormalPickerDelegate.h"
#import "DJValueProtocol.h"

@interface DJNormalPickerDelegate()

@property(nonatomic, weak) NSArray<NSArray *> *optionsArray;

@end

@implementation DJNormalPickerDelegate

- (instancetype)initWithOptions:(NSArray<NSArray *> *)optionsArray
{
    self = [super init];
    if (self) {
        _optionsArray = optionsArray;
    }
    return self;
}

- (void)refreshPickerWithValues:(NSArray *)valuesArray
{
    [valuesArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull valueElement, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.optionsArray.count > idx) {
            NSArray *componentArray = self.optionsArray[idx];
            [componentArray enumerateObjectsUsingBlock:^(id  _Nonnull titleObject, NSUInteger destRow, BOOL * _Nonnull stop) {
                if ([[self readValueObject:titleObject] isEqualToString:valueElement]) {
                    [self.pickerView selectRow:destRow inComponent:idx animated:NO];
                    *stop = YES;
                }
            }];
        }
    }];
}

- (NSArray *)selectedObjects;
{
    NSMutableArray *valuesArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.optionsArray.count; i++) {
        NSArray *elementArray = self.optionsArray[i];
        NSObject *valueObject = [elementArray objectAtIndex:[self.pickerView selectedRowInComponent:i]];
        [valuesArray addObject:valueObject];
    }
    
    return valuesArray;
}

- (NSArray *)currentValue
{
    NSMutableArray *valuesArray = [NSMutableArray array];
    
    [self.optionsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *options = [self.optionsArray objectAtIndex:idx];
        NSObject *valueObject = [options objectAtIndex:[self.pickerView selectedRowInComponent:idx]];
        [valuesArray addObject:[self readValueObject:valueObject]];
    }];
    
    return valuesArray;
}

- (NSString *)readValueObject:(NSObject *)valueObject
{
    if ([valueObject isKindOfClass:NSString.class]) {
        return (NSString *)valueObject;
    }else if([valueObject conformsToProtocol:@protocol(DJValueProtocol)]){
        return ((NSObject <DJValueProtocol> *)valueObject).dj_titleValue;
    }else{
        NSAssert(NO, @"element must be NSString, object implements DJValueProtocol");
        return @"";
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.optionsArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *titlesArray = [self.optionsArray objectAtIndex:component];
    NSAssert([titlesArray isKindOfClass:[NSArray class]], @"elements of optionsArray is also array");
    return [titlesArray count];
}

#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component __TVOS_PROHIBITED
{
    if (self.optionsArray.count > 0) {
        if (self.widthForComponent) {
            return self.widthForComponent(component);
        }else{
            return pickerView.frame.size.width/self.optionsArray.count;
        }
    }else{
        return 0;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED
{
    if (self.heightForComponent) {
        return self.heightForComponent(component);
    }else{
        return 32;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view __TVOS_PROHIBITED
{
    NSArray *titlesArray = [self.optionsArray objectAtIndex:component];
    NSObject *valueObject = [titlesArray objectAtIndex:row];
    NSString *title = [self readValueObject:valueObject];
    if (view == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectNull];
        label.font = self.pickerTitleFont;
        label.textColor = self.pickerTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
        return label;
    }else{
        ((UILabel *)view).text = title;
        return view;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *valuesArray = [self currentValue];
    if (self.valueChangeBlock) {
        self.valueChangeBlock(valuesArray);
    }
    
    [pickerView reloadAllComponents];
//    [self updateCurrentValue];
    
}

@end
