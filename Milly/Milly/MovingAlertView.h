//
//  MovingAlertView.h
//  Milly
//
//  Created by 花澤 長行 on 2013/07/12.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#import "ViewController.h"

@protocol messageDelegate <NSObject>

- (void)moveMessageAppear;
- (void)areaDegreeUpdate;

@end


@interface MovingAlertView : UIAlertView

@property (nonatomic, assign) id<messageDelegate> delegate;

@end
