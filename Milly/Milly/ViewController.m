//
//  ViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/05/26.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

{
    ADBannerView *adView;
    BOOL bannerIsVisible;
    BOOL fastViewFlag;
}

//@property int areaLevelInt;
@property UILabel *areaLevelLabel;

//状態の判断
//探索モードか戦闘モードか？
@property BOOL battleOrExplor;

//ボス演出用ボタン
@property CATextLayer *talk1;

//ボス演出用メッセージ関連
@property CALayer *talkBackgroundLayer;
@property UIButton *nextbtn;

//会話タップ回数保存
@property NSInteger tapTime;

//プロローグ
@property CALayer *fullBackground;
@property CALayer *dummyLayer;
@property CALayer *catLayer;

@end

@implementation ViewController

@synthesize lifeLabel;
@synthesize millyDefault;
@synthesize txtvw;
@synthesize monsterLayer;
@synthesize battleTitle;
@synthesize attackWindow1,attackWindow2,attackWindow3;
@synthesize circleLayer;
@synthesize effectChargeLayer;
@synthesize monsterLayers;
@synthesize targetLayer;
@synthesize monsterCount;
@synthesize monsterLayer1,monsterLayer2,monsterLayer3;
@synthesize targetMonster;
@synthesize selectingMonsterID;
@synthesize appearMonstersArray;
@synthesize monsterLife1,monsterLife2,monsterLife3;
@synthesize isMonster1Dead,isMonster2Dead,isMonster3Dead;
@synthesize targetButton1,targetButton2,targetButton3;
@synthesize btnGo=_btnGo,btnRest=_btnRest,btnSave=_btnSave,btnStatus=_btnStatus;
@synthesize magicalNumber,pushedButtonNumber;
@synthesize monsterLifeObject;
@synthesize isTestament;
@synthesize isShield;
@synthesize isCurse;
@synthesize isBarrier;
@synthesize monsterLifeBar1,monsterLifeBar2,monsterLifeBar3;
@synthesize button1Enable,button2Enable,button3Enable,button4Enable,buttonObject,button1Deley,button2Deley,button3Deley,button4Deley;
@synthesize timerBackGround1,timerBackGround2,timerBackGround3,timerBackGround4;
@synthesize playerObject,playerLife;
@synthesize isPlayerAlive;
@synthesize downLayer,downBackground,downButton;
@synthesize isWin;
@synthesize selectedTarget;
@synthesize cursedTarget;
@synthesize barrierBackLayer;
@synthesize shieldBackLayer;

#pragma mark
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    
    //一時的設定
    _battleOrExplor = NO;
    
    //background時のアニメ消去対策
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(animationRedraw)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    //効果音の事前読み込み
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"go.mp3"];
    
    //背景描画メソッド起動
    [self backGraoundDraw];
    
    //エリア表記メソッド起動
    [self areaAppearanceDraw];
        
    //ステータスレイヤー
    CALayer *statusLayer = [CALayer layer];
    statusLayer.backgroundColor = [UIColor blackColor].CGColor;
    statusLayer.frame = CGRectMake(0, self.view.frame.size.height - 220, 320, 220);
    statusLayer.opacity = 0.2;
    [self.view.layer addSublayer:statusLayer];
    [self.view.layer insertSublayer:statusLayer atIndex:3];
    
    //体力表記
    [self lifeLabelDraw];
        
    //探索開始
    [self explorStarted];
    
    //ミリィさんのアニメ
    [self millyAnimationReady];
    
    //音楽のプリロード
    [[SimpleAudioEngine sharedEngine]preloadEffect:@"go.mp3"];    
    
    // iAD ------------------------------------------------
    // バナービューの作成
    UIScreen *sc = [UIScreen mainScreen];
    CGRect rect = sc.applicationFrame;
    adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0,rect.size.height - 100,0,0)];
    adView.delegate = self;
    adView.autoresizesSubviews = YES;
    adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:adView];
    adView.alpha = 0.0;
    //-----------------------------------------------------
    
    //プロローグ開始
    if ([[delegate.playerPara valueForKey:@"prologue1"]boolValue] == NO && [[delegate.playerPara valueForKey:@"currentStage"]intValue] == 0) {
        
        [self prolog1Start];
        
    }else if([[delegate.playerPara valueForKey:@"prologue2"]boolValue] == NO && [[delegate.playerPara valueForKey:@"currentStage"]intValue] == 1){
        
        [self prolog1Start];
        
    }else if([[delegate.playerPara valueForKey:@"prologue3"]boolValue] == NO && [[delegate.playerPara valueForKey:@"currentStage"]intValue] == 2){
        
        [self prolog1Start];

    }else if([[delegate.playerPara valueForKey:@"prologue4"]boolValue] == NO && [[delegate.playerPara valueForKey:@"currentStage"]intValue] == 3){
        
        [self prolog1Start];
        
    }else if([[delegate.playerPara valueForKey:@"prologue5"]boolValue] == NO && [[delegate.playerPara valueForKey:@"currentStage"]intValue] == 4){
        
        [self prolog1Start];
    
    }else if([[delegate.playerPara valueForKey:@"prologue6"]boolValue] == NO && [[delegate.playerPara valueForKey:@"currentStage"]intValue] == 5){
            
            [self prolog1Start];



    }else{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 3) {
                [self performSelector:@selector(bgmPlay:) withObject:@"351.mp3" afterDelay:1.5];
            }else{
                [self performSelector:@selector(bgmPlay:) withObject:@"120.mp3" afterDelay:1.5];
            }
           
        });

    }
    
    
}




//背景の描画
- (void)backGraoundDraw{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSInteger stageNumber = [[delegate.playerPara valueForKey:@"currentStage"]integerValue];
    
    //背景レイヤー
    CALayer *backgroundImageLayer = [CALayer layer];
    NSString *stageName = [NSString stringWithFormat:@"stage%02d", stageNumber];
    UIImage *backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:stageName ofType:@"jpg" ]];
    
    float scale = self.view.frame.size.height/backgroundImage.size.height;
    backgroundImageLayer.frame = CGRectMake(-backgroundImage.size.width/2 + 160, 0, backgroundImage.size.width * scale, backgroundImage.size.height * scale);
    
    backgroundImageLayer.contents = (id)backgroundImage.CGImage;
    [self.view.layer addSublayer:backgroundImageLayer];
    [self.view.layer insertSublayer:backgroundImageLayer atIndex:0];

}

- (void)areaAppearanceDraw{
    
    //エリア背景レイヤー
    CALayer *areaStatus = [CALayer layer];
    areaStatus.backgroundColor = [UIColor blackColor].CGColor;
    areaStatus.opacity = 0.2;
    areaStatus.frame = CGRectMake(160, 10, 150, 50);
    [self.view.layer addSublayer:areaStatus];
    [self.view.layer insertSublayer:areaStatus atIndex:1];
    
    //エリア表記
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    NSInteger areaValue = [[delegate.playerPara valueForKey:@"currentStage"]integerValue];
    
    NSString *areaName;
    
    switch (areaValue) {
        case 0:
            areaName = [NSString stringWithFormat:@"シンヂュク郊外"];
            break;
        case 1:
            areaName = [NSString stringWithFormat:@"シンヂュク駅前"];
            break;
        case 2:
            areaName = [NSString stringWithFormat:@"シンヂュク駅56番線"];
            break;
        case 3:
            areaName = [NSString stringWithFormat:@"Y AM T 線列車内"];
            break;
        case 4:
            areaName = [NSString stringWithFormat:@"メガ都庁ビル前"];
            break;
        case 5:
            areaName = [NSString stringWithFormat:@"メガ都庁下層"];
            break;
        case 6:
            areaName = [NSString stringWithFormat:@"メガ都庁上層"];
            break;
        
        default:
            break;
    }
    
    UILabel *areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 17, 130, 40)];
    areaLabel.text = [NSString stringWithFormat:@"%@\nエリア制圧度              ", areaName];
    areaLabel.textAlignment = NSTextAlignmentRight;
    areaLabel.backgroundColor = [UIColor clearColor];
    areaLabel.textColor = [UIColor whiteColor];
    areaLabel.numberOfLines = 2;
    [areaLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    [self.view addSubview:areaLabel];
    
    //別フォントのためエリア表記の数値部分
    _areaLevelLabel = [[UILabel alloc]init];
    _areaLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(255, 32, 50, 25)];
    
    NSString *string = [NSString stringWithFormat:@"area%dDegree", [[delegate.playerPara valueForKey:@"currentStage"]intValue]+1];
    
    _areaLevelLabel.text = [NSString stringWithFormat:@"%03d %@", [[delegate.playerPara valueForKey:string]intValue],@"%"];
    _areaLevelLabel.backgroundColor = [UIColor clearColor];
    _areaLevelLabel.textColor = [UIColor whiteColor];
    [_areaLevelLabel setFont:[UIFont fontWithName:@"AmericanCaptain" size:20]];
    [self.view addSubview:_areaLevelLabel];

    
}

- (void)areaDegreeUpdate{
    
     AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSString *string = [NSString stringWithFormat:@"area%dDegree", [[delegate.playerPara valueForKey:@"currentStage"]intValue]+1];
    _areaLevelLabel.text = [NSString stringWithFormat:@"%03d %@", [[delegate.playerPara valueForKey:string]intValue],@"%"];

}

- (void)lifeLabelDraw{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    lifeLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, self.view.frame.size.height - 87, 150, 30)];
    [lifeLabel setText:[NSString stringWithFormat:@"LIFE : %05d/%05d", [[delegate.playerPara valueForKey:@"currentLife"]intValue],[[delegate.playerPara valueForKey:@"maxLife"]intValue]]];
    lifeLabel.backgroundColor = [UIColor clearColor];
    [lifeLabel setTextColor:[UIColor whiteColor]];
    [lifeLabel setFont:[UIFont fontWithName:@"AmericanCaptain" size:20]];
    [self.view addSubview:lifeLabel];

}

- (void)lifeLabelWillUpdate{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];

    [lifeLabel setText:[NSString stringWithFormat:@"LIFE : %05d/%05d", [[delegate.playerPara valueForKey:@"currentLife"]intValue],[[delegate.playerPara valueForKey:@"maxLife"]intValue]]];

}


- (void)millyAnimationReady{
    
    
    
    [millyDefault removeFromSuperlayer];
    
    //ミリィさんレイヤー
    millyDefault = [CALayer layer];
//    millyDefault.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Milly_Down" ofType:@"png"]].CGImage;

    millyDefault.frame = CGRectMake(15, self.view.frame.size.height - 210, 128, 128);
    [self.view.layer addSublayer:millyDefault];
    [self.view.layer insertSublayer:millyDefault atIndex:4];
    
    //立ちアニメ
    CAKeyframeAnimation *animation = [self animationContents];
    animation.duration= 2.5;
    animation.repeatCount = HUGE_VALF;
    animation.calculationMode = kCAAnimationDiscrete;
    [millyDefault addAnimation:animation forKey:@"bakemono"];
}

- (void)animationRedraw{
    
    
    
    if (_battleOrExplor == NO) {
        
    [millyDefault removeFromSuperlayer];
        
    //ミリィさんレイヤー
    millyDefault = [CALayer layer];
    //    millyDefault.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Milly_Down" ofType:@"png"]].CGImage;
    
    millyDefault.frame = CGRectMake(15, self.view.frame.size.height - 210, 128, 128);
    [self.view.layer addSublayer:millyDefault];
    [self.view.layer insertSublayer:millyDefault atIndex:4];
    
    //立ちアニメ
    CAKeyframeAnimation *animation = [self animationContents];
    animation.duration= 2.5;
    animation.repeatCount = HUGE_VALF;
    animation.calculationMode = kCAAnimationDiscrete;
    [millyDefault addAnimation:animation forKey:@"bakemono"];
    
    }else{
        
        //詠唱アニメの準備
        CAKeyframeAnimation *animation = [self playerMagicAnimation];
        animation.duration= .3;
        animation.repeatCount = HUGE_VALF;
        animation.calculationMode = kCAAnimationDiscrete;
        [millyDefault addAnimation:animation forKey:@"bakemono"];
        millyDefault.frame = CGRectMake(15, self.view.frame.size.height - 215, 128, 128);
        
        [self performSelector:@selector(playerAnimationUp) withObject:nil afterDelay:0.2];
    
        CABasicAnimation* rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotate.toValue = [NSNumber numberWithFloat:M_PI / 2.0];
        rotate.duration = 0.7;           // 0.5秒で90度回転
        rotate.repeatCount = MAXFLOAT;   // 無限に繰り返す
        rotate.cumulative = YES;         // 効果を累積
        [circleLayer addAnimation:rotate forKey:@"ImageViewRotation"];
        
    }


}

//詠唱アニメここから---------------------------------------------------
- (CAKeyframeAnimation*)playerMagicAnimation{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 3; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"millyMagic%02d",i] ofType:@"gif"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
    
}


- (void)bgmPlay:(NSString*)title{
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:title loop:YES];
    
}


- (void)soundEffectYES{
    
    //効果音再生
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
}

