//
//  DJTableViewVM+Keyboard.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/2/20.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVM.h"

@interface DJTableViewVM (Keyboard)

- (void)scrollHideKeyboard;//check keyboard while scrolling.
- (void)registKeyboard;
- (void)unregistKeyboard;

@end
