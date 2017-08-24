//
//  DJTableViewVMRelatedPickerCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMRelatedPickerCell.h"
@interface DJTableViewVMRelatedPickerCell()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation DJTableViewVMRelatedPickerCell
@dynamic rowVM;

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    self.textField.inputView = self.pickerView;
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    self.detailTextLabel.text = self.rowVM.valueArray ? [self.rowVM.valueArray componentsJoinedByString:@","] : @"";
    self.placeholderLabel.text = self.rowVM.placeholder;
    if (self.rowVM.attributedPlaceholder) {
        self.placeholderLabel.attributedText = self.rowVM.attributedPlaceholder;
    }
    if (self.rowVM.toolbarTintColor) {
        self.accessoryView.tintColor = self.rowVM.toolbarTintColor;
    }
    
    self.placeholderLabel.hidden = self.detailTextLabel.text.length > 0;
}

- (void)updateCurrentValue
{
    NSMutableArray *valuesArray = [NSMutableArray array];
    
    NSInteger componentCount = [self getComponentCount];
    for (NSInteger i = 0; i < componentCount; i++) {
        NSArray *currentComponentElements = [self getValuesWithConponent:i];
        NSString *valueObject = [currentComponentElements objectAtIndex:[self.pickerView selectedRowInComponent:i]];
        NSString *valueText = [self readValueObject:valueObject];
        [valuesArray addObject:valueText];
    }

    self.rowVM.valueArray = [valuesArray copy];
    self.detailTextLabel.text = self.rowVM.valueArray ? [self.rowVM.valueArray componentsJoinedByString:@","] : @"";
    self.placeholderLabel.hidden = self.detailTextLabel.text.length > 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.rowVM.valueArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull valueElement, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.rowVM.relatedOptionsArray.count > idx) {
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
}

- (NSInteger)getComponentCount
{
    NSInteger tmpComponent = 0;
    NSArray *currentComponentElements = self.rowVM.relatedOptionsArray;
    
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
    NSArray *currentComponentElements = self.rowVM.relatedOptionsArray;
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
    [self updateCurrentValue];
    if (self.rowVM.onValueChangeHandler){
        self.rowVM.onValueChangeHandler(self.rowVM);
    }
    
    //set row = 0 in component after current component
    NSInteger componentCount = [self getComponentCount];
    NSInteger i = component + 1;
    while (i < componentCount) {
        i++;
        [self.pickerView selectRow:0 inComponent:i animated:YES];
    }
    
    [pickerView reloadAllComponents];
    [self updateCurrentValue];
    
}

#pragma mark - getter
- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectNull];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

@end
