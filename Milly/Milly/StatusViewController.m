//
//  StatusViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/05/29.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "StatusViewController.h"

@interface StatusViewController ()

{
    ADBannerView *adView;
    BOOL bannerIsVisible;
    BOOL fastViewFlag;
}


@property UIButton *skillbtn;
@property CATextLayer *skillText1;
@property CATextLayer *skillText2;

@property UIButton *equipbtn;
@property CATextLayer *equipText1;
@property CATextLayer *equipText2;

@property UIButton *btnPuchase;
@property CATextLayer *purchaseText1;
@property CATextLayer *purchaseText2;

@property UIButton *goBackbtn;
@property CATextLayer *goBackText1;
@property CATextLayer *goBackText2;

@property UIButton *savebtn;
@property CATextLayer *saveText1;
@property CATextLayer *saveText2;

@property UIButton *goLast;
@property CATextLayer *goLastText1;
@property CATextLayer *goLastText2;


@property NSArray *itemNamearr;
@property NSArray *itemPreNamearr;
@property NSArray *itemAfter1Namearr;
@property NSArray *itemAfter2Namearr;

@property int total;

@property (nonatomic, retain) MrdIconLoader* iconLoader;
@property (nonatomic, retain) MrdIconLoader* iconLoader2;



@end

@implementation StatusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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

    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    //音楽変更用に一時インスタンス保存
    _stageValueOld = [[delegate.playerPara valueForKey:@"currentStage"]intValue];

    
    //背景セット
    CALayer *backPortrait = [CALayer layer];
    backPortrait.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    
    if (self.view.frame.size.height == 460) {
        backPortrait.contents = (id)[UIImage imageNamed:@"milly02_640x920.png"].CGImage;
    }else{
        backPortrait.contents = (id)[UIImage imageNamed:@"milly02.png"].CGImage;
    }
    
    [self.view.layer addSublayer:backPortrait];
    [self.view.layer insertSublayer:backPortrait atIndex:0];
    
    CALayer *backLayerFilter = [CALayer layer];
    backLayerFilter.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    backLayerFilter.opacity = 0.7;
    backLayerFilter.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:backLayerFilter];
    [self.view.layer insertSublayer:backLayerFilter atIndex:1];

    [delegate.playerPara valueForKey:@"currentLife"];
    
    //ステータス表記
    UILabel *statLife = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 150, 30)];
    [statLife setText:[NSString stringWithFormat:@"LIFE : %05d / %05d", [[delegate.playerPara valueForKey:@"currentLife"]intValue],[[delegate.playerPara valueForKey:@"maxLife"]intValue]]];
    statLife.backgroundColor = [UIColor clearColor];
    [statLife setTextColor:[UIColor whiteColor]];
    [statLife setFont:[UIFont fontWithName:@"AmericanCaptain" size:17]];
    [self.view addSubview:statLife];
    
    UILabel *statLevel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 30)];
    [statLevel setText:[NSString stringWithFormat:@"LEVEL : %@", [delegate.playerPara valueForKey:@"level"]]];
    statLevel.backgroundColor = [UIColor clearColor];
    [statLevel setTextColor:[UIColor whiteColor]];
    [statLevel setFont:[UIFont fontWithName:@"AmericanCaptain" size:17]];
    [self.view addSubview:statLevel];
    
    UILabel *statEXP = [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 150, 30)];
    [statEXP setText:[NSString stringWithFormat:@"EXP : %03d" ,[[delegate.playerPara valueForKey:@"exp"]intValue]]];
    statEXP.backgroundColor = [UIColor clearColor];
    [statEXP setTextColor:[UIColor whiteColor]];
    [statEXP setFont:[UIFont fontWithName:@"AmericanCaptain" size:17]];
    [self.view addSubview:statEXP];

    
    //itemのplist３種読み込み
    NSString* filePath0 = [[NSBundle mainBundle] pathForResource:@"itemName" ofType:@"plist"];
    _itemNamearr = [[NSArray alloc] initWithContentsOfFile:filePath0];
    NSString* filePath1 = [[NSBundle mainBundle] pathForResource:@"itemPreName" ofType:@"plist"];
    _itemPreNamearr = [[NSArray alloc] initWithContentsOfFile:filePath1];
    NSString* filePath2 = [[NSBundle mainBundle] pathForResource:@"itemAfter1Name" ofType:@"plist"];
    _itemAfter1Namearr = [[NSArray alloc] initWithContentsOfFile:filePath2];
    NSString* filePath3 = [[NSBundle mainBundle] pathForResource:@"itemAfter2Name" ofType:@"plist"];
    _itemAfter2Namearr = [[NSArray alloc] initWithContentsOfFile:filePath3];


    //装備表記
        
    
    //装備している所持アイテムID
    NSInteger num = [[delegate.playerItem valueForKey:@"equip"]indexOfObject:[NSNumber numberWithInteger:1]];
    //それぞれのマジックネームID呼び出し
    int itemIDCall = [[[delegate.playerItem objectAtIndex:num]valueForKey:@"name"]intValue];
    int itemPreIDCall = [[[delegate.playerItem objectAtIndex:num]valueForKey:@"pre"]intValue];
    int itemAfter1IDCall = [[[delegate.playerItem objectAtIndex:num]valueForKey:@"after1"]intValue];
    int itemAfter2IDCall = [[[delegate.playerItem objectAtIndex:num]valueForKey:@"after2"]intValue];
    
    UILabel *statWeapon = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 250, 30)];
    statWeapon.text = [NSString stringWithFormat:@"装備１ : %@%@%@%@",[[_itemPreNamearr objectAtIndex:itemPreIDCall]valueForKey:@"preName"] ,[[_itemNamearr objectAtIndex:itemIDCall]valueForKey:@"itemName"],[[_itemAfter1Namearr objectAtIndex:itemAfter1IDCall]valueForKey:@"afterName"],[[_itemAfter2Namearr objectAtIndex:itemAfter2IDCall]valueForKey:@"afterName"]];
    
    statWeapon.backgroundColor = [UIColor clearColor];
    [statWeapon setTextColor:[UIColor whiteColor]];
    [statWeapon setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statWeapon];
    
    
    UILabel *statArmor1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 250, 30)];
    
    //装備している所持アイテムID
    NSInteger integ2 = [[delegate.playerItem valueForKey:@"equip"]indexOfObject:[NSNumber numberWithInteger:2]];
    //それぞれのマジックネームID呼び出し
    int itemIDCall2 = [[[delegate.playerItem objectAtIndex:integ2]valueForKey:@"name"]intValue];
    int itemPreIDCall2 = [[[delegate.playerItem objectAtIndex:integ2]valueForKey:@"pre"]intValue];
    int itemAfter1IDCall2 = [[[delegate.playerItem objectAtIndex:integ2]valueForKey:@"after1"]intValue];
    int itemAfter2IDCall2 = [[[delegate.playerItem objectAtIndex:integ2]valueForKey:@"after2"]intValue];
    
    statArmor1.text = [NSString stringWithFormat:@"装備２ : %@%@%@%@",[[_itemPreNamearr objectAtIndex:itemPreIDCall2]valueForKey:@"preName"] ,[[_itemNamearr objectAtIndex:itemIDCall2]valueForKey:@"itemName"],[[_itemAfter1Namearr objectAtIndex:itemAfter1IDCall2]valueForKey:@"afterName"],[[_itemAfter2Namearr objectAtIndex:itemAfter2IDCall2]valueForKey:@"afterName"]];

    statArmor1.backgroundColor = [UIColor clearColor];
    [statArmor1 setTextColor:[UIColor whiteColor]];
    [statArmor1 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statArmor1];

    
    UILabel *statArmor2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 250, 30)];
    
    //装備している所持アイテムID
    NSInteger integ3 = [[delegate.playerItem valueForKey:@"equip"]indexOfObject:[NSNumber numberWithInteger:3]];
    //それぞれのマジックネームID呼び出し
    int itemIDCall3 = [[[delegate.playerItem objectAtIndex:integ3]valueForKey:@"name"]intValue];
    int itemPreIDCall3 = [[[delegate.playerItem objectAtIndex:integ3]valueForKey:@"pre"]intValue];
    int itemAfter1IDCall3 = [[[delegate.playerItem objectAtIndex:integ3]valueForKey:@"after1"]intValue];
    int itemAfter2IDCall3 = [[[delegate.playerItem objectAtIndex:integ3]valueForKey:@"after2"]intValue];
    
    statArmor2.text = [NSString stringWithFormat:@"装備３ : %@%@%@%@",[[_itemPreNamearr objectAtIndex:itemPreIDCall3]valueForKey:@"preName"] ,[[_itemNamearr objectAtIndex:itemIDCall3]valueForKey:@"itemName"],[[_itemAfter1Namearr objectAtIndex:itemAfter1IDCall3]valueForKey:@"afterName"],[[_itemAfter2Namearr objectAtIndex:itemAfter2IDCall3]valueForKey:@"afterName"]];
    
    statArmor2.backgroundColor = [UIColor clearColor];
    [statArmor2 setTextColor:[UIColor whiteColor]];
    [statArmor2 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statArmor2];
    
    UILabel *statArmor3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 250, 30)];
    
    //装備している所持アイテムID
    NSInteger integ4 = [[delegate.playerItem valueForKey:@"equip"]indexOfObject:[NSNumber numberWithInteger:4]];
    //それぞれのマジックネームID呼び出し
    int itemIDCall4 = [[[delegate.playerItem objectAtIndex:integ4]valueForKey:@"name"]intValue];
    int itemPreIDCall4 = [[[delegate.playerItem objectAtIndex:integ4]valueForKey:@"pre"]intValue];
    int itemAfter1IDCall4 = [[[delegate.playerItem objectAtIndex:integ4]valueForKey:@"after1"]intValue];
    int itemAfter2IDCall4 = [[[delegate.playerItem objectAtIndex:integ4]valueForKey:@"after2"]intValue];
    
    statArmor3.text = [NSString stringWithFormat:@"装備３ : %@%@%@%@",[[_itemPreNamearr objectAtIndex:itemPreIDCall4]valueForKey:@"preName"] ,[[_itemNamearr objectAtIndex:itemIDCall4]valueForKey:@"itemName"],[[_itemAfter1Namearr objectAtIndex:itemAfter1IDCall4]valueForKey:@"afterName"],[[_itemAfter2Namearr objectAtIndex:itemAfter2IDCall4]valueForKey:@"afterName"]];

    
    //[statArmor3 setText:@"装備４ : 無限の イヤリング +2"];
    statArmor3.backgroundColor = [UIColor clearColor];
    [statArmor3 setTextColor:[UIColor whiteColor]];
    [statArmor3 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statArmor3];
    
