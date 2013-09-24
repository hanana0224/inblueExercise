//
//  ViewController.h
//  Milly
//
//  Created by 花澤 長行 on 2013/05/26.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>
#import "AppDelegate.h"
#import "StatusViewController.h"
#import "BattleAlertViewController.h"
#import "ViewController+Monster.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ViewController+Player.h"
#import "UIViewController+PlayerMagic.h"
#import "WinAlertViewController.h"
#import "SimpleAudioEngine.h"
#import "CongratuationViewController.h"

@interface ViewController : UIViewController<ADBannerViewDelegate>
{
    UIButton *btnGo,*btnRest,*btnStatus,*btnSave;
    
    //カテゴリ用
    CALayer *monsterLayer,*battleTitle,*millyDefault,*circleLayer,*effectChargeLayer,*targetLayer;
    CALayer *monsterLayer1,*monsterLayer2,*monsterLayer3;
    UITextView *txtvw;
    NSMutableArray *monsterLayers,*appearMonstersArray;
    UILabel *lifeLabel;
    CALayer *attackWindow1,*attackWindow2,*attackWindow3;
    
    NSInteger monsterCount;
    NSInteger targetMonster;
    NSInteger selectingMonsterID;
    NSInteger selectedTarget;
    
    //死亡判定用モンスター体力
    NSInteger monsterLife1,monsterLife2,monsterLife3;
    
    //フラグ
    BOOL isMonster1Dead;
    BOOL isMonster2Dead;
    BOOL isMonster3Dead;
    
    ViewController *monsterLifeObject;
    
    //ターゲット切り替えボタン
    UIButton *targetButton1,*targetButton2,*targetButton3;
    
        
    //使用魔法仮保存インスタンス
    int magicalNumber;
    int pushedButtonNumber;
    
    //カースフラグ
    BOOL isCurse;
    NSInteger cursedTarget;
    
    //テスタメントフラグ
    BOOL isTestament;
    
    //守護者の召喚フラグ
    BOOL isShield;
    CALayer *shieldBackLayer;
    
    //結界回数
    BOOL isBarrier;
    CALayer *barrierBackLayer;
    
    //モンスターのライフバー
    UIProgressView *monsterLifeBar1;
    UIProgressView *monsterLifeBar2;
    UIProgressView *monsterLifeBar3;
    
    //新ボタンの使用可否フラグ
    ViewController *buttonObject;
    BOOL button1Enable;
    BOOL button2Enable;
    BOOL button3Enable;
    BOOL button4Enable;
    
    //ディレイ中フラグ
    BOOL button1Deley;
    BOOL button2Deley;
    BOOL button3Deley;
    BOOL button4Deley;
    
    //ボタン使用可否レイヤー
    CALayer *timerBackGround1;
    CALayer *timerBackGround2;
    CALayer *timerBackGround3;
    CALayer *timerBackGround4;
    
    //プレイヤー死亡管理
    ViewController *playerObject;
    NSInteger playerLife;
    BOOL isPlayerAlive;
    CALayer *downLayer;
    CALayer *downBackground;
    UIButton *downButton;
    
    //勝利フラグ
    BOOL isWin;
        

}
//ボタン表記シリーズ
@property UIButton *btnGo;
@property CATextLayer *btnGoOverTextLayer1;
@property CATextLayer *btnGoOverTextLayer2;

@property UIButton *btnRest;
@property CATextLayer *btnRestOverTextLayer1;
@property CATextLayer *btnRestOverTextLayer2;

@property UIButton *btnStatus;
@property CATextLayer *btnStatusOverTextLayer1;
@property CATextLayer *btnStatusOverTextLayer2;

@property UIButton *btnSave;
@property CATextLayer *btnSaveOverTextLayer1;
@property CATextLayer *btnSaveOverTextLayer2;


//カテゴリ用
@property CALayer *monsterLayer,*battleTitle,*millyDefault,*circleLayer,*effectChargeLayer,*targetLayer;
@property CALayer *monsterLayer1,*monsterLayer2,*monsterLayer3;
@property UITextView *txtvw;
@property NSMutableArray *monsterLayers;
@property NSMutableArray *appearMonstersArray;
@property UILabel *lifeLabel;
@property CALayer *attackWindow1,*attackWindow2,*attackWindow3;

@property NSInteger monsterCount;
@property NSInteger targetMonster;
@property NSInteger selectingMonsterID;
@property NSInteger selectedTarget;

//死亡判定用モンスター体力
@property NSInteger monsterLife1,monsterLife2,monsterLife3;
@property BOOL isMonster1Dead,isMonster2Dead,isMonster3Dead;
@property UIButton *targetButton1,*targetButton2,*targetButton3;

@property ViewController *monsterLifeObject;

//使用魔法仮保存インスタンス
@property int magicalNumber;
@property int pushedButtonNumber;

//カースフラグ
@property BOOL isCurse;
@property NSInteger cursedTarget;

//テスタメントフラグ
@property BOOL isTestament;

//守護者の召喚フラグ
@property BOOL isShield;
@property CALayer *shieldBackLayer;

//結界
@property BOOL isBarrier;
@property CALayer *barrierBackLayer;

//モンスターのライフバー
@property UIProgressView *monsterLifeBar1;
@property UIProgressView *monsterLifeBar2;
@property UIProgressView *monsterLifeBar3;

//新ボタンの使用可否フラグ
@property ViewController *buttonObject;
@property BOOL button1Enable;
@property BOOL button2Enable;
@property BOOL button3Enable;
@property BOOL button4Enable;

//ディレイ中フラグ
@property BOOL button1Deley;
@property BOOL button2Deley;
@property BOOL button3Deley;
@property BOOL button4Deley;

//ボタン使用可否レイヤー
@property CALayer *timerBackGround1;
@property CALayer *timerBackGround2;
@property CALayer *timerBackGround3;
@property CALayer *timerBackGround4;

//プレイヤー死亡管理
@property ViewController *playerObject;
@property NSInteger playerLife;
@property BOOL isPlayerAlive;
@property CALayer *downLayer;
@property CALayer *downBackground;
@property UIButton *downButton;

//勝利フラグ
@property BOOL isWin;

- (void)bgmPlay:(NSString*)title;

- (void)buttonDisable:(NSArray*)arr;
- (void)buttonEnable:(NSArray*)arr;

- (void)battleEndAndExplorRestart;
- (void)areaDegreeUpdate;
- (void)lifeLabelWillUpdate;

- (void)millyAnimationReady;


@end

