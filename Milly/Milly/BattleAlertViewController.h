//
//  BattleAlertViewController.h
//  Milly
//
//  Created by 花澤 長行 on 2013/06/11.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"

@protocol BattleAlertDelegate <NSObject>

- (void)escapeSelected;
- (void)battleStarted;
- (void)FOEBatteleStarted;
- (void)bgmPlay:(NSString*)title;
- (void)bossBattleStarted;


@end

@interface BattleAlertViewController : UIAlertView

@property (nonatomic, assign) id<BattleAlertDelegate> delegate;

@property UIButton *btnStatus;
@property CATextLayer *btnStatusOverTextLayer1;
@property CATextLayer *btnStatusOverTextLayer2;

@property UIButton *btnSave;
@property CATextLayer *btnSaveOverTextLayer1;
@property CATextLayer *btnSaveOverTextLayer2;

@property AVAudioPlayer *soundEffect;

@property int alarm;

@end
