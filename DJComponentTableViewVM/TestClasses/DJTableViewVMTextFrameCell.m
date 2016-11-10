//
//  DJComponentTableViewVMTextFrameCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/19.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJTableViewVMTextFrameCell.h"

@interface DJTableViewVMTextFrameCell()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DJTableViewVMTextFrameCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    [self.contentView addSubview:self.contentLabel];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.contentLabel.text = ((DJTableViewVMTextTestRow *)self.rowVM).contentText;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentLabel.frame = self.contentView.bounds;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.contentLabel sizeThatFits:size].height;
    totalHeight += 20; // margins
    return CGSizeMake(size.width, totalHeight);
}

#pragma mark - getter
- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor blackColor];
    }
    return _contentLabel;
}

@end
