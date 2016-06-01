//
//  DJComponentTableViewVMTextTestCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/19.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJTableViewVMTextTestCell.h"

@interface DJTableViewVMTextTestCell()

@property(nonatomic, weak) IBOutlet UILabel *nibTextLabel;

@end

@implementation DJTableViewVMTextTestCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
 
    }
    return self;
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.nibTextLabel.text = ((DJTableViewVMTextTestRow *)self.rowVM).contentText;
}


@end
