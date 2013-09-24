//
//  ViewController+Battle.m
//  Milly
//
//  Created by 花澤 長行 on 2013/06/12.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "ViewController+Monster.h"

@implementation ViewController (Battle)



- (void)battle{
    
    //フラグ初期化
    isMonster1Dead = NO;
    isMonster2Dead = NO;
    isMonster3Dead = NO;
    
    isWin = NO;
    
    isCurse = NO;
    cursedTarget = 0;
    
    //SEをプリロード
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"damage7.mp3"];
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    //音楽再生
    if(delegate.isBOSS == YES){
        
        //モンスター出現
        [self performSelector:@selector(bossAppear) withObject:nil afterDelay:0.5];

        
    }else if(delegate.isFOE == YES){
        
        //モンスター出現
        [self performSelector:@selector(FOEAppear) withObject:nil afterDelay:0.5];
        
        //音楽再生
        if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 3) {
            [self performSelector:@selector(battleBGM:) withObject:@"394.mp3" afterDelay:1.2];
        }else{
        [self performSelector:@selector(battleBGM:) withObject:@"214.mp3" afterDelay:1.2];
        }
        
    }else{
        
        //モンスター出現
        [self performSelector:@selector(monsterApper) withObject:nil afterDelay:0.5];

        //音楽再生
        if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 3) {
            [self performSelector:@selector(battleBGM:) withObject:@"Heavy Hitter (Theme).mp3" afterDelay:1.2];
        }else{
            [self performSelector:@selector(battleBGM:) withObject:@"170.mp3" afterDelay:1.2];
        }
        
        
        
    }
    
    //プレイヤー体力を監視に登録
    playerObject = [[ViewController alloc]init];
    [playerObject addObserver:self forKeyPath:@"playerLife" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [playerObject setPlayerLife:[[delegate.playerPara valueForKey:@"currentLife"] integerValue]];
    
    //フラグ初期か
    isPlayerAlive = YES;
    
    //フラグをYESで初期化
    buttonObject = [[ViewController alloc]init];
    
    
    //４ボタンを監視に登録
    [buttonObject addObserver:self forKeyPath:@"button1Enable" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [buttonObject addObserver:self forKeyPath:@"button2Enable" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [buttonObject addObserver:self forKeyPath:@"button3Enable" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [buttonObject addObserver:self forKeyPath:@"button4Enable" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    //初期化
    [buttonObject setButton1Enable:YES];
    [buttonObject setButton2Enable:YES];
    [buttonObject setButton3Enable:YES];
    [buttonObject setButton4Enable:YES];
    
    button1Deley = NO;
    button2Deley = NO;
    button3Deley = NO;
    button4Deley = NO;
    
    
    //使用不可のレイヤーを事前作成
    timerBackGround1 = [CALayer layer];
    timerBackGround1.backgroundColor = [UIColor blackColor].CGColor;
    timerBackGround1.opacity = 1.0;
    timerBackGround1.frame = CGRectMake(440, self.view.frame.size.height - 130, 70, 70);
    [self.view.layer addSublayer:timerBackGround1];
    
    CATextLayer *disableText = [CATextLayer layer];
    [disableText setString:@"使用"];
    disableText.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    disableText.fontSize = 30;
    disableText.foregroundColor = [UIColor whiteColor].CGColor;
    disableText.frame = CGRectMake(0, 3, 70, 70);
    disableText.alignmentMode = kCAAlignmentCenter;
    disableText.contentsScale = [UIScreen mainScreen].scale;
    [timerBackGround1 addSublayer:disableText];
    
    CATextLayer *disableText2 = [CATextLayer layer];
    [disableText2 setString:@"不可"];
    disableText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    disableText2.fontSize = 30;
    disableText2.foregroundColor = [UIColor whiteColor].CGColor;
    disableText2.frame = CGRectMake(0, 35, 70, 35);
    disableText2.alignmentMode = kCAAlignmentCenter;
    disableText2.contentsScale = [UIScreen mainScreen].scale;
    [timerBackGround1 addSublayer:disableText2];
    
    //ふたつめ
    timerBackGround2 = [CALayer layer];
    timerBackGround2.backgroundColor = [UIColor blackColor].CGColor;
    timerBackGround2.opacity = 1.0;
    timerBackGround2.frame = CGRectMake(360, self.view.frame.size.height - 130, 70, 70);
    [self.view.layer addSublayer:timerBackGround2];
    
    CATextLayer *disableText3 = [CATextLayer layer];
    [disableText3 setString:@"使用"];
    disableText3.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    disableText3.fontSize = 30;
    disableText3.foregroundColor = [UIColor whiteColor].CGColor;
    disableText3.frame = CGRectMake(0, 3, 70, 70);
    disableText3.alignmentMode = kCAAlignmentCenter;
    disableText3.contentsScale = [UIScreen mainScreen].scale;
    [timerBackGround2 addSublayer:disableText3];
    
    CATextLayer *disableText4 = [CATextLayer layer];
    [disableText4 setString:@"不可"];
    disableText4.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    disableText4.fontSize = 30;
    disableText4.foregroundColor = [UIColor whiteColor].CGColor;
    disableText4.frame = CGRectMake(0, 35, 70, 35);
    disableText4.alignmentMode = kCAAlignmentCenter;
    disableText4.contentsScale = [UIScreen mainScreen].scale;
    [timerBackGround2 addSublayer:disableText4];
    
    
    //みっつめ
    timerBackGround3 = [CALayer layer];
    timerBackGround3.backgroundColor = [UIColor blackColor].CGColor;
    timerBackGround3.opacity = 1.0;
    timerBackGround3.frame = CGRectMake(440, self.view.frame.size.height - 210, 70, 70);
    [self.view.layer addSublayer:timerBackGround3];
    
    CATextLayer *disableText5 = [CATextLayer layer];
    [disableText5 setString:@"使用"];
    disableText5.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    disableText5.fontSize = 30;
    disableText5.foregroundColor = [UIColor whiteColor].CGColor;
    disableText5.frame = CGRectMake(0, 3, 70, 70);
    disableText5.alignmentMode = kCAAlignmentCenter;
    disableText5.contentsScale = [UIScreen mainScreen].scale;
    [timerBackGround3 addSublayer:disableText5];
    
    CATextLayer *disableText6 = [CATextLayer layer];
    [disableText6 setString:@"不可"];
    disableText6.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    disableText6.fontSize = 30;
    disableText6.foregroundColor = [UIColor whiteColor].CGColor;
    disableText6.frame = CGRectMake(0, 35, 70, 35);
    disableText6.alignmentMode = kCAAlignmentCenter;
    disableText6.contentsScale = [UIScreen mainScreen].scale;
    [timerBackGround3 addSublayer:disableText6];
    
    //よっつめ
    timerBackGround4 = [CALayer layer];
    timerBackGround4.backgroundColor = [UIColor blackColor].CGColor;
    timerBackGround4.opacity = 1.0;
    timerBackGround4.frame = CGRectMake(360, self.view.frame.size.height - 210, 70, 70);
    [self.view.layer addSublayer:timerBackGround4];
    
    CATextLayer *disableText7 = [CATextLayer layer];
    [disableText7 setString:@"使用"];
    disableText7.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    disableText7.fontSize = 30;
    disableText7.foregroundColor = [UIColor whiteColor].CGColor;
    disableText7.frame = CGRectMake(0, 3, 70, 70);
    disableText7.alignmentMode = kCAAlignmentCenter;
    disableText7.contentsScale = [UIScreen mainScreen].scale;
    [timerBackGround4 addSublayer:disableText7];
    
    CATextLayer *disableText8 = [CATextLayer layer];
    [disableText8 setString:@"不可"];
    disableText8.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    disableText8.fontSize = 30;
    disableText8.foregroundColor = [UIColor whiteColor].CGColor;
    disableText8.frame = CGRectMake(0, 35, 70, 35);
    disableText8.alignmentMode = kCAAlignmentCenter;
    disableText8.contentsScale = [UIScreen mainScreen].scale;
    [timerBackGround4 addSublayer:disableText8];

}

- (void)battleBGM:(NSString*)string{
    
    //戦闘音楽再生
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:string loop:YES];
}


#pragma mark monsterAppear
- (void)monsterApper{
    
    //定数を設定
    const float monsterLayerOriginX = 0;
    const float monsterLayerOriginY = 60;
    const float monsterLayerWidth = 320;
    const float monsterLayerHeight = self.view.frame.size.height -220 -60;
    
    monsterLayer = [CALayer layer];
    int monsterArea = self.view.frame.size.height -220 -60;
    monsterLayer.frame = CGRectMake(monsterLayerOriginX,monsterLayerOriginY,monsterLayerWidth,monsterLayerHeight);
    [self.view.layer addSublayer:monsterLayer];
    
    //モンスターの出現数をルーレッツ！
    int monsterRan = arc4random() % 100;
    
    //モンスターのレイヤーを配列に保存の準備
    monsterLayers =[[NSMutableArray alloc]init];
    
    //ダメージ計算用にモンスターID保存配列を用意
    appearMonstersArray = [[NSMutableArray alloc]init];
    
    //死亡フラグをリセット
    isMonster1Dead = NO;
    isMonster2Dead = NO;
    isMonster3Dead = NO;
    
    //queueに動作を登録していくよ！
    //モンスター一体出現時
    if (monsterRan <= 40) {
        
        monsterLayer1 = [CALayer layer];
        
        int ran = arc4random() % 7;
        
        //ステージごとのモンスター選出
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
        
        ran = ran + 7*stageValue;
                
        UIImage *monsterImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"m%02d", ran] ofType:@"png"]];
        monsterLayer1.contents = (id)monsterImage.CGImage;
         monsterLayer1.frame = CGRectMake(0, 0, 320, monsterArea);
        
        if (monsterImage.size.height > monsterArea || monsterImage.size.width > 320) {
            monsterLayer1.contentsGravity = kCAGravityResizeAspect;
        }else{
        monsterLayer1.contentsGravity = kCAGravityCenter;
        }
                
        [monsterLayer addSublayer:monsterLayer1];
        
        //出現時のアニメーション
        [self monsterAppearAnimation:monsterLayer1];
        
                
        //フラグオン
        monsterCount = 1;
        isMonster1Dead = NO;
        
        //ダメージ算出用に配列に保存
        [appearMonstersArray addObject:[NSNumber numberWithInt:ran]];
        
        [self addTargetMonster:monsterLayer monster:1];
        
        //モンスター体力をセット&モンスターライフを監視
        NSString *path = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
        NSArray *dic = [[NSArray alloc]initWithContentsOfFile:path];
        
        monsterLifeObject = [[ViewController alloc]init];
        [monsterLifeObject setMonsterLife1:[[[dic objectAtIndex:ran]valueForKey:@"life"]integerValue]];
        
        [monsterLifeObject addObserver:self forKeyPath:@"monsterLife1" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        //攻撃開始
        [self enemyAttackQueue:monsterLayer1 monsterID:ran attackArrayKey:@"attack1"];

        
                

    //モンスター２体出現
    }else if(monsterRan > 40 && monsterRan <=75){
        
        monsterLayer1 = [CALayer layer];
        int ran = arc4random() % 7;
        
        //ステージごとのモンスター選出
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
        
        ran = ran + 7*stageValue;
        
        UIImage *monsterImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"m%02d", ran] ofType:@"png"]];
        monsterLayer1.contents = (id)monsterImage.CGImage;
        monsterLayer1.frame = CGRectMake(0, 0, 160, monsterArea);
        
        if (monsterImage.size.height > monsterArea || monsterImage.size.width > 160) {
            monsterLayer1.contentsGravity = kCAGravityResizeAspect;
        }else{
            monsterLayer1.contentsGravity = kCAGravityCenter;
        }
        
        [monsterLayer addSublayer:monsterLayer1];
                
        
        
        //ダメージ算出用に配列に保存
        [appearMonstersArray addObject:[NSNumber numberWithInt:ran]];
        
        //出現時のアニメーション
        [self monsterAppearAnimation:monsterLayer1];
        
        monsterLayer2 = [CALayer layer];
        int ran2 = arc4random() % 7;
        
        //ステージごとのモンスター選出
