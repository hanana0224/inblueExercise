//
//  WinAlertViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/06/19.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "WinAlertViewController.h"

@implementation WinAlertViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)show{
    
    [super show];
    
    //デフォルトアラートを隠します
    for (UIView *subview in self.subviews) {
        subview.hidden = YES;
    }
    

    //背景
    CALayer *backGroundLayer = [CALayer layer];
    backGroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    [backGroundLayer setFrame:CGRectMake(0, 0, 320, 330)];
    backGroundLayer.opacity = 0.7;
    [self.layer addSublayer:backGroundLayer];
    
    //背景レイヤーは半透明なため、もう一つ下地レイヤーを用意?
    CALayer *backGroundLayerAnother = [CALayer layer];
    backGroundLayerAnother.backgroundColor = [UIColor clearColor].CGColor;
    [backGroundLayerAnother setFrame:CGRectMake(0, 0, 320, 330)];
    [self.layer addSublayer:backGroundLayerAnother];
    
    //WIN!!の表示
    CATextLayer *winText = [CATextLayer layer];
    winText.backgroundColor = [UIColor clearColor].CGColor;
    [winText setString:@"WIN!"];
    winText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    winText.fontSize = 40;
    winText.foregroundColor = [UIColor whiteColor].CGColor;
    winText.frame = CGRectMake(15, 5, 305, 60);
    winText.contentsScale = [UIScreen mainScreen].scale;
    [backGroundLayerAnother addSublayer:winText];
    
    //点滅アニメーション
    CABasicAnimation *flashText = [CABasicAnimation animationWithKeyPath:@"opacity"];
    flashText.duration = .5;
    flashText.fromValue = [NSNumber numberWithFloat:0];
    flashText.toValue = [NSNumber numberWithFloat:1];
    flashText.autoreverses = YES;
    flashText.repeatCount = HUGE_VALF;
    [winText addAnimation:flashText forKey:@"flashText"];
    
    //経験値関係の処理をスタート
    [self expUpQueue:backGroundLayerAnother];
    
    
    //アイテムをドロップ処理をスタート
    CATextLayer *itemText = [CATextLayer layer];
    itemText.backgroundColor = [UIColor clearColor].CGColor;
    [itemText setString:[NSString stringWithFormat:@"DROP ITEMS"]];
    itemText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    itemText.fontSize = 25;
    itemText.foregroundColor = [UIColor whiteColor].CGColor;
    itemText.frame = CGRectMake(15, 80, 305, 30);
    itemText.contentsScale = [UIScreen mainScreen].scale;
    [backGroundLayerAnother addSublayer:itemText];
    
    
    [self itemDropStart:backGroundLayerAnother];
    
    //戦後処理終了ボタン
    UIButton *battleEndButton = [UIButton buttonWithType:UIButtonTypeCustom];
    battleEndButton.frame = CGRectMake(240, 240, 70, 70);
    [battleEndButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [battleEndButton setTitle:@"終了" forState:UIControlStateNormal];
    [battleEndButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [battleEndButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [battleEndButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [battleEndButton setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [super addSubview:battleEndButton];
    
    [battleEndButton addTarget:self action:@selector(endUpWinAlert) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnGoTextBackgroundLayer = [CALayer layer];
    btnGoTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnGoTextBackgroundLayer.opacity = 0.5;
    btnGoTextBackgroundLayer.frame = CGRectMake(240, 280, 70, 30);
    [self.layer addSublayer:btnGoTextBackgroundLayer];
    
    CATextLayer *battleEndText1 = [CATextLayer layer];
    battleEndText1.backgroundColor = [UIColor clearColor].CGColor;
    [battleEndText1 setString:@"あーあ…"];
    battleEndText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    battleEndText1.fontSize = 10;
    battleEndText1.foregroundColor = [UIColor whiteColor].CGColor;
    battleEndText1.frame = CGRectMake(245, 285, 70, 70);
    battleEndText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:battleEndText1];
    
    CATextLayer *battleEndText2 = [CATextLayer layer];
    battleEndText2.backgroundColor = [UIColor clearColor].CGColor;
    [battleEndText2 setString:@"弱かったー"];
    battleEndText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    battleEndText2.fontSize = 10;
    battleEndText2.foregroundColor = [UIColor whiteColor].CGColor;
    battleEndText2.frame = CGRectMake(245, 296, 70, 70);
    battleEndText2.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:battleEndText2];
    
    
    
}

#pragma mark - exp
- (void)expUpQueue:(CALayer*)layer{
    
    //いつもの
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    //経験値バーと数値の表示
    CATextLayer *expText = [CATextLayer layer];
    expText.backgroundColor = [UIColor clearColor].CGColor;
    [expText setString:[NSString stringWithFormat:@"EXP"]];
    expText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    expText.fontSize = 25;
    expText.foregroundColor = [UIColor whiteColor].CGColor;
    expText.frame = CGRectMake(15, 50, 305, 30);
    expText.contentsScale = [UIScreen mainScreen].scale;
    [layer addSublayer:expText];
    
    //経験値バー
    UIProgressView *expProgress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    expProgress.frame = CGRectMake( 60, 60, 155 , 30 );
    expProgress.progress = [[delegate.playerPara valueForKey:@"exp"]floatValue]/100;
    expProgress.transform = CGAffineTransformMakeScale( 1.0f, 1.2f ); // 横方向に1倍、縦方向に3倍して表示する
    [self addSubview:expProgress];
    
    //経験値の値
    CATextLayer *expValueText = [CATextLayer layer];
    expValueText.backgroundColor = [UIColor clearColor].CGColor;
    [expValueText setString:[NSString stringWithFormat:@"%03d/100", [[delegate.playerPara valueForKey:@"exp"]intValue]]];
    expValueText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    expValueText.fontSize = 25;
    expValueText.foregroundColor = [UIColor whiteColor].CGColor;
    expValueText.frame = CGRectMake(230, 50, 305, 30);
    expValueText.contentsScale = [UIScreen mainScreen].scale;
    [layer addSublayer:expValueText];
    
    
    //経験値アップ処理
    NSString *path = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    for (id obj in delegate.delegateAppearMonsters){
        
        //モンスターレベルよりもプレイヤーレベルが高かったら経験値はあがらない
        if([[delegate.playerPara valueForKey:@"level"]intValue] >=  [[[arr objectAtIndex:[obj intValue]]valueForKey:@"level"]intValue]){
            
            
            //通常の経験値アップ処理
        }else{
            
            //通常モンスターの場合
            //レベル差があればあるほど経験値に倍率がかかる
            int levelDeference = [[[arr objectAtIndex:[obj intValue]]valueForKey:@"level"]intValue] - [[delegate.playerPara valueForKey:@"level"]intValue];
            
            
            
            //倍率計算
            int magnification = 1;
            
            if (levelDeference <= 1) {
                magnification = 1;
            }else if (levelDeference >= 2){
                magnification = levelDeference;
            }
            
           
            
            _risedExpValue = _risedExpValue + 1 * magnification;
            
            //FOEの場合
            if (delegate.isFOE == YES) {
                _risedExpValue = _risedExpValue + 1 * magnification * 3;
            }
            
            //ボスの場合
            if (delegate.isBOSS == YES) {
                _risedExpValue = _risedExpValue + 1 * magnification * 5;
            }
        }
        
    }
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
    [mdic setValue:[NSNumber numberWithInt:[[delegate.playerPara valueForKey:@"exp"]intValue] + _risedExpValue] forKey:@"exp"];
    delegate.playerPara = mdic;
    
    
    //バーのアニメーション開始
    [self performSelector:@selector(expUpBarAnimation:) withObject:expProgress afterDelay:1.0];
    
    //数値のアニメーション開始
    [self performSelector:@selector(expValueAnimation:) withObject:expValueText afterDelay:1.0];
    
}


- (void)expUpBarAnimation:(UIProgressView*)progressView{
    
    //いつもの
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    if ([[delegate.playerPara valueForKey:@"exp"]intValue] >= 100 ) {
        
        [progressView setProgress:1 animated:YES];
        
        [self performSelector:@selector(expBarLevelUpAnimation:) withObject:progressView afterDelay:1.0];
    }
    
    [progressView setProgress:[[delegate.playerPara valueForKey:@"exp"]floatValue]/100 animated:YES];
    
}

- (void)expBarLevelUpAnimation:(UIProgressView*)progressView{
    
    //いつもの
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    //一旦0に戻す
    [progressView setProgress:0 animated:NO];
    
    //レベルアップの音！
    [[SimpleAudioEngine sharedEngine]playEffect:@"levelUp.mp3"];
    
    //expから100をひく
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
    [mdic setValue:[NSNumber numberWithInt:[[delegate.playerPara valueForKey:@"exp"]intValue] - 100] forKey:@"exp"];
    delegate.playerPara = mdic;
    
    //レベルアップを表記
    [self performSelector:@selector(LevelUpText) withObject:nil afterDelay:1.0];
    
    //パラメーター上昇処理開始-------------------------------------------------------------
    //
    
    float ran0 = arc4random() % 20;
    
    //レベルを上昇
    int level = [[delegate.playerPara valueForKey:@"level"]intValue] + 1;
    
    //LIFEを上昇
    //上昇幅はLEVEL*10*ランダム90〜100%
    float life = [[delegate.playerPara valueForKey:@"maxLife"]floatValue] + level*10*(90+ran0)/100;
    
    float ran1 = arc4random() % 20;
    
    //baseAttackを上昇
    //上昇幅はLEVEL*3*ランダム90〜100%
    float baseAttack = [[delegate.playerPara valueForKey:@"baseAttack"]floatValue] + level*3*(90+ran1)/100;
    
    float ran2 = arc4random() % 20;
    
    //baseDefenceを上昇
    //上昇幅はLEVEL*3*ランダム90〜100%
    float baseDefence = [[delegate.playerPara valueForKey:@"baseDefence"]floatValue] + level*3*(90+ran2)/100;
    
    //スキルポイント上昇
    int skillPoint = [[delegate.playerPara valueForKey:@"skillPoint"]intValue] + 1;
    
    //Appdelegateに戻す
    [mdic setValue:[NSNumber numberWithInt:level] forKey:@"level"];
    [mdic setValue:[NSNumber numberWithFloat:life] forKey:@"maxLife"];
    [mdic setValue:[NSNumber numberWithFloat:baseAttack] forKey:@"baseAttack"];
    [mdic setValue:[NSNumber numberWithFloat:baseDefence] forKey:@"baseDefence"];
    [mdic setValue:[NSNumber numberWithInt:skillPoint] forKey:@"skillPoint"];
    
    delegate.playerPara = mdic;
    
    //パラメーター上昇処理終了-------------------------------------------------------------
    


    [self performSelector:@selector(expUpBarAnimation:) withObject:progressView afterDelay:1.0];
    
    
}


- (void)expValueAnimation:(CATextLayer*)textLayer{
    
    //いつもの
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    if ([[delegate.playerPara valueForKey:@"exp"]intValue] >= 100 ) {
        
        [textLayer setString:@"100/100"];
        
        [self performSelector:@selector(expValueAnimation:) withObject:textLayer afterDelay:1.0];
    }

    
    [textLayer setString:[NSString stringWithFormat:@"%03d/100", [[delegate.playerPara valueForKey:@"exp"]intValue]]];
    
}

#pragma mark ひょっとしたらレイヤー消さんくていいかも？

- (void)LevelUpText{
    
    //LEVELUP!!の表示
    CATextLayer *levelUpText = [CATextLayer layer];
    levelUpText.backgroundColor = [UIColor clearColor].CGColor;
    [levelUpText setString:@"LEVEL UP!"];
    levelUpText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    levelUpText.fontSize = 35;
    levelUpText.foregroundColor = [UIColor whiteColor].CGColor;
    levelUpText.frame = CGRectMake(195, 7, 305, 60);
    levelUpText.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:levelUpText];

}

#pragma mark - itemDrop
- (void)itemDropStart:(CALayer*)layer{
    
    //いつもの
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];

    //アイテムドロップ数を一時保存
    NSInteger dropItemCount = 0;
    
    //アイテムドロップ処理
    for (id obj in delegate.delegateAppearMonsters){
        
        //アイテムを落とすかどうかのチェック
        //通常モンスターは確率5割、FOE以上は10割
        int ran = arc4random() % 4;
        
        if (delegate.isFOE == YES) {
            ran = 0;
        }
        
        //ビンゴ!
        if (ran == 0 ) {
        
            dropItemCount = dropItemCount + 1;
        }
        
        
    }
    
    if (delegate.isBOSS == YES) {
        dropItemCount = 1;
    }

    
    //インスタンスを初期化
    _willPickItem = [[NSMutableArray alloc]init];
    
    //アイテム生成メソッドへ
    [self itemDropGenerator:layer dropItemCount:dropItemCount];

}


- (void)itemDropGenerator:(CALayer*)layer dropItemCount:(NSInteger)count{
    
    //いつもの
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];

    //monster.plist読み込み
    NSString *path = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    //アイテム４種plist読み込み
    NSString *path1 = [[NSBundle mainBundle]pathForResource:@"itemName" ofType:@"plist"];
    NSArray *nameArr = [[NSArray alloc]initWithContentsOfFile:path1];
    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"itemPreName" ofType:@"plist"];
    NSArray *preNameArr = [[NSArray alloc]initWithContentsOfFile:path2];
    NSString *path3 = [[NSBundle mainBundle]pathForResource:@"itemAfter1Name" ofType:@"plist"];
    NSArray *after1NameArr = [[NSArray alloc]initWithContentsOfFile:path3];
    NSString *path4 = [[NSBundle mainBundle]pathForResource:@"itemAfter2Name" ofType:@"plist"];
    NSArray *after2NameArr = [[NSArray alloc]initWithContentsOfFile:path4];
    
    NSInteger i = 1;

    for (i = 1; i <= count; i++) {
        
        //一時保存用のarray達
        NSMutableArray *muarr = [[NSMutableArray alloc]init];
        NSMutableArray *dropPreNameArr = [[NSMutableArray alloc]init];
        NSMutableArray *dropAfter1NameArr = [[NSMutableArray alloc]init];
        NSMutableArray *dropAfter2NameArr = [[NSMutableArray alloc]init];
        NSMutableArray *enchantsArr = [[NSMutableArray alloc]init];

        //出現モンスターからドロップテーブル呼び出し
        int dropTableIntValue = [[[arr objectAtIndex:[[delegate.delegateAppearMonsters objectAtIndex:0] intValue]]valueForKey:@"dropTable"]intValue];

        //itemNameからテーブルに該当するアイテムを抽出
        for(id obj2 in nameArr){

            if ([[obj2 valueForKey:@"dropTable"]intValue] == dropTableIntValue) {

                [muarr addObject:obj2];
            }
        }

        //ドロップテーブルから実際のドロップアイテムを抽選
        int ran2 = arc4random() % [muarr count];

        //ここからエンチャント系
        //通常モンスターは確率20%で付与
        //全部付与される確率は1%を切る
        int enchantDice = arc4random() % 6;

        //当選時にドロップアイテムに付与されるエンチャントを抽出するver.pre--------------------
        if (enchantDice == 0) {


            for (id obj3 in preNameArr) {

                if ([[obj3 valueForKey:@"dropTable"]intValue] <= dropTableIntValue) {

                    [dropPreNameArr addObject:obj3];

                }
            }


            int ran3 = arc4random() % [dropPreNameArr count];
            [enchantsArr addObject:[dropPreNameArr objectAtIndex:ran3]];


        }else{

            [enchantsArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"preNameID", nil]];

        }


        //当選時にドロップアイテムに付与されるエンチャントを抽出するver.preここまで--------------------

        int enchantDiceAfter1 = arc4random() % 6;

        //当選時にドロップアイテムに付与されるエンチャントを抽出するver.after1--------------------
        if (enchantDiceAfter1 == 0) {


            for (id obj4 in after1NameArr) {

                if ([[obj4 valueForKey:@"dropTable"]intValue] <= dropTableIntValue) {

                    [dropAfter1NameArr addObject:obj4];

                }
            }

            int ran4 = arc4random() % [dropAfter1NameArr count];
            [enchantsArr addObject:[dropAfter1NameArr objectAtIndex:ran4]];


        }else{

            [enchantsArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"afterNameID", nil]];

        }
        //当選時にドロップアイテムに付与されるエンチャントを抽出するver.after1ここまで--------------------

        int enchantDiceAfter2 = arc4random() % 6;

        //当選時にドロップアイテムに付与されるエンチャントを抽出するver.after1--------------------
        if (enchantDiceAfter2 == 0) {


            for (id obj5 in after2NameArr) {

                if ([[obj5 valueForKey:@"dropTable"]intValue] <= dropTableIntValue) {

                    [dropAfter2NameArr addObject:obj5];

                }
            }

            int ran5 = arc4random() % [dropAfter2NameArr count];
            [enchantsArr addObject:[dropAfter2NameArr objectAtIndex:ran5]];

        }else{

            [enchantsArr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"afterNameID", nil]];

        }
        //当選時にドロップアイテムに付与されるエンチャントを抽出するver.after1ここまで--------------------

        //enchantsArrからそれぞれのIDを抽出
        int preNameIDInt = [[[enchantsArr objectAtIndex:0]valueForKey:@"preNameID"]intValue];
        int itemNameIDInt = [[[muarr objectAtIndex:ran2]valueForKey:@"itemNameID"]intValue];
        int after1NameIDInt = [[[enchantsArr objectAtIndex:1]valueForKey:@"afterNameID"]intValue];
        int after2NameIDInt = [[[enchantsArr objectAtIndex:2]valueForKey:@"afterNameID"]intValue];
        
        //アイテムを描画メソッドへ
        [self dropItemLayersDraw:layer dropItemCount:i pre:preNameIDInt name:itemNameIDInt after1:after1NameIDInt after2:after2NameIDInt];
        
        //インスタンスに保存
        [_willPickItem addObject:[[NSArray alloc]initWithObjects:[NSNumber numberWithInt:preNameIDInt],[NSNumber numberWithInt:itemNameIDInt],[NSNumber numberWithInt:after1NameIDInt],[NSNumber numberWithInt:after2NameIDInt], nil]];
    }
}