-(void)explorStarted{
    
        
    //探索ボタン
    _btnGo = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnGo.frame = CGRectMake(240, self.view.frame.size.height - 130, 70, 70);
    [_btnGo setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnGo setTitle:@"探索" forState:UIControlStateNormal];
    [_btnGo.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnGo setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnGo setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    _btnGo.exclusiveTouch = YES;
    [self.view addSubview:_btnGo];
    
    [_btnGo addTarget:self action:@selector(explor:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnGoTextBackgroundLayer = [CALayer layer];
    btnGoTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnGoTextBackgroundLayer.opacity = 0.5;
    btnGoTextBackgroundLayer.frame = CGRectMake(240, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnGoTextBackgroundLayer];
    
    _btnGoOverTextLayer1 = [CATextLayer layer];
    _btnGoOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnGoOverTextLayer1 setString:@"お仕事は"];
    _btnGoOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnGoOverTextLayer1.fontSize = 10;
    _btnGoOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnGoOverTextLayer1.frame = CGRectMake(245, self.view.frame.size.height - 85, 70, 70);
    [_btnGoOverTextLayer1 setRasterizationScale:[[UIScreen mainScreen] scale]];
    [_btnGoOverTextLayer1 setShouldRasterize:YES];
    _btnGoOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnGoOverTextLayer1];
    
    _btnGoOverTextLayer2 = [CATextLayer layer];
    _btnGoOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnGoOverTextLayer2 setString:@"見敵必殺"];
    _btnGoOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnGoOverTextLayer2.fontSize = 10;
    _btnGoOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnGoOverTextLayer2.frame = CGRectMake(245, self.view.frame.size.height - 74, 70, 70);
    _btnGoOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnGoOverTextLayer2];
    
    
    //休憩ボタン
    _btnRest = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRest.frame = CGRectMake(160, self.view.frame.size.height - 130, 70, 70);
    [_btnRest setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnRest setTitle:@"休憩" forState:UIControlStateNormal];
    [_btnRest.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnRest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRest setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnRest setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    _btnRest.exclusiveTouch = YES;
    [self.view addSubview:_btnRest];
    
    [_btnRest addTarget:self action:@selector(restButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnRestTextBackgroundLayer = [CALayer layer];
    btnRestTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnRestTextBackgroundLayer.opacity = 0.5;
    btnRestTextBackgroundLayer.frame = CGRectMake(160, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnRestTextBackgroundLayer];
    
    _btnRestOverTextLayer1 = [CATextLayer layer];
    _btnRestOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnRestOverTextLayer1 setString:@"良く眠るのは"];
    _btnRestOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnRestOverTextLayer1.fontSize = 10;
    _btnRestOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnRestOverTextLayer1.frame = CGRectMake(165, self.view.frame.size.height - 85, 70, 70);
    _btnRestOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnRestOverTextLayer1];
    
    _btnRestOverTextLayer2 = [CATextLayer layer];
    _btnRestOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnRestOverTextLayer2 setString:@"豚だけね"];
    _btnRestOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnRestOverTextLayer2.fontSize = 10;
    _btnRestOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnRestOverTextLayer2.frame = CGRectMake(165, self.view.frame.size.height - 74, 70, 70);
    _btnRestOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnRestOverTextLayer2];
    
    
    //状態ボタン
    _btnStatus = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStatus.frame = CGRectMake(240, self.view.frame.size.height - 210, 70, 70);
    [_btnStatus setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnStatus setTitle:@"状態" forState:UIControlStateNormal];
    [_btnStatus.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnStatus setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnStatus setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    _btnStatus.exclusiveTouch = YES;
    [self.view addSubview:_btnStatus];
    
    [_btnStatus addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnStatusTextBackgroundLayer = [CALayer layer];
    btnStatusTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnStatusTextBackgroundLayer.opacity = 0.5;
    btnStatusTextBackgroundLayer.frame = CGRectMake(240, self.view.frame.size.height - 170, 70, 30);
    [self.view.layer addSublayer:btnStatusTextBackgroundLayer];
    
    _btnStatusOverTextLayer1 = [CATextLayer layer];
    _btnStatusOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer1 setString:@"装備の基準は"];
    _btnStatusOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer1.fontSize = 10;
    _btnStatusOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer1.frame = CGRectMake(245, self.view.frame.size.height - 165, 70, 70);
    _btnStatusOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnStatusOverTextLayer1];
    
    _btnStatusOverTextLayer2 = [CATextLayer layer];
    _btnStatusOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer2 setString:@"見た目"];
    _btnStatusOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer2.fontSize = 10;
    _btnStatusOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer2.frame = CGRectMake(245, self.view.frame.size.height - 154, 70, 70);
    _btnStatusOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnStatusOverTextLayer2];
    
    
    //ヘルプボタン検討中
    _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSave.frame = CGRectMake(160, self.view.frame.size.height - 210, 70, 70);
    [_btnSave setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnSave setTitle:@"説明" forState:UIControlStateNormal];
    [_btnSave.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnSave setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    _btnSave.exclusiveTouch = YES;
    [self.view addSubview:_btnSave];
    
    [_btnSave addTarget:self action:@selector(readmeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnSaveTextBackgroundLayer = [CALayer layer];
    btnSaveTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnSaveTextBackgroundLayer.opacity = 0.5;
    btnSaveTextBackgroundLayer.frame = CGRectMake(160, self.view.frame.size.height - 170, 70, 30);
    [self.view.layer addSublayer:btnSaveTextBackgroundLayer];
    
    _btnSaveOverTextLayer1 = [CATextLayer layer];
    _btnSaveOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnSaveOverTextLayer1 setString:@"ゆあたんの"];
    _btnSaveOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer1.fontSize = 10;
    _btnSaveOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer1.frame = CGRectMake(165, self.view.frame.size.height - 165, 70, 70);
    _btnSaveOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnSaveOverTextLayer1];
    
    _btnSaveOverTextLayer2 = [CATextLayer layer];
    _btnSaveOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnSaveOverTextLayer2 setString:@"超絶解説"];
    _btnSaveOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer2.fontSize = 10;
    _btnSaveOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer2.frame = CGRectMake(165, self.view.frame.size.height - 154, 70, 70);
    _btnSaveOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnSaveOverTextLayer2];
    
    
}


- (CAKeyframeAnimation*)animationContents{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 25; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"Milly_stand%02d",i] ofType:@"gif"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;

}

#pragma mark - prologues

- (void)prolog1Start{
    
    //ボタンを使用不可に
    _btnGo.enabled = NO;
    _btnRest.enabled = NO;
    _btnSave.enabled = NO;
    _btnStatus.enabled = NO;
    
    [self bgmPlay:@"072.mp3"];
    
    _fullBackground = [CALayer layer];
    _fullBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _fullBackground.backgroundColor = [UIColor blackColor].CGColor;
    _fullBackground.opacity = .2;
    [self.view.layer addSublayer:_fullBackground];
    
    _dummyLayer = [CALayer layer];
    _dummyLayer.backgroundColor = [UIColor clearColor].CGColor;
    _dummyLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view.layer addSublayer:_dummyLayer];
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    CATextLayer *title1 = [CATextLayer layer];
    title1.backgroundColor = [UIColor clearColor].CGColor;
    [title1 setString:[NSString stringWithFormat:@"Area %02d", [[delegate.playerPara valueForKey:@"currentStage"]intValue]+1] ];
    title1.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    title1.fontSize = 30;
    title1.foregroundColor = [UIColor whiteColor].CGColor;
    title1.frame = CGRectMake(320, self.view.frame.size.height/2 - 70, 310, 65);
    title1.alignmentMode = kCAAlignmentLeft;
    title1.contentsScale = [UIScreen mainScreen].scale;
    [_dummyLayer addSublayer:title1];
    
    CABasicAnimation *anime1 = [CABasicAnimation animationWithKeyPath:@"position"];
    anime1.duration = .5;
    anime1.fillMode = kCAFillModeForwards;
    anime1.removedOnCompletion = NO;
    anime1.toValue = [NSValue valueWithCGPoint:CGPointMake(title1.position.x-310, title1.position.y)];
    anime1.fromValue = [NSValue valueWithCGPoint:title1.position];
    anime1.beginTime = CACurrentMediaTime() + 1.0;
    [title1 addAnimation:anime1 forKey:@"title1"];
    
    
    CATextLayer *title2 = [CATextLayer layer];
    title2.backgroundColor = [UIColor clearColor].CGColor;
    
    //タイトル一覧
    NSString *AreaTitleString;
    int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
    
    if (stageValue == 0) {
        AreaTitleString = @"『人間をどう定義しようか』";
    }else if(stageValue == 1){
        AreaTitleString = @"『哀れなのは一体だれ？』";
    }else if(stageValue == 2){
        AreaTitleString = @"『正義を曲げないための正義』";
    }else if(stageValue == 3){
        AreaTitleString = @"『通り魔はご用心』";
    }else if(stageValue == 4){
        AreaTitleString = @"『特異点』";
    }else if(stageValue == 5){
        AreaTitleString = @"『守るものの違い』";
    }else if(stageValue == 6){
        AreaTitleString = @"『』";
    }



    
    [title2 setString:AreaTitleString];
    
    title2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    title2.fontSize = 16;
    title2.foregroundColor = [UIColor whiteColor].CGColor;
    title2.frame = CGRectMake(320, self.view.frame.size.height/2 - 30, 310, 65);
    title2.alignmentMode = kCAAlignmentLeft;
    title2.contentsScale = [UIScreen mainScreen].scale;
    [_dummyLayer addSublayer:title2];
    
    CABasicAnimation *anime2 = [CABasicAnimation animationWithKeyPath:@"position"];
    anime2.duration = .5;
    anime2.fillMode = kCAFillModeForwards;
    anime2.removedOnCompletion = NO;
    anime2.toValue = [NSValue valueWithCGPoint:CGPointMake(title2.position.x-310, title2.position.y)];
    anime2.fromValue = [NSValue valueWithCGPoint:title2.position];
    anime2.beginTime = CACurrentMediaTime() + 2.0;
    [title2 addAnimation:anime2 forKey:@"title2"];
    
    
    //タイトルとかもろもろを全消去
    [self performSelector:@selector(DeleteLayer:) withObject:_fullBackground afterDelay:5.0];
    [self performSelector:@selector(DeleteLayer:) withObject:_dummyLayer afterDelay:5.0];
    
    //ゆあ登場！
    [self performSelector:@selector(yuaComing) withObject:nil afterDelay:6.0];
}

- (void)yuaComing{
    
    _catLayer = [CALayer layer];
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"yua" ofType:@"png"]];
    _catLayer.contents = (id)img.CGImage;
    _catLayer.frame = CGRectMake(160-64, (self.view.frame.size.height - 220-50)/2+50-60, 128, 128);
    //_catLayer.frame = CGRectMake(0, 0, 320, 180);

    [self.view.layer addSublayer:_catLayer];
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anime.duration = 2.0;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    anime.fromValue = [NSNumber numberWithFloat:0];
    anime.toValue = [NSNumber numberWithFloat:1];
    [_catLayer addAnimation:anime forKey:@"prolog1"];
    
    CABasicAnimation *anime2 = [CABasicAnimation animationWithKeyPath:@"position"];
    anime2.duration = .5;
    anime2.removedOnCompletion = NO;
    anime2.fillMode = kCAFillModeForwards;
    anime2.fromValue = [NSValue valueWithCGPoint:CGPointMake(_catLayer.position.x, _catLayer.position.y -100)];
    anime2.toValue = [NSValue valueWithCGPoint:_catLayer.position];
    [_catLayer addAnimation:anime2 forKey:@"cat2"];
    
    //トーク
    _talkBackgroundLayer = [CALayer layer];
    _talkBackgroundLayer.frame = CGRectMake(10, self.view.frame.size.height -220 - 80, 300, 70);
    _talkBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    _talkBackgroundLayer.opacity = .2;
    [self.view.layer addSublayer:_talkBackgroundLayer];
    
    _nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextbtn.frame = CGRectMake(10, self.view.frame.size.height - 300, 300, 70);
    NSString *path = [[NSBundle mainBundle]pathForResource:@"none" ofType:@"png"];
    _nextbtn.imageView.image = [UIImage imageWithContentsOfFile:path];
    [self.view addSubview:_nextbtn];
    [_nextbtn addTarget:self action:@selector(prologueButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _talk1 = [CATextLayer layer];
    _talk1.backgroundColor = [UIColor clearColor].CGColor;
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
    
    if (stageValue == 0) {
        [_talk1 setString:@"使い魔ゆあ『ん-…\n無事転送が済んだようだにゃ…』"];
    }else if(stageValue == 1){
        [_talk1 setString:@"ゆあ『わー！旧科学時代の構造物が\nいっぱいにゃ！』"];
    }else if(stageValue == 2){
        [_talk1 setString:@"ゆあ『ミリィ！なんか凄い機械がある！\nにゃんだこれ！』"];
    }else if(stageValue == 3){
        [_talk1 setString:@"ゆあ『いよいよこの任務も佳境だにゃー。』"];
    }else if(stageValue == 4){
        [_talk1 setString:@"ゆあ『あー、お外久しぶり！』"];
    }else if(stageValue == 5){
        [_talk1 setString:@"ゆあ『ねぇねぇミリィ…』"];
    }

    
    _talk1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _talk1.fontSize = 14;
    _talk1.foregroundColor = [UIColor whiteColor].CGColor;
    _talk1.frame = CGRectMake(15, self.view.frame.size.height -220 - 75, 300, 65);
    _talk1.alignmentMode = kCAAlignmentLeft;
    _talk1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_talk1];
    
    //TAP!の表示が発生
    CATextLayer *tapText = [CATextLayer layer];
    [tapText setString:@"TAP HERE"];
    tapText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    tapText.fontSize = 18;
    tapText.foregroundColor = [UIColor whiteColor].CGColor;
    tapText.frame = CGRectMake(0, 40, 285, 30);
    tapText.alignmentMode = kCAAlignmentRight;
    tapText.contentsScale = [UIScreen mainScreen].scale;
    [_talk1 addSublayer:tapText];
    
    CABasicAnimation *anime3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anime3.duration = .5;
    anime3.autoreverses = YES;
    anime3.fromValue = [NSNumber numberWithFloat:0];
    anime3.toValue = [NSNumber numberWithFloat:1];
    anime3.repeatCount = HUGE_VALF;
    [tapText addAnimation:anime3 forKey:@"opening"];
    
    //ボタンのタップ回数を保存
    _tapTime = 0;
    
}