//        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
//        int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
        
        ran2 = ran2 + 7*stageValue;
        
        UIImage *monsterImage2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"m%02d", ran2] ofType:@"png"]];
        monsterLayer2.contents = (id)monsterImage2.CGImage;
        monsterLayer2.frame = CGRectMake(160, 0, 160, monsterArea);
        
        if (monsterImage2.size.height > monsterArea || monsterImage2.size.width > 160) {
            monsterLayer2.contentsGravity = kCAGravityResizeAspect;
        }else{
            monsterLayer2.contentsGravity = kCAGravityCenter;
        }

        [monsterLayer addSublayer:monsterLayer2];
        
        //出現時のアニメーション
        [self monsterAppearAnimation:monsterLayer2];

        //ターゲットレイヤー作成
        [self addTargetMonster:monsterLayer1 monster:1];
        [self addTargetMonster:monsterLayer2 monster:2];
        
        //フラグオン
        monsterCount = 2;
        isMonster1Dead = NO;
        isMonster2Dead = NO;
        
        
        //ダメージ算出用に配列に保存
        [appearMonstersArray addObject:[NSNumber numberWithInt:ran2]];

        //モンスター体力をセット&モンスターライフを監視
        NSString *path = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
        NSArray *dic = [[NSArray alloc]initWithContentsOfFile:path];
        
        monsterLifeObject = [[ViewController alloc]init];
        [monsterLifeObject setMonsterLife1:[[[dic objectAtIndex:ran]valueForKey:@"life"]integerValue]];
        [monsterLifeObject setMonsterLife2:[[[dic objectAtIndex:ran2]valueForKey:@"life"]integerValue]];
        
        
        [monsterLifeObject addObserver:self forKeyPath:@"monsterLife1" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [monsterLifeObject addObserver:self forKeyPath:@"monsterLife2" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        //攻撃開始
        [self enemyAttackQueue:monsterLayer1 monsterID:ran attackArrayKey:@"attack1"];
        [self enemyAttackQueue:monsterLayer2 monsterID:ran2 attackArrayKey:@"attack1"];
        
    //モンスター3体出現
    }else{
    
        monsterLayer1 = [CALayer layer];
        int ran = arc4random() % 7;
        
        //ステージごとのモンスター選出
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
        
        ran = ran + 7*stageValue;
        
        UIImage *monsterImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"m%02d", ran] ofType:@"png"]];
        monsterLayer1.contents = (id)monsterImage.CGImage;
        monsterLayer1.frame = CGRectMake(0, 0, 106, monsterArea);
        
        if (monsterImage.size.height > monsterArea || monsterImage.size.width > 106) {
            monsterLayer1.contentsGravity = kCAGravityResizeAspect;
        }else{
            monsterLayer1.contentsGravity = kCAGravityCenter;
        }
        
        [monsterLayer addSublayer:monsterLayer1];
        
        //出現時のアニメーション
        [self monsterAppearAnimation:monsterLayer1];

        
        
        
        //ダメージ算出用に配列に保存
        [appearMonstersArray addObject:[NSNumber numberWithInt:ran]];

        
                
        monsterLayer2 = [CALayer layer];
        int ran2 = arc4random() % 7;
        
        //ステージごとのモンスター選出
//        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
//        int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
        
        ran2 = ran2 + 7*stageValue;
        
        UIImage *monsterImage2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"m%02d", ran2] ofType:@"png"]];
        monsterLayer2.contents = (id)monsterImage2.CGImage;
        monsterLayer2.frame = CGRectMake(106, 0, 106, monsterArea);
        
        if (monsterImage2.size.height > monsterArea || monsterImage2.size.width > 106) {
            monsterLayer2.contentsGravity = kCAGravityResizeAspect;
        }else{
            monsterLayer2.contentsGravity = kCAGravityCenter;
        }
        
        [monsterLayer addSublayer:monsterLayer2];
        
        //出現時のアニメーション
        [self monsterAppearAnimation:monsterLayer2];

                
        //フラグオン
        monsterCount = 3;
        isMonster1Dead = NO;
        isMonster2Dead = NO;
        isMonster3Dead = NO;
        
        
        //ダメージ算出用に配列に保存
        [appearMonstersArray addObject:[NSNumber numberWithInt:ran2]];

        
        monsterLayer3 = [CALayer layer];
        int ran3 = arc4random() % 7;
        
        //ステージごとのモンスター選出
//        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
//        int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
        
        ran3 = ran3 + 7*stageValue;
        
        UIImage *monsterImage3 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"m%02d", ran3] ofType:@"png"]];
        monsterLayer3.contents = (id)monsterImage3.CGImage;
        monsterLayer3.frame = CGRectMake(212, 0, 106, monsterArea);
        
        if (monsterImage3.size.height > monsterArea || monsterImage3.size.width > 106) {
            monsterLayer3.contentsGravity = kCAGravityResizeAspect;
        }else{
            monsterLayer3.contentsGravity = kCAGravityCenter;
        }
        
        [monsterLayer addSublayer:monsterLayer3];
        
        //出現時のアニメーション
        [self monsterAppearAnimation:monsterLayer3];

        
        
        
        //ダメージ算出用に配列に保存
        [appearMonstersArray addObject:[NSNumber numberWithInt:ran3]];

        //ターゲットレイヤー作成
        [self addTargetMonster:monsterLayer1 monster:1];
        [self addTargetMonster:monsterLayer2 monster:2];
        [self addTargetMonster:monsterLayer3 monster:3];
        
        //モンスター体力をセット&モンスターライフを監視
        NSString *path = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
        NSArray *dic = [[NSArray alloc]initWithContentsOfFile:path];
        
        monsterLifeObject = [[ViewController alloc]init];
        [monsterLifeObject setMonsterLife1:[[[dic objectAtIndex:ran]valueForKey:@"life"]integerValue]];
        [monsterLifeObject setMonsterLife2:[[[dic objectAtIndex:ran2]valueForKey:@"life"]integerValue]];
        [monsterLifeObject setMonsterLife3:[[[dic objectAtIndex:ran3]valueForKey:@"life"]integerValue]];
        
        [monsterLifeObject addObserver:self forKeyPath:@"monsterLife1" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [monsterLifeObject addObserver:self forKeyPath:@"monsterLife2" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [monsterLifeObject addObserver:self forKeyPath:@"monsterLife3" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        
        //攻撃開始
        [self enemyAttackQueue:monsterLayer1 monsterID:ran attackArrayKey:@"attack1"];
        [self enemyAttackQueue:monsterLayer3 monsterID:ran3 attackArrayKey:@"attack1"];
        [self enemyAttackQueue:monsterLayer2 monsterID:ran2 attackArrayKey:@"attack1"];

    }
    
    //モンスターライフのバーを表示
    [self monsterLifeBar];
    
    //ターゲットボタンを変更しないデフォルト状態での攻撃対象をセット
    selectingMonsterID = [[appearMonstersArray objectAtIndex:0] integerValue];
    
    //勝利時の計算用にAppdelegateに出現モンスターを保存
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    delegate.delegateAppearMonsters = [[NSMutableArray alloc]initWithArray:appearMonstersArray];
}

- (void)FOEAppear{
    
    //ベースレイヤー
    monsterLayer = [CALayer layer];
    int monsterArea = self.view.frame.size.height -220 -60;
    monsterLayer.frame = CGRectMake(0, 60, 320, monsterArea);
    [self.view.layer addSublayer:monsterLayer];
    
    //モンスターのレイヤーを配列に保存の準備
    monsterLayers =[[NSMutableArray alloc]init];
    
    //ダメージ計算用にモンスターID保存配列を用意
    appearMonstersArray = [[NSMutableArray alloc]init];
    
    //死亡フラグをリセット
    isMonster1Dead = NO;

    
    //queueに動作を登録していくよ！
        
    monsterLayer1 = [CALayer layer];
    int ran = arc4random() % 3;
    
    //ステージごとのモンスター選出
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
    
    ran = ran + 3*stageValue;   
    
    //UIImage *monsterImage = [UIImage imageNamed:[NSString stringWithFormat:@"foe%02d.png", ran]];
    UIImage *monsterImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"foe%02d", ran] ofType:@"png"]];
    monsterLayer1.contents = (id)monsterImage.CGImage;
    monsterLayer1.frame = CGRectMake(0, 0, 320, monsterArea);
    
    if (monsterImage.size.height > monsterArea || monsterImage.size.width > 320) {
        monsterLayer1.contentsGravity = kCAGravityResizeAspect;
    }else{
        monsterLayer1.contentsGravity = kCAGravityCenter;
    }
    
    [monsterLayer addSublayer:monsterLayer1];
    
    //出現時のアニメーション
    [self monsterAppearAnimation:monsterLayer1];
    
        
    
    NSString *monsterPath = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:monsterPath];
    
    NSNumber *num = [NSNumber numberWithInt:ran+500];
    int ID = [[arr valueForKey:@"ID"]indexOfObject:num];
    
    
    
    //フラグオン
    monsterCount = 1;
    isMonster1Dead = NO;
    
    //ダメージ算出用に配列に保存
    [appearMonstersArray addObject:[NSNumber numberWithInt:ID]];
    
    [self addTargetMonster:monsterLayer monster:1];
    
    //モンスター体力をセット&モンスターライフを監視
    NSString *path = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *dic = [[NSArray alloc]initWithContentsOfFile:path];
    
    monsterLifeObject = [[ViewController alloc]init];
    [monsterLifeObject setMonsterLife1:[[[dic objectAtIndex:ID]valueForKey:@"life"]integerValue]];
    
    [monsterLifeObject addObserver:self forKeyPath:@"monsterLife1" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    //ターゲットボタンを変更しないデフォルト状態での攻撃対象をセット
    selectingMonsterID = [[appearMonstersArray objectAtIndex:0] integerValue];
    
    //勝利時の計算用にAppdelegateに出現モンスターを保存
    delegate.delegateAppearMonsters = [[NSMutableArray alloc]initWithArray:appearMonstersArray];
    
    //モンスターライフのバーを表示
    [self monsterLifeBar];
    
    //攻撃開始
    [self enemyAttackQueue:monsterLayer1 monsterID:ID attackArrayKey:@"attack1"];

}

