//
//  CustomAlertView.h
//  Milly
//
//  Created by 花澤 長行 on 2013/06/06.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EquipmentViewController.h"
#import "SimpleAudioEngine.h"

@protocol CustomDelegate <NSObject>

- (void)equipNext:(int)buttonNumber;
- (void)equipcancel;

@end


@interface CustomAlertView : UIAlertView<UIAlertViewDelegate>

@property (nonatomic, assign) id<CustomDelegate> delegate;

@end