#pragma mark skill
    
    //スキル表記
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"skillList" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
        
    UILabel *statSkill1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, 310, 30)];
    
    int num0 = [[delegate.playerSkillEquipedPlist objectAtIndex:0] intValue];
    NSString *str0 = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:num0] valueForKey:@"icontext1"]];
    NSString *str1 = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:num0] valueForKey:@"icontext2"]];
    [statSkill1 setText:[NSString stringWithFormat:@"スキル1 : %@ LV%@ ディレイ%@秒",[str0 stringByAppendingString:str1],[delegate.playerSkillFirst objectAtIndex:num0],[[arr objectAtIndex:num0] valueForKey:@"delay"]]];
    
    statSkill1.backgroundColor = [UIColor clearColor];
    [statSkill1 setTextColor:[UIColor whiteColor]];
    [statSkill1 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statSkill1];
    
    
    UILabel *statSkill2 = [[UILabel alloc]initWithFrame:CGRectMake(10,100,310,30)];
    
    int num1 = [[delegate.playerSkillEquipedPlist objectAtIndex:1] intValue];
    NSString *str2 = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:num1] valueForKey:@"icontext1"]];
    NSString *str3 = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:num1] valueForKey:@"icontext2"]];
    [statSkill2 setText:[NSString stringWithFormat:@"スキル2 : %@ LV%@ ディレイ%@秒",[str2 stringByAppendingString:str3],[delegate.playerSkillFirst objectAtIndex:num1],[[arr objectAtIndex:num1] valueForKey:@"delay"]]];
    
    statSkill2.backgroundColor = [UIColor clearColor];
    [statSkill2 setTextColor:[UIColor whiteColor]];
    [statSkill2 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statSkill2];
    
    UILabel *statSkill3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 115, 310, 30)];
    
    int num2 = [[delegate.playerSkillEquipedPlist objectAtIndex:2] intValue];
    NSString *str4 = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:num2] valueForKey:@"icontext1"]];
    NSString *str5 = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:num2] valueForKey:@"icontext2"]];
    [statSkill3 setText:[NSString stringWithFormat:@"スキル3 : %@ LV%@ ディレイ%@秒",[str4 stringByAppendingString:str5],[delegate.playerSkillFirst objectAtIndex:num2],[[arr objectAtIndex:num2] valueForKey:@"delay"]]];
    
    statSkill3.backgroundColor = [UIColor clearColor];
    [statSkill3 setTextColor:[UIColor whiteColor]];
    [statSkill3 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statSkill3];
    
    UILabel *statSkill4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 130, 310, 30)];
    
    int num3 = [[delegate.playerSkillEquipedPlist objectAtIndex:3] intValue];
    NSString *str6 = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:num3] valueForKey:@"icontext1"]];
    NSString *str7 = [NSString stringWithFormat:@"%@", [[arr objectAtIndex:num3] valueForKey:@"icontext2"]];
    [statSkill4 setText:[NSString stringWithFormat:@"スキル4 : %@ LV%@ ディレイ%@秒",[str6 stringByAppendingString:str7],[delegate.playerSkillFirst objectAtIndex:num3],[[arr objectAtIndex:num3] valueForKey:@"delay"]]];
    
    statSkill4.backgroundColor = [UIColor clearColor];
    [statSkill4 setTextColor:[UIColor whiteColor]];
    [statSkill4 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statSkill4];