- (void)bossAppear{
    
    //モンスターのレイヤーを配列に保存の準備
    monsterLayers =[[NSMutableArray alloc]init];
    
    //ダメージ計算用にモンスターID保存配列を用意
    appearMonstersArray = [[NSMutableArray alloc]init];
    
    //死亡フラグをリセット
    isMonster1Dead = NO;
    isMonster2Dead = NO;
    isMonster3Dead = NO;
    
    //queueに動作を登録していくよ！
    
    monsterLayer1 = [CALayer layer];

    int monsterArea = self.view.frame.size.height -220 -60;
    monsterLayer1.frame = CGRectMake(0, 0, 320, monsterArea);

    [monsterLayer addSublayer:monsterLayer1];
    
    //攻撃開始
    NSString *monsterPath = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:monsterPath];
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    int BossID = [[delegate.playerPara valueForKey:@"currentStage"]intValue] + 900;

    int ID = [[arr valueForKey:@"ID"]indexOfObject:[NSNumber numberWithInt:BossID]];
    
    //特殊設定２窓攻撃----------------------------------------------------------------------------
    
    if (BossID == 902 || BossID == 903 || BossID == 904) {
        
        
        monsterLayer1.frame = CGRectMake(0, 0, 160, monsterArea);
        
        monsterLayer2 = [CALayer layer];
        monsterLayer2.frame = CGRectMake(160,0, 160, monsterArea);
        [monsterLayer addSublayer:monsterLayer2];
        
        
        
    }


   
    
    //フラグオン
    monsterCount = 1;
    isMonster1Dead = NO;
    
    //ダメージ算出用に配列に保存
    [appearMonstersArray addObject:[NSNumber numberWithInt:ID]];
    
    [self addTargetMonster:monsterLayer monster:1];
    
    //モンスター体力をセット&モンスターライフを監視
    NSString *path = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *dic = [[NSArray alloc]initWithContentsOfFile:path];
    
    monsterLifeObject = [[ViewController alloc]init];
    [monsterLifeObject setMonsterLife1:[[[dic objectAtIndex:ID]valueForKey:@"life"]integerValue]];
    
    [monsterLifeObject addObserver:self forKeyPath:@"monsterLife1" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    //ターゲットボタンを変更しないデフォルト状態での攻撃対象をセット
    selectingMonsterID = [[appearMonstersArray objectAtIndex:0] integerValue];
    
    //勝利時の計算用にAppdelegateに出現モンスターを保存
    delegate.delegateAppearMonsters = [[NSMutableArray alloc]initWithArray:appearMonstersArray];
    
    //モンスターライフのバーを表示
    [self monsterLifeBar];
    
    
    //攻撃開始
    [self enemyAttackQueue:monsterLayer1 monsterID:ID  attackArrayKey:@"attack1"];
    
    //特殊設定２窓攻撃----------------------------------------------------------------------------
    
    if (BossID == 902 || BossID == 903 || BossID == 904) {
        
        [monsterLifeObject setMonsterLife2:99999];
        
        int BossID = [[delegate.playerPara valueForKey:@"currentStage"]intValue] + 900 + 100;
        
        int ID = [[arr valueForKey:@"ID"]indexOfObject:[NSNumber numberWithInt:BossID]];
        
        [self enemyAttackQueue:monsterLayer2 monsterID:ID attackArrayKey:@"attack1"];
    }

    
}

#pragma mark KVO

//監視
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"playerLife"] && [[change valueForKey:@"old"]integerValue] <= 0) {
        return;
    }
    
    //プレイヤーライフ監視
    if ([keyPath isEqualToString:@"playerLife"] && [[change valueForKey:@"new"]integerValue] <= 0 ) {
        
        
        //死亡処理メソッドへ！
        [self playerDownStart];
        return;
        
    }
    
    if ([[playerObject valueForKey:@"playerLife"]intValue] <= 0 ) {
        return;
    }

    
    //ボタン監視
    if ([keyPath isEqualToString:@"button1Enable"] || [keyPath isEqualToString:@"button2Enable"] || [keyPath isEqualToString:@"button3Enable"] || [keyPath isEqualToString:@"button4Enable"]) {
        
        //ボタンOK
        if ([[change valueForKey:@"new"]boolValue] == YES && [keyPath isEqualToString:@"button1Enable"]) {
            
            [self disableLayerWillRemove:0];
            
            [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], nil]];
        }
        
        if ([[change valueForKey:@"new"]boolValue] == YES &&[keyPath isEqualToString:@"button2Enable"] ) {
            
            [self disableLayerWillRemove:1];
            
            [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:2], nil]];
        }

        if ([[change valueForKey:@"new"]boolValue] == YES &&[keyPath isEqualToString:@"button3Enable"] ) {
            
            [self disableLayerWillRemove:2];
            
            [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], nil]];
        }

        if ([[change valueForKey:@"new"]boolValue] == YES && [keyPath isEqualToString:@"button4Enable"]) {
            
            [self disableLayerWillRemove:3];
            
            [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:4], nil]];
        }

        
        //ボタンNG
        if ([[change valueForKey:@"new"]boolValue] == NO) {
            
            if ([keyPath isEqualToString:@"button1Enable"]) {
                
                [self buttonDisableAnimationStart:0];
                [self otherButtonDisableAnimation:0];
                
                
            }
            
            if ([keyPath isEqualToString:@"button2Enable"]) {
                
                [self buttonDisableAnimationStart:1];
                [self otherButtonDisableAnimation:1];
                
                
            }

            
            if ([keyPath isEqualToString:@"button3Enable"]) {
                
                [self buttonDisableAnimationStart:2];
                [self otherButtonDisableAnimation:2];
                
                
            }

            
            if ([keyPath isEqualToString:@"button4Enable"]) {
                
                [self buttonDisableAnimationStart:3];
                [self otherButtonDisableAnimation:3];
                
               
            }
        }
    }
    
       
    //monsterLifeBarを変更する
    [self monsterLifeBarUpDown:keyPath change:change];
    
    
    //死亡した場合
    //死亡フラグONそしてアニメーション
    if ([keyPath isEqualToString:@"monsterLife1"] && [[change valueForKey:@"new"]intValue] <= 0) {
        isMonster1Dead = YES;
        [monsterLifeObject removeObserver:self forKeyPath:@"monsterLife1"];
        [self performSelector:@selector(monsterDownSound) withObject:nil afterDelay:0.3];
        [self performSelector:@selector(monsterDownAnimation:) withObject:keyPath afterDelay:0.5];
    }
    
    if ([keyPath isEqualToString:@"monsterLife2"] && [[change valueForKey:@"new"]intValue] <= 0) {
        isMonster2Dead = YES;
        [monsterLifeObject removeObserver:self forKeyPath:@"monsterLife2"];
        [self performSelector:@selector(monsterDownSound) withObject:nil afterDelay:0.3];
        [self performSelector:@selector(monsterDownAnimation:) withObject:keyPath afterDelay:0.5];
    }
    
    if ([keyPath isEqualToString:@"monsterLife3"] && [[change valueForKey:@"new"]intValue] <= 0) {
        isMonster3Dead = YES;
        [monsterLifeObject removeObserver:self forKeyPath:@"monsterLife3"];
        [self performSelector:@selector(monsterDownSound) withObject:nil afterDelay:0.3];
        [self performSelector:@selector(monsterDownAnimation:) withObject:keyPath afterDelay:0.5];
    }
    
    
    //全滅させた！
    //勝利画面へ移行
    if (isWin == NO) {
        
        if (monsterCount == 1) {
            
            if ([keyPath isEqualToString:@"monsterLife1"] && [[change valueForKey:@"new"]intValue] < 0) {
                
                [self performSelector:@selector(win) withObject:nil afterDelay:0.8];
                isWin = YES;
                
                //キー監視の終了
                @try {
                    [buttonObject removeObserver:self forKeyPath:@"button1Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button2Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button3Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button4Enable"];
                }
                @catch (NSException *exception) {
                    
                
                }
                

            }
        }

        if (monsterCount == 2) {
            if ([keyPath isEqualToString:@"monsterLife1"] && [[change valueForKey:@"new"]intValue] < 0 && isMonster2Dead == YES) {
                [self performSelector:@selector(win) withObject:nil afterDelay:0.8];
                isWin = YES;
                //キー監視の終了
                @try {
                    [buttonObject removeObserver:self forKeyPath:@"button1Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button2Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button3Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button4Enable"];
                }
                @catch (NSException *exception) {
                    
                    
                }
            }
            
            if ([keyPath isEqualToString:@"monsterLife2"] && [[change valueForKey:@"new"]intValue] < 0 && isMonster1Dead == YES) {
                [self performSelector:@selector(win) withObject:nil afterDelay:0.8];
                isWin = YES;
                //キー監視の終了
                @try {
                    [buttonObject removeObserver:self forKeyPath:@"button1Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button2Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button3Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button4Enable"];
                }
                @catch (NSException *exception) {
                    
                    
                }
            }
        }

        if (monsterCount == 3) {
            
            if (isMonster1Dead == YES && isMonster2Dead == YES && isMonster3Dead == YES) {
                [self performSelector:@selector(win) withObject:nil afterDelay:0.8];
                isWin = YES;
                //キー監視の終了
                @try {
                    [buttonObject removeObserver:self forKeyPath:@"button1Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button2Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button3Enable"];
                    [buttonObject removeObserver:self forKeyPath:@"button4Enable"];
                }
                @catch (NSException *exception) {
                    
                    
                }
               
            }
        }
    
    }
    
    //ターゲットの変更処理
    if ([keyPath isEqualToString:@"monsterLife1"] && [[change valueForKey:@"new"]intValue] < 0) {
        
        [attackWindow1 removeFromSuperlayer];
        targetButton1.enabled = NO;
        [self targetChange];
        
    }else if([keyPath isEqualToString:@"monsterLife2"] && [[change valueForKey:@"new"]intValue] < 0){
        
        [attackWindow2 removeFromSuperlayer];
        targetButton2.enabled = NO;
        [self targetChange];
        
    }else if([keyPath isEqualToString:@"monsterLife3"] && [[change valueForKey:@"new"]intValue] < 0){
        
        [attackWindow3 removeFromSuperlayer];
        targetButton3.enabled = NO;
        [self targetChange];
        
    }
    
}