- (void)dropItemLayersDraw:(CALayer*)layer dropItemCount:(NSInteger)count pre:(int)pre name:(int)name after1:(int)after1 after2:(int)after2{
    
    //アイテム４種plist読み込み
    NSString *path1 = [[NSBundle mainBundle]pathForResource:@"itemName" ofType:@"plist"];
    NSArray *nameArr = [[NSArray alloc]initWithContentsOfFile:path1];
    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"itemPreName" ofType:@"plist"];
    NSArray *preNameArr = [[NSArray alloc]initWithContentsOfFile:path2];
    NSString *path3 = [[NSBundle mainBundle]pathForResource:@"itemAfter1Name" ofType:@"plist"];
    NSArray *after1NameArr = [[NSArray alloc]initWithContentsOfFile:path3];
    NSString *path4 = [[NSBundle mainBundle]pathForResource:@"itemAfter2Name" ofType:@"plist"];
    NSArray *after2NameArr = [[NSArray alloc]initWithContentsOfFile:path4];

    //レイヤーにはりつけ
    CATextLayer *dropItemTextLayer1 = [CATextLayer layer];
    dropItemTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    
    NSString *str0 = [NSString stringWithFormat:@"%@", [[preNameArr objectAtIndex:pre]valueForKey:@"preName"]];
    NSString *str1 = [NSString stringWithFormat:@"%@", [[nameArr objectAtIndex:name]valueForKey:@"itemName"]];
    NSString *str2 = [NSString stringWithFormat:@"%@", [[after1NameArr objectAtIndex:after1]valueForKey:@"afterName"]];
    NSString *str3 = [NSString stringWithFormat:@"%@", [[after2NameArr objectAtIndex:after2]valueForKey:@"afterName"]];
    
    [dropItemTextLayer1 setString:[NSString stringWithFormat:@"%@%@%@%@", str0,str1,str2,str3]];
    dropItemTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    dropItemTextLayer1.fontSize = 12;
    dropItemTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    dropItemTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    
    if (count == 1) {
        dropItemTextLayer1.frame = CGRectMake(95, 125, 220, 35);
        
        // 表示する項目の配列を指定してSVSegmentedControlインスタンス生成
        SVSegmentedControl *navSC0 = [[SVSegmentedControl alloc] initWithSectionTitles:@[@"拾", @"捨"]];
        navSC0.frame = CGRectMake(15, 115, 70, 35);
        
        //初期は拾う設定
        _isItem1Pick = YES;
        
        // 値変更時のイベントハンドラをBlocksで指定する
        navSC0.changeHandler = ^(NSUInteger newIndex) {
            
            if (newIndex == 0) {
                _isItem1Pick = YES;
        
            }
            
            if (newIndex == 1) {
                _isItem1Pick = NO;
            }
            
        };
        
        // ビューに追加
        [self addSubview:navSC0];

        
    }else if(count == 2){
        
        dropItemTextLayer1.frame = CGRectMake(95, 165, 220, 35);
        
        SVSegmentedControl *navSC1 = [[SVSegmentedControl alloc] initWithSectionTitles:@[@"拾", @"捨"]];
        navSC1.frame = CGRectMake(15, 155, 70, 35);
        
        //初期は拾う設定
        _isItem2Pick = YES;

        
        // 値変更時のイベントハンドラをBlocksで指定する
        navSC1.changeHandler = ^(NSUInteger newIndex) {
            
            if (newIndex == 0) {
                _isItem2Pick = YES;
            }
            
            if (newIndex == 1) {
                _isItem2Pick = NO;
            }

            
        };
        
        
        // ビューに追加
        [self addSubview:navSC1];
        
        
    }else if(count == 3){
        dropItemTextLayer1.frame = CGRectMake(95, 205, 220, 35);
        
        SVSegmentedControl *navSC2 = [[SVSegmentedControl alloc] initWithSectionTitles:@[@"拾", @"捨"]];
        navSC2.frame = CGRectMake(15, 195, 70, 35);
        
        //初期は拾う設定
        _isItem3Pick = YES;
        
        // 値変更時のイベントハンドラをBlocksで指定する
        navSC2.changeHandler = ^(NSUInteger newIndex) {
            
            if (newIndex == 0) {
                _isItem3Pick = YES;
            }
            
            if (newIndex == 1) {
                _isItem3Pick = NO;
            }

            
        };
        
        // ビューに追加
        [self addSubview:navSC2];

        
        
    }
    
    [layer addSublayer:dropItemTextLayer1];
    
}