#pragma mark para
    
    //耐性やら特殊能力の表記
    
    UILabel *statMagicPower = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 310, 30)];
    
    //別メソッドでトータルの値を出す
    [self returnTotalPower:@"baseAttack"];
    
    [statMagicPower setText:[NSString stringWithFormat:@"基礎魔導力 : %d", _total]];
    statMagicPower.backgroundColor = [UIColor clearColor];
    [statMagicPower setTextColor:[UIColor whiteColor]];
    [statMagicPower setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statMagicPower];

    
    
    UILabel *statMagicDefence = [[UILabel alloc]initWithFrame:CGRectMake(10, 165, 310, 30)];
    
    [self returnTotalPower:@"baseDefence"];
    
    [statMagicDefence setText:[NSString stringWithFormat:@"防壁展開力 : %d", _total]];
    statMagicDefence.backgroundColor = [UIColor clearColor];
    [statMagicDefence setTextColor:[UIColor whiteColor]];
    [statMagicDefence setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statMagicDefence];
    
    UILabel *statCritical = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, 310, 30)];
     [self returnTotalPower:@"critical"];
    [statCritical setText:[NSString stringWithFormat:@"クリティカル率 : %d％", _total]];
    statCritical.backgroundColor = [UIColor clearColor];
    [statCritical setTextColor:[UIColor whiteColor]];
    [statCritical setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statCritical];
    
    UILabel *statAvoid = [[UILabel alloc]initWithFrame:CGRectMake(10, 195, 310, 30)];
    [self returnTotalPower:@"avoid"];
    [statAvoid setText:[NSString stringWithFormat:@"回避率 : %d％", _total]];
    statAvoid.backgroundColor = [UIColor clearColor];
    [statAvoid setTextColor:[UIColor whiteColor]];
    [statAvoid setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statAvoid];
    
    UILabel *statLeech = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, 310, 30)];
    [self returnTotalPower:@"leech"];
    [statLeech setText:[NSString stringWithFormat:@"吸収率 : %d％", _total]];
    statLeech.backgroundColor = [UIColor clearColor];
    [statLeech setTextColor:[UIColor whiteColor]];
    [statLeech setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statLeech];
    
    UILabel *statPhisical = [[UILabel alloc]initWithFrame:CGRectMake(160, 150, 310, 30)];
    [self returnTotalPower:@"physical"];
    [statPhisical setText:[NSString stringWithFormat:@"物理適正 : %d％", _total]];
    statPhisical.backgroundColor = [UIColor clearColor];
    [statPhisical setTextColor:[UIColor whiteColor]];
    [statPhisical setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statPhisical];

    UILabel *statFreeze = [[UILabel alloc]initWithFrame:CGRectMake(160, 165, 310, 30)];
    [self returnTotalPower:@"fire"];
    [statFreeze setText:[NSString stringWithFormat:@"炎熱適正 : %d％", _total]];
    statFreeze.backgroundColor = [UIColor clearColor];
    [statFreeze setTextColor:[UIColor whiteColor]];
    [statFreeze setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statFreeze];

    UILabel *statFrame = [[UILabel alloc]initWithFrame:CGRectMake(160, 180, 310, 30)];
    [self returnTotalPower:@"freeze"];
    [statFrame setText:[NSString stringWithFormat:@"氷結適正 : %d％", _total]];
    statFrame.backgroundColor = [UIColor clearColor];
    [statFrame setTextColor:[UIColor whiteColor]];
    [statFrame setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statFrame];

    UILabel *statThunder = [[UILabel alloc]initWithFrame:CGRectMake(160, 195, 310, 30)];
    [self returnTotalPower:@"holy"];
    [statThunder setText:[NSString stringWithFormat:@"聖光適正 : %d％", _total]];
    statThunder.backgroundColor = [UIColor clearColor];
    [statThunder setTextColor:[UIColor whiteColor]];
    [statThunder setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statThunder];

    UILabel *statAutoHeal = [[UILabel alloc]initWithFrame:CGRectMake(160, 210, 310, 30)];
    [self returnTotalPower:@"dark"];
    [statAutoHeal setText:[NSString stringWithFormat:@"暗黒適正 : %d％", _total]];
    statAutoHeal.backgroundColor = [UIColor clearColor];
    [statAutoHeal setTextColor:[UIColor whiteColor]];
    [statAutoHeal setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    [self.view addSubview:statAutoHeal];

    
    //スキルボタン
    _skillbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _skillbtn.frame = CGRectMake(242, self.view.frame.size.height - 130, 70, 70);
    [_skillbtn setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_skillbtn setTitle:@"魔導" forState:UIControlStateNormal];
    [_skillbtn.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_skillbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_skillbtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_skillbtn setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_skillbtn];
    
    [_skillbtn addTarget:self action:@selector(skillbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnGoTextBackgroundLayer = [CALayer layer];
    btnGoTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnGoTextBackgroundLayer.opacity = 0.5;
    btnGoTextBackgroundLayer.frame = CGRectMake(242, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnGoTextBackgroundLayer];
    
    _skillText1 = [CATextLayer layer];
    _skillText1.backgroundColor = [UIColor clearColor].CGColor;
    [_skillText1 setString:@"戦略が"];
    _skillText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _skillText1.fontSize = 10;
    _skillText1.foregroundColor = [UIColor whiteColor].CGColor;
    _skillText1.frame = CGRectMake(245, self.view.frame.size.height - 85, 70, 70);
    _skillText1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_skillText1];
    
    _skillText2 = [CATextLayer layer];
    _skillText2.backgroundColor = [UIColor clearColor].CGColor;
    [_skillText2 setString:@"勝敗になる"];
    _skillText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _skillText2.fontSize = 10;
    _skillText2.foregroundColor = [UIColor whiteColor].CGColor;
    _skillText2.frame = CGRectMake(247, self.view.frame.size.height - 74, 70, 70);
    _skillText2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_skillText2];
    
    //装備ボタン
    _equipbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _equipbtn.frame = CGRectMake(164, self.view.frame.size.height - 130, 70, 70);
    [_equipbtn setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_equipbtn setTitle:@"装備" forState:UIControlStateNormal];
    [_equipbtn.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_equipbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_equipbtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_equipbtn setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_equipbtn];
    
    [_equipbtn addTarget:self action:@selector(equipbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnRestTextBackgroundLayer = [CALayer layer];
    btnRestTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnRestTextBackgroundLayer.opacity = 0.5;
    btnRestTextBackgroundLayer.frame = CGRectMake(164, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnRestTextBackgroundLayer];
    
    _equipText1 = [CATextLayer layer];
    _equipText1.backgroundColor = [UIColor clearColor].CGColor;
    [_equipText1 setString:@"きちんと"];
    _equipText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _equipText1.fontSize = 10;
    _equipText1.foregroundColor = [UIColor whiteColor].CGColor;
    _equipText1.frame = CGRectMake(169, self.view.frame.size.height - 85, 70, 70);
    _equipText1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_equipText1];
    
    _equipText2 = [CATextLayer layer];
    _equipText2.backgroundColor = [UIColor clearColor].CGColor;
    [_equipText2 setString:@"準備してる？"];
    _equipText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _equipText2.fontSize = 10;
    _equipText2.foregroundColor = [UIColor whiteColor].CGColor;
    _equipText2.frame = CGRectMake(169, self.view.frame.size.height - 74, 70, 70);
    _equipText2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_equipText2];
    
    
    //課金ボタン
    _btnPuchase = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnPuchase.frame = CGRectMake(242, self.view.frame.size.height - 210, 70, 70);
    [_btnPuchase setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnPuchase setTitle:@"評価" forState:UIControlStateNormal];
    [_btnPuchase.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnPuchase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnPuchase setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnPuchase setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnPuchase];
    
    [_btnPuchase addTarget:self action:@selector(postReview) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *puchaseTextBackgroundLayer = [CALayer layer];
    puchaseTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    puchaseTextBackgroundLayer.opacity = 0.5;
    puchaseTextBackgroundLayer.frame = CGRectMake(242, self.view.frame.size.height - 170, 70, 30);
    [self.view.layer addSublayer:puchaseTextBackgroundLayer];
    
    _purchaseText1 = [CATextLayer layer];
    _purchaseText1.backgroundColor = [UIColor clearColor].CGColor;
    [_purchaseText1 setString:@"レビューを"];
    _purchaseText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _purchaseText1.fontSize = 10;
    _purchaseText1.foregroundColor = [UIColor whiteColor].CGColor;
    _purchaseText1.frame = CGRectMake(249, self.view.frame.size.height - 165, 70, 70);
    _purchaseText1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_purchaseText1];
    
    _purchaseText2 = [CATextLayer layer];
    _purchaseText2.backgroundColor = [UIColor clearColor].CGColor;
    [_purchaseText2 setString:@"投稿する"];
    _purchaseText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _purchaseText2.fontSize = 10;
    _purchaseText2.foregroundColor = [UIColor whiteColor].CGColor;
    _purchaseText2.frame = CGRectMake(249, self.view.frame.size.height - 154, 70, 70);
    _purchaseText2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_purchaseText2];

    