#pragma mark playerDown
- (void)playerDownStart{
    
    
    //ボタンをOFF
    [self buttonDisable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4],  nil]];
    
    //SE
    [self soundEffectStart:@"critical.mp3" volume:1.0 timing:0];
    //[[SimpleAudioEngine sharedEngine]playEffect:@"down.mp3"];
    
    //画像を修正
    [millyDefault removeAllAnimations];
    millyDefault.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Milly_Down" ofType:@"png"]].CGImage;
    
    //まわる魔法陣を削除
     [circleLayer removeFromSuperlayer];
    
    //死亡フラグをONにしてモンスターの攻撃をストップ
    isPlayerAlive = NO;
    
    //死亡したぜ！の表示
    downLayer = [CALayer layer];
    downLayer.backgroundColor = [UIColor blackColor].CGColor;
    downLayer.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    downLayer.opacity =.3;
    [self.view.layer addSublayer:downLayer];
    
    downBackground = [CALayer layer];
    downBackground.backgroundColor = [UIColor clearColor].CGColor;
    downBackground.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    [self.view.layer addSublayer:downBackground];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    textLayer.fontSize = 50;
    textLayer.foregroundColor = [UIColor whiteColor].CGColor;
    textLayer.frame = CGRectMake(0,self.view.frame.size.height/2-100,320,100);
    [textLayer setString:@"Down"];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [downBackground addSublayer:textLayer];
    
    CATextLayer *textLayer2 = [CATextLayer layer];
    textLayer2.backgroundColor = [UIColor clearColor].CGColor;
    textLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    textLayer2.fontSize = 15;
    textLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    textLayer2.frame = CGRectMake(0,self.view.frame.size.height/2-40,320,100);
    
    //ランダムで名言を表示
    NSInteger randValue = arc4random() % 6;
    
    switch (randValue) {
        case 0:
            [textLayer2 setString:@"Control your destiny,\nor someone else will.\nJack Welch"];
            break;
        case 1:
            [textLayer2 setString:@"All people are doing the best they can,\neverywhere, always. No exceptions."];
            break;
        case 2:
            [textLayer2 setString:@"In three words i can sum up everything\nI've learned about life.\nit goes on.\nRobert Frost"];
            break;
        case 3:
            [textLayer2 setString:@"Life is 10 percent what you make it,\nand 90 percent how you take it.\nAnonimous"];
            break;
        case 4:
            [textLayer2 setString:@"Any man can mistakes,\nbut only an idiot persists in his error.\nCicero"];
            break;
        case 5:
            [textLayer2 setString:@"Why join the navy if you can be a pirate?\nOur Steve"];
        default:
            break;
    }
        
        
    
    
    textLayer2.alignmentMode = kCAAlignmentCenter;
    textLayer2.contentsScale = [UIScreen mainScreen].scale;
    [downBackground addSublayer:textLayer2];

    //タップ表示
    //テキストスクロール終了後TAP!の表示が発生
    CATextLayer *tapText = [CATextLayer layer];
    [tapText setString:@"TAP ANYWHERE!"];
    tapText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    tapText.fontSize = 20;
    tapText.foregroundColor = [UIColor whiteColor].CGColor;
    tapText.frame = CGRectMake(0, self.view.frame.size.height/2+50, 320, 45);
    tapText.alignmentMode = kCAAlignmentCenter;
    tapText.contentsScale = [UIScreen mainScreen].scale;
    [downBackground addSublayer:tapText];
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anime.duration = .5;
    anime.autoreverses = YES;
    anime.fromValue = [NSNumber numberWithFloat:0];
    anime.toValue = [NSNumber numberWithFloat:1];
    anime.repeatCount = HUGE_VALF;
    [tapText addAnimation:anime forKey:@"opening"];
    
    //NEXTボタン
    downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    NSString *path = [[NSBundle mainBundle]pathForResource:@"none" ofType:@"png"];
    downButton.imageView.image = [UIImage imageWithContentsOfFile:path];
    [self.view addSubview:downButton];
    
    //NEXTボタンクリックメソッド
    [downButton addTarget:self action:@selector(playerDownEnd) forControlEvents:UIControlEventTouchUpInside];

}

- (void)playerDownEnd{
    
    [downBackground removeFromSuperlayer];
    [downLayer removeFromSuperlayer];
    [downButton removeFromSuperview];
    
    //レイヤー達を削除
    [targetLayer removeFromSuperlayer];
    [monsterLayer removeFromSuperlayer];
   
    [effectChargeLayer removeFromSuperlayer];
    
    [targetButton1 removeFromSuperview];
    [targetButton2 removeFromSuperview];
    [targetButton3 removeFromSuperview];
    
    [timerBackGround1 removeFromSuperlayer];
    [timerBackGround2 removeFromSuperlayer];
    [timerBackGround3 removeFromSuperlayer];
    [timerBackGround4 removeFromSuperlayer];
    
    [playerObject removeObserver:self forKeyPath:@"playerLife"];
    
    [buttonObject removeObserver:self forKeyPath:@"button1Enable"];
    [buttonObject removeObserver:self forKeyPath:@"button2Enable"];
    [buttonObject removeObserver:self forKeyPath:@"button3Enable"];
    [buttonObject removeObserver:self forKeyPath:@"button4Enable"];

    
    if (isMonster1Dead == NO) {
        [monsterLifeBar1 removeFromSuperview];
        [monsterLifeObject removeObserver:self forKeyPath:@"monsterLife1"];
    }
    
    if (monsterCount >= 2 && isMonster2Dead == NO) {
        [monsterLifeBar2 removeFromSuperview];
        [monsterLifeObject removeObserver:self forKeyPath:@"monsterLife2"];
    }
    
    if (monsterCount == 3 && isMonster3Dead == NO) {
        [monsterLifeBar3 removeFromSuperview];
        [monsterLifeObject removeObserver:self forKeyPath:@"monsterLife3"];
    }
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    
    
    
    //音楽の停止
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    
    //フラグ初期化
   
    delegate.isFOE = NO;
    delegate.isBOSS = NO;
    
    //エリア制圧度の低下
    NSString *string = [NSString stringWithFormat:@"area%dDegree", [[delegate.playerPara valueForKey:@"currentStage"]intValue]+1];
    int areaValue = [[delegate.playerPara valueForKey:string]intValue];
    areaValue =  (areaValue - 30 < 0) ? 0:areaValue - 30;
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
    [mdic setValue:[NSNumber numberWithInt:areaValue] forKey:string];
    delegate.playerPara = mdic;
    [self areaDegreeUpdate];
    
    //体力を1に
    [mdic setValue:[NSNumber numberWithInt:1] forKey:@"currentLife"];
    delegate.playerPara = mdic;
    [self lifeLabelWillUpdate];

    [self autoSave];
    
    //別クラスに移動
    [self battleEndAndExplorRestart];


}


#pragma mark buttonDisable
- (void)buttonDisableAnimationStart:(int)num{
    
    CALayer *layer;
    
    if (num == 0) {
        layer = timerBackGround1;
    
    }else if(num == 1){
        layer = timerBackGround2;
        
                
    }else if(num == 2){
        layer = timerBackGround3;
        
                
    }else if(num == 3){
        layer = timerBackGround4;
    }
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"position"];
    anime.duration = 0.2;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    anime.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y)];
    anime.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x-200, layer.position.y)];
    [layer addAnimation:anime forKey:@"disable"];
    
    
}



- (void)otherButtonDisableAnimation:(int)num{
    
    
    CALayer *layer1;
    CALayer *layer2;
    CALayer *layer3;
    CALayer *layer4;
    
    NSMutableArray *muar = [[NSMutableArray alloc]init];
    
    if (num == 0) {
        
        if (button2Deley == NO) {
            layer2 = timerBackGround2;
            [muar addObject:layer2];

        }
        
        if (button3Deley == NO) {
            layer3 = timerBackGround3;
            [muar addObject:layer3];
        }
            
        if (button4Deley == NO){
            layer4 = timerBackGround4;
            [muar addObject:layer4];
        }
            
        
        
    }
    
    if (num == 1) {
        
        if (button1Deley == NO) {
            layer1 = timerBackGround1;
            [muar addObject:layer1];
        }
        
        if (button3Deley == NO) {
            layer3 = timerBackGround3;
            [muar addObject:layer3];
        }
        
        if (button4Deley == NO) {
            layer4 = timerBackGround4;
            [muar addObject:layer4];
        }

    }
    
    if (num == 2) {
        
        if (button1Deley == NO) {
            layer1 = timerBackGround1;
            [muar addObject:layer1];
        }
        
        if (button2Deley == NO) {
            layer2 = timerBackGround2;
            [muar addObject:layer2];

        }
                         
        if (button4Deley == NO) {
            layer4 = timerBackGround4;
            [muar addObject:layer4];
        }
        
    }
    
    if (num == 3) {
        
        if (button1Deley == NO) {
            layer1 = timerBackGround1;
            [muar addObject:layer1];
        }

        
        if (button2Deley == NO) {
            layer2 = timerBackGround2;
            [muar addObject:layer2];

        }
                   
        
        if (button3Deley == NO) {
            layer3 = timerBackGround3;
            [muar addObject:layer3];
        }
            
    
        
    }


    for (CALayer *obj in muar) {
        
        CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"position"];
        anime.duration = 0.2;
        anime.removedOnCompletion = NO;
        anime.fillMode = kCAFillModeForwards;
        anime.fromValue = [NSValue valueWithCGPoint:CGPointMake(obj.position.x, obj.position.y)];
        anime.toValue = [NSValue valueWithCGPoint:CGPointMake(obj.position.x-200, obj.position.y)];
        
        //既にアニメーション済だったら中途終了
        if (obj.position.x <= 320) {
            return;
        }else{
        
        [obj addAnimation:anime forKey:@"disable"];

        }
    }
    
}

- (void)disableLayerWillRemove:(int)num{
    
    CALayer *layer;
    
    if (num == 0) {
        layer = timerBackGround1;
    }else if(num == 1){
        layer = timerBackGround2;
    }else if(num == 2){
        layer = timerBackGround3;
    }else if(num == 3){
        layer = timerBackGround4;
    }
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"position"];
    anime.duration = 0.2;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    anime.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x-200, layer.position.y)];
    anime.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y)];
    [layer addAnimation:anime forKey:@"disable2"];
    
}

- (void)otherDisableLayerWillRemove:(int)num{
    
    CALayer *layer;
    
    if (num == 0) {
        layer = timerBackGround1;
    }else if(num == 1){
        layer = timerBackGround2;
    }else if (num == 2) {
        layer = timerBackGround3;
    }else if(num == 3) {
        layer = timerBackGround4;
    }
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"position"];
    anime.duration = 0.2;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    anime.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x-200, layer.position.y)];
    anime.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y)];
    [layer addAnimation:anime forKey:@"disable2"];

    
}




#pragma mark monsterLifeBar
- (void)monsterLifeBar{
    
    monsterLifeBar1 = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    monsterLifeBar1.frame = CGRectMake(monsterLayer1.frame.size.width/2-50, self.view.frame.size.height - 240, 100, 11);
    monsterLifeBar1.progress = 1.0;
    
    //複数窓用の特殊設定
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        
        monsterLifeBar1.frame = CGRectMake(monsterLayer.frame.size.width/2-50, self.view.frame.size.height - 240, 100, 11);
        
    }
    
    [self.view addSubview:monsterLifeBar1];
    
    
    if (monsterCount > 1) {
        
        monsterLifeBar2 = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
        monsterLifeBar2.frame = CGRectMake(monsterLayer2.frame.origin.x+monsterLayer2.frame.size.width/2-50, self.view.frame.size.height - 240, 95, 11);
        monsterLifeBar2.progress = 1.0;
        [self.view addSubview:monsterLifeBar2];
        
    }
    
    if (monsterCount == 3) {
        
        monsterLifeBar3 = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
        monsterLifeBar3.frame = CGRectMake(monsterLayer3.frame.origin.x+monsterLayer3.frame.size.width/2-50, self.view.frame.size.height - 240, 95, 11);
        monsterLifeBar3.progress = 1.0;
        [self.view addSubview:monsterLifeBar3];

    }

}

