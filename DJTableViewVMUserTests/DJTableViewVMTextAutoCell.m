//
//  DJComponentTableViewVMTextAutoCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/19.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJTableViewVMTextAutoCell.h"

@interface DJTableViewVMTextAutoCell()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation DJTableViewVMTextAutoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.contentLabel];
}

- (void)setupLayout
{
    NSDictionary *views = NSDictionaryOfVariableBindings(_contentLabel);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentLabel]|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentLabel]|" options:0 metrics:nil views:views]];
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    self.contentLabel.text = ((DJTableViewVMTextTestRow *)self.rowVM).contentText;
}

#pragma mark - getter
- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [UILabel new];
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _contentLabel;
}

@end
