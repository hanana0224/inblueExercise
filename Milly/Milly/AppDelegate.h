//
//  AppDelegate.h
//  Milly
//
//  Created by 花澤 長行 on 2013/05/26.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//音楽の状態フラグ
@property BOOL musicFlag;

//エリア制圧度
@property int areaLevelInt;

//プレイヤーファイル（一時保存）
@property NSArray *playerSkillFirst;
@property NSArray *playerSkillEquipedPlist;
@property NSArray *playerItem;
@property NSDictionary *playerPara;

//出現モンスター
@property NSMutableArray *delegateAppearMonsters;

//中ボスフラグ
@property BOOL isFOE;

//エリアボスフラグ
@property BOOL isBOSS;


@end
