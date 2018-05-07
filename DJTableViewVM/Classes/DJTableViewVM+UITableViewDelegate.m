//
//  DJComponentTableViewVM+UITableViewDelegate.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJTableViewVM+UITableViewDelegate.h"
#import "DJTableViewVMCell.h"
#import "DJTableViewVMSection.h"
#import "DJTableViewVMRow.h"
#import "DJLog.h"

@implementation DJTableViewVM(UITableViewDelegate)

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkAvaliableForIndexPath:indexPath] == NO) {
        return 0;
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    DJTableViewVMSection *section = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    if (row.cellHeight == 0 || row.heightForceRefreshEnable) {
        if (row.heightCaculateType == DJCellHeightCaculateDefault) {
            NSString *cellClassName = [self objectAtKeyedSubscript:NSStringFromClass(row.class)];
            row.cellHeight = [NSClassFromString(cellClassName) heightWithRow:row tableViewVM:self];
        }else{
            row.cellHeight = [self heightWithAutoLayoutCellForIndexPath:indexPath];
            DJLog(@"auto caculate cell(position:%@) height:%f",indexPath,row.cellHeight);
        }
    }
    return row.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]){
        return [self.delegate tableView:tableView heightForHeaderInSection:sectionIndex];
    }
    
    return [self heightWithSectionIndex:sectionIndex isHeader:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]){
        return [self.delegate tableView:tableView heightForFooterInSection:sectionIndex];
    }
    
    return [self heightWithSectionIndex:sectionIndex isHeader:NO];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkAvaliableForIndexPath:indexPath] == NO) {
        return 0;
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }
    
    if (self.sections.count <= indexPath.section) {
        return UITableViewAutomaticDimension;
    }
    
    if (self.estimatedRowHeight > 0.0f) {
        return self.estimatedRowHeight;
    }
    
    DJTableViewVMSection *section = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    NSString *cellClassName = [self objectAtKeyedSubscript:NSStringFromClass(row.class)];
    CGFloat height = 0;
    if (row.cellHeight == 0) {
        height = [NSClassFromString(cellClassName) heightWithRow:row tableViewVM:self];
    }else{
        height = row.cellHeight;
    }
    
    return height ? height : UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0)
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:estimatedHeightForHeaderInSection:)]){
        return [self.delegate tableView:tableView estimatedHeightForHeaderInSection:section];
    }
    
    if (section < self.sections.count){
        DJTableViewVMSection *sectionVM = [self.sections objectAtIndex:section];
        if (sectionVM.headerView){
            return sectionVM.headerView.frame.size.height;
        }
        
        if (sectionVM.headerTitle){
            return 28;// default height for header
        }
    }

    return self.tableView.estimatedSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0)
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:estimatedHeightForFooterInSection:)]){
        return [self.delegate tableView:tableView estimatedHeightForFooterInSection:section];
    }

    if (section < self.sections.count){
        DJTableViewVMSection *sectionVM = [self.sections objectAtIndex:section];
        if (sectionVM.footerView){
            return sectionVM.footerView.frame.size.height;
        }
        
        if (sectionVM.footerTitle){
            return 28;// default height for footer
        }
    }
    
    return self.tableView.estimatedSectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]){
        return [self.delegate tableView:tableView viewForHeaderInSection:sectionIndex];
    }
    
    if (self.sections.count <= sectionIndex) {
        return nil;
    }
    DJTableViewVMSection *section = [self.sections objectAtIndex:sectionIndex];
    return section.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]){
        return [self.delegate tableView:tableView viewForFooterInSection:sectionIndex];
    }
    
    if (self.sections.count <= sectionIndex) {
        return nil;
    }
    DJTableViewVMSection *section = [self.sections objectAtIndex:sectionIndex];
    return section.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkAvaliableForIndexPath:indexPath] == NO) {
        return;
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    DJTableViewVMSection *section = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    if ([row respondsToSelector:@selector(setSelectionHandler:)]){
        DJTableViewVMRow *actionRow = (DJTableViewVMRow *)row;
        if (actionRow.selectionHandler) {
            actionRow.selectionHandler(actionRow);
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]){
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]){
        [self.delegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]){
        [self.delegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(cellDidDisappear)]){
        [(UITableViewCell<DJTableViewVMCellProtocol> *)cell cellDidDisappear];
    }
    
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]){
        [self.delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)]){
        [self.delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]){
        [self.delegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkAvaliableForIndexPath:indexPath] == NO) {
        return;
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]){
        [self.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
    DJTableViewVMSection *section = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    if ([row respondsToSelector:@selector(setSelectionHandler:)]){
        DJTableViewVMRow *actionRow = (DJTableViewVMRow *)row;
        if (actionRow.accessoryButtonTapHandler) {
            actionRow.accessoryButtonTapHandler(actionRow);
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]){
        return [self.delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)]){
        [self.delegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)]){
        [self.delegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]){
        return [self.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]){
        return [self.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]){
        [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkAvaliableForIndexPath:indexPath] == NO) {
        return UITableViewCellEditingStyleNone;
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    DJTableViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
    return rowVM.editingStyle;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkAvaliableForIndexPath:indexPath] == NO) {
        return nil;
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView editActionsForRowAtIndexPath:indexPath];
    }
    DJTableViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
    return rowVM.editActions;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    
    return NSLocalizedString(@"Delete", @"Delete");
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]){
        return [self.delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    
    return YES;
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]){
        [self.delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]){
        [self.delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([self checkAvaliableForIndexPath:sourceIndexPath] == NO) {
        return sourceIndexPath;
    }
    
    DJTableViewVMSection *sourceSection = [self.sections objectAtIndex:sourceIndexPath.section];
    DJTableViewVMRow *rowVM = [sourceSection.rows objectAtIndex:sourceIndexPath.row];
    if (rowVM.moveCellHandler) {
        BOOL allowed = rowVM.moveCellHandler(rowVM, sourceIndexPath, proposedDestinationIndexPath);
        if (!allowed){
            return sourceIndexPath;
        }
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]){
        return [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }
    
    return proposedDestinationIndexPath;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkAvaliableForIndexPath:indexPath] == NO) {
        return NO;
    }
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    
    DJTableViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
    return (rowVM.copyHandler || rowVM.pasteHandler);
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([self checkAvaliableForIndexPath:indexPath] == NO) {
        return NO;
    }
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]){
        return [self.delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    DJTableViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
    if (rowVM.copyHandler && action == @selector(copy:)){
        return YES;
    }
    if (rowVM.pasteHandler && action == @selector(paste:)){
        return YES;
    }
    if (rowVM.cutHandler && action == @selector(cut:)){
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([self checkAvaliableForIndexPath:indexPath] == NO) {
        return;
    }
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]){
        [self.delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    
    DJTableViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
    
    if (action == @selector(copy:) && rowVM.copyHandler) {
        rowVM.copyHandler(rowVM);
    }
    if (action == @selector(paste:) && rowVM.pasteHandler) {
        rowVM.pasteHandler(rowVM);
    }
    if (action == @selector(cut:) && rowVM.cutHandler) {
        rowVM.cutHandler(rowVM);
    }
}

#pragma mark - private methods
- (BOOL)checkAvaliableForIndexPath:(NSIndexPath *)indexPath
{
    if (self.sections.count > indexPath.section) {
        DJTableViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
        if (sectionVM.rows.count > indexPath.row) {
            return YES;
        }
    }
    
    return NO;
}

- (CGFloat)heightWithSectionIndex:(NSInteger )sectionIndex isHeader:(BOOL)isHeader
{
    if (self.sections.count <= sectionIndex) {
        return 0;
    }
    
    DJTableViewVMSection *sectionVM = [self.sections objectAtIndex:sectionIndex];
    UIView *sectionView = isHeader ? sectionVM.headerView : sectionVM.footerView;
    DJSectionHeightCaculateType caculateType = isHeader ? sectionVM.headerHeightCaculateType : sectionVM.footerHeightCaculateType;
    NSString *heightCacheKey = isHeader ? @"DJSectionVMHeaderHeightKey" : @"DJSectionVMFooterHeightKey";
    
    //UITableView init in Xib has default height 28
    //    if (self.sectionHeaderHeight > 0.0f) {
    //        return self.sectionHeaderHeight;
    //    }
    
    if(sectionView) {
        if (caculateType == DJSectionHeightCaculateTypeDefault) {
            return sectionView.frame.size.height;
        }else if(caculateType == DJSectionHeightCaculateTypeAutomatic){
            CGFloat cacheHeight = [[sectionVM.automaticHeightCache valueForKey:heightCacheKey] floatValue];
            if (cacheHeight == 0 || sectionVM.isSectionHeightNeedRefresh) {
                CGFloat contentViewWidth = CGRectGetWidth(self.tableView.frame);
                if (contentViewWidth > 0) {
                    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:sectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
                    [sectionView addConstraint:widthFenceConstraint];
                    CGSize sectionViewSize = [sectionView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                    [sectionView removeConstraint:widthFenceConstraint];
                    
                    [sectionVM.automaticHeightCache setValue:@(sectionViewSize.height) forKey:heightCacheKey];
                    sectionVM.isSectionHeightNeedRefresh = NO;
                    
                    return sectionViewSize.height;
                }
            }else{
                return cacheHeight;
            }
            
        }
    }
    
    return UITableViewAutomaticDimension;
}

@end
