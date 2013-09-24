//
//  StatusViewController.h
//  Milly
//
//  Created by 花澤 長行 on 2013/05/29.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "MagicSetViewController.h"
#import "EquipmentViewController.h"
#import "MovingAlertView.h"
#import <MrdIconSDK/MrdIconSDK.h>
#import <iAd/iAd.h>

@interface StatusViewController : UIViewController<ADBannerViewDelegate>

//音楽変更用
@property int stageValueOld;
@property int stageValueNew;

@end
