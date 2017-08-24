//
//  DJRelatedPickerDelegate.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJRelatedPickerDelegate.h"

@interface DJRelatedPickerDelegate()

@property(nonatomic, weak) NSArray<NSArray<DJRelatedPickerValueProtocol> *> *relatedOptionsArray;

@end

@implementation DJRelatedPickerDelegate

- (instancetype)initWithOptions:(NSArray<NSArray<DJRelatedPickerValueProtocol> *> *)optionsArray
{
    self = [super init];
    if (self) {
        _relatedOptionsArray = optionsArray;
    }
    return self;
}

- (void)setSelectedWithValue:(NSArray *)valuesArray
{
    [valuesArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull valueElement, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.relatedOptionsArray.count > idx) {
            NSArray *componentArray = [self getValuesWithConponent:idx];
            NSInteger destRow = [componentArray indexOfObject:valueElement];
            
            [componentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *value =  [self readValueObject:obj];
                if ([value isEqualToString:valueElement]) {
                    [self.pickerView selectRow:destRow inComponent:idx animated:NO];
                    *stop = YES;
                }
            }];
        }
    }];
}

- (NSArray *)updateCurrentValue
{
    NSMutableArray *valuesArray = [NSMutableArray array];
    
    NSInteger componentCount = [self getComponentCount];
    for (NSInteger i = 0; i < componentCount; i++) {
        NSArray *currentComponentElements = [self getValuesWithConponent:i];
        NSString *valueObject = [currentComponentElements objectAtIndex:[self.pickerView selectedRowInComponent:i]];
        NSString *valueText = [self readValueObject:valueObject];
        [valuesArray addObject:valueText];
    }
    
    return valuesArray;
    
}

- (NSInteger)getComponentCount
{
    NSInteger tmpComponent = 0;
    NSArray *currentComponentElements = self.relatedOptionsArray;
    
    do{
        if (currentComponentElements.count > 0 && [currentComponentElements.firstObject conformsToProtocol:@protocol(DJRelatedPickerValueProtocol)]) {
            currentComponentElements = ((NSObject<DJRelatedPickerValueProtocol> *)currentComponentElements.firstObject).dj_childOptionsValues;
            tmpComponent++;
        }
    }while(tmpComponent < 4);
    
    return tmpComponent;
}

- (NSArray *)getValuesWithConponent:(NSInteger)component
{
    NSInteger tmpComponent = -1;
    NSArray *currentComponentElements = self.relatedOptionsArray;
    do{
        if (currentComponentElements.count > 0 && [currentComponentElements.firstObject conformsToProtocol:@protocol(DJRelatedPickerValueProtocol)]) {
            currentComponentElements = ((NSObject<DJRelatedPickerValueProtocol> *)currentComponentElements.firstObject).dj_childOptionsValues;
            tmpComponent++;
        }
    }while(tmpComponent != component);
    
    return currentComponentElements;
}

- (NSString *)readValueObject:(NSObject *)valueObject
{
    if ([valueObject isKindOfClass:NSString.class]) {
        return (NSString *)valueObject;
    }else if([valueObject conformsToProtocol:@protocol(DJValueProtocol)]){
        return ((NSObject <DJValueProtocol> *)valueObject).dj_contentValue;
    }
    else if([valueObject conformsToProtocol:@protocol(DJRelatedPickerValueProtocol)]){
        return ((NSObject <DJRelatedPickerValueProtocol> *)valueObject).dj_contentValue;
    }else{
        NSAssert(NO, @"element must be NSString, object implements DJValueProtocol,object implements DJRelatedPickerValueProtocol");
        return @"";
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self getComponentCount];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *currentComponentElements = [self getValuesWithConponent:component];
    
    return currentComponentElements.count;
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *currentComponentElements = [self getValuesWithConponent:component];
    NSObject *valueObject = [currentComponentElements objectAtIndex:row];
    
    return [self readValueObject:valueObject];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *valuesArray = [self updateCurrentValue];
    if (self.valueChangeBlock) {
        self.valueChangeBlock(valuesArray);
    }
    
    //set row = 0 in component after current component
    NSInteger componentCount = [self getComponentCount];
    NSInteger i = component + 1;
    while (i < componentCount) {
        i++;
        [self.pickerView selectRow:0 inComponent:i animated:YES];
    }
    
    [pickerView reloadAllComponents];
//    [self updateCurrentValue];
    
}

@end
