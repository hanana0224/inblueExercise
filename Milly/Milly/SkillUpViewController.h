//
//  SkillUpViewController.h
//  Milly
//
//  Created by 花澤 長行 on 2013/07/08.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@protocol skillUpDelegate <NSObject>

- (void)skillTableReload;
- (void)skillUpFlagOFF;
- (void)skillPointLabelUpdate;
- (void)flagOFF;


@end



@interface SkillUpViewController : UIAlertView

@property UIButton *btnStatus;
@property CATextLayer *btnStatusOverTextLayer1;
@property CATextLayer *btnStatusOverTextLayer2;

@property UIButton *btnSave;
@property CATextLayer *btnSaveOverTextLayer1;
@property CATextLayer *btnSaveOverTextLayer2;

@property (nonatomic, assign) id<skillUpDelegate> delegate;

@property UILabel *skillPointLabel;

@end