//    //セーブボタン
//    _savebtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _savebtn.frame = CGRectMake(242, self.view.frame.size.height - 210, 70, 70);
//    [_savebtn setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
//    [_savebtn setTitle:@"保存" forState:UIControlStateNormal];
//    [_savebtn.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
//    [_savebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_savebtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [_savebtn setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
//    [self.view addSubview:_savebtn];
//    
//    [_savebtn addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    CALayer *btnSaveTextBackgroundLayer = [CALayer layer];
//    btnSaveTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
//    btnSaveTextBackgroundLayer.opacity = 0.5;
//    btnSaveTextBackgroundLayer.frame = CGRectMake(242, self.view.frame.size.height - 170, 70, 30);
//    [self.view.layer addSublayer:btnSaveTextBackgroundLayer];
//    
//    _saveText1 = [CATextLayer layer];
//    _saveText1.backgroundColor = [UIColor clearColor].CGColor;
//    [_saveText1 setString:@"こまめに"];
//    _saveText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
//    _saveText1.fontSize = 10;
//    _saveText1.foregroundColor = [UIColor whiteColor].CGColor;
//    _saveText1.frame = CGRectMake(249, self.view.frame.size.height - 165, 70, 70);
//    _saveText1.contentsScale = [UIScreen mainScreen].scale;
//    [self.view.layer addSublayer:_saveText1];
//    
//    _saveText2 = [CATextLayer layer];
//    _saveText2.backgroundColor = [UIColor clearColor].CGColor;
//    [_saveText2 setString:@"忘れずに"];
//    _saveText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
//    _saveText2.fontSize = 10;
//    _saveText2.foregroundColor = [UIColor whiteColor].CGColor;
//    _saveText2.frame = CGRectMake(249, self.view.frame.size.height - 154, 70, 70);
//    _saveText2.contentsScale = [UIScreen mainScreen].scale;
//    [self.view.layer addSublayer:_saveText2];
    
    //広告！-------------------------------------------------------------
    MrdIconLoader* iconLoader = [[MrdIconLoader alloc]init]; // (1)
    [iconLoader startLoadWithMediaCode: @"id680098855"]; // (5)
    self.iconLoader = iconLoader;
    
    CGRect frame = CGRectMake(86,self.view.frame.size.height - 210,75,75);
    MrdIconCell* iconCell = [[MrdIconCell alloc]initWithFrame:frame]; // (2)
    [iconLoader addIconCell:iconCell];  // (3)
    
    CGRect frame2 = CGRectMake(8,self.view.frame.size.height - 210,75,75);
    MrdIconCell* iconCell2 = [[MrdIconCell alloc]initWithFrame:frame2]; // (2)
    [iconLoader addIconCell:iconCell2];  // (3)
    
    CGRect frame3 = CGRectMake(165,self.view.frame.size.height - 210,75,75);
    MrdIconCell* iconCell3 = [[MrdIconCell alloc]initWithFrame:frame3]; // (2)
    [iconLoader addIconCell:iconCell3];  // (3)


    [self.view addSubview:iconCell];  // (4)
    [self.view addSubview:iconCell2];  // (4)
    [self.view addSubview:iconCell3];
    //----------------------------------------------------------------------

    
    //移動ボタン
    _goLast = [UIButton buttonWithType:UIButtonTypeCustom];
    _goLast.frame = CGRectMake(86, self.view.frame.size.height - 130, 70, 70);
    [_goLast setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_goLast setTitle:@"転移" forState:UIControlStateNormal];
    [_goLast.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_goLast setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_goLast setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_goLast setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_goLast];
    
    [_goLast addTarget:self action:@selector(movingAreaStart) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnGoTextBackgroundLayer3 = [CALayer layer];
    btnGoTextBackgroundLayer3.backgroundColor = [UIColor blackColor].CGColor;
    btnGoTextBackgroundLayer3.opacity = 0.5;
    btnGoTextBackgroundLayer3.frame = CGRectMake(86, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnGoTextBackgroundLayer3];
    
    _goLastText1 = [CATextLayer layer];
    _goLastText1.backgroundColor = [UIColor clearColor].CGColor;
    [_goLastText1 setString:@"過去の戦場に"];
    _goLastText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _goLastText1.fontSize = 10;
    _goLastText1.foregroundColor = [UIColor whiteColor].CGColor;
    _goLastText1.frame = CGRectMake(91, self.view.frame.size.height - 85, 70, 70);
    _goLastText1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_goLastText1];
    
    _goLastText2 = [CATextLayer layer];
    _goLastText2.backgroundColor = [UIColor clearColor].CGColor;
    [_goLastText2 setString:@"飛ぶよ"];
    _goLastText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _goLastText2.fontSize = 10;
    _goLastText2.foregroundColor = [UIColor whiteColor].CGColor;
    _goLastText2.frame = CGRectMake(91, self.view.frame.size.height - 74, 70, 70);
    _goLastText2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_goLastText2];
    
    //戻るボタン
    _goBackbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goBackbtn.frame = CGRectMake(8, self.view.frame.size.height - 130, 70, 70);
    [_goBackbtn setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_goBackbtn setTitle:@"復帰" forState:UIControlStateNormal];
    [_goBackbtn.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_goBackbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_goBackbtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_goBackbtn setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_goBackbtn];
    
    [_goBackbtn addTarget:self action:@selector(goBackbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnStatusTextBackgroundLayer = [CALayer layer];
    btnStatusTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnStatusTextBackgroundLayer.opacity = 0.5;
    btnStatusTextBackgroundLayer.frame = CGRectMake(8, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnStatusTextBackgroundLayer];
    
    _goBackText1 = [CATextLayer layer];
    _goBackText1.backgroundColor = [UIColor clearColor].CGColor;
    [_goBackText1 setString:@"探索に"];
    _goBackText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _goBackText1.fontSize = 10;
    _goBackText1.foregroundColor = [UIColor whiteColor].CGColor;
    _goBackText1.frame = CGRectMake(13, self.view.frame.size.height - 85, 70, 70);
    _goBackText1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_goBackText1];
    
    _goBackText2 = [CATextLayer layer];
    _goBackText2.backgroundColor = [UIColor clearColor].CGColor;
    [_goBackText2 setString:@"戻る"];
    _goBackText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _goBackText2.fontSize = 10;
    _goBackText2.foregroundColor = [UIColor whiteColor].CGColor;
    _goBackText2.frame = CGRectMake(13, self.view.frame.size.height - 74, 70, 70);
    _goBackText2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_goBackText2];




    
    
}

