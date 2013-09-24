//
//  WinAlertViewController.h
//  Milly
//
//  Created by 花澤 長行 on 2013/06/19.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "ViewController+Monster.h"
#import "ViewController.h"
#import "SVSegmentedControl.h"

@protocol winAlertDelegate <NSObject>

- (void)battleEndAndExplorRestart;
- (void)DeleteLayer:(CALayer*)layer;

@end


@interface WinAlertViewController : UIAlertView<UITableViewDataSource,UITableViewDelegate>

@property (copy) NSMutableArray *appearMonstersArray;

@property int risedExpValue;

//拾う予定のアイテム
@property NSMutableArray *willPickItem;

//拾うアイテムのフラグ
@property BOOL isItem1Pick;
@property BOOL isItem2Pick;
@property BOOL isItem3Pick;

@property (nonatomic, assign) id<winAlertDelegate> delegate;

@end
