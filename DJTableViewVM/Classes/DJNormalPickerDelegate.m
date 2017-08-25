//
//  DJNormalPickerDelegate.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJNormalPickerDelegate.h"

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
            NSInteger destRow = [componentArray indexOfObject:valueElement];
            [self.pickerView selectRow:destRow inComponent:idx animated:NO];
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

- (NSArray *)updateCurrentValue
{
    NSMutableArray *valuesArray = [NSMutableArray array];
    
    [self.optionsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *options = [self.optionsArray objectAtIndex:idx];
        NSString *valueText = [options objectAtIndex:[self.pickerView selectedRowInComponent:idx]];
        [valuesArray addObject:valueText];
    }];
    
    return valuesArray;
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.optionsArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray<NSString *> *titlesArray = [self.optionsArray objectAtIndex:component];
    NSAssert([titlesArray isKindOfClass:[NSArray class]], @"elements of optionsArray is also array");
    return [titlesArray count];
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray<NSString *> *titlesArray = [self.optionsArray objectAtIndex:component];
    return [titlesArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *valuesArray = [self updateCurrentValue];
    if (self.valueChangeBlock) {
        self.valueChangeBlock(valuesArray);
    }
    
    [pickerView reloadAllComponents];
//    [self updateCurrentValue];
    
}

@end