- (void)equipbtnClicked:(UIButton*)button{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    MagicSetViewController *mycontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"equipment"];
    [self presentViewController:mycontroller animated:YES completion:nil];

}

- (void)skillbtnClicked:(UIButton*)button{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    MagicSetViewController *mycontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"MagicSet"];
    [self presentViewController:mycontroller animated:YES completion:nil];
    
}

- (void)saveButtonClicked:(UIButton*)button{
    
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

    //セーブしましたのメッセージ
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
    [equipMessage setString:[NSString stringWithFormat:@"ゲームデータを保存しました"]];
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


    
}

- (void)goBackbtnClicked:(UIButton*)button{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    _stageValueNew = [[delegate.playerPara valueForKey:@"currentStage"]intValue];
    
    if (_stageValueOld <= 2 && _stageValueNew >= 3 && [[delegate.playerPara valueForKey:@"prologe3"]intValue] == 0) {
        
        ViewController *view = [[ViewController alloc] initWithNibName:@"view" bundle:nil];
        [view bgmPlay:@"351.mp3"];
        
    }
    if (_stageValueOld >= 3 && _stageValueNew <= 2) {
        
        ViewController *view = [[ViewController alloc] initWithNibName:@"view" bundle:nil];
        [view bgmPlay:@"120.mp3"];
        
    }
    
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    ViewController *mycontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"main"];
    [self presentViewController:mycontroller animated:YES completion:nil];
    
}

