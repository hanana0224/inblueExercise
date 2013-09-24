//
//  ViewController+Battle.h
//  Milly
//
//  Created by 花澤 長行 on 2013/06/12.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "ViewController.h"
#import "ViewController+Player.h"

@protocol buttonDelegate <NSObject>

- (void)buttonDisableAnimationStart:(int)num;

@end

@interface UIViewController (monster)

-(void)battle;

@property (nonatomic, assign) id<buttonDelegate> delegate;

@end