- (void)monsterLifeBarUpDown:(NSString*)keyPath change:(NSDictionary*)change{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    //既に削除されてるとこを回避
    if ([[change valueForKey:@"old"]intValue] < 0) {
        return;
    }
    
    
    if ([keyPath isEqualToString:@"monsterLife1"]) {

        float oldValue = [[[arr objectAtIndex:[[appearMonstersArray objectAtIndex:0] intValue]]valueForKey:@"life"]floatValue];
        float newValue = [[change valueForKey:@"new"]floatValue];
        
        //死亡時
        if (newValue/oldValue < 0) {
            [monsterLifeBar1 setProgress:0 animated:YES];
            [self performSelector:@selector(monsterLifeBarWillRemove:) withObject:monsterLifeBar1 afterDelay:.3];
            return;
        }
        
        [monsterLifeBar1 setProgress:newValue/oldValue animated:YES];

    }
    
    if ([keyPath isEqualToString:@"monsterLife2"]) {
        
        float oldValue = [[[arr objectAtIndex:[[appearMonstersArray objectAtIndex:1] intValue]]valueForKey:@"life"]floatValue];
        float newValue = [[change valueForKey:@"new"]floatValue];
        
        //死亡時
        if (newValue/oldValue < 0) {
            [monsterLifeBar2 setProgress:0 animated:YES];
            [self performSelector:@selector(monsterLifeBarWillRemove:) withObject:monsterLifeBar2 afterDelay:.3];
            return;
        }
        
        [monsterLifeBar2 setProgress:newValue/oldValue animated:YES];
        
    }
    
    if ([keyPath isEqualToString:@"monsterLife3"]) {
        
        float oldValue = [[[arr objectAtIndex:[[appearMonstersArray objectAtIndex:2] intValue]]valueForKey:@"life"]floatValue];
        float newValue = [[change valueForKey:@"new"]floatValue];

        //死亡時
        if (newValue/oldValue < 0) {
            [monsterLifeBar3 setProgress:0 animated:YES];
            [self performSelector:@selector(monsterLifeBarWillRemove:) withObject:monsterLifeBar3 afterDelay:.3];
            return;
        }
        
        [monsterLifeBar3 setProgress:newValue/oldValue animated:YES];
    
}

    
}

- (void)monsterLifeBarWillRemove:(UIView*)view{
    
    [view removeFromSuperview];

    
}

#pragma mark monsterAnimation
//モンスターのやられアニメーション

- (void)monsterDownAnimation:(NSString*)keyPath{

    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anime.duration = 1.5f;
    anime.fromValue = [NSNumber numberWithFloat:1.0];
    anime.toValue = [NSNumber numberWithFloat:0];
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    
    if ([keyPath isEqualToString:@"monsterLife1"]) {
        [monsterLayer1 addAnimation:anime forKey:@"monster1Down"];
    }else if([keyPath isEqualToString:@"monsterLife2"]){
        [monsterLayer2 addAnimation:anime forKey:@"monster2Down"];
    }else if([keyPath isEqualToString:@"monsterLife3"]){
        [monsterLayer3 addAnimation:anime forKey:@"monster3Down"];
    }
}

//モンスターやられボイス
- (void)monsterDownSound{
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"monsterDown.wav" pitch:1.5 pan:1.0 gain:2.5f];

}


- (void)targetChange{
    
    //ターゲット変更処理
    if (monsterLifeObject.monsterLife1 <= 0 && monsterLifeObject.monsterLife2 <= 0 && monsterLifeObject.monsterLife3 <= 0) {
        [targetLayer removeFromSuperlayer];
    }
    
    
    if (monsterCount == 2) {
        if (isMonster1Dead == YES) {
            targetLayer.frame = CGRectMake(monsterLayer2.frame.origin.x, 60, monsterLayer2.frame.size.width, monsterLayer2.frame.size.height);
            targetMonster = 2;
        }else if(isMonster2Dead == YES){
            targetLayer.frame = CGRectMake(monsterLayer1.frame.origin.x, 60, monsterLayer1.frame.size.width, monsterLayer1.frame.size.height);
            targetMonster = 1;
        }else if(isMonster1Dead && isMonster2Dead){
            [targetLayer removeFromSuperlayer];
        }
        
        
    }
    
    if (monsterCount == 3) {
        if (isMonster1Dead == YES && monsterLifeObject.monsterLife2 > 0 && monsterLifeObject.monsterLife3 > 0) {
            targetLayer.frame = CGRectMake(monsterLayer2.frame.origin.x, 60, monsterLayer2.frame.size.width, monsterLayer2.frame.size.height);
            targetMonster = 2;
        }else if(isMonster1Dead == YES && isMonster2Dead == YES && monsterLifeObject.monsterLife3 > 0){
            targetLayer.frame = CGRectMake(monsterLayer3.frame.origin.x, 60, monsterLayer3.frame.size.width, monsterLayer3.frame.size.height);
            targetMonster = 3;
        }else if(monsterLifeObject.monsterLife1 > 0 && isMonster2Dead ==YES && monsterLifeObject.monsterLife3 > 0){
            targetLayer.frame = CGRectMake(monsterLayer1.frame.origin.x, 60, monsterLayer1.frame.size.width, monsterLayer1.frame.size.height);
            targetMonster = 1;
        }else if(monsterLifeObject.monsterLife1 > 0 && isMonster2Dead == YES && isMonster3Dead == YES){
            targetLayer.frame = CGRectMake(monsterLayer1.frame.origin.x, 60, monsterLayer1.frame.size.width, monsterLayer1.frame.size.height);
            targetMonster = 1;
        }else if(monsterLifeObject.monsterLife1 > 0 && monsterLifeObject.monsterLife2 > 0 && isMonster3Dead == YES){
            targetLayer.frame = CGRectMake(monsterLayer1.frame.origin.x, 60, monsterLayer1.frame.size.width, monsterLayer1.frame.size.height);
            targetMonster = 1;
        }else if(isMonster1Dead == YES && monsterLifeObject.monsterLife2 > 0 && isMonster3Dead == YES){
            targetLayer.frame = CGRectMake(monsterLayer2.frame.origin.x, 60, monsterLayer2.frame.size.width, monsterLayer2.frame.size.height);
            targetMonster = 2;
        }else if(isMonster1Dead == YES && isMonster2Dead == YES && isMonster3Dead == YES){
            [targetLayer removeFromSuperlayer];
        }
        
    }
    
    
}

//モンスター出現時のアニメーション
- (void)monsterAppearAnimation:(CALayer*)layer{
    
    int rand;
    rand = arc4random() % 4;
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"position"];
    anime.duration = 0.4;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    
    
    if(rand == 0){
        anime.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x-400, layer.position.y)]; // 始点
        anime.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y)]; // 終点
    }else if(rand == 1){
        anime.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y-400)]; // 始点
        anime.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y)]; // 終点
    }else if(rand == 2){
        anime.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x+400, layer.position.y)]; // 始点
        anime.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y)]; // 終点
    }else if(rand == 3){
        anime.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y+400)]; // 始点
        anime.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y)]; // 終点

    }
    
    [layer addAnimation:anime forKey:@"monsterAppear"];
    
    CABasicAnimation *anime2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anime2.duration = 1.0;
    anime2.fromValue = [NSNumber numberWithFloat:0.3];
    anime2.toValue = [NSNumber numberWithFloat:1.0];
    anime2.removedOnCompletion = NO;
    anime2.fillMode = kCAFillModeForwards;
    [layer addAnimation:anime2 forKey:@"monsterAppear2"];
    
}


