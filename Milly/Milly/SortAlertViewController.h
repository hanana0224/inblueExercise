//
//  SortAlertViewController.h
//  Milly
//
//  Created by 花澤 長行 on 2013/06/07.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EquipmentViewController.h"
#import "SimpleAudioEngine.h"

@protocol SortDelegate <NSObject>

- (void)sort:(int)buttonNumber;

@end


@interface SortAlertViewController : UIAlertView

@property (nonatomic, assign) id<SortDelegate> delegate;

@property UIView *test;

@end
