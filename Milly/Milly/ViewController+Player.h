//
//  ViewController+Player.h
//  Milly
//
//  Created by 花澤 長行 on 2013/06/14.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "ViewController.h"

@interface UIViewController (Player)


- (void)pushedButtonNumber0:(UIButton*)button;
- (void)pushedButtonNumber1:(UIButton*)button;
- (void)pushedButtonNumber2:(UIButton*)button;
- (void)pushedButtonNumber3:(UIButton*)button;

- (void)millyAnimationChange;

- (void)buttonDisableAnimationStart:(int)num;

@end