#pragma mark targetCircle
//ターゲティング用イメージはりつけ＆透明ボタン作成
- (void)addTargetMonster:(CALayer*)layer monster:(int)number{
    
    
    if (number == 1) {
        
        //配列にレイヤーを保存
        [monsterLayers addObject:layer];
        
        //攻撃対象を固定
        targetMonster = 1;
    
        NSString *path = [[NSBundle mainBundle]pathForResource:@"target" ofType:@"png"];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
        
        //リサイズ
        UIImage *img_ato;  // リサイズ後UIImage
        CGFloat width = 80;  // リサイズ後幅のサイズ
        CGFloat height = 80;  // リサイズ後高さのサイズ
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [image drawInRect:CGRectMake(0, 0, width, height)];
        img_ato = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        targetLayer = [CALayer layer];
        targetLayer.contents = (id)img_ato.CGImage;
        targetLayer.frame = CGRectMake(0,60,layer.frame.size.width,layer.frame.size.height);
        targetLayer.backgroundColor = [UIColor clearColor].CGColor;
        targetLayer.opacity = 0.5;
        targetLayer.contentsGravity = kCAGravityCenter;
        
        [self.view.layer addSublayer:targetLayer];
        
        CABasicAnimation *fadeInFadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeInFadeOut.duration = 0.3;
        fadeInFadeOut.repeatCount = HUGE_VALF;
        fadeInFadeOut.fromValue = [NSNumber numberWithFloat:0.3];
        fadeInFadeOut.toValue = [NSNumber numberWithFloat:0.5];
        fadeInFadeOut.autoreverses = YES;
        [targetLayer addAnimation:fadeInFadeOut forKey:@"targetFadeInFadeOut"];
        
        targetButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        targetButton1.backgroundColor = [UIColor clearColor];
        targetButton1.tag = 1;
        targetButton1.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y, layer.frame.size.width, layer.frame.size.height);
        [self.view addSubview:targetButton1];
        
        [targetButton1 addTarget:self action:@selector(targetChangeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
                
    }else if(number == 2){
        
        //配列にレイヤーを保存
        [monsterLayers addObject:layer];
        
        targetButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        targetButton2.backgroundColor = [UIColor clearColor];
        targetButton2.tag = 2;
        targetButton2.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y, layer.frame.size.width, layer.frame.size.height);
        [self.view addSubview:targetButton2];
        
        [targetButton2 addTarget:self action:@selector(targetChangeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if(number == 3){
        
        //配列にレイヤーを保存
        [monsterLayers addObject:layer];
        
        targetButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
        targetButton3.backgroundColor = [UIColor clearColor];
        targetButton3.tag = 3;
        targetButton3.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y, layer.frame.size.width, layer.frame.size.height);
        [self.view addSubview:targetButton3];
        
        [targetButton3 addTarget:self action:@selector(targetChangeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    
}

- (void)targetChangeButtonClicked:(UIButton*)button{
    
    if (button.tag == 3) {
        
        CALayer *layer = [monsterLayers objectAtIndex:2];
        targetLayer.frame = CGRectMake(layer.frame.origin.x, 60, layer.frame.size.width, layer.frame.size.height);
        
        targetMonster = 3;
        
        //ダメージ算出対象を保存
        selectingMonsterID = [[appearMonstersArray objectAtIndex:2] integerValue];
        
    }else if(button.tag == 2){
        
        
        CALayer *layer = [monsterLayers objectAtIndex:1];
        targetLayer.frame = CGRectMake(layer.frame.origin.x, 60, layer.frame.size.width, layer.frame.size.height);
        
        targetMonster = 2;
        
        //ダメージ算出対象を保存
        selectingMonsterID = [[appearMonstersArray objectAtIndex:1] integerValue];
        
    }else if(button.tag == 1){
        CALayer *layer = [monsterLayers objectAtIndex:0];
        targetLayer.frame = CGRectMake(layer.frame.origin.x, 60, layer.frame.size.width, layer.frame.size.height);
        
        targetMonster = 1;
        
        //ダメージ算出対象を保存
        selectingMonsterID = [[appearMonstersArray objectAtIndex:0] integerValue];
        
        
    }
    
}

#pragma mark enemyAttack!
- (void)enemyAttackQueue:(CALayer*)monsterLayerRect monsterID:(int)ID attackArrayKey:(NSString*)key{
    
    //テスタメント発動時の凍結処理
    if(isTestament == YES){
        
        //一旦別メソッドにafterDelayをかけて時間を稼ぎ、凍結処理を行う。
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:monsterLayerRect,@"layer",[NSNumber numberWithInt:ID],@"ID",key,@"key", nil];
        [self performSelector:@selector(testamentEffect:) withObject:dic afterDelay:4.0];

        return;
    }
    
    //モンスター死亡確認
    if ([[monsterLifeObject valueForKey:@"monsterLife1"]intValue] <= 0 && monsterLayerRect.frame.origin.x == 0) {
        
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife2"]intValue] <= 0 && monsterLayerRect.frame.origin.x > 0 && monsterLayerRect.frame.origin.x < 210){
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife3"]intValue] <= 0 && monsterLayerRect.frame.origin.x > 210){
        return;
    }
    
//    if (monsterCount == 3) {
//        
//        if ([[monsterLifeObject valueForKey:@"monsterLife1"]intValue] <= 0 && [[monsterLifeObject valueForKey:@"monsterLife2"]intValue] <= 0 && [[monsterLifeObject valueForKey:@"monsterLife3"]intValue] <= 0) {
//            return;
//        }
//    }
    
    //複数窓特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if (delegate.isBOSS == YES && [[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2) {
        
        if (isMonster1Dead == YES) {
            return;
        }
    }
    
    NSString *monsterPath = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:monsterPath];
    
    //player死亡確認
    if (isPlayerAlive == NO) {
        return;
    }
    
    
    //あんまスマートなやり方じゃあないが・・・アタックウィンドウを３こに分ける
    if (monsterLayerRect.frame.origin.x == 0) {
    
        //アタックウィンドウ
        attackWindow1 = [CALayer layer];
        //属性ごとに色分け
    
        if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"physical"]){
            attackWindow1.backgroundColor = [UIColor grayColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"fire"]){
            attackWindow1.backgroundColor = [UIColor redColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"freeze"]){
            attackWindow1.backgroundColor = [UIColor blueColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"holy"]){
            attackWindow1.backgroundColor = [UIColor brownColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"dark"]){
            attackWindow1.backgroundColor = [UIColor blackColor].CGColor;
        }

        attackWindow1.frame = CGRectMake(monsterLayerRect.frame.origin.x + monsterLayerRect.frame.size.width/2 - 50,self.view.frame.size.height -350, 100, 40);
        
                                        

        attackWindow1.opacity = 0;
        [monsterLayer addSublayer:attackWindow1];

        CALayer *addlayer = [CALayer layer];
        addlayer.backgroundColor = [UIColor blackColor].CGColor;
        addlayer.frame = CGRectMake(0, 20, 100, 20);
        addlayer.opacity = 0.5;
        [attackWindow1 addSublayer:addlayer];


        CATextLayer *attackText = [CATextLayer layer];
        [attackText setString:[NSString stringWithFormat:@"%@", [[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attackname"]]];
        attackText.backgroundColor = [UIColor clearColor].CGColor;
        attackText.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
        attackText.fontSize = 14;
        attackText.foregroundColor = [UIColor whiteColor].CGColor;
        attackText.frame = CGRectMake(5,4, 95, 65);
        attackText.contentsScale = [UIScreen mainScreen].scale;
        [attackWindow1 addSublayer:attackText];

        CATextLayer *attackMonsterName = [CATextLayer layer];
        [attackMonsterName setString:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:ID]valueForKey:@"name"]]];
        attackMonsterName.backgroundColor = [UIColor clearColor].CGColor;
        attackMonsterName.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
        attackMonsterName.fontSize = 12;
        attackMonsterName.alignmentMode = kCAAlignmentRight;
        attackMonsterName.foregroundColor = [UIColor whiteColor].CGColor;
        attackMonsterName.frame = CGRectMake(5,24, 85, 20);
        attackMonsterName.contentsScale = [UIScreen mainScreen].scale;
        [attackWindow1 addSublayer:attackMonsterName];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:attackWindow1,@"layer",[NSNumber numberWithInt:ID],@"ID",key,@"key",monsterLayerRect, @"layer2", nil];
        [self performSelector:@selector(enemyAttackWindowAppear:) withObject:dic afterDelay:0.5];

        
    }else if (monsterLayerRect.frame.origin.x > 200 ) {
        
        //アタックウィンドウ
        attackWindow3 = [CALayer layer];
        //属性ごとに色分け
        
        if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"physical"]){
            attackWindow3.backgroundColor = [UIColor grayColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"fire"]){
            attackWindow3.backgroundColor = [UIColor redColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"freeze"]){
            attackWindow3.backgroundColor = [UIColor blueColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"holy"]){
            attackWindow3.backgroundColor = [UIColor brownColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"dark"]){
            attackWindow3.backgroundColor = [UIColor blackColor].CGColor;
        }
        
        attackWindow3.frame = CGRectMake(monsterLayerRect.frame.origin.x + monsterLayerRect.frame.size.width/2 - 50,self.view.frame.size.height -350, 100, 40);
        attackWindow3.opacity = 0;
        [monsterLayer addSublayer:attackWindow3];
        
        CALayer *addlayer = [CALayer layer];
        addlayer.backgroundColor = [UIColor blackColor].CGColor;
        addlayer.frame = CGRectMake(0, 20, 100, 20);
        addlayer.opacity = 0.5;
        [attackWindow3 addSublayer:addlayer];
        
        
        CATextLayer *attackText = [CATextLayer layer];
        [attackText setString:[NSString stringWithFormat:@"%@", [[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attackname"]]];
        attackText.backgroundColor = [UIColor clearColor].CGColor;
        attackText.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
        attackText.fontSize = 14;
        attackText.foregroundColor = [UIColor whiteColor].CGColor;
        attackText.frame = CGRectMake(5,4, 95, 65);
        attackText.contentsScale = [UIScreen mainScreen].scale;
        [attackWindow3 addSublayer:attackText];
        
        CATextLayer *attackMonsterName = [CATextLayer layer];
        [attackMonsterName setString:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:ID]valueForKey:@"name"]]];
        attackMonsterName.backgroundColor = [UIColor clearColor].CGColor;
        attackMonsterName.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
        attackMonsterName.fontSize = 12;
        attackMonsterName.alignmentMode = kCAAlignmentRight;
        attackMonsterName.foregroundColor = [UIColor whiteColor].CGColor;
        attackMonsterName.frame = CGRectMake(5,24, 85, 20);
        attackMonsterName.contentsScale = [UIScreen mainScreen].scale;
        [attackWindow3 addSublayer:attackMonsterName];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:attackWindow3,@"layer",[NSNumber numberWithInt:ID],@"ID",key,@"key",monsterLayerRect, @"layer2", nil];
        [self performSelector:@selector(enemyAttackWindowAppear:) withObject:dic afterDelay:0.5];

        
    }else{
        
        //アタックウィンドウ
        attackWindow2 = [CALayer layer];
        //属性ごとに色分け
        
        if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"physical"]){
            attackWindow2.backgroundColor = [UIColor grayColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"fire"]){
            attackWindow2.backgroundColor = [UIColor redColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"freeze"]){
            attackWindow2.backgroundColor = [UIColor blueColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"holy"]){
            attackWindow2.backgroundColor = [UIColor brownColor].CGColor;
        }else if ([[[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attribute"] isEqualToString:@"dark"]){
            attackWindow2.backgroundColor = [UIColor blackColor].CGColor;
        }
        
        attackWindow2.frame = CGRectMake(monsterLayerRect.frame.origin.x + monsterLayerRect.frame.size.width/2 - 50,self.view.frame.size.height -350, 100, 40);
        attackWindow2.opacity = 0;
        [monsterLayer addSublayer:attackWindow2];
        
        CALayer *addlayer = [CALayer layer];
        addlayer.backgroundColor = [UIColor blackColor].CGColor;
        addlayer.frame = CGRectMake(0, 20, 100, 20);
        addlayer.opacity = 0.5;
        [attackWindow2 addSublayer:addlayer];
        
        
        CATextLayer *attackText = [CATextLayer layer];
        [attackText setString:[NSString stringWithFormat:@"%@", [[[arr objectAtIndex:ID]valueForKey:key]valueForKey:@"attackname"]]];
        attackText.backgroundColor = [UIColor clearColor].CGColor;
        attackText.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
        attackText.fontSize = 14;
        attackText.foregroundColor = [UIColor whiteColor].CGColor;
        attackText.frame = CGRectMake(5,4, 95, 65);
        attackText.contentsScale = [UIScreen mainScreen].scale;
        [attackWindow2 addSublayer:attackText];
        
        CATextLayer *attackMonsterName = [CATextLayer layer];
        [attackMonsterName setString:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:ID]valueForKey:@"name"]]];
        attackMonsterName.backgroundColor = [UIColor clearColor].CGColor;
        attackMonsterName.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
        attackMonsterName.fontSize = 12;
        attackMonsterName.alignmentMode = kCAAlignmentRight;
        attackMonsterName.foregroundColor = [UIColor whiteColor].CGColor;
        attackMonsterName.frame = CGRectMake(5,24, 85, 20);
        attackMonsterName.contentsScale = [UIScreen mainScreen].scale;
        [attackWindow2 addSublayer:attackMonsterName];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:attackWindow2,@"layer",[NSNumber numberWithInt:ID],@"ID",key,@"key",monsterLayerRect, @"layer2", nil];
        [self performSelector:@selector(enemyAttackWindowAppear:) withObject:dic afterDelay:0.5];
        
    }

}

- (void)enemyAttackWindowAppear:(NSDictionary*)dic{
    
    CALayer *layer = [dic valueForKey:@"layer2"];
    
    //モンスター死亡確認
    if ([[monsterLifeObject valueForKey:@"monsterLife1"]intValue] <= 0 && layer.frame.origin.x == 0) {
        
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife2"]intValue] <= 0 && layer.frame.origin.x > 0 && layer.frame.origin.x < 210){
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife3"]intValue] <= 0 && layer.frame.origin.x > 210){
        return;
    }
   
    //dicから情報を展開
    CALayer *window = [dic valueForKey:@"layer"];
    
    NSString *monsterPath = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:monsterPath];

    int ID = [[dic valueForKey:@"ID"]intValue];
    NSString *key = [dic valueForKey:@"key"];

    [CATransaction begin];
    [CATransaction setAnimationDuration:[[[[arr objectAtIndex:ID]objectForKey:key]objectForKey:@"time"]floatValue]];
    [CATransaction setCompletionBlock:^{ [self attackWindowMove:window monsterDic:dic]; }];  // 8
    window.opacity = 1.0;
    [CATransaction commit];
    
}

- (void)attackWindowMove:(CALayer*)window monsterDic:(NSDictionary*)dic{
    
    CALayer *layer = [dic valueForKey:@"layer2"];
    
    //モンスター死亡確認
    if ([[monsterLifeObject valueForKey:@"monsterLife1"]intValue] <= 0 && layer.frame.origin.x == 0) {
        
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife2"]intValue] <= 0 && layer.frame.origin.x > 0 && layer.frame.origin.x < 210){
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife3"]intValue] <= 0 && layer.frame.origin.x > 210){
        return;
    }
    
    //ウィンドウがジャンプ！する処理
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:.3];
    window.position = CGPointMake(window.position.x, window.position.y-30);
    window.opacity = 0;
    [CATransaction setCompletionBlock:^{
        [self enemyAttackEffectAnimationQueue:dic];
    }];
    [CATransaction commit];
    
    
    [self enemyAttackCalculate:dic];
    
}

