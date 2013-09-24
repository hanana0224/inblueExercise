//
//  DropAlertViewController.h
//  Milly
//
//  Created by 花澤 長行 on 2013/06/11.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@protocol dropDelegate <NSObject>

- (void)itemDrop2;

@end

@interface DropAlertViewController : UIAlertView

@property (nonatomic, assign) id<dropDelegate> delegate;

@property UIButton *btnStatus;
@property CATextLayer *btnStatusOverTextLayer1;
@property CATextLayer *btnStatusOverTextLayer2;

@property UIButton *btnSave;
@property CATextLayer *btnSaveOverTextLayer1;
@property CATextLayer *btnSaveOverTextLayer2;


@end