- (void)endUpWinAlert{
    
    //いつもの
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    //一時保存用インスタンス
    NSMutableArray *muarr = [[NSMutableArray alloc]init];
    
    if ([_willPickItem count] == 1) {
        
        if (_isItem1Pick == YES) {
            
            muarr = [NSMutableArray arrayWithArray:delegate.playerItem];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[_willPickItem objectAtIndex:0]objectAtIndex:0],@"pre",[[_willPickItem objectAtIndex:0]objectAtIndex:1],@"name",[[_willPickItem objectAtIndex:0] objectAtIndex:2],@"after1",[[_willPickItem objectAtIndex:0] objectAtIndex:3],@"after2",[NSNumber numberWithInt:0],@"equip", nil];
            [muarr addObject:dic];
            
            if ([muarr count] >= 51) {
                
                [self itemOverAnimation];
                return;

            }
            
            delegate.playerItem = [muarr copy];
            
        }
        
    }else if([_willPickItem count] == 2){
        
        if (_isItem1Pick == YES) {
            
            muarr = [NSMutableArray arrayWithArray:delegate.playerItem];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[_willPickItem objectAtIndex:0]objectAtIndex:0],@"pre",[[_willPickItem objectAtIndex:0]objectAtIndex:1],@"name",[[_willPickItem objectAtIndex:0] objectAtIndex:2],@"after1",[[_willPickItem objectAtIndex:0] objectAtIndex:3],@"after2",[NSNumber numberWithInt:0],@"equip", nil];
            [muarr addObject:dic];
            
            if ([muarr count] >= 51) {
                
                [self itemOverAnimation];
                return;
                
            }

            delegate.playerItem = [muarr copy];
            
            
            
        }
        
        if (_isItem2Pick == YES) {
            
            muarr = [NSMutableArray arrayWithArray:delegate.playerItem];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[_willPickItem objectAtIndex:1]objectAtIndex:0],@"pre",[[_willPickItem objectAtIndex:1]objectAtIndex:1],@"name",[[_willPickItem objectAtIndex:1] objectAtIndex:2],@"after1",[[_willPickItem objectAtIndex:1] objectAtIndex:3],@"after2",[NSNumber numberWithInt:0],@"equip", nil];
            [muarr addObject:dic];
            
            if ([muarr count] >= 51) {
                
                [self itemOverAnimation];
                return;
                
            }

            delegate.playerItem = [muarr copy];
            
        }
        
    }else if([_willPickItem count] == 3){
        
        if (_isItem1Pick == YES) {
            
            muarr = [NSMutableArray arrayWithArray:delegate.playerItem];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[_willPickItem objectAtIndex:0]objectAtIndex:0],@"pre",[[_willPickItem objectAtIndex:0]objectAtIndex:1],@"name",[[_willPickItem objectAtIndex:0] objectAtIndex:2],@"after1",[[_willPickItem objectAtIndex:0] objectAtIndex:3],@"after2",[NSNumber numberWithInt:0],@"equip", nil];
            [muarr addObject:dic];
            
            if ([muarr count] >= 51) {
                
                [self itemOverAnimation];
                return;
                
            }

            delegate.playerItem = [muarr copy];
            
        }
        
        if (_isItem2Pick == YES) {
            
            muarr = [NSMutableArray arrayWithArray:delegate.playerItem];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[_willPickItem objectAtIndex:1]objectAtIndex:0],@"pre",[[_willPickItem objectAtIndex:1]objectAtIndex:1],@"name",[[_willPickItem objectAtIndex:1] objectAtIndex:2],@"after1",[[_willPickItem objectAtIndex:1] objectAtIndex:3],@"after2",[NSNumber numberWithInt:0],@"equip", nil];
            [muarr addObject:dic];
            
            if ([muarr count] >= 51) {
                
                [self itemOverAnimation];
                return;
                
            }

            delegate.playerItem = [muarr copy];
            
        }
        
        if (_isItem3Pick == YES) {
            
            muarr = [NSMutableArray arrayWithArray:delegate.playerItem];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[_willPickItem objectAtIndex:2]objectAtIndex:0],@"pre",[[_willPickItem objectAtIndex:2]objectAtIndex:1],@"name",[[_willPickItem objectAtIndex:2] objectAtIndex:2],@"after1",[[_willPickItem objectAtIndex:2] objectAtIndex:3],@"after2",[NSNumber numberWithInt:0],@"equip", nil];
            [muarr addObject:dic];
            
            if ([muarr count] >= 51) {
                
                [self itemOverAnimation];
                return;
                
            }

            delegate.playerItem = [muarr copy];
            
        }
        

    }
    
    //winAlertView終了！
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
    //音楽の停止
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    
    //ボスフラグの処理
    if (delegate.isBOSS == YES) {
        int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
        NSString *string = [NSString stringWithFormat:@"boss%dDown", stageValue+1];
        
        NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
        [mdic setValue:[NSNumber numberWithBool:YES] forKey:string];
        delegate.playerPara = mdic;
    }
    
    //フラグ初期化
    delegate.isFOE = NO;
    delegate.isBOSS = NO;
    
    [self autoSave];
    
    //別クラスに移動
    [self.delegate battleEndAndExplorRestart];
    

}

- (void)itemOverAnimation{
    
    CATextLayer *equipMessage = [CATextLayer layer];
    equipMessage.backgroundColor = [UIColor clearColor].CGColor;
    [equipMessage setString:[NSString stringWithFormat:@"アイテムは50個までしか持てないわ"]];
    equipMessage.alignmentMode = kCAAlignmentCenter;
    equipMessage.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    equipMessage.fontSize = 12;
    equipMessage.foregroundColor = [UIColor whiteColor].CGColor;
    equipMessage.frame = CGRectMake(0,self.center.y - 15,320,30);
    equipMessage.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:equipMessage];
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 1.5f;
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0];
    animation.autoreverses = NO;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [equipMessage addAnimation:animation forKey:@"opacityAnimation"];

    
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