- (void)returnTotalPower:(NSString*)string{
    
    
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
    int total1 = [[[_itemNamearr objectAtIndex:itemHaveNameID1]valueForKey:string]intValue];
    int total2 = [[[_itemPreNamearr objectAtIndex:itemHavePreNameID2]valueForKey:string]intValue];
    int total3 = [[[_itemAfter1Namearr objectAtIndex:itemHaveAfter1NameID3]valueForKey:string]intValue];
    int total4 = [[[_itemAfter2Namearr objectAtIndex:itemHaveAfter2NameID4]valueForKey:string]intValue];
    
    int total5 = [[[_itemNamearr objectAtIndex:itemHaveNameID5]valueForKey:string]intValue];
    int total6 = [[[_itemPreNamearr objectAtIndex:itemHavePreNameID6]valueForKey:string]intValue];
    int total7 = [[[_itemAfter1Namearr objectAtIndex:itemHaveAfter1NameID7]valueForKey:string]intValue];
    int total8 = [[[_itemAfter2Namearr objectAtIndex:itemHaveAfter2NameID8]valueForKey:string]intValue];
    
    int total9 = [[[_itemNamearr objectAtIndex:itemHaveNameID9]valueForKey:string]intValue];
    int total10 = [[[_itemPreNamearr objectAtIndex:itemHavePreNameID10]valueForKey:string]intValue];
    int total11 = [[[_itemAfter1Namearr objectAtIndex:itemHaveAfter1NameID11]valueForKey:string]intValue];
    int total12 = [[[_itemAfter2Namearr objectAtIndex:itemHaveAfter2NameID12]valueForKey:string]intValue];
    
    int total13 = [[[_itemNamearr objectAtIndex:itemHaveNameID13]valueForKey:string]intValue];
    int total14 = [[[_itemPreNamearr objectAtIndex:itemHavePreNameID14]valueForKey:string]intValue];
    int total15 = [[[_itemAfter1Namearr objectAtIndex:itemHaveAfter1NameID15]valueForKey:string]intValue];
    int total16 = [[[_itemAfter2Namearr objectAtIndex:itemHaveAfter2NameID16]valueForKey:string]intValue];
    
    _total = total1 + total2 + total3 + total4 + total5 + total6 + total7 + total8 + total9 + total10 + total11 + total12 + total13 + total14 + total15 + total16 + totalPara;

    
}

- (void)movingAreaStart{
    
    MovingAlertView *movingAlert = [[MovingAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil];

    [movingAlert show];
    
    
}

//転移からのメッセージ表示（プロトコル用）
- (void)moveMessageAppear{
    
    //転移しましたのメッセージ
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
    [equipMessage setString:[NSString stringWithFormat:@"転移完了"]];
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
    
}

- (void)postReview{
    
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/jp/app/maoto-mo-fato-gui-fangto/id680098855?mt=8"];
    [[UIApplication sharedApplication] openURL:url];
    
}


// アラートが表示される前に呼び出される
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    
           
        CGRect alertFrame = CGRectMake(0, 0, 320, 250);
        alertView.frame = alertFrame;
        
        // アラートの表示位置を設定(アラート表示サイズを変更すると位置がずれるため)
        CGPoint alertPoint = CGPointMake(160, self.view.frame.size.height / 2.0);
        alertView.center = alertPoint;
          
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
// --------------------------------------------------


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