- (void)enemyAttackEffectAnimationQueue:(NSDictionary*)dic{
    
    //player死亡確認
    if (isPlayerAlive == NO) {
        return;
    }
    
    CALayer *layer = [dic valueForKey:@"layer2"];
    
    //モンスター死亡確認
    if ([[monsterLifeObject valueForKey:@"monsterLife1"]intValue] <= 0 && layer.frame.origin.x == 0) {
        
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife2"]intValue] <= 0 && layer.frame.origin.x > 0 && layer.frame.origin.x < 210){
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife3"]intValue] <= 0 && layer.frame.origin.x > 210){
        return;
    }
    
    //複数窓特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if (delegate.isBOSS == YES && [[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2) {
        
        if (isMonster1Dead == YES) {
            return;
        }
    }
    
    //monster.plistの情報を取得
    NSString *path = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    //monster.plistのモンスターIDを参照
    NSDictionary *monsdic = [arr objectAtIndex:[[dic valueForKey:@"ID"] intValue]];
    
    //attackのナンバーを参照してアニメーションのナンバーを呼び出す
    int animationNum =[[[monsdic valueForKey:[dic valueForKey:@"key"]]valueForKey:@"animation"]intValue];
    
    CALayer *animationBackGroundLayer = [CALayer layer];
    animationBackGroundLayer.frame = CGRectMake(20, self.view.frame.size.height -210, 120, 120);
    animationBackGroundLayer.backgroundColor = [UIColor clearColor].CGColor;
    animationBackGroundLayer.opacity = .6;
    [self.view.layer addSublayer:animationBackGroundLayer];
    
    if (animationNum == 0) {
        
        CAKeyframeAnimation *anime = [self punchAnimation];
        anime.duration= .4;
        anime.repeatCount = 1;
        anime.calculationMode = kCAAnimationDiscrete;
        [animationBackGroundLayer addAnimation:anime forKey:@"punch"];
        
        [self soundEffectStart:@"punch.mp3" volume:1.0 timing:.1];
        [self soundEffectStart:@"punch.mp3" volume:1.0 timing:.2];
        [self soundEffectStart:@"punch.mp3" volume:1.0 timing:.3];
        
        [self performSelector:@selector(removeSublayers:) withObject:animationBackGroundLayer afterDelay:.5];
    
    }else if(animationNum == 1){
        
        CAKeyframeAnimation *anime = [self crushAnimation];
        anime.duration= .3;
        anime.repeatCount = 1;
        anime.calculationMode = kCAAnimationDiscrete;
        [animationBackGroundLayer addAnimation:anime forKey:@"crush"];
        
        [self soundEffectStart:@"damage0.mp3" volume:1.2 timing:.2];
        
        [self performSelector:@selector(removeSublayers:) withObject:animationBackGroundLayer afterDelay:.5];
                
    }else if(animationNum == 2){
        
        CAKeyframeAnimation *anime = [self stunAnimation];
        anime.duration= .5;
        anime.repeatCount = 1;
        anime.calculationMode = kCAAnimationDiscrete;
        [animationBackGroundLayer addAnimation:anime forKey:@"stun"];
        
        [self soundEffectStart:@"damage0.mp3" volume:1.0 timing:.4];
        
        [self performSelector:@selector(removeSublayers:) withObject:animationBackGroundLayer afterDelay:.6];

        
    }else if(animationNum == 3){
        
        CAKeyframeAnimation *anime = [self slashAnimation];
        anime.duration= .3;
        anime.repeatCount = 1;
        anime.calculationMode = kCAAnimationDiscrete;
        [animationBackGroundLayer addAnimation:anime forKey:@"slash"];
        
        [self soundEffectStart:@"slash.mp3" volume:1.0 timing:.2];
        
        [self performSelector:@selector(removeSublayers:) withObject:animationBackGroundLayer afterDelay:.5];
                
    }else if(animationNum == 4){
        
        CAKeyframeAnimation *anime = [self poinsonAnimation];
        anime.duration= .4;
        anime.repeatCount = 1;
        anime.calculationMode = kCAAnimationDiscrete;
        [animationBackGroundLayer addAnimation:anime forKey:@"poison"];
        
        [self soundEffectStart:@"poison.mp3" volume:1.0 timing:.2];
        
        [self performSelector:@selector(removeSublayers:) withObject:animationBackGroundLayer afterDelay:.5];
        
    }else if(animationNum == 5){
        
        CAKeyframeAnimation *anime = [self flameAnimation];
        anime.duration= .5;
        anime.repeatCount = 1;
        anime.calculationMode = kCAAnimationDiscrete;
        [animationBackGroundLayer addAnimation:anime forKey:@"flame"];
        
        [self soundEffectStart:@"flame.mp3" volume:1.0 timing:.2];
        
        [self performSelector:@selector(removeSublayers:) withObject:animationBackGroundLayer afterDelay:.7];
    
    }else if(animationNum == 6){
        
        CAKeyframeAnimation *anime = [self freezeAnimation];
        anime.duration= .5;
        anime.repeatCount = 1;
        anime.calculationMode = kCAAnimationDiscrete;
        [animationBackGroundLayer addAnimation:anime forKey:@"freeze"];
        
        [self soundEffectStart:@"iceCoffin.mp3" volume:1.0 timing:.2];
        
        [self performSelector:@selector(removeSublayers:) withObject:animationBackGroundLayer afterDelay:.7];
    }


    
}

#pragma mark - enemyAttackAnimations

- (CAKeyframeAnimation*)punchAnimation{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 8 ; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"pun%02d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;

}

- (CAKeyframeAnimation*)slashAnimation{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 4 ; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"sla%02d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
    
}


- (CAKeyframeAnimation*)stunAnimation{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 6 ; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"stu%02d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
    
}

- (CAKeyframeAnimation*)crushAnimation{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 4 ; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"cru%02d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
    
}

- (CAKeyframeAnimation*)poinsonAnimation{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 6 ; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"poi%02d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
    
}

- (CAKeyframeAnimation*)flameAnimation{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 8 ; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"fl%02d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
    
}

- (CAKeyframeAnimation*)freezeAnimation{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 7 ; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"ic%02d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
    
}




- (void)enemyAttackCalculate:(NSDictionary*)dic{
    
    CALayer *layer = [dic valueForKey:@"layer2"];
    
    //モンスター死亡確認
    if ([[monsterLifeObject valueForKey:@"monsterLife1"]intValue] <= 0 && layer.frame.origin.x == 0) {
        
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife2"]intValue] <= 0 && layer.frame.origin.x > 0 && layer.frame.origin.x < 210){
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife3"]intValue] <= 0 && layer.frame.origin.x > 210){
        return;
    }
    
    //player死亡確認
    if (isPlayerAlive == NO) {
        return;
    }
    
    //複数窓特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if (delegate.isBOSS == YES && [[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2) {
        
        if (isMonster1Dead == YES) {
            return;
        }
    }

    
    NSString *monsterPath = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:monsterPath];
    
    //防御時の計算式----------------------------------------------------------------------------------------
    //(敵baseDamage - 自分baseDefence) * (100 - 属性耐性)*randam幅10%
    //もし属性耐性が-の値になったらダメージ0
    //もし敵baseDamage - 自分baseDefenceがマイナスの値になったらダメージ0
    int num = [[dic valueForKey:@"ID"]intValue];
    NSString *str = [dic valueForKey:@"key"];
    
    //ランダム幅の生成
    float ran = arc4random() % 20;   
    
    int enemyAttackDamage = [[[[arr objectAtIndex:num]valueForKey:str]valueForKey:@"baseDamage" ]intValue];
    enemyAttackDamage = enemyAttackDamage * (.9 + ran/100);

    int playerBaseDefence = [self returnTotalPower2:@"baseDefence"];
    int playerAttributeValue = [self returnTotalPower2:[[[arr objectAtIndex:num]valueForKey:str]valueForKey:@"attribute"]];
    int finalValue;
    
    if (playerAttributeValue >= 100) {
        finalValue = 0;
    }else if(enemyAttackDamage - playerBaseDefence < 0){
        finalValue = 0;
    }else{
        finalValue = (enemyAttackDamage - playerBaseDefence) * (100 - playerAttributeValue)/100;
    }
    
    //シールドON時
    if (isShield == YES) {
        finalValue = finalValue/2;
    }
    
    //結界ON時
    if (isBarrier == YES) {
        finalValue = 0;
    }
    
    //回避判定
    [self returnTotalPower2:@"avoid"];
    
    int avoidDice = arc4random() % 100;
    
    if (avoidDice < [self returnTotalPower2:@"avoid"]) {
        
        //[damageText setString:@"MISS"];
        //[[SimpleAudioEngine sharedEngine] playEffect:@"avoid.mp3" pitch:1.0f pan:0 gain:1.2f];
        finalValue = 0;
    }
    
    //防御時の計算式ここまで----------------------------------------------------------------------------------------
    
    //dicにダメージの値をセット
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mdic setValue:[NSNumber numberWithInt:finalValue] forKey:@"finalValue"];
    dic = [NSDictionary dictionaryWithDictionary:mdic];
    
    //被ダメージ表示レイヤーをセット
    CATextLayer *damageText = [CATextLayer layer];
    damageText.backgroundColor = [UIColor clearColor].CGColor;
    damageText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    damageText.fontSize = 35;
    damageText.foregroundColor = [UIColor whiteColor].CGColor;
    damageText.frame = CGRectMake(30,self.view.frame.size.height-200, 100, 70);
    
    [damageText setString:[NSString stringWithFormat:@"%d", finalValue]];
    damageText.alignmentMode = kCAAlignmentCenter;
    damageText.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:damageText];
    
    [self performSelector:@selector(damageTextAnimation:) withObject:damageText afterDelay:0.3];
    [self lifeLabelUpdate:dic];
    
    //回避判定
    
    if (avoidDice < [self returnTotalPower2:@"avoid"]) {
        
        [damageText setString:@"MISS"];
         [[SimpleAudioEngine sharedEngine] playEffect:@"avoid.mp3" pitch:1.0f pan:0 gain:1.2f];
        
    }else{
        
        //
        //[self soundEffectDamaged];
        
        //ミリィにヒット時の体のブレ
        CABasicAnimation *millyDameged = [CABasicAnimation animationWithKeyPath:@"position"];
        millyDameged.fromValue = [NSValue valueWithCGPoint:CGPointMake(millyDefault.position.x, millyDefault.position.y)]; // 始点
        millyDameged.toValue = [NSValue valueWithCGPoint:CGPointMake(millyDefault.position.x+7, millyDefault.position.y)]; // 終点
        millyDameged.duration = 0.05; // アニメーション速度
        millyDameged.repeatCount = 5;
        millyDameged.autoreverses = YES; // 逆アニメーションを実行する
        [millyDefault addAnimation:millyDameged forKey:@"damaged"];
        
    }
    
    
   

}