- (void)prologueButtonClicked:(UIButton*)button{
    
    _tapTime = _tapTime + 1;
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
    
    //Area1
    if (stageValue == 0) {
    
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『んー、今回の転送者ヘタクソね。\nきっと童貞ね』"];
                break;
            case 2:
                [_talk1 setString:@"ゆあ『統治局も人材不足だってマスターが\n言ってた。でも低級能力者にそこまでの\nクオリティを求めるのも酷だにゃ』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『それもそーね。\nさて、んじゃ今回の任務概要の説明宜しく。』"];
                break;
            case 4:
                [_talk1 setString:@"ゆあ『はいはーい。\nまずは旧都市シンヂュクの調査をしてね。\nそしていつも通り危険生物の排除。』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『ゴミ掃除はいつも通りだけど\n情報部の報告書では戦術級以上の個体が\n確認されてなかった？』"];
                break;
            case 6:
                [_talk1 setString:@"ゆあ『一応それ機密情報にゃんだけど…\nまた勝手に情報部に侵入してるにゃ。』"];
                break;
            case 7:
                [_talk1 setString:@"ミリィ『あんなザルシステムを組んでる方が\n悪いのよ。』"];
                break;
            case 8:
                [_talk1 setString:@"ゆあ『オメガクラスのシステムに侵入できる\n個人なんか想定してにゃいもん。』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『はいはい。\nすみませんでしたぁー。。』"];
                break;
            case 10:
                [_talk1 setString:@"ゆあ『話を戻すけど、戦術級以上の反応値が\n確かにあるにゃ。』"];
                break;
            case 11:
                [_talk1 setString:@"ゆあ『でも情報部の老害部長が「そんな\n高級能力者がいるはずない」って最終報告書\nから記載を外したにゃ。』"];
                break;
            case 12:
                [_talk1 setString:@"ミリィ『ふーん…、やーねー。\nコンプレックス持ちの官僚は歯車にも\nなれないのね。』"];
                break;
            case 13:
                [_talk1 setString:@"ゆあ『いつも迷惑してるにゃ。。\nだからもし、そういう戦術級の個体と\n出会った際の対処は一任するにゃ。』"];
                break;
            case 14:
                [_talk1 setString:@"ミリィ『オッケー。\nまぁ、無駄な指示を出されるよりは\n任せられる方がマシね。』"];
                break;
            case 15:
                [_talk1 setString:@"ミリィ『それじゃあゴミ処理を開始するわ。\n危険だから半径100m以内に入らないでね。\nんで追随と記録をよろしく。』"];
                break;
            case 16:
                [_talk1 setString:@"ゆあ『はーい。いってらっしゃーい♪』"];
                break;
            case 17:
                [self prologueEnd];
                break;
            default:
                break;
        }
        
    }else if(stageValue == 1){
        
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『ゆあは見るのは初めて？』"];
                break;
            case 2:
                [_talk1 setString:@"ゆあ『うん！こんなにおっきいなんて…\nすごぉい…』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『なんか貴方イノセントな分そういう\n台詞が卑猥ね。』"];
                break;
            case 4:
                [_talk1 setString:@"ゆあ『？』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『あー、今の台詞は忘れて。\nこの辺は旧科学時代で世界屈指の都市\nだったらしいからねー。』"];
                break;
            case 6:
                [_talk1 setString:@"ゆあ『「のあ」にはこんな大きな建物とか\nないもん。単純に大きいことって凄いこと\nなんだにゃ〜。』"];
                break;
            case 7:
                [_talk1 setString:@"ミリィ『昔は人口が50億いたらしいわ。\nありあまる人間を収容するのに大型構造物が\n必要だったとか。』"];
                break;
            case 8:
                [_talk1 setString:@"ゆあ『50億人！嘘みたいな数字だにゃ。』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『本当よ。野放図極まる繁殖行為で\n際限なく増えたらしいわ。』"];
                break;
            case 10:
                [_talk1 setString:@"ゆあ『今の人口って一億人くらいだよね？\nどうしてそんなに減ったにゃ？』"];
                break;
            case 11:
                [_talk1 setString:@"ミリィ『一種の共食いね。この惑星のリソース\nを奪い合った末に、殺し合ったらしいわ。』"];
                break;
            case 12:
                [_talk1 setString:@"ゆあ『ふーん…\nその時誰も「これ以上私達が増えたら\nヤバい」って考えなかったんだ…』"];
                break;
            case 13:
                [_talk1 setString:@"ミリィ『そう。誰も止めなかったのよ。\n己だけが大事で自己犠牲は誰もできなかった\nのね。』"];
                break;
            case 14:
                [_talk1 setString:@"ゆあ『なんだか哀れだにゃ…』"];
                break;
            case 15:
                [_talk1 setString:@"ミリィ『そうね。でも薄給でこんな任務に\n駆り出されてる私達も充分哀れよ。』"];
                break;
            case 16:
                [_talk1 setString:@"ゆあ『うぅ…、そうかも…』"];
                break;
            case 17:
                [self prologueEnd];
                break;
            default:
                break;
        }

        
    }else if(stageValue == 2){
        
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『えーと、確か昔の乗り物よ。』"];
                break;
            case 2:
                [_talk1 setString:@"ミリィ『名前なんだっけ………\n「でんしゅ」だったかしら？』"];
                break;
            case 3:
                [_talk1 setString:@"ゆあ『でんしゅ！』"];
                break;
            case 4:
                [_talk1 setString:@"ゆあ『これに乗って昔の人は生活してたんだ\nにゃあ…。なんかちょっと感動。』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『そう？今のヒトと大して変わらないわ\nよ。仕事して、恋愛して、落ち込んで、幸せに\nなって、そして子供を残して死ぬ。』"];
                break;
            case 6:
                [_talk1 setString:@"ゆあ『ミリィはそういうことに感動しなそう\nだからにゃー。』"];
                break;
            case 7:
                [_talk1 setString:@"ミリィ『そうねぇ…。歴史文献を読む限りでは\n昔からヒトは進歩無いし、なんか進化的な行き\n詰まりを感じるのよね。』"];
                break;
            case 8:
                [_talk1 setString:@"ゆあ『進化なんかしなくてもいいにょです！』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『えー、人類の生存繁栄進化を大義名分\nに掲げる統治局の職員とは思えない台詞ね。』"];
                break;
            case 10:
                [_talk1 setString:@"ゆあ『ゆあにはもっと大事なことがあるにゃ！』"];
                break;
            case 11:
                [_talk1 setString:@"ミリィ『えっと…、それはふかふかのベッドと\nマスターと…』"];
                break;
            case 12:
                [_talk1 setString:@"ゆあ『ごはん！』"];
                break;
            case 13:
                [_talk1 setString:@"ミリィ『うん。一次衝動の前に思索は無意味な\nことを思い知らされたわ。』"];
                break;
            case 14:
                [_talk1 setString:@"ゆあ『おなかすいたにゃー…』"];
                break;
            case 15:
                [self prologueEnd];
            default:
                break;
        }
        
        
    }else if(stageValue == 3){
        
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『そうね…いいとこまで来たわね。\nところでこの機能停止したでんしゅを伝って\n私達はどこへ行くの？』"];
                break;
            case 2:
                [_talk1 setString:@"ゆあ『この地下空洞は旧都シンヂュクの首都\n機能のあった構造物に繋がってるにゃ。』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『ふむふむ。』"];
                break;
            case 4:
                [_talk1 setString:@"ゆあ『地上よりは生命反応は少ないし、制圧の\n手間も省けるしでこのルートが選ばれたにゃ。』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『なるほどねー。把握。』"];
                break;
            case 6:
                [_talk1 setString:@"ミリィ『でもこの地下空洞どうにも陰気で何か\n出そうな感じね。』"];
                break;
            case 7:
                [_talk1 setString:@"ゆあ『！！！』"];
                break;
            case 8:
                [_talk1 setString:@"ゆあ『そういうの止めて欲しいにゃ！』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『大丈夫よー。ひょっとしたら遥か昔の\nご先祖様と再会できるかも。』"];
                break;
            case 10:
                [_talk1 setString:@"ゆあ『ご先祖様と再会するのは死んでからで\n充分にゃ！』"];
                break;
            case 11:
                [_talk1 setString:@"ミリィ『なーにー？霊子の残留物がそんなに\n怖いの？大丈夫よ、害意があっても彼らは\nほとんど何もできないし。』"];
                break;
            case 12:
                [_talk1 setString:@"ミリィ『死んだヒトより生きてるヒトの害意を\n心配するべきよ。そっちのがずっと厄介。』"];
                break;
            case 13:
                [_talk1 setString:@"ゆあ『猫は霊的なものに敏感なんだにゃ！』"];
                break;
            case 14:
                [_talk1 setString:@"ミリィ『一応私も猫と霊子的に接続してるん\nだけどな…』"];
                break;
            case 15:
                [_talk1 setString:@"ゆあ『ミリィは鈍感なの！』"];
                break;
            case 16:
                [_talk1 setString:@"ミリィ『ガーン…』"];
                [[SimpleAudioEngine sharedEngine]playEffect:@"shock.mp3"];
                break;
            case 17:
                [self prologueEnd];
                break;
            default:
                break;
        }
        
        
    }else if(stageValue == 4){
        
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『………』"];
                break;
            case 2:
                [_talk1 setString:@"ゆあ『あれ？どうしたの？』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『気がつかない？』"];
                break;
            case 4:
                [_talk1 setString:@"ゆあ『にゃにがー？』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『空を見て。』"];
                break;
            case 6:
                [_talk1 setString:@"ゆあ『…？』"];
                break;
            case 7:
                [_talk1 setString:@"ゆあ『！！！！！』"];
                break;
            case 8:
                [_talk1 setString:@"ゆあ『太陽が無いよ！ってゆーか夕方かと\n思ったけど違う！空が真っ赤！』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『シンヂュク郊外の空は普通だったから\nこの辺一帯だけの異常ね。』"];
                break;
            case 10:
                [_talk1 setString:@"ゆあ『わー、ミリィ冷静だにゃー。』"];
                break;
            case 11:
                [_talk1 setString:@"ミリィ『局地的な気象改変かしら？それとも\n天体の操作？いずれにしても私と同等以上の\n魔導士がいるわね。』"];
                break;
            case 12:
                [_talk1 setString:@"ゆあ『…』"];
                break;
            case 13:
                [_talk1 setString:@"ミリィ『どしたの？』"];
                break;
            case 14:
                [_talk1 setString:@"ゆあ『すごく理不尽。』"];
                break;
            case 15:
                [_talk1 setString:@"ミリィ『なにが？』"];
                break;
            case 16:
                [_talk1 setString:@"ゆあ『私の給料でこんな目にあってられない！\nぷんすか！』"];
                break;
            case 17:
                [_talk1 setString:@"ミリィ『あー…、そっちね…』"];
                break;
            case 18:
                [_talk1 setString:@"ゆあ『絶対マスターに文句つける！横暴にゃ！\nぷんすか！』"];
                break;
            case 19:
                [_talk1 setString:@"ミリィ『やれやれね。』"];
                break;
            case 20:
                [self prologueEnd];
                break;
            default:
                break;
        }
        
        
    }else if(stageValue == 5){
        
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『なーにー？』"];
                break;
            case 2:
                [_talk1 setString:@"ゆあ『いちおう、聞いておきたいんだけど…』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『ふむふむ』"];
                break;
            case 4:
                [_talk1 setString:@"ゆあ『ミリィはこの最上階にいるナニカをどう\nするつもり？』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『むー、でたとこ勝負ね。』"];
                break;
            case 6:
                [_talk1 setString:@"ゆあ『マジですか！？』"];
                break;
            case 7:
                [_talk1 setString:@"ゆあ『下手すると死にますよー！』"];
                break;
            case 8:
                [_talk1 setString:@"ミリィ『死なないわよ（笑）』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『んー、正直に言って２世紀以上に\n渡って放置されてきた地上でね。』"];
                break;
            case 10:
                [_talk1 setString:@"ミリィ『魔導学が進化の道筋を好き放題にして\nしまったけど…』"];
                break;
            case 11:
                [_talk1 setString:@"ミリィ『ひょっとしたら停滞したこの世界を\n変えられるナニカかもしれないって思ってる。』"];
                break;
            case 12:
                [_talk1 setString:@"ゆあ『確認でーす。統治局からの任務は「安全\nの確保」と「制圧」でーす。』"];
                break;
            case 13:
                [_talk1 setString:@"ミリィ『無視よ無視。』"];
                break;
            case 14:
                [_talk1 setString:@"ミリィ『私の自由意志を止める方法を統治局は\n持ってないでしょ？』"];
                break;
            case 15:
                [_talk1 setString:@"ゆあ『ふんがー！』"];
                break;
            case 16:
                [_talk1 setString:@"ミリィ『多分その辺統治局はわかってないけど\n立場として私が統治局に協力してあげてるのよ。』"];
                break;
            case 17:
                [_talk1 setString:@"ミリィ『だからいざとなったら私は私の目的を\n優先するわ☆』"];
                break;
            case 18:
                [_talk1 setString:@"ゆあ『あーうー…』"];
                break;
            case 19:
                [_talk1 setString:@"ミリィ『いい加減諦めなさい。きっと面白い\nことになるわよ。』"];
                break;
            case 20:
                [_talk1 setString:@"ゆあ『へいへい…、ついていきまーす。。』"];
                break;
            case 21:
                [_talk1 setString:@"ミリィ『よしよし、いいこいいこ。\nさーてぶっとばすぞー！』"];
                break;
            case 22:
                [self prologueEnd];
                break;
            default:
                break;
        }
        
        
    }




    
}

