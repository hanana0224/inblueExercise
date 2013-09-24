//
//  UIViewController+PlayerMagic.h
//  Milly
//
//  Created by 花澤 長行 on 2013/06/16.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "ViewController.h"

@interface UIViewController (PlayerMagic)

- (void)playerMagicStart:(int)magicID;

- (void)buttonEnableOthers;
- (void)win;

@end
