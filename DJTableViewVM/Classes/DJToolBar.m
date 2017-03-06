//
//  DJToolBar.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/6.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJToolBar.h"

@interface DJToolBar()

@property(nonatomic, strong) NSString *placeholder;

@property(nonatomic, strong) UIBarButtonItem *preButton;
@property(nonatomic, strong) UIBarButtonItem *nextButton;
@property(nonatomic, strong) UIBarButtonItem *doneButton;
@property(nonatomic, strong) UIBarButtonItem *placeHolderItem;

@end

@implementation DJToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setupCurrentView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupCurrentView];
}

- (void)setupCurrentView
{
    NSBundle *resoureBundle = [self resourceBundle];
    if (resoureBundle == nil) {
        resoureBundle = [NSBundle mainBundle];
    }
    
    UIImage *preImage = [UIImage imageNamed:@"DJArrowLeft" inBundle:resoureBundle compatibleWithTraitCollection:nil];
    self.preButton = [[UIBarButtonItem alloc] initWithImage:preImage style:UIBarButtonItemStylePlain target:self action:@selector(onTouchPre)];
    
    UIBarButtonItem *emptyItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    emptyItem.width = 20;
    
    UIImage *nextImage = [UIImage imageNamed:@"DJArrowRight" inBundle:resoureBundle compatibleWithTraitCollection:nil];
    self.nextButton = [[UIBarButtonItem alloc] initWithImage:nextImage style:UIBarButtonItemStylePlain target:self action:@selector(onTouchNext)];

    self.placeHolderItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.placeHolderItem.tintColor = [UIColor lightGrayColor];
    self.placeHolderItem.enabled = NO;
    
    UIBarButtonItem *emptyLeftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *emptyRightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onTouchDone)];
    
    self.items = @[self.preButton,emptyItem,self.nextButton,emptyLeftItem,self.placeHolderItem,emptyRightItem,self.doneButton];
}

#pragma mark - actions
- (NSBundle *)resourceBundle
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"DJTableViewVM" ofType:@"bundle"];
    NSBundle *nibBundle = [NSBundle bundleWithPath:bundlePath];
    return nibBundle;
}
- (void)onTouchPre
{
    if (self.tapPreHandler) {
        self.tapPreHandler();
    }
}

- (void)onTouchNext
{
    if (self.tapNextHandler) {
        self.tapNextHandler();
    }
}

- (void)onTouchDone
{
    if (self.tapDoneHandler) {
        self.tapDoneHandler();
    }
}

#pragma mark - seter
- (void)setDoneTitle:(NSString *)doneTitle
{
    _doneTitle = doneTitle;
    self.doneButton.title = doneTitle;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeHolderItem.title = placeholder;
}

- (void)setPreEnable:(BOOL)preEnable
{
    _preEnable = preEnable;
    self.preButton.enabled = preEnable;
}

- (void)setNextEnable:(BOOL)nextEnable
{
    _nextEnable = nextEnable;
    self.nextButton.enabled = nextEnable;
}


@end