- (void)prologueEnd{
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anime.duration = .5;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    anime.fromValue = [NSNumber numberWithFloat:1];
    anime.toValue = [NSNumber numberWithFloat:0];
    [_catLayer addAnimation:anime forKey:@"prolog1"];
    
    CABasicAnimation *anime2 = [CABasicAnimation animationWithKeyPath:@"position"];
    anime2.duration = 2.0;
    anime2.removedOnCompletion = NO;
    anime2.fillMode = kCAFillModeForwards;
    anime2.fromValue = [NSValue valueWithCGPoint:CGPointMake(_catLayer.position.x, _catLayer.position.y)];
    anime2.toValue = [NSValue valueWithCGPoint:CGPointMake(_catLayer.position.x, _catLayer.position.y - 100)];
    [_catLayer addAnimation:anime2 forKey:@"cat2"];
    
    //音楽停止
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    
    //レイヤー削除
    [self DeleteLayer:_fullBackground];
    [self DeleteLayer:_dummyLayer];
    [_nextbtn removeFromSuperview];
    [self DeleteLayer:_talkBackgroundLayer];
    [self DeleteLayer:_talk1];
    [self performSelector:@selector(DeleteLayer:) withObject:_catLayer afterDelay:2.0];
    
    //音楽再開
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 3 ) {
        [self bgmPlay:@"351.mp3"];
    }else{
        [self bgmPlay:@"120.mp3"];
    }
    
    
    
    //ボタン再開
    [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
    
    //フラグ変更
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
    
    int StageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
    StageValue = StageValue + 1;
    
    [mdic setValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"prologue%d", StageValue]];
    delegate.playerPara = mdic;
    
    
}
#pragma mark - endlogue
- (void)endlogue1Start{
    
    //ボタンを使用不可に
    _btnGo.enabled = NO;
    _btnRest.enabled = NO;
    _btnSave.enabled = NO;
    _btnStatus.enabled = NO;
    
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    
    [self performSelector:@selector(bgmPlay:) withObject:@"072.mp3" afterDelay:1.0];
    
    _catLayer = [CALayer layer];
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"yua" ofType:@"png"]];
    _catLayer.contents = (id)img.CGImage;
    _catLayer.frame = CGRectMake(160-64, (self.view.frame.size.height - 220-50)/2+50-60, 128, 128);
    [self.view.layer addSublayer:_catLayer];
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anime.duration = 2.0;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    anime.fromValue = [NSNumber numberWithFloat:0];
    anime.toValue = [NSNumber numberWithFloat:1];
    [_catLayer addAnimation:anime forKey:@"prolog1"];
    
    CABasicAnimation *anime2 = [CABasicAnimation animationWithKeyPath:@"position"];
    anime2.duration = .5;
    anime2.removedOnCompletion = NO;
    anime2.fillMode = kCAFillModeForwards;
    anime2.fromValue = [NSValue valueWithCGPoint:CGPointMake(_catLayer.position.x, _catLayer.position.y -100)];
    anime2.toValue = [NSValue valueWithCGPoint:_catLayer.position];
    [_catLayer addAnimation:anime2 forKey:@"cat2"];
    
    //トーク
    _talkBackgroundLayer = [CALayer layer];
    _talkBackgroundLayer.frame = CGRectMake(10, self.view.frame.size.height -220 - 80, 300, 70);
    _talkBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    _talkBackgroundLayer.opacity = .2;
    [self.view.layer addSublayer:_talkBackgroundLayer];
    
    _nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextbtn.frame = CGRectMake(10, self.view.frame.size.height - 300, 300, 70);
    NSString *path = [[NSBundle mainBundle]pathForResource:@"none" ofType:@"png"];
    _nextbtn.imageView.image = [UIImage imageWithContentsOfFile:path];
    [self.view addSubview:_nextbtn];
    [_nextbtn addTarget:self action:@selector(endlogueButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _talk1 = [CATextLayer layer];
    _talk1.backgroundColor = [UIColor clearColor].CGColor;
    
    //ステージごとの分岐
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
    
    if (stageValue == 0) {
        [_talk1 setString:@"ゆあ『おつかれにゃーん。』"];
    }else if(stageValue == 1){
        [_talk1 setString:@"ゆあ『お仕事はやーい。』"];
    }else if(stageValue == 2){
        [_talk1 setString:@"ゆあ『おいっすー。』"];
    }else if(stageValue == 3){
        [_talk1 setString:@"ゆあ『ミリィ！はやくはやく！』"];
    }else if(stageValue == 4){
        [_talk1 setString:@"ゆあ『…もうカエリタイデス。』"];
    }
    
    _talk1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _talk1.fontSize = 14;
    _talk1.foregroundColor = [UIColor whiteColor].CGColor;
    _talk1.frame = CGRectMake(15, self.view.frame.size.height -220 - 75, 300, 65);
    _talk1.alignmentMode = kCAAlignmentLeft;
    _talk1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_talk1];
    
    //TAP!の表示が発生
    CATextLayer *tapText = [CATextLayer layer];
    [tapText setString:@"TAP HERE"];
    tapText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    tapText.fontSize = 18;
    tapText.foregroundColor = [UIColor whiteColor].CGColor;
    tapText.frame = CGRectMake(0, 40, 285, 30);
    tapText.alignmentMode = kCAAlignmentRight;
    tapText.contentsScale = [UIScreen mainScreen].scale;
    [_talk1 addSublayer:tapText];
    
    CABasicAnimation *anime3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anime3.duration = .5;
    anime3.autoreverses = YES;
    anime3.fromValue = [NSNumber numberWithFloat:0];
    anime3.toValue = [NSNumber numberWithFloat:1];
    anime3.repeatCount = HUGE_VALF;
    [tapText addAnimation:anime3 forKey:@"opening"];
    
    //ボタンのタップ回数を保存
    _tapTime = 0;

}

- (void)endlogueButtonClicked{
    
    _tapTime = _tapTime + 1;
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
    
    if (stageValue == 0) {
        
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『はーい。3km四方に生体反応無し。\nこのエリアは完了ね。』"];
                break;
            case 2:
                [_talk1 setString:@"ゆあ『次のエリアの座標は…のポイントに\nなるにゃ。』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『さっさと次にいきましょ。』"];
                break;
            case 4:
                [_talk1 setString:@"ゆあ『ねぇ、ミリィ。』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『なに？』"];
                break;
            case 6:
                [_talk1 setString:@"ゆあ『さっきの蜘蛛と一体化してた子が\nいたじゃない？』"];
                break;
            case 7:
                [_talk1 setString:@"ミリィ『あの子がどうかしたの？』"];
                break;
            case 8:
                [_talk1 setString:@"ゆあ『あのぐらいの遺伝子一致率の人間なら\n”のあ”にも一杯いるじゃない？』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『そうね。スラムに行けばもっと\n酷いわね。』"];
                break;
            case 10:
                [_talk1 setString:@"ゆあ『じゃあミリィが排除したのは\nどうしてにゃ？』"];
                break;
            case 11:
                [_talk1 setString:@"ミリィ『排除するかどうかについては\n貴方達統治局の基準に従っただけよ。』"];
                break;
            case 12:
                [_talk1 setString:@"ミリィ『それともゆあが聞きたいのは\n私の基準のこと？』"];
                break;
            case 13:
                [_talk1 setString:@"ゆあ『そうだにゃ。』"];
                break;
            case 14:
                [_talk1 setString:@"ミリィ『人が人たらしめてるのは\n何かを考えてみればいいんじゃない？』"];
                break;
            case 15:
                [_talk1 setString:@"ミリィ『少なくとも…\nあの子はもう人間を辞めてたわよ。』"];
                break;
            case 16:
                [_talk1 setString:@"ミリィ『それにもう人間かどうか\n定義するしないの話はナンセンスよ。』"];
                break;
            case 17:
                [_talk1 setString:@"ミリィ『こんな時代じゃあ、昔の人類が\n信仰してたっていう「神様」ぐらいしか\n本当の判断はできないと思う。』"];
                break;
            case 18:
                [_talk1 setString:@"ゆあ『えー、ミリィってそんな精神補完概念\nなんかを信じてるアナクロな人だったっけー？』"];
                break;
            case 19:
                [_talk1 setString:@"ミリィ『馬鹿ね。ただの物の例え。\n誰にも判断なんかできないってことよ。』"];
                break;
            case 20:
                [_talk1 setString:@"ゆあ『でもミリィは判断できなくても\n「仕事」としてあの子を排除する。』"];
                break;
            case 21:
                [_talk1 setString:@"ミリィ『そう。世の中は不完全だし、\n誰かに文句言っても始まらないからね。』"];
                break;
            case 22:
                [_talk1 setString:@"ゆあ『うーん…、ごまかされて結局ミリィの\nことを教えてもらえなかった気がするにゃ。』"];
                break;
            case 23:
                [_talk1 setString:@"ミリィ『バレたか。』"];
                break;
            case 24:
                [_talk1 setString:@"ゆあ『そうだにゃ。』"];
                break;
            case 25:

                [self endlogueEnd];
                break;
            default:
                break;
        }
        
    }else if(stageValue == 1){
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『楽勝ね。』"];
                break;
            case 2:
                [_talk1 setString:@"ゆあ『流石は世界で５人しかいない戦略級\n魔導士にゃ！』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『おだてても何も出ないわよ？』"];
                break;
            case 4:
                [_talk1 setString:@"ゆあ『んー…？』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『どしたの？』"];
                break;
            case 6:
                [_talk1 setString:@"ゆあ『ミリィはどうしてこんな仕事してるの？\n他にもっといい仕事いっぱいあるのに。』"];
                break;
            case 7:
                [_talk1 setString:@"ミリィ『ふむ。』"];
                break;
            case 8:
                [_talk1 setString:@"ゆあ『私のマスターですら統治局本部勤めで\n全然ミリィより待遇いいにゃ。』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『猫の使い魔にはっきりそう言われると\n傷つくわね。』"];
                break;
            case 10:
                [_talk1 setString:@"ゆあ『うっ…ごめんにゃ。でも気になる。』"];
                break;
            case 11:
                [_talk1 setString:@"ミリィ『そうねぇ…、私としては贖罪かな。』"];
                break;
            case 12:
                [_talk1 setString:@"ゆあ『ふぇ？端から見てジェノサイドしてる\nだけにゃ。』"];
                break;
            case 13:
                [_talk1 setString:@"ミリィ『んー、そう見えてるならそれはゆあが\nお子様なせいかな。』"];
                break;
            case 14:
                [_talk1 setString:@"ゆあ『ぶー。』"];
                break;
            case 15:
                [_talk1 setString:@"ミリィ『あはは。ほら、次に行くわよ。\nつぎつぎー。』"];
                break;
            case 16:
                [_talk1 setString:@"ゆあ『ぶー。』"];
                break;
            case 17:
                [_talk1 setString:@"ミリィ（そうねぇ…、本当に哀れなのは…、\n一体誰かしら。）"];
                break;
            case 18:
                [self endlogueEnd];
                break;
            default:
                break;

        }
    }else if(stageValue == 2){
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『…おいすー。』"];
                break;
            case 2:
                [_talk1 setString:@"ゆあ『元気ないにゃー。制圧地域の1/3は完了\nしたよ。もうちょっと元気だしてー。』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『はー…、ゆあは能天気でいいわねー。\nお姉さんはちょっと疲れたの。』"];
                break;
            case 4:
                [_talk1 setString:@"ゆあ『むー。。』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『この任務、お題目は調査になってる\nけど喧嘩売ってくる輩が多過ぎるわね。』"];
                break;
            case 6:
                [_talk1 setString:@"ミリィ『もうちょっと理解を示したり、建設的\nにできるかと思ったんだけど…』"];
                break;
            case 7:
                [_talk1 setString:@"ゆあ『ふにゃ。ミリィも相当喧嘩腰な感じが\nするけどにゃ。』"];
                break;
            case 8:
                [_talk1 setString:@"ミリィ『だって私を見るなり餌かストレス発散\nの対象に見る奴が多いんだもの。』"];
                break;
            case 9:
                [_talk1 setString:@"ゆあ『それだけこの地域の人間やそれ以外で\n諍いが激しいんだにゃ。』"];
                break;
            case 10:
                [_talk1 setString:@"ミリィ『殺害するつもりで絡んでくる輩に情け\nをかける気もしないからねぇ…』"];
                break;
            case 11:
                [_talk1 setString:@"ゆあ『でもミリィが頑張ってるおかげで、\n復興プロジェクトに関わる人間が安全に作業\nできるようになるよ。』"];
                break;
            case 12:
                [_talk1 setString:@"ミリィ『そうねぇ…、あんたの励ましの言葉に\n免じてあと一踏ん張りしようかな。。』"];
                break;
            case 13:
                [_talk1 setString:@"ゆあ『そうにゃ！ミリィがんばてー！』"];
                break;
            case 14:
                [_talk1 setString:@"ミリィ『うん。ゆあのために頑張る。』"];
                break;
            case 15:
                [self endlogueEnd];
                break;
            default:
                break;
                
        }
    }else if(stageValue == 3){
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『はいはいはい。そんなにここが嫌な\nのね。』"];
                break;
            case 2:
                [_talk1 setString:@"ゆあ『（こくこく）』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『あれ？』"];
                break;
            case 4:
                [_talk1 setString:@"ゆあ『？』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『ゆあはさっきまで私の後ろからついて\nきてたんだよね？』"];
                break;
            case 6:
                [_talk1 setString:@"ゆあ『違うにゃ。ボスを倒してからはミリィ\nの先を歩いてたにゃ。』"];
                break;
            case 7:
                [_talk1 setString:@"ミリィ『…？』"];
                break;
            case 8:
                [_talk1 setString:@"ミリィ『足音が後ろからしてたからてっきり\n後ろにいるものだと思ってたけど…』"];
                break;
            case 9:
                [_talk1 setString:@"ゆあ『ミリィ！！！』"];
                break;
            case 10:
                [_talk1 setString:@"ミリィ『は、はい。』"];
                break;
            case 11:
                [_talk1 setString:@"ゆあ『早く行こ早く行こ早く行こ早く行こ！』"];
                break;
            case 12:
                [_talk1 setString:@"ミリィ『近場に生命反応はゆあだけだったはず\nなんだけど…』"];
                break;
            case 13:
                [_talk1 setString:@"ゆあ『もういやー！！！！』"];
                break;
            case 14:
                [_catLayer removeFromSuperlayer];
                [_talk1 setString:@"ミリィ『あ…、行っちゃった。』"];
                break;
            case 15:
                [self endlogueEnd];
                break;
            default:
                break;
                
        }
    }else if(stageValue == 4){
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『はいはいはい。\nさっさとついて来なさい。』"];
                break;
            case 2:
                [_talk1 setString:@"ゆあ『しくしく。』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『おそらく上層の何かは控えめに見積\nもっても戦略級以上の魔導士になるわ。』"];
                break;
            case 4:
                [_talk1 setString:@"ミリィ『あるいはひょっとしたらヒトで\n2人目の災害級魔導士になれるかも。』"];
                break;
            case 5:
                [_talk1 setString:@"ゆあ『あれっぽちの危険手当でこんな仕事した\nくなぃ〜。』"];
                break;
            case 6:
                [_talk1 setString:@"ミリィ『ゴネないの。いざとなったら私が貴方\nを転送してあげるから。』"];
                break;
            case 7:
                [_talk1 setString:@"ミリィ『命だけは大丈夫よ。きっと多分。』"];
                break;
            case 8:
                [_talk1 setString:@"ゆあ『……ミリィと一緒じゃなかったら\nとっくに帰ってるにゃ…』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『よしよし。この構造物の上層にいる\n何かに出会えるなら、この仕事はもっと大きな\n意味を持つわ。』"];
                break;
            case 10:
                [_talk1 setString:@"ミリィ『さぁ、、行きましょ？』"];
                break;
            case 11:
                [_talk1 setString:@"ゆあ『…うん。』"];
                break;
            case 12:
                [self endlogueEnd];
                //[self congratuationAlert];
                
                
                break;
            default:
                break;
                
        }
    }




}

