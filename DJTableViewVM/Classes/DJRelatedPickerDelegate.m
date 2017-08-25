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
@property(nonatomic, assign) NSInteger componentCount;
@property(nonatomic, strong) NSArray *componentValuesArray;

@end

@implementation DJRelatedPickerDelegate

- (instancetype)initWithOptions:(NSArray<NSArray<DJRelatedPickerValueProtocol> *> *)optionsArray
{
    self = [super init];
    if (self) {
        _relatedOptionsArray = optionsArray;
        _componentCount = [self getComponentCount];
        _componentValuesArray = [NSMutableArray arrayWithCapacity:_componentCount];
        [self recaculateTitlesWithSelectComponent:0];
    }
    return self;
}

- (void)recaculateTitlesWithSelectComponent:(NSInteger)selectComponent
{
    NSMutableArray *rows = [NSMutableArray new];
    for (NSInteger i = 0; i < self.componentCount; i++) {
        if (i <= selectComponent) {
            [rows addObject:@([self.pickerView selectedRowInComponent:i])];
        }else{
            [rows addObject:@(0)];
        }
    }

    self.componentValuesArray = [self getValuesWithSelectRows:rows];
}

- (void)refreshPickerWithValues:(NSArray *)valuesArray
{
    if (valuesArray.count == self.componentCount) {
        NSMutableArray *destValues = [NSMutableArray new];
        NSMutableArray *rows = [NSMutableArray new];
        __block NSArray *currentComponentElements = self.relatedOptionsArray;
        [valuesArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull valueElement, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *valueContent = [self readValueObject:valueElement];
            for (NSInteger i = 0 ; i < currentComponentElements.count; i++) {
                NSObject<DJRelatedPickerValueProtocol> *valueObject = currentComponentElements[i];
                if ([valueContent isEqualToString:[self readValueObject:valueObject]]) {
                    [destValues addObject:currentComponentElements.copy];
                    currentComponentElements = valueObject.dj_childOptionsValues;
                    [rows addObject:@(i)];
                    continue;
                }
            }
        }];
        self.componentValuesArray = destValues.copy;
        [self.pickerView reloadAllComponents];
        [rows enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.pickerView selectRow:[obj integerValue] inComponent:idx animated:NO];
        }];
    }
}

- (NSArray *)updateCurrentValue
{
    NSMutableArray *valuesArray = [NSMutableArray array];
    
    NSInteger componentCount = self.componentCount;
    for (NSInteger i = 0; i < componentCount; i++) {
        NSArray *currentComponentElements = [self.componentValuesArray objectAtIndex:i];
        NSString *valueObject = [currentComponentElements objectAtIndex:[self.pickerView selectedRowInComponent:i]];
        NSString *valueText = [self readValueObject:valueObject];
        [valuesArray addObject:valueText];
    }
    
    return valuesArray;
    
}

- (NSArray *)selectedObjects;
{
    NSMutableArray *valuesArray = [NSMutableArray array];
    
    NSInteger componentCount = self.componentCount;
    for (NSInteger i = 0; i < componentCount; i++) {
        NSArray *currentComponentElements = [self.componentValuesArray objectAtIndex:i];
        NSObject *valueObject = [currentComponentElements objectAtIndex:[self.pickerView selectedRowInComponent:i]];
        [valuesArray addObject:valueObject];
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
        }else{
            break;
        }
    }while(tmpComponent < 4);
    
    return tmpComponent;
}

- (NSArray *)getValuesWithSelectRows:(NSArray *)rows
{
    if (rows.count != self.componentCount) {
        NSAssert(NO, @"componentCount error");
        return nil;
    }
    
    NSArray *currentComponentElements = self.relatedOptionsArray;
    NSMutableArray *destValues = [NSMutableArray new];
    [destValues addObject:currentComponentElements.copy];
    
    for (NSInteger i = 0 ; i < self.componentCount-1; i++) {
        NSInteger row = [rows[i] integerValue];
        NSObject<DJRelatedPickerValueProtocol> *valueObject = currentComponentElements[row];
        currentComponentElements = valueObject.dj_childOptionsValues;
        [destValues addObject:currentComponentElements.copy];
    }
    
    return destValues;
}

- (NSString *)readValueObject:(NSObject *)valueObject
{
    if ([valueObject isKindOfClass:NSString.class]) {
        return (NSString *)valueObject;
    }else if([valueObject conformsToProtocol:@protocol(DJValueProtocol)]){
        return ((NSObject <DJValueProtocol> *)valueObject).dj_titleValue;
    }
    else if([valueObject conformsToProtocol:@protocol(DJRelatedPickerValueProtocol)]){
        return ((NSObject <DJRelatedPickerValueProtocol> *)valueObject).dj_titleValue;
    }else{
        NSAssert(NO, @"element must be NSString, object implements DJValueProtocol,object implements DJRelatedPickerValueProtocol");
        return @"";
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.componentValuesArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *titlesArray = [self.componentValuesArray objectAtIndex:component];
    NSAssert([titlesArray isKindOfClass:[NSArray class]], @"elements of optionsArray is also array");
    return [titlesArray count];
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *titlesArray = [self.componentValuesArray objectAtIndex:component];
    NSObject *valueObject = [titlesArray objectAtIndex:row];
    return [self readValueObject:valueObject];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self recaculateTitlesWithSelectComponent:component];
    [pickerView reloadAllComponents];
    //set row = 0 in component after current component
//    NSInteger componentCount = self.componentCount;
//    NSInteger i = component + 1;
//    while (i < componentCount) {
//        [self.pickerView selectRow:0 inComponent:i animated:YES];
//        i++;
//    }
    
    NSArray *valuesArray = [self updateCurrentValue];
    if (self.valueChangeBlock) {
        self.valueChangeBlock(valuesArray);
    }

//    [self updateCurrentValue];
    
}

@end