- (int)returnTotalPower2:(NSString*)string{
    
    //itemのplist３種読み込み
    NSString* filePath0 = [[NSBundle mainBundle] pathForResource:@"itemName" ofType:@"plist"];
    NSArray *itemNamearr = [[NSArray alloc] initWithContentsOfFile:filePath0];
    NSString* filePath1 = [[NSBundle mainBundle] pathForResource:@"itemPreName" ofType:@"plist"];
    NSArray *itemPreNamearr = [[NSArray alloc] initWithContentsOfFile:filePath1];
    NSString* filePath2 = [[NSBundle mainBundle] pathForResource:@"itemAfter1Name" ofType:@"plist"];
    NSArray *itemAfter1Namearr = [[NSArray alloc] initWithContentsOfFile:filePath2];
    NSString* filePath3 = [[NSBundle mainBundle] pathForResource:@"itemAfter2Name" ofType:@"plist"];
    NSArray *itemAfter2Namearr = [[NSArray alloc] initWithContentsOfFile:filePath3];

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    int totalPara = [[delegate.playerPara valueForKey:string]intValue];
    
    //装備ID
    NSInteger haveItem1ID = [[delegate.playerItem valueForKey:@"equip"]indexOfObject:[NSNumber numberWithInteger:1]];
    NSInteger haveItem2ID = [[delegate.playerItem valueForKey:@"equip"]indexOfObject:[NSNumber numberWithInteger:2]];
    NSInteger haveItem3ID = [[delegate.playerItem valueForKey:@"equip"]indexOfObject:[NSNumber numberWithInteger:3]];
    NSInteger haveItem4ID = [[delegate.playerItem valueForKey:@"equip"]indexOfObject:[NSNumber numberWithInteger:4]];
    
    //アイテムリストのIDを取得
    int itemHaveNameID1 = [[[delegate.playerItem valueForKey:@"name"]objectAtIndex:haveItem1ID]intValue];
    int itemHavePreNameID2 = [[[delegate.playerItem valueForKey:@"pre"]objectAtIndex:haveItem1ID]intValue];
    int itemHaveAfter1NameID3 = [[[delegate.playerItem valueForKey:@"after1"]objectAtIndex:haveItem1ID]intValue];
    int itemHaveAfter2NameID4 = [[[delegate.playerItem valueForKey:@"after2"]objectAtIndex:haveItem1ID]intValue];
    
    int itemHaveNameID5 = [[[delegate.playerItem valueForKey:@"name"]objectAtIndex:haveItem2ID]intValue];
    int itemHavePreNameID6 = [[[delegate.playerItem valueForKey:@"pre"]objectAtIndex:haveItem2ID]intValue];
    int itemHaveAfter1NameID7 = [[[delegate.playerItem valueForKey:@"after1"]objectAtIndex:haveItem2ID]intValue];
    int itemHaveAfter2NameID8 = [[[delegate.playerItem valueForKey:@"after2"]objectAtIndex:haveItem2ID]intValue];
    
    int itemHaveNameID9 = [[[delegate.playerItem valueForKey:@"name"]objectAtIndex:haveItem3ID]intValue];
    int itemHavePreNameID10 = [[[delegate.playerItem valueForKey:@"pre"]objectAtIndex:haveItem3ID]intValue];
    int itemHaveAfter1NameID11 = [[[delegate.playerItem valueForKey:@"after1"]objectAtIndex:haveItem3ID]intValue];
    int itemHaveAfter2NameID12 = [[[delegate.playerItem valueForKey:@"after2"]objectAtIndex:haveItem3ID]intValue];
    
    int itemHaveNameID13 = [[[delegate.playerItem valueForKey:@"name"]objectAtIndex:haveItem4ID]intValue];
    int itemHavePreNameID14 = [[[delegate.playerItem valueForKey:@"pre"]objectAtIndex:haveItem4ID]intValue];
    int itemHaveAfter1NameID15 = [[[delegate.playerItem valueForKey:@"after1"]objectAtIndex:haveItem4ID]intValue];
    int itemHaveAfter2NameID16 = [[[delegate.playerItem valueForKey:@"after2"]objectAtIndex:haveItem4ID]intValue];
    
    //アイテムリストからパラメーター用の値を取得
    int total1 = [[[itemNamearr objectAtIndex:itemHaveNameID1]valueForKey:string]intValue];
    int total2 = [[[itemPreNamearr objectAtIndex:itemHavePreNameID2]valueForKey:string]intValue];
    int total3 = [[[itemAfter1Namearr objectAtIndex:itemHaveAfter1NameID3]valueForKey:string]intValue];
    int total4 = [[[itemAfter2Namearr objectAtIndex:itemHaveAfter2NameID4]valueForKey:string]intValue];
    
    int total5 = [[[itemNamearr objectAtIndex:itemHaveNameID5]valueForKey:string]intValue];
    int total6 = [[[itemPreNamearr objectAtIndex:itemHavePreNameID6]valueForKey:string]intValue];
    int total7 = [[[itemAfter1Namearr objectAtIndex:itemHaveAfter1NameID7]valueForKey:string]intValue];
    int total8 = [[[itemAfter2Namearr objectAtIndex:itemHaveAfter2NameID8]valueForKey:string]intValue];
    
    int total9 = [[[itemNamearr objectAtIndex:itemHaveNameID9]valueForKey:string]intValue];
    int total10 = [[[itemPreNamearr objectAtIndex:itemHavePreNameID10]valueForKey:string]intValue];
    int total11 = [[[itemAfter1Namearr objectAtIndex:itemHaveAfter1NameID11]valueForKey:string]intValue];
    int total12 = [[[itemAfter2Namearr objectAtIndex:itemHaveAfter2NameID12]valueForKey:string]intValue];
    
    int total13 = [[[itemNamearr objectAtIndex:itemHaveNameID13]valueForKey:string]intValue];
    int total14 = [[[itemPreNamearr objectAtIndex:itemHavePreNameID14]valueForKey:string]intValue];
    int total15 = [[[itemAfter1Namearr objectAtIndex:itemHaveAfter1NameID15]valueForKey:string]intValue];
    int total16 = [[[itemAfter2Namearr objectAtIndex:itemHaveAfter2NameID16]valueForKey:string]intValue];
    
    int total = total1 + total2 + total3 + total4 + total5 + total6 + total7 + total8 + total9 + total10 + total11 + total12 + total13 + total14 + total15 + total16 + totalPara;
    
    return total;
    
}




//やられ音再生
- (void)soundEffectDamaged{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"damage7.mp3" pitch:1.0f pan:0 gain:.7f];
}

//ダメージ表示アニメ
- (void)damageTextAnimation:(CATextLayer*)textLayer{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    textLayer.opacity = 0;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setCompletionBlock:^{ [self removeSublayers:textLayer]; }];
    textLayer.position = CGPointMake(80, self.view.frame.size.height-250);
    [CATransaction commit];
    
    [CATransaction commit];
    
}

//増えまくるレイヤーの消去
- (void)removeSublayers:(CALayer*)layer{
    
    [layer removeFromSuperlayer];
    
}

//体力表記の更新
- (void)lifeLabelUpdate:(NSDictionary*)dic{
    
    CALayer *monsterLayerRect = [dic valueForKey:@"layer2"];
    
    //死亡確認
    if (isMonster1Dead == YES && monsterLayerRect.frame.origin.x == 0) {
        return;
    }
    if (isMonster2Dead == YES && monsterLayerRect.frame.origin.x > 0 && monsterLayerRect.frame.origin.x < 210){
        return;
    }
    if (isMonster3Dead == YES && monsterLayerRect.frame.origin.x > 210){
        return;
    }
    
    //player死亡確認
    if (isPlayerAlive == NO) {
        return;
    }
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    int curr = [[delegate.playerPara valueForKey:@"currentLife"]intValue] - [[dic valueForKey:@"finalValue"]intValue];
    
    //体力表記を更新
    [lifeLabel setText:[NSString stringWithFormat:@"LIFE : %05d / %05d",curr,[[delegate.playerPara valueForKey:@"maxLife"]intValue]]];
    
    //監視に値を送る
    [playerObject setPlayerLife:curr];
    
    //値を保存
    NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
    [mudic setValue:[NSNumber numberWithInt:curr] forKey:@"currentLife"];
    delegate.playerPara = [NSDictionary dictionaryWithDictionary:mudic];
    
    
    
    //繰り返し処理
    NSMutableDictionary *mu = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if ([[mu valueForKey:@"key"] isEqualToString:@"attack1"]) {
        [mu setValue:@"attack2" forKey:@"key"];
    }else if ([[mu valueForKey:@"key"] isEqualToString:@"attack2"]) {
        [mu setValue:@"attack3" forKey:@"key"];
    }else if ([[mu valueForKey:@"key"] isEqualToString:@"attack3"]) {
        [mu setValue:@"attack4" forKey:@"key"];
    }else if ([[mu valueForKey:@"key"] isEqualToString:@"attack4"]) {
        [mu setValue:@"attack1" forKey:@"key"];
    }
    
    dic = [[NSDictionary alloc]initWithDictionary:mu];
    
    [self enemyAttackQueue:[dic valueForKey:@"layer2"] monsterID:[[dic valueForKey:@"ID"]intValue] attackArrayKey:[dic valueForKey:@"key"]];

}

#pragma mark testamentEffect
- (void)testamentEffect:(NSDictionary*)dic{
    
    //フラグ停止
    isTestament = NO;
    
    CALayer *layer = [dic valueForKey:@"layer"];
    
    //モンスター死亡確認
    if ([[monsterLifeObject valueForKey:@"monsterLife1"]intValue] <= 0 && layer.frame.origin.x == 0) {
        
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife2"]intValue] <= 0 && layer.frame.origin.x > 0 && layer.frame.origin.x < 210){
        return;
    }
    if ([[monsterLifeObject valueForKey:@"monsterLife3"]intValue] <= 0 && layer.frame.origin.x > 210){
        return;
    }
    
    [self enemyAttackQueue:[dic valueForKey:@"layer"] monsterID:[[dic valueForKey:@"ID"]intValue] attackArrayKey:[dic valueForKey:@"key"]];
    
}

#pragma mark soundEffect
- (void)soundEffectStart:(NSString*)string volume:(float)volume timing:(float)timing{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:string,@"string",[NSNumber numberWithFloat:volume],@"volume",[NSNumber numberWithFloat:timing],@"timing", nil];
    [self performSelector:@selector(soundEffectStarted:) withObject:dic afterDelay:timing];
    
}

- (void)soundEffectStarted:(NSDictionary*)dic{
    
    [[SimpleAudioEngine sharedEngine]playEffect:[dic valueForKey:@"string"] pitch:1.0 pan:1.0 gain:[[dic valueForKey:@"volume"]floatValue]];
    
}

//オートセーブ
- (void)autoSave{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    NSString *fileName = @"playerPara1.plist";
    NSString *pathHome = NSHomeDirectory();
    NSString *filePath = [[pathHome stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    [delegate.playerPara writeToFile:filePath atomically:YES];
    
    NSString *itemFileName = @"playerItem1.plist";
    NSString *itemPathHome = NSHomeDirectory();
    NSString *itemFilePath = [[itemPathHome stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:itemFileName];
    [delegate.playerItem writeToFile:itemFilePath atomically:YES];
    
    NSString *skillFileName = @"playerSkill1.plist";
    NSString *skillPathHome = NSHomeDirectory();
    NSString *skillFilePath = [[skillPathHome stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:skillFileName];
    [delegate.playerSkillFirst writeToFile:skillFilePath atomically:YES];
    
    NSString *equipSkillFileName = @"playerEquipSkill1.plist";
    NSString *equipSkillPathHome = NSHomeDirectory();
    NSString *equipSkillFilePath = [[equipSkillPathHome stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:equipSkillFileName];
    [delegate.playerSkillEquipedPlist writeToFile:equipSkillFilePath atomically:YES];
    
}





@end