- (void)congratuationAlert{
    
    CongratuationViewController *battleAlert = [[CongratuationViewController alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil];
    battleAlert.tag = 6;
    [battleAlert show];
}

- (void)endlogueEnd{
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anime.duration = .5;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    anime.fromValue = [NSNumber numberWithFloat:1];
    anime.toValue = [NSNumber numberWithFloat:0];
    [_catLayer addAnimation:anime forKey:@"prolog1"];
    
    CABasicAnimation *anime2 = [CABasicAnimation animationWithKeyPath:@"position"];
    anime2.duration = 2.0;
    anime2.removedOnCompletion = NO;
    anime2.fillMode = kCAFillModeForwards;
    anime2.fromValue = [NSValue valueWithCGPoint:CGPointMake(_catLayer.position.x, _catLayer.position.y)];
    anime2.toValue = [NSValue valueWithCGPoint:CGPointMake(_catLayer.position.x, _catLayer.position.y - 100)];
    [_catLayer addAnimation:anime2 forKey:@"cat2"];
    
    //音楽停止
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    
    //レイヤー削除
    [self DeleteLayer:_fullBackground];
    [self DeleteLayer:_dummyLayer];
    [_nextbtn removeFromSuperview];
    [self DeleteLayer:_talkBackgroundLayer];
    [self DeleteLayer:_talk1];
    [self performSelector:@selector(DeleteLayer:) withObject:_catLayer afterDelay:2.0];
    
    //音楽再開
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 3 ) {
        [self bgmPlay:@"351.mp3"];
    }else{
        [self bgmPlay:@"120.mp3"];
    }
    
    //ボタン再開
    [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
    
    //フラグ変更
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
    
    int stageValue = [[delegate.playerPara valueForKey:@"maxStage"]intValue];
    [mdic setValue:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"endlogue%d", stageValue]];
    stageValue = stageValue + 1;
    [mdic setValue:[NSNumber numberWithInt:stageValue] forKey:@"maxStage"];
    delegate.playerPara = mdic;

    //アナウンス表示
    [self announceAppear];
    
}
                 
                 

- (void)announceAppear{
    
    CALayer *dummyLayer = [CALayer layer];
    dummyLayer.frame = CGRectMake(0, self.view.center.y - 30, 320, 45);
    dummyLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:dummyLayer];
    
    CALayer *backgroundEquipMessage = [CALayer layer];
    backgroundEquipMessage.backgroundColor = [UIColor blackColor].CGColor;
    backgroundEquipMessage.frame = CGRectMake(0, 0, 320, 45);
    //backgroundEquipMessage.opacity = 0;
    [dummyLayer addSublayer:backgroundEquipMessage];
    
    CATextLayer *equipMessage = [CATextLayer layer];
    equipMessage.backgroundColor = [UIColor clearColor].CGColor;
    [equipMessage setString:[NSString stringWithFormat:@"次のエリアへの転移が可能になりました"]];
    equipMessage.alignmentMode = kCAAlignmentCenter;
    equipMessage.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    equipMessage.fontSize = 12;
    equipMessage.foregroundColor = [UIColor whiteColor].CGColor;
    equipMessage.frame = CGRectMake(0,15,320,30);
    equipMessage.contentsScale = [UIScreen mainScreen].scale;
    [dummyLayer addSublayer:equipMessage];
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 2.0f;
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0];
    animation.autoreverses = NO;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.beginTime = CACurrentMediaTime() + .7;
    
    [dummyLayer addAnimation:animation forKey:@"opacityAnimation"];

    [self performSelector:@selector(DeleteLayer:) withObject:dummyLayer afterDelay:2.5];
}
                 
                 

                 
    
#pragma mark - explorMODE
//探索ボタンクリック
-(void)explor:(UIButton*)button{
    
    if (_battleOrExplor == NO) {
    
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
        
        NSString *string = [NSString stringWithFormat:@"area%dDegree", [[delegate.playerPara valueForKey:@"currentStage"]intValue]+1];
        
        int areaValue = [[mdic valueForKey:string]intValue];
        areaValue = areaValue + 1;
        
        if (areaValue > 999) {
            areaValue = 999;
        }
        
        [mdic setValue:[NSNumber numberWithInt:areaValue] forKey:string];
        delegate.playerPara = mdic;
        [self areaDegreeUpdate];
        
        
        
        //効果音再生
        [self soundEffectYES];
        
        
        
        //ボス演出
        if ([[delegate.playerPara valueForKey:string]intValue] == 99) {
            
            int stageValue =[[delegate.playerPara valueForKey:@"currentStage"]intValue];
            NSString *string = [NSString stringWithFormat:@"boss%dDown", stageValue+1];
            
            if ([[delegate.playerPara valueForKey:string]intValue] == 0) {
                
                //フラグ変更
                _battleOrExplor = YES;
                [self bossDrama];
                return;

            }

        }
        
        //エンドローグへ
        if ([[delegate.playerPara valueForKey:string]intValue] == 100)
        {
            int stageValue =[[delegate.playerPara valueForKey:@"currentStage"]intValue];
            
            NSString *str =[NSString stringWithFormat:@"endlogue%d", stageValue+1];
            
            
            if ([[delegate.playerPara valueForKey:str]intValue] == 0) {
                [self endlogue1Start];
            }else{
                
            }

            return;
        }
        
    
        //ランダムイベントルーレット
        int ran;
        ran = arc4random() % 30;
        
        //モンスターに遭遇
        if (ran <= 15) {
           
            //フラグON
            _battleOrExplor = YES;
            
            [self battleStart];
        
        
        //NEAR DEATH HAPPINESS
        }else if(ran >= 27){
            
            //フラグON
            _battleOrExplor = YES;
            
            //FOEフラグON
            AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
            delegate.isFOE = YES;
            
            [self battleStart];
            
        }else{
        
            [self autoSave];
            
        }

        
    }
}

//休憩ボタンクリック
-(void)restButtonClicked:(UIButton*)button{
    
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    if (_battleOrExplor == NO) {
        
        //効果音再生
        [[SimpleAudioEngine sharedEngine]playEffect:@"healing.wav"];
        
        //休憩しましたのメッセージ
        CALayer *backgroundEquipMessage = [CALayer layer];
        backgroundEquipMessage.backgroundColor = [UIColor blackColor].CGColor;
        backgroundEquipMessage.frame = CGRectMake(0, self.view.center.y - 30, 320, 45);
        [self.view.layer addSublayer:backgroundEquipMessage];
        
        CABasicAnimation *backgroundAnimation;
        backgroundAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        backgroundAnimation.duration = 1.5f;
        backgroundAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        backgroundAnimation.toValue = [NSNumber numberWithFloat:0];
        backgroundAnimation.autoreverses = NO;
        backgroundAnimation.repeatCount = 1;
        backgroundAnimation.removedOnCompletion = NO;
        backgroundAnimation.fillMode = kCAFillModeForwards;
        [backgroundEquipMessage addAnimation:backgroundAnimation forKey:@"opacityAnimation"];
        
        CATextLayer *equipMessage = [CATextLayer layer];
        equipMessage.backgroundColor = [UIColor clearColor].CGColor;
        [equipMessage setString:[NSString stringWithFormat:@"休憩してLIFEを回復した…"]];
        equipMessage.alignmentMode = kCAAlignmentCenter;
        equipMessage.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
        equipMessage.fontSize = 12;
        equipMessage.foregroundColor = [UIColor whiteColor].CGColor;
        equipMessage.frame = CGRectMake(0,self.view.center.y - 15,320,30);
        equipMessage.contentsScale = [UIScreen mainScreen].scale;
        [self.view.layer addSublayer:equipMessage];
        
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


        //体力回復
        int lifeCheck = [[delegate.playerPara valueForKey:@"currentLife"]intValue] + [[delegate.playerPara valueForKey:@"maxLife"]intValue] * 0.3;
        int value = ([[delegate.playerPara valueForKey:@"maxLife"]intValue] < lifeCheck) ?  [[delegate.playerPara valueForKey:@"maxLife"]intValue] : lifeCheck ;
        
        NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
        [mdic setValue:[NSNumber numberWithInt:value] forKey:@"currentLife"];
        delegate.playerPara = mdic;
        
        //LIFEの表示を更新
        [lifeLabel setText:[NSString stringWithFormat:@"LIFE : %05d/%05d", value,[[delegate.playerPara valueForKey:@"maxLife"]intValue]]];
        
        //ランダムで敵と遭遇
        //ランダムイベントルーレット
        int ran;
        ran = arc4random() % 10;
        
        //モンスターに遭遇
        if (ran == 0) {
            
            _battleOrExplor = YES;
            [self battleStart];
            
        }else{
            [self autoSave];
        }
    }
}

//状態ボタンクリック
- (void)statusButtonClicked:(UIButton*)button{
    
    if (_battleOrExplor == NO) {
        
        //効果音再生
        [self soundEffectYES];
        
        //音楽フラグをオフ
        AppDelegate *apppDelegate = [[UIApplication sharedApplication]delegate];
        apppDelegate.musicFlag = NO;
        
        StatusViewController *mycontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"status"];
        [self presentViewController:mycontroller animated:YES completion:nil];
        
        
        //background時のアニメ消去対策
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
}

//説明ボタンクリック
- (void)readmeButtonClicked:(UIButton*)button{
    
    
    if (_battleOrExplor == NO) {
        
        //効果音再生
        [self soundEffectYES];
    
        //音楽フラグをオフ
        AppDelegate *apppDelegate = [[UIApplication sharedApplication]delegate];
        apppDelegate.musicFlag = NO;

        [self performSegueWithIdentifier:@"manual" sender:self];
        
        //background時のアニメ消去対策
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
}

- (void)escapeSelected{
    
    //[_monsterLayer removeFromSuperlayer];
    _battleOrExplor = NO;
    //bgm.volume = 1;
    
}

- (void)battleEndAndExplorRestart{
    
       
    //音楽再生
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 3 ) {
        [self bgmPlay:@"351.mp3"];
    }else{
        [self bgmPlay:@"120.mp3"];
    }
    
    //ミリィさん通常モードに
    [self millyAnimationReady];

    //フラグ管理
    _battleOrExplor = NO;
    
    //ボタンの再設定
    //探索ボタン
    
    [_btnGo removeFromSuperview];
    
    _btnGo = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnGo.frame = CGRectMake(240, self.view.frame.size.height - 130, 70, 70);
    [_btnGo setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnGo setTitle:@"探索" forState:UIControlStateNormal];
    [_btnGo.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnGo setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnGo setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnGo];
    
    [_btnGo addTarget:self action:@selector(explor:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnGoTextBackgroundLayer = [CALayer layer];
    btnGoTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnGoTextBackgroundLayer.opacity = 0.5;
    btnGoTextBackgroundLayer.frame = CGRectMake(240, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnGoTextBackgroundLayer];
    
    [_btnGoOverTextLayer1 removeFromSuperlayer];
    
    _btnGoOverTextLayer1 = [CATextLayer layer];
    _btnGoOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnGoOverTextLayer1 setString:@"お仕事が"];
    _btnGoOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnGoOverTextLayer1.fontSize = 10;
    _btnGoOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnGoOverTextLayer1.frame = CGRectMake(245, self.view.frame.size.height - 85, 70, 70);
    _btnGoOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnGoOverTextLayer1];
    
    [_btnGoOverTextLayer2 removeFromSuperlayer];
    
    _btnGoOverTextLayer2 = [CATextLayer layer];
    _btnGoOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnGoOverTextLayer2 setString:@"見敵必殺"];
    _btnGoOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnGoOverTextLayer2.fontSize = 10;
    _btnGoOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnGoOverTextLayer2.frame = CGRectMake(245, self.view.frame.size.height - 74, 70, 70);
    _btnGoOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnGoOverTextLayer2];
    
    
    //休憩ボタン
    
    [_btnRest removeFromSuperview];
    
    _btnRest = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRest.frame = CGRectMake(160, self.view.frame.size.height - 130, 70, 70);
    [_btnRest setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnRest setTitle:@"休憩" forState:UIControlStateNormal];
    [_btnRest.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnRest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRest setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnRest setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnRest];
    
    [_btnRest addTarget:self action:@selector(restButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnRestTextBackgroundLayer = [CALayer layer];
    btnRestTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnRestTextBackgroundLayer.opacity = 0.5;
    btnRestTextBackgroundLayer.frame = CGRectMake(160, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnRestTextBackgroundLayer];
    
    [_btnRestOverTextLayer1 removeFromSuperlayer];
    
    _btnRestOverTextLayer1 = [CATextLayer layer];
    _btnRestOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnRestOverTextLayer1 setString:@"良く眠るのは"];
    _btnRestOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnRestOverTextLayer1.fontSize = 10;
    _btnRestOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnRestOverTextLayer1.frame = CGRectMake(165, self.view.frame.size.height - 85, 70, 70);
    _btnRestOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnRestOverTextLayer1];
    
    [_btnRestOverTextLayer2 removeFromSuperlayer];
    
    _btnRestOverTextLayer2 = [CATextLayer layer];
    _btnRestOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnRestOverTextLayer2 setString:@"豚だけね"];
    _btnRestOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnRestOverTextLayer2.fontSize = 10;
    _btnRestOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnRestOverTextLayer2.frame = CGRectMake(165, self.view.frame.size.height - 74, 70, 70);
    _btnRestOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnRestOverTextLayer2];
    
    
    //状態ボタン
    
    [_btnStatus removeFromSuperview];
    
    _btnStatus = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStatus.frame = CGRectMake(240, self.view.frame.size.height - 210, 70, 70);
    [_btnStatus setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnStatus setTitle:@"状態" forState:UIControlStateNormal];
    [_btnStatus.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnStatus setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnStatus setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnStatus];
    
    [_btnStatus addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnStatusTextBackgroundLayer = [CALayer layer];
    btnStatusTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnStatusTextBackgroundLayer.opacity = 0.5;
    btnStatusTextBackgroundLayer.frame = CGRectMake(240, self.view.frame.size.height - 170, 70, 30);
    [self.view.layer addSublayer:btnStatusTextBackgroundLayer];
    
    [_btnStatusOverTextLayer1 removeFromSuperlayer];
    
    _btnStatusOverTextLayer1 = [CATextLayer layer];
    _btnStatusOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer1 setString:@"装備の基準は"];
    _btnStatusOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer1.fontSize = 10;
    _btnStatusOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer1.frame = CGRectMake(245, self.view.frame.size.height - 165, 70, 70);
    _btnStatusOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnStatusOverTextLayer1];
    
    [_btnStatusOverTextLayer2 removeFromSuperlayer];
    
    _btnStatusOverTextLayer2 = [CATextLayer layer];
    _btnStatusOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer2 setString:@"見た目"];
    _btnStatusOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer2.fontSize = 10;
    _btnStatusOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer2.frame = CGRectMake(245, self.view.frame.size.height - 154, 70, 70);
    _btnStatusOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnStatusOverTextLayer2];
    
    
    //ヘルプボタン検討中
    
    [_btnSave removeFromSuperview];
    
    _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSave.frame = CGRectMake(160, self.view.frame.size.height - 210, 70, 70);
    [_btnSave setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnSave setTitle:@"説明" forState:UIControlStateNormal];
    [_btnSave.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnSave setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnSave];
    
    [_btnSave addTarget:self action:@selector(readmeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    CALayer *btnSaveTextBackgroundLayer = [CALayer layer];
    btnSaveTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnSaveTextBackgroundLayer.opacity = 0.5;
    btnSaveTextBackgroundLayer.frame = CGRectMake(160, self.view.frame.size.height - 170, 70, 30);
    [self.view.layer addSublayer:btnSaveTextBackgroundLayer];
    
    [_btnSaveOverTextLayer1 removeFromSuperlayer];
    
    _btnSaveOverTextLayer1 = [CATextLayer layer];
    _btnSaveOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnSaveOverTextLayer1 setString:@"ゆあの"];
    _btnSaveOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer1.fontSize = 10;
    _btnSaveOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer1.frame = CGRectMake(165, self.view.frame.size.height - 165, 70, 70);
    _btnSaveOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnSaveOverTextLayer1];
    
    [_btnSaveOverTextLayer2 removeFromSuperlayer];
    
    _btnSaveOverTextLayer2 = [CATextLayer layer];
    _btnSaveOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnSaveOverTextLayer2 setString:@"超絶解説"];
    _btnSaveOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer2.fontSize = 10;
    _btnSaveOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer2.frame = CGRectMake(165, self.view.frame.size.height - 154, 70, 70);
    _btnSaveOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnSaveOverTextLayer2];

    
}

#pragma mark - BOSS DRAMA

- (void)bossDrama{
    
    //ボタンを使用不可に
    _btnGo.enabled = NO;
    _btnRest.enabled = NO;
    _btnSave.enabled = NO;
    _btnStatus.enabled = NO;
    
    //フラグをON
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    delegate.isBOSS = YES;
    
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    
    //音楽を再生
    int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
    
    NSMutableString *musicPath;
    
    switch (stageValue) {
        case 0:
            musicPath = [NSString stringWithFormat:@"187.mp3"];
            break;
        case 1:
            musicPath = [NSString stringWithFormat:@"107.mp3"];
            break;
        case 2:
            musicPath = [NSString stringWithFormat:@"game1.mp3"];
            break;
        case 3:
            musicPath = [NSString stringWithFormat:@"186.mp3"];
            break;
        case 4:
            musicPath = [NSString stringWithFormat:@"262.mp3"];
        default:
            break;
    }
    
    [self performSelector:@selector(bgmPlay:) withObject:musicPath afterDelay:2.5];
    
    
    //定数を設定
    const float monsterLayerWidth = 320;
    const float monsterLayerHeight = self.view.frame.size.height -220 -60;

    //ベースレイヤー
    monsterLayer = [CALayer layer];
    int monsterArea = self.view.frame.size.height -220 -60;
    monsterLayer.frame = CGRectMake(0, 60, 320, monsterArea);
    [self.view.layer addSublayer:monsterLayer];
    
    //モンスターレイヤー
    monsterLayer1 = [CALayer layer];

    //画像を読み込んでリサイズ
    NSString *str = [NSString stringWithFormat:@"boss%02d", stageValue];
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:str ofType:@"png"]];
    monsterLayer1.contents = (id)img.CGImage;
    monsterLayer1.contentsGravity = kCAGravityResizeAspect;
    monsterLayer1.frame = CGRectMake(0, 0, monsterLayerWidth, monsterLayerHeight);
    [monsterLayer addSublayer:monsterLayer1];        
    
    CABasicAnimation *bossAnime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    bossAnime.duration = 3.0;
    bossAnime.fromValue = [NSNumber numberWithFloat:0];
    bossAnime.toValue = [NSNumber numberWithFloat:1];
    bossAnime.removedOnCompletion = NO;
    bossAnime.fillMode = kCAFillModeForwards;
    [monsterLayer1 addAnimation:bossAnime forKey:@"bossAppearance"];
     
    //副題
    CATextLayer *bossNickName = [CATextLayer layer];
    bossNickName.backgroundColor = [UIColor clearColor].CGColor;
    
    //ボスごとの分岐
    if (stageValue == 0) {
        [bossNickName setString:@"渇望する闇食"];
    }else if(stageValue == 1){
        [bossNickName setString:@"愛食む壷"];
    }else if(stageValue == 2){
        [bossNickName setString:@"暴虐の炎"];
    }else if(stageValue == 3){
        [bossNickName setString:@"首収集家"];
    }else if(stageValue == 4){
        [bossNickName setString:@"朱天争覇"];
    }
    
    bossNickName.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    bossNickName.fontSize = 13;
    bossNickName.foregroundColor = [UIColor whiteColor].CGColor;
    bossNickName.frame = CGRectMake(10, monsterLayer1.self.frame.size.height-70, 160, 30);
    bossNickName.alignmentMode = kCAAlignmentCenter;
    bossNickName.contentsScale = [UIScreen mainScreen].scale;
    [monsterLayer addSublayer:bossNickName];
    
    CABasicAnimation *bossTextAnime2 = [CABasicAnimation animationWithKeyPath:@"position"];
    bossTextAnime2.duration = 3.0;
    bossTextAnime2.fromValue = [NSValue valueWithCGPoint:bossNickName.position];
    bossTextAnime2.toValue = [NSValue valueWithCGPoint:CGPointMake(bossNickName.position.x+160, bossNickName.position.y)];
    bossTextAnime2.removedOnCompletion = NO;
    bossTextAnime2.fillMode = kCAFillModeForwards;
    
    [bossNickName addAnimation:bossTextAnime2 forKey:@"bossTextAppearance2"];
    
    //ボスの名前
    CATextLayer *bossName = [CATextLayer layer];
    bossName.backgroundColor = [UIColor clearColor].CGColor;
    
    if (stageValue == 0) {
        [bossName setString:@"アトラ"];
    }else if(stageValue == 1){
        [bossName setString:@"マナティス"];
    }else if(stageValue == 2){
        [bossName setString:@"霊山ほむら"];
    }else if(stageValue == 3){
        [bossName setString:@"塞"];
    }else if(stageValue == 4){
        [bossName setString:@"アインソフ"];
    }

    
    
    bossName.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    bossName.fontSize = 18;
    bossName.foregroundColor = [UIColor whiteColor].CGColor;
    bossName.frame = CGRectMake(10, monsterLayer1.self.frame.size.height-50, 160, 30);
    bossName.alignmentMode = kCAAlignmentCenter;
    bossName.contentsScale = [UIScreen mainScreen].scale;
    [monsterLayer addSublayer:bossName];
    
    CABasicAnimation *bossTextAnime = [CABasicAnimation animationWithKeyPath:@"position"];
    bossTextAnime.duration = 3.0;
    bossTextAnime.fromValue = [NSValue valueWithCGPoint:bossName.position];
    bossTextAnime.toValue = [NSValue valueWithCGPoint:CGPointMake(bossName.position.x+160, bossName.position.y)];
    bossTextAnime.removedOnCompletion = NO;
    bossTextAnime.fillMode = kCAFillModeForwards;
    
    [bossName addAnimation:bossTextAnime forKey:@"bossTextAppearance2"];
    
    //レイヤーを消しとく
    [self performSelector:@selector(DeleteLayer:) withObject:bossName afterDelay:5.0];
    [self performSelector:@selector(DeleteLayer:) withObject:bossNickName afterDelay:5.0];
    
    //会話へ
    [self performSelector:@selector(bossDramaTalk) withObject:nil afterDelay:5.5];

}

- (void)bossDramaTalk{
    
    _talkBackgroundLayer = [CALayer layer];
    _talkBackgroundLayer.frame = CGRectMake(10, self.view.frame.size.height -220 - 80, 300, 70);
    _talkBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    _talkBackgroundLayer.opacity = .2;
    [self.view.layer addSublayer:_talkBackgroundLayer];
    
    _nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextbtn.frame = CGRectMake(10, self.view.frame.size.height - 300, 300, 70);
    NSString *path = [[NSBundle mainBundle]pathForResource:@"none" ofType:@"png"];
    _nextbtn.imageView.image = [UIImage imageWithContentsOfFile:path];
    [self.view addSubview:_nextbtn];
    [_nextbtn addTarget:self action:@selector(dramaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _talk1 = [CATextLayer layer];
    _talk1.backgroundColor = [UIColor clearColor].CGColor;
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];

    if (stageValue == 0) {
        [_talk1 setString:@"アトラ『さっきから凄い死臭ね…』"];
    }else if(stageValue == 1){
        [_talk1 setString:@"マナ『ふふふっ…、\nアナタ、あの人に目がそっくり…』"];
    }else if(stageValue == 2){
        [_talk1 setString:@"ほむら『…』"];
    }else if(stageValue == 3){
        [_talk1 setString:@"塞『ふくくっ』"];
    }else if(stageValue == 4){
        [_talk1 setString:@"アイ『ここに近寄っては駄目。』"];
    }

    _talk1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _talk1.fontSize = 14;
    _talk1.foregroundColor = [UIColor whiteColor].CGColor;
    _talk1.frame = CGRectMake(15, self.view.frame.size.height -220 - 75, 300, 65);
    _talk1.alignmentMode = kCAAlignmentLeft;
    _talk1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_talk1];
    
    //ボタンのタップ回数を保存
    _tapTime = 0;
    
    [self tapHere];

}

- (void)tapHere{
    
    //TAP!の表示が発生
    CATextLayer *tapText = [CATextLayer layer];
    [tapText setString:@"TAP HERE"];
    tapText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    tapText.fontSize = 18;
    tapText.foregroundColor = [UIColor whiteColor].CGColor;
    tapText.frame = CGRectMake(0, 40, 285, 30);
    tapText.alignmentMode = kCAAlignmentRight;
    tapText.contentsScale = [UIScreen mainScreen].scale;
    [_talk1 addSublayer:tapText];
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anime.duration = .5;
    anime.autoreverses = YES;
    anime.fromValue = [NSNumber numberWithFloat:0];
    anime.toValue = [NSNumber numberWithFloat:1];
    anime.repeatCount = HUGE_VALF;
    [tapText addAnimation:anime forKey:@"opening"];
    
}

- (void)dramaButtonClicked:(UIButton*)button{
    
    _tapTime = _tapTime + 1;
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    int stageValue = [[delegate.playerPara valueForKey:@"currentStage"]intValue];

    if (stageValue == 0) {
    
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『そんなに臭いかな…？』"];
                break;
            case 2:
                [_talk1 setString:@"アトラ『そうね。この森のいきものを\n絶滅させる勢いで殺しまくってるからね。』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『あー、しょうがないのよ。。\nこのエリアにいる人間以外を排除するのが\n仕事だもの。』"];
                break;
            case 4:
                [_talk1 setString:@"アトラ『…？』"];
                break;
            case 5:
                [_talk1 setString:@"アトラ『一応私は人間のつもりなんだけど…\n私も”排除”されるのかな？』"];
                break;
            case 6:
                [_talk1 setString:@"ミリィ『えっとー…あなたの遺伝子構造を\n簡易スキャンしたけど』"];
                break;
            case 7:
                [_talk1 setString:@"ミリィ『一致率50%を切っちゃってるね。\nすごく残念。』"];
                break;
            case 8:
                [_talk1 setString:@"ミリィ『とても残念』"];
                break;
            case 9:
                [_talk1 setString:@"アトラ『ひどーい！\nこんなに可憐な女の子なのにー』"];
                break;
            case 10:
                [_talk1 setString:@"ミリィ『私の辞書には動くものを片っ端から\n溶かして食うのは人間って書いてないわ』"];
                break;
            case 11:
                [_talk1 setString:@"アトラ『あはは！見られちゃってたかー。。』"];
                [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
                break;
            case 12:
                [_talk1 setString:@"アトラ『じゃあこの森の主として！\n同胞を殺したアバズレに罰を与えなきゃ！』"];
                [self bgmPlay:@"mao03.mp3"];
                break;
            case 13:
                [_talk1 setString:@"ミリィ『人間のフリをするなよフリークス。\n丁寧に焼いて灰も残さないようにしたげる。』"];
                break;
            case 14:
                [self battleStart];
                [_talk1 removeFromSuperlayer];
                [_talkBackgroundLayer removeFromSuperlayer];
                [_nextbtn removeFromSuperview];
                
                [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
                
                break;
               
            default:
                break;
        }
        
    }else if(stageValue == 1){
        
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『いきなり気色悪い声あげないでよ。』"];
                break;
            case 2:
                [_talk1 setString:@"マナ『いいじゃない。ずっと待ってて暇なの。\n少し話し相手になってよ。』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『誰を待ってるの？』"];
                break;
            case 4:
                [_talk1 setString:@"マナ『恋人。でもぜーんぜん待ち合わせに\n来ないの。』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『ふーん。私なら10分遅刻したらもう\n帰るけど。で、次に会ったら蹴る。』"];
                break;
            case 6:
                [_talk1 setString:@"マナ『駄目よそんなの。愛があるなら』"];
                break;
            case 7:
                [_talk1 setString:@"ミリィ『どれだけ愛があろうと程度問題よ。\nバランスを失ってしまったら、奴隷契約に\nなりかねないんじゃない？』"];
                break;
            case 8:
                [_talk1 setString:@"マナ『奴隷になってもいいのよ。もともと\n自己満足なんだから。』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『へー…、じゃあ貴方はその愛しい人を\nどれくらい待ってるの？』"];
                break;
            case 10:
                [_talk1 setString:@"マナ『120年かしら。』"];
                [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
                break;
            case 11:
                [_talk1 setString:@"マナ『だから…、あの人が来るまで\nアタシの遊び相手になってよお！！』"];
                [self bgmPlay:@"mao03.mp3"];
                break;
            case 12:
                [_talk1 setString:@"ミリィ『哀れな女ね。』"];
                break;
            case 13:
                [self battleStart];
                [_talk1 removeFromSuperlayer];
                [_talkBackgroundLayer removeFromSuperlayer];
                [_nextbtn removeFromSuperview];
                
                [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
                break;
            default:
                break;
        }
    }else if(stageValue == 2){
        
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『？』"];
                break;
            case 2:
                [_talk1 setString:@"ほむら『汝、何故このようなことをする。』"];
                break;
            case 3:
                [_talk1 setString:@"ミリィ『今までと違ってコミュニケーションが\nまともにできるみたいね。』"];
                break;
            case 4:
                [_talk1 setString:@"ほむら『目的を問うている。』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『はいはい。この地域周辺の調査をして\n安全を確保したら、復興事業を行いたいの。』"];
                break;
            case 6:
                [_talk1 setString:@"ミリィ『混沌に秩序をもたらしたいのよ。』"];
                break;
            case 7:
                [_talk1 setString:@"ほむら『ここには秩序はある。汝が言っている\nのは一方面からの善の強制であろう。』"];
                break;
            case 8:
                [_talk1 setString:@"ミリィ『んー、あんまり否定できないわね。』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『ただ私達が悪ってわけでもないのよ。\nヒトとして世界を再生したいの。』"];
                break;
            case 10:
                [_talk1 setString:@"ほむら『最早この世界に人などおらぬ。化外の\n者達の世よ。』"];
                break;
            case 11:
                [_talk1 setString:@"ほむら『この世界の在り様の全てが世界そのも\nのを示す。徒な改変こそ悪なり。』"];
                break;
            case 12:
                [_talk1 setString:@"ミリィ『ふー…、やっぱり平行線ね…。仮に\n行いが悪だったとしても、それでもヒトは前に\n進まなきゃいけない種なのよ。』"];
                break;
            case 13:
                [_talk1 setString:@"ほむら『汝は理解しているのであろう？\n行いが無為であることを。』"];
                break;
            case 14:
                [_talk1 setString:@"ミリィ『例え無為だったとしてもよ。私はこの\n世界に借りがあるの。何かしなきゃいけない\n立場なのよ。』"];
                break;
            case 15:
                [_talk1 setString:@"ほむら『呆なり。』"];
                break;
            case 16:
                [_talk1 setString:@"ほむら『魯鈍なり。』"];
                break;
            case 17:
                [_talk1 setString:@"ほむら『愚劣なり。』"];
                break;
            case 18:
                [_talk1 setString:@"ほむら『死をもて誅す。』"];
                break;
            case 19:
                [_talk1 setString:@"ミリィ『…』"];
                break;
            case 20:
                [_talk1 setString:@"ミリィ『やってみなよ。』"];
                break;
            case 21:
                [self battleStart];
                [_talk1 removeFromSuperlayer];
                [_talkBackgroundLayer removeFromSuperlayer];
                [_nextbtn removeFromSuperview];
                
                [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
                break;
            default:
                break;
        }
    }else if(stageValue == 3){
        
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"塞『きれぇな…カオ…』"];
                break;
            case 2:
                [_talk1 setString:@"ミリィ『くくっ』"];
                break;
            case 3:
                [_talk1 setString:@"塞『ほしぃ…なぁ…』"];
                break;
            case 4:
                [_talk1 setString:@"ミリィ『あはは！』"];
                break;
            case 5:
                [_talk1 setString:@"塞『………なに？』"];
                break;
            case 6:
                [_talk1 setString:@"ミリィ『あっとゴメンね。』"];
                break;
            case 7:
                [_talk1 setString:@"ミリィ『ちょっと悩んでたのよ。自分のしてる\nこと間違ったかなーって。』"];
                break;
            case 8:
                [_talk1 setString:@"塞『？？』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『でも貴方を見てほっとした。』"];
                break;
            case 10:
                [_talk1 setString:@"ミリィ『貴方みたいなド外道を粉々にして\nこそ私よね。』"];
                break;
            case 11:
                [_talk1 setString:@"塞『！』"];
                break;
            case 12:
                [_talk1 setString:@"ミリィ『さて、ちょっと溜まったフラストレー\nションを解消しようかな！』"];
                break;
            case 13:
                [_talk1 setString:@"塞『！！』"];
                break;
            case 14:
                [_talk1 setString:@"ミリィ『あ、痛かったら言ってね。でも手心\nなんか加えないけど。』"];
                break;
            case 15:
                [_talk1 setString:@"塞『…』"];
                [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
                break;
            case 16:
                [_talk1 setString:@"塞『……』"];
                break;
            case 17:
                [_talk1 setString:@"塞『…………ひどい。』"];
                [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"bossMusic03.mp3"];
                
                break;
            case 18:
                [self battleStart];
                [_talk1 removeFromSuperlayer];
                [_talkBackgroundLayer removeFromSuperlayer];
                [_nextbtn removeFromSuperview];
                
                [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
                break;
            default:
                break;
        }
    }else if(stageValue == 4){
        
        switch (_tapTime) {
            case 1:
                [_talk1 setString:@"ミリィ『見たとこすごくまともなヒトっぽい。\nやっとまともなヒトに会えたのかな。』"];
                break;
            case 2:
                [_talk1 setString:@"アイ『貴方が力のある者だとわかります。』"];
                break;
            case 3:
                [_talk1 setString:@"アイ『だからお願い。これ以上この建物に\n近づいては駄目。』"];
                break;
            case 4:
                [_talk1 setString:@"ミリィ『？？』"];
                break;
            case 5:
                [_talk1 setString:@"ミリィ『多分この異常な空の理由を知ってる\nわね。教えてくれない？』"];
                break;
            case 6:
                [_talk1 setString:@"アイ『…いいでしょう。理由がわからずには\n帰れない人のようですから。』"];
                break;
            case 7:
                [_talk1 setString:@"アイ『この建物の上層で何かが生まれました。\nとても力のある何かです。』"];
                break;
            case 8:
                [_talk1 setString:@"アイ『そしてその何かは生まれたばかりで、\n力の制御ができていません。』"];
                break;
            case 9:
                [_talk1 setString:@"ミリィ『…ちょっと待って！生まれたての力の\n奔流でこの異常現象？』"];
                break;
            case 10:
                [_talk1 setString:@"アイ『そうです。』"];
                break;
            case 11:
                [_talk1 setString:@"ミリィ『わぉ…、単純な好奇心からしても\nすごくそそられる。』"];
                break;
            case 12:
                [_talk1 setString:@"アイ『悪い予感がします…。貴方は前へ進む\nつもりですね？』"];
                break;
            case 13:
                [_talk1 setString:@"ミリィ『そう。』"];
                break;
            case 14:
                [_talk1 setString:@"アイ『私は生まれた何かに対して保護をする\nつとめがあります。止めてください。』"];
                break;
            case 15:
                [_talk1 setString:@"ミリィ『断るわ。』"];
                break;
            case 16:
                [_talk1 setString:@"アイ『では力づくで、、ですね。』"];
                break;
            case 17:
                [_talk1 setString:@"ミリィ『別の出会い方なら友達になれそう\nなのに残念。』"];
                break;
            case 18:
                [_talk1 setString:@"アイ『友達になれますよ。戦った後に貴方が\n生きていれば。』"];
                break;
            case 19:
                [_talk1 setString:@"ミリィ『へー、まるで勝つのは自分みたいな\n言い草ね。』"];
                break;
            case 20:
                [_talk1 setString:@"アイ『気に障りましたか？』"];
                break;
            case 21:
                [_talk1 setString:@"ミリィ『全然。だって貴方の方が酷い目に合う\nんだもの。』"];
                [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
                break;
            case 22:
                [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"bgm_maoudamashii_neorock33.mp3"];
                [self battleStart];
                [_talk1 removeFromSuperlayer];
                [_talkBackgroundLayer removeFromSuperlayer];
                [_nextbtn removeFromSuperview];
                
                [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
                break;
            default:
                break;
        }
    }



    
}

#pragma mark - BATTLE
- (void)battleStart{
    
    BattleAlertViewController *battleAlert = [[BattleAlertViewController alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil];
    battleAlert.tag = 4;
    [battleAlert show];
    
    
}



- (void)battleStarted{
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    [self battle];
    [self animationBattleTitle];
    [self millyAnimationChange];
    
    //フラグ初期化
    isShield = NO;
    isCurse = NO;
    isBarrier = NO;
    
    //ボタンの表記変更
    [self buttonAppearanceChange];
    
    [self buttonDisable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
    

    
}

- (void)FOEBatteleStarted{
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    [self battle];
    [self animationBattleTitle];
    [self millyAnimationChange];
    
    //フラグ初期化
    isShield = NO;
    isCurse = NO;
    isBarrier = NO;
    
    //ボタンの表記変更
    [self buttonAppearanceChange];
    
    [self buttonDisable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
    
}

- (void)bossBattleStarted{
    
    [self battle];
    [self animationBattleTitle];
    [self millyAnimationChange];
    
    //フラグ初期化
    isShield = NO;
    isCurse = NO;
    isBarrier = NO;
    
    //ボタンの表記変更
    [self buttonAppearanceChange];
    
    [self buttonDisable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
}

- (void)buttonAppearanceChange{
    
    //ボタン表記入れ替えスタート-----------------------------------------------------
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"skillList" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    //右下ボタン
    int value0 = [[delegate.playerSkillEquipedPlist objectAtIndex:0]intValue];
    
    NSString *str = [[arr valueForKey:@"iconName"] objectAtIndex:value0];
    [_btnGo setTitle:[NSString stringWithFormat:@"%@", str] forState:UIControlStateNormal];
    _btnGo.tag = value0;
    
    NSString *str1 = [[arr valueForKey:@"attribute"] objectAtIndex:value0];
    if ([str1 isEqualToString:@"fire"]) {
        _btnGo.backgroundColor = [UIColor redColor];
    }else if([str1 isEqualToString:@"freeze"]) {
        _btnGo.backgroundColor = [UIColor blueColor];
    }else if([str1 isEqualToString:@"physical"]) {
        _btnGo.backgroundColor = [UIColor grayColor];
    }else if([str1 isEqualToString:@"holy"]) {
        _btnGo.backgroundColor = [UIColor brownColor];
    }else if([str1 isEqualToString:@"physical"]) {
        _btnGo.backgroundColor = [UIColor grayColor];
    }else if([str1 isEqualToString:@"dark"]) {
        _btnGo.backgroundColor = [UIColor blackColor];
    }
    
    NSString *str2 = [[arr valueForKey:@"icontext1"] objectAtIndex:value0];
    [_btnGoOverTextLayer1 setString:[NSString stringWithFormat:@"%@", str2]];
    
    NSString *str3 = [[arr valueForKey:@"icontext2"] objectAtIndex:value0];
    [_btnGoOverTextLayer2 setString:[NSString stringWithFormat:@"%@", str3]];
    
    
    //左下ボタン
    int value1 = [[delegate.playerSkillEquipedPlist objectAtIndex:1]intValue];
    
    NSString *str4 = [[arr valueForKey:@"iconName"] objectAtIndex:value1];
    [_btnRest setTitle:[NSString stringWithFormat:@"%@", str4] forState:UIControlStateNormal];
    _btnRest.tag = value1;
    
    NSString *str5 = [[arr valueForKey:@"attribute"] objectAtIndex:value1];
    if ([str5 isEqualToString:@"fire"]) {
        _btnRest.backgroundColor = [UIColor redColor];
    }else if([str5 isEqualToString:@"freeze"]) {
        _btnRest.backgroundColor = [UIColor blueColor];
    }else if([str5 isEqualToString:@"physical"]) {
        _btnRest.backgroundColor = [UIColor grayColor];
    }else if([str5 isEqualToString:@"holy"]) {
        _btnRest.backgroundColor = [UIColor brownColor];
    }else if([str5 isEqualToString:@"physical"]) {
        _btnRest.backgroundColor = [UIColor grayColor];
    }else if([str5 isEqualToString:@"dark"]) {
        _btnRest.backgroundColor = [UIColor blackColor];
    }
    
    NSString *str6 = [[arr valueForKey:@"icontext1"] objectAtIndex:value1];
    [_btnRestOverTextLayer1 setString:[NSString stringWithFormat:@"%@", str6]];
    NSString *str7 = [[arr valueForKey:@"icontext2"] objectAtIndex:value1];
    [_btnRestOverTextLayer2 setString:[NSString stringWithFormat:@"%@", str7]];
    
    
    //右上ボタン
    int value2 = [[delegate.playerSkillEquipedPlist objectAtIndex:2]intValue];
    
    NSString *st1 = [[arr valueForKey:@"iconName"] objectAtIndex:value2];
    [_btnStatus setTitle:[NSString stringWithFormat:@"%@", st1] forState:UIControlStateNormal];
    _btnStatus.tag = value2;
    
    NSString *st2 = [[arr valueForKey:@"attribute"] objectAtIndex:value2];
    
    if ([st2 isEqualToString:@"fire"]) {
        _btnStatus.backgroundColor = [UIColor redColor];
    }else if([st2 isEqualToString:@"freeze"]) {
        _btnStatus.backgroundColor = [UIColor blueColor];
    }else if([st2 isEqualToString:@"physical"]) {
        _btnStatus.backgroundColor = [UIColor grayColor];
    }else if([st2 isEqualToString:@"holy"]) {
        _btnStatus.backgroundColor = [UIColor brownColor];
    }else if([st2 isEqualToString:@"physical"]) {
        _btnStatus.backgroundColor = [UIColor grayColor];
    }else if([st2 isEqualToString:@"dark"]) {
        _btnStatus.backgroundColor = [UIColor blackColor];
    }
    
    NSString *st3 = [[arr valueForKey:@"icontext1"] objectAtIndex:value2];
    [_btnStatusOverTextLayer1 setString:[NSString stringWithFormat:@"%@", st3]];
    NSString *st4 = [[arr valueForKey:@"icontext2"] objectAtIndex:value2];
    [_btnStatusOverTextLayer2 setString:[NSString stringWithFormat:@"%@", st4]];
    
    
    //左上ボタン
    int value3 = [[delegate.playerSkillEquipedPlist objectAtIndex:3]intValue];
    
    NSString *s1 = [[arr valueForKey:@"iconName"] objectAtIndex:value3];
    [_btnSave setTitle:[NSString stringWithFormat:@"%@", s1] forState:UIControlStateNormal];
    _btnSave.tag = value3;
    
    NSString *s2 = [[arr valueForKey:@"attribute"] objectAtIndex:value3];
    
    if ([s2 isEqualToString:@"fire"]) {
        _btnSave.backgroundColor = [UIColor redColor];
    }else if([s2 isEqualToString:@"freeze"]) {
        _btnSave.backgroundColor = [UIColor blueColor];
    }else if([s2 isEqualToString:@"physical"]) {
        _btnSave.backgroundColor = [UIColor grayColor];
    }else if([s2 isEqualToString:@"holy"]) {
        _btnSave.backgroundColor = [UIColor brownColor];
    }else if([s2 isEqualToString:@"physical"]) {
        _btnSave.backgroundColor = [UIColor grayColor];
    }else if([s2 isEqualToString:@"dark"]) {
        _btnSave.backgroundColor = [UIColor blackColor];
    }
    
    
    NSString *s3 = [[arr valueForKey:@"icontext1"] objectAtIndex:value3];
    [_btnSaveOverTextLayer1 setString:[NSString stringWithFormat:@"%@", s3]];
    NSString *s4 = [[arr valueForKey:@"icontext2"] objectAtIndex:value3];
    [_btnSaveOverTextLayer2 setString:[NSString stringWithFormat:@"%@", s4]];
    
    //入れ替えここまで---------------------------------------------------------------
    
    //選択するよ！
    [_btnGo addTarget:self action:@selector(pushedButtonNumber0:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRest addTarget:self action:@selector(pushedButtonNumber1:) forControlEvents:UIControlEventTouchUpInside];
    [_btnStatus addTarget:self action:@selector(pushedButtonNumber2:) forControlEvents:UIControlEventTouchUpInside];
    [_btnSave addTarget:self action:@selector(pushedButtonNumber3:) forControlEvents:UIControlEventTouchUpInside];
    
}

//戦闘開始時のタイトル---------------------------------------------------------------
- (void)animationBattleTitle{
    
    CALayer *dummyLayer = [CALayer layer];
    dummyLayer.frame = CGRectMake(0, -60, 320, 60);
    NSString *path = [[NSBundle mainBundle]pathForResource:@"none" ofType:@"png"];
    dummyLayer.contents = (id)[UIImage imageWithContentsOfFile:path].CGImage;
    [self.view.layer addSublayer:dummyLayer];
    
    CALayer *BattleStartTitleBackground = [CALayer layer];
    BattleStartTitleBackground.backgroundColor = [UIColor blackColor].CGColor;
    BattleStartTitleBackground.opacity = .5;
    BattleStartTitleBackground.frame = CGRectMake(0, 0, 320, 60);
    [dummyLayer addSublayer:BattleStartTitleBackground];
    
    CATextLayer *BattleStartTitle = [CATextLayer layer];
    [BattleStartTitle setString:@"KICK THE FATES!"];
    BattleStartTitle.frame = CGRectMake(0, 5, 320, 55);
    BattleStartTitle.foregroundColor = [UIColor whiteColor].CGColor;
    BattleStartTitle.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    BattleStartTitle.fontSize = 40;
    BattleStartTitle.opacity = 1;
    BattleStartTitle.alignmentMode = kCAAlignmentCenter;
    BattleStartTitle.contentsScale = [UIScreen mainScreen].scale;
    [dummyLayer addSublayer:BattleStartTitle];
    
    [self performSelector:@selector(battleTitleAnimation:) withObject:dummyLayer afterDelay:.1];

}

- (void)battleTitleAnimation:(CALayer*)layer{
      
    [CATransaction begin];
    [CATransaction setAnimationDuration:.3];
    layer.frame = CGRectMake(0, (self.view.layer.frame.size.height -220)/2+5, 320, 60);

    [CATransaction setCompletionBlock:^{

        [self performSelector:@selector(battleTitleAnimationMoveOut:) withObject:layer afterDelay:.4];

    }];

    [CATransaction commit];
    
}

- (void)battleTitleAnimationMoveOut:(CALayer*)layer{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:.8];
    layer.frame = CGRectMake(0, 1300, 320, 60);
    
    [CATransaction setCompletionBlock:^{
        [self performSelector:@selector(DeleteLayer:) withObject:layer afterDelay:.9];
        [self buttonEnable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
        
        }];
    
    [CATransaction commit];

}
     
- (void)DeleteLayer:(CALayer*)layer{
    
    [layer removeFromSuperlayer];
    
}

//戦闘開始時のタイトルここまで---------------------------------------------------------------


- (void)buttonDisable:(NSArray*)arr{
    
    for (id obj in arr) {
        
        if ([obj intValue] == 1 ) {
            _btnGo.enabled = NO;
        }else if([obj intValue] == 2){
            _btnRest.enabled = NO;
        }else if([obj intValue]== 3){
            _btnStatus.enabled = NO;
        }else if([obj intValue] == 4){
            _btnSave.enabled = NO;
        }
    }
    
}

- (void)buttonEnable:(NSArray*)arr{
    
    for (id obj in arr) {
        
        if ([obj intValue] == 1 ) {
            _btnGo.enabled = YES;
        }else if([obj intValue] == 2){
            _btnRest.enabled = YES;
        }else if([obj intValue]== 3){
            _btnStatus.enabled = YES;
        }else if([obj intValue] == 4){
            _btnSave.enabled = YES;
        }
    
    }
    
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



#pragma mark - iAD
// iAD ------------------------------------------------
// 新しい広告がロードされた後に呼ばれる
// 非表示中のバナービューを表示する
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	if (!bannerIsVisible) {
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		[UIView setAnimationDuration:0.3];
        
#ifdef DISP_AD_BOTTOM
		
        banner.frame = CGRectOffset(banner.frame, 0, -CGRectGetHeight(banner.frame));

#else
		banner.frame = CGRectOffset(banner.frame, 0, CGRectGetHeight(banner.frame));
        
#endif
        banner.alpha = 1.0;        
		[UIView commitAnimations];
		bannerIsVisible = YES;
	}
}

// 広告バナータップ後に広告画面切り替わる前に呼ばれる
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	BOOL shoudExecuteAction = YES; // 広告画面に切り替える場合はYES（通常はYESを指定する）
	if (!willLeave && shoudExecuteAction) {
		// 必要ならココに、広告と競合する可能性のある処理を一時停止する処理を記述する。
	}
	return shoudExecuteAction;
}

// 広告画面からの復帰時に呼ばれる
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    // 必要ならココに、一時停止していた処理を再開する処理を記述する。
}

// 表示中の広告が無効になった場合に呼ばれる
// 表示中のバナービューを非表示にする
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		[UIView setAnimationDuration:0.3];
        
#ifdef DISP_AD_BOTTOM
        banner.frame = CGRectOffset(banner.frame, 0, CGRectGetHeight(banner.frame));
#else
        banner.frame = CGRectOffset(banner.frame, 0, -CGRectGetHeight(banner.frame));
#endif
        banner.alpha = 0.0;
        
        [UIView commitAnimations];
        bannerIsVisible = NO;
    }
}
// ----------------------------------------------------

// アラートが表示される前に呼び出される
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    
    if(alertView.tag == 4){
        
        CGRect alertFrame = CGRectMake(0, 0, 320, 330);
        alertView.frame = alertFrame;
        
        // アラートの表示位置を設定(アラート表示サイズを変更すると位置がずれるため)
        CGPoint alertPoint = CGPointMake(160, self.view.frame.size.height / 2.0);
        alertView.center = alertPoint;
        
    }else if(alertView.tag == 5){
                
        CGRect alertFrame = CGRectMake(0, 0, 320, 330);
        alertView.frame = alertFrame;
        
        // アラートの表示位置を設定(アラート表示サイズを変更すると位置がずれるため)
        CGPoint alertPoint = CGPointMake(160, self.view.frame.size.height / 2.0);
        alertView.center = alertPoint;

        
    }else if(alertView.tag == 6){
        
        CGRect alertFrame = CGRectMake(0, 0, 320, 400);
        alertView.frame = alertFrame;
        
        // アラートの表示位置を設定(アラート表示サイズを変更すると位置がずれるため)
        CGPoint alertPoint = CGPointMake(160, self.view.frame.size.height / 2.0);
        alertView.center = alertPoint;
        
        
    }

    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
