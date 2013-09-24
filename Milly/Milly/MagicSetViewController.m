//
//  MagicSetViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/05/30.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "MagicSetViewController.h"

@interface MagicSetViewController ()

{
    ADBannerView *adView;
    BOOL bannerIsVisible;
    BOOL fastViewFlag;
}


@property UILabel *skillNamelabel;
@property UILabel *skillLevelLabel;
@property UITableView *skillTableView;
@property UITableViewCell *cell;

@property UITableView *skillTable;


//ボタンシリーズ
@property UIButton *btnGo;
@property CALayer *btnGoTextBackgroundLayer;
@property CATextLayer *btnGoOverTextLayer1;
@property CATextLayer *btnGoOverTextLayer2;

@property UIButton *btnRest;
@property CATextLayer *btnRestOverTextLayer1;
@property CATextLayer *btnRestOverTextLayer2;
@property CALayer *btnRestTextBackgroundLayer;

@property UIButton *btnStatus;
@property CATextLayer *btnStatusOverTextLayer1;
@property CATextLayer *btnStatusOverTextLayer2;
@property CALayer *btnStatusTextBackgroundLayer;

@property UIButton *btnSave;
@property CATextLayer *btnSaveOverTextLayer1;
@property CATextLayer *btnSaveOverTextLayer2;
@property CALayer *btnSaveTextBackgroundLayer;


@property UIButton *goLast;
@property CATextLayer *goLastText1;
@property CATextLayer *goLastText2;

@property UIButton *goback;
@property CATextLayer *goBackText1;
@property CATextLayer *goBackText2;

@property UIButton *skillReset;
@property CATextLayer *skillResetText1;
@property CATextLayer *skillResetText2;

@property NSMutableArray *learnedSkillList;
@property NSArray *skillListLoadedArray;

//右カラム
@property UILabel *skillNameDetailLabel;
@property UILabel *skillDescriptionLabel;
@property UILabel *skillDamageLabel;
@property UILabel *skillDelayLabel;
@property UILabel *skillDamageUpLabel;
@property UILabel *skillCurrentDamageUpLabel;
@property UILabel *skillAttributeLabel;
@property UILabel *skillAttackTime;
@property UILabel *skillSPDescriptionLabel;

//スキル変更のため、一時値の保存
@property NSIndexPath *indexPathSkill;

//スキル成長フラグ
@property BOOL isSkillUp;

@property CATextLayer *skillPointTextLayer;

@property (nonatomic, retain) MrdIconLoader* iconLoader;
@property (nonatomic, retain) MrdIconLoader* iconLoader2;


@end

@implementation MagicSetViewController

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

    
    //いつもの
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    //フラグ初期か
    _isSkillUp = NO;

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
    
    //スキルポイントのこり
    
    
    _skillPointTextLayer = [CATextLayer layer];
    _skillPointTextLayer.backgroundColor = [UIColor clearColor].CGColor;
    [_skillPointTextLayer setString:[NSString stringWithFormat:@"SKILLPOINT:%@", [delegate.playerPara valueForKey:@"skillPoint"]]];
    _skillPointTextLayer.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    _skillPointTextLayer.fontSize = 16;
    _skillPointTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    _skillPointTextLayer.contentsScale = [UIScreen mainScreen].scale;
    _skillPointTextLayer.frame = CGRectMake(10, 0, 160, 20);
    
    //[_skillPointTextLayer removeFromSuperlayer];
    
    [self.view.layer addSublayer:_skillPointTextLayer];
    
    [self skillPointLabelUpdate];


    
    //テーブルセット
    _skillTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, 176, self.view.frame.size.height-235) style:UITableViewStylePlain];
    _skillTable.delegate = self;
    _skillTable.dataSource = self;
    [self.view addSubview:_skillTable];
    
    //skillListの読み込み
    NSString* path = [[NSBundle mainBundle] pathForResource:@"skillList" ofType:@"plist"];
    _skillListLoadedArray = [[NSArray alloc]initWithContentsOfFile:path];
    
    
    //スキルボタンの設定
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    int value0 = [[delegate.playerSkillEquipedPlist objectAtIndex:0]intValue];
    
    NSString *str = [[arr valueForKey:@"iconName"] objectAtIndex:value0];
    [_btnGo setTitle:[NSString stringWithFormat:@"%@", str] forState:UIControlStateNormal];

    
    //スキル１ボタン
    _btnGo = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnGo.frame = CGRectMake(242, self.view.frame.size.height - 130, 70, 70);
    
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
    
    NSString *str0 = [[arr valueForKey:@"iconName"] objectAtIndex:value0];
    [_btnGo setTitle:[NSString stringWithFormat:@"%@", str0] forState:UIControlStateNormal];
    [_btnGo.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnGo setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnGo setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnGo];
    
    [_btnGo addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnGoTextBackgroundLayer = [CALayer layer];
    _btnGoTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    _btnGoTextBackgroundLayer.opacity = 0.5;
    _btnGoTextBackgroundLayer.frame = CGRectMake(242, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:_btnGoTextBackgroundLayer];
    
    _btnGoOverTextLayer1 = [CATextLayer layer];
    _btnGoOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    NSString *str2 = [[arr valueForKey:@"icontext1"] objectAtIndex:value0];
    [_btnGoOverTextLayer1 setString:[NSString stringWithFormat:@"%@", str2]];
    _btnGoOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnGoOverTextLayer1.fontSize = 10;
    _btnGoOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnGoOverTextLayer1.frame = CGRectMake(247, self.view.frame.size.height - 85, 70, 70);
    _btnGoOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnGoOverTextLayer1];
    
    _btnGoOverTextLayer2 = [CATextLayer layer];
    _btnGoOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    NSString *str3 = [[arr valueForKey:@"icontext2"] objectAtIndex:value0];
    [_btnGoOverTextLayer2 setString:[NSString stringWithFormat:@"%@", str3]];
    _btnGoOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnGoOverTextLayer2.fontSize = 10;
    _btnGoOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnGoOverTextLayer2.frame = CGRectMake(247, self.view.frame.size.height - 74, 70, 70);
    _btnGoOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnGoOverTextLayer2];
    
    
    //スキル２ボタン
    int value1 = [[delegate.playerSkillEquipedPlist objectAtIndex:1]intValue];
    
    _btnRest = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRest.frame = CGRectMake(164, self.view.frame.size.height - 130, 70, 70);
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

    NSString *str4 = [[arr valueForKey:@"iconName"] objectAtIndex:value1];
    [_btnRest setTitle:[NSString stringWithFormat:@"%@", str4] forState:UIControlStateNormal];
    [_btnRest.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnRest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRest setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnRest setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnRest];
    
    [_btnRest addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnRestTextBackgroundLayer = [CALayer layer];
    _btnRestTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    _btnRestTextBackgroundLayer.opacity = 0.5;
    _btnRestTextBackgroundLayer.frame = CGRectMake(164, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:_btnRestTextBackgroundLayer];
    
    _btnRestOverTextLayer1 = [CATextLayer layer];
    _btnRestOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    NSString *str6 = [[arr valueForKey:@"icontext1"] objectAtIndex:value1];
    [_btnRestOverTextLayer1 setString:[NSString stringWithFormat:@"%@", str6]];
    _btnRestOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnRestOverTextLayer1.fontSize = 10;
    _btnRestOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnRestOverTextLayer1.frame = CGRectMake(169, self.view.frame.size.height - 85, 70, 70);
    _btnRestOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnRestOverTextLayer1];
    
    _btnRestOverTextLayer2 = [CATextLayer layer];
    _btnRestOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    NSString *str7 = [[arr valueForKey:@"icontext2"] objectAtIndex:value1];
    [_btnRestOverTextLayer2 setString:[NSString stringWithFormat:@"%@", str7]];
    _btnRestOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnRestOverTextLayer2.fontSize = 10;
    _btnRestOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnRestOverTextLayer2.frame = CGRectMake(169, self.view.frame.size.height - 74, 70, 70);
    _btnRestOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnRestOverTextLayer2];
    
    
    //スキル３ボタン
    int value2 = [[delegate.playerSkillEquipedPlist objectAtIndex:2]intValue];
    
    _btnStatus = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStatus.frame = CGRectMake(242, self.view.frame.size.height - 210, 70, 70);
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

    NSString *st1 = [[arr valueForKey:@"iconName"] objectAtIndex:value2];
    [_btnStatus setTitle:[NSString stringWithFormat:@"%@", st1] forState:UIControlStateNormal];
    [_btnStatus.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnStatus setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnStatus setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnStatus];
    
    [_btnStatus addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnStatusTextBackgroundLayer = [CALayer layer];
    _btnStatusTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    _btnStatusTextBackgroundLayer.opacity = 0.5;
    _btnStatusTextBackgroundLayer.frame = CGRectMake(242, self.view.frame.size.height - 170, 70, 30);
    [self.view.layer addSublayer:_btnStatusTextBackgroundLayer];
    
    _btnStatusOverTextLayer1 = [CATextLayer layer];
    _btnStatusOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    NSString *st3 = [[arr valueForKey:@"icontext1"] objectAtIndex:value2];
    [_btnStatusOverTextLayer1 setString:[NSString stringWithFormat:@"%@", st3]];
    _btnStatusOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer1.fontSize = 10;
    _btnStatusOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer1.frame = CGRectMake(247, self.view.frame.size.height - 165, 70, 70);
    _btnStatusOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnStatusOverTextLayer1];
    
    _btnStatusOverTextLayer2 = [CATextLayer layer];
    _btnStatusOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    NSString *st4 = [[arr valueForKey:@"icontext2"] objectAtIndex:value2];
    [_btnStatusOverTextLayer2 setString:[NSString stringWithFormat:@"%@", st4]];
    _btnStatusOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer2.fontSize = 10;
    _btnStatusOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer2.frame = CGRectMake(247, self.view.frame.size.height - 154, 70, 70);
    _btnStatusOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnStatusOverTextLayer2];
    
    
    //スキル４ボタン
    
    int value3 = [[delegate.playerSkillEquipedPlist objectAtIndex:3]intValue];
    
    _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSave.frame = CGRectMake(164, self.view.frame.size.height - 210, 70, 70);
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

    NSString *s1 = [[arr valueForKey:@"iconName"] objectAtIndex:value3];
    [_btnSave setTitle:[NSString stringWithFormat:@"%@", s1] forState:UIControlStateNormal];
    [_btnSave.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnSave setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnSave];
    
    [_btnSave addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnSaveTextBackgroundLayer = [CALayer layer];
    _btnSaveTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    _btnSaveTextBackgroundLayer.opacity = 0.5;
    _btnSaveTextBackgroundLayer.frame = CGRectMake(164, self.view.frame.size.height - 170, 70, 30);
    [self.view.layer addSublayer:_btnSaveTextBackgroundLayer];
    
    _btnSaveOverTextLayer1 = [CATextLayer layer];
    _btnSaveOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    NSString *s3 = [[arr valueForKey:@"icontext1"] objectAtIndex:value3];
    [_btnSaveOverTextLayer1 setString:[NSString stringWithFormat:@"%@", s3]];
    _btnSaveOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer1.fontSize = 10;
    _btnSaveOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer1.frame = CGRectMake(169, self.view.frame.size.height - 165, 70, 70);
    _btnSaveOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnSaveOverTextLayer1];
    
    _btnSaveOverTextLayer2 = [CATextLayer layer];
    _btnSaveOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    NSString *s4 = [[arr valueForKey:@"icontext2"] objectAtIndex:value3];
    [_btnSaveOverTextLayer2 setString:[NSString stringWithFormat:@"%@", s4]];
    _btnSaveOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer2.fontSize = 10;
    _btnSaveOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer2.frame = CGRectMake(169, self.view.frame.size.height - 154, 70, 70);
    _btnSaveOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnSaveOverTextLayer2];
    
    //スキル成長ボタン
    _goLast = [UIButton buttonWithType:UIButtonTypeCustom];
    _goLast.frame = CGRectMake(86, self.view.frame.size.height - 130, 70, 70);
    [_goLast setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_goLast setTitle:@"成長" forState:UIControlStateNormal];
    [_goLast.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_goLast setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_goLast setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_goLast setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_goLast];
    
    [_goLast addTarget:self action:@selector(skillupStart) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnGoTextBackgroundLayer3 = [CALayer layer];
    btnGoTextBackgroundLayer3.backgroundColor = [UIColor blackColor].CGColor;
    btnGoTextBackgroundLayer3.opacity = 0.5;
    btnGoTextBackgroundLayer3.frame = CGRectMake(86, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnGoTextBackgroundLayer3];
    
    _goLastText1 = [CATextLayer layer];
    _goLastText1.backgroundColor = [UIColor clearColor].CGColor;
    [_goLastText1 setString:@"育つじゃなく"];
    _goLastText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _goLastText1.fontSize = 10;
    _goLastText1.foregroundColor = [UIColor whiteColor].CGColor;
    _goLastText1.frame = CGRectMake(91, self.view.frame.size.height - 85, 70, 70);
    _goLastText1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_goLastText1];
    
    _goLastText2 = [CATextLayer layer];
    _goLastText2.backgroundColor = [UIColor clearColor].CGColor;
    [_goLastText2 setString:@"育てる"];
    _goLastText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _goLastText2.fontSize = 10;
    _goLastText2.foregroundColor = [UIColor whiteColor].CGColor;
    _goLastText2.frame = CGRectMake(91, self.view.frame.size.height - 74, 70, 70);
    _goLastText2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_goLastText2];
    
    //スキルリセットボタン
    _skillReset = [UIButton buttonWithType:UIButtonTypeCustom];
    _skillReset.frame = CGRectMake(86, self.view.frame.size.height - 210, 70, 70);
    [_skillReset setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_skillReset setTitle:@"再振" forState:UIControlStateNormal];
    [_skillReset.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_skillReset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_skillReset setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_skillReset setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_skillReset];
    
    [_skillReset addTarget:self action:@selector(skillResetStart) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnSkillResetBackgroundLayer3 = [CALayer layer];
    btnSkillResetBackgroundLayer3.backgroundColor = [UIColor blackColor].CGColor;
    btnSkillResetBackgroundLayer3.opacity = 0.5;
    btnSkillResetBackgroundLayer3.frame = CGRectMake(86, self.view.frame.size.height - 170, 70, 30);
    [self.view.layer addSublayer:btnSkillResetBackgroundLayer3];
    
    _skillResetText1 = [CATextLayer layer];
    _skillResetText1.backgroundColor = [UIColor clearColor].CGColor;
    [_skillResetText1 setString:@"いつでも"];
    _skillResetText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _skillResetText1.fontSize = 10;
    _skillResetText1.foregroundColor = [UIColor whiteColor].CGColor;
    _skillResetText1.frame = CGRectMake(91, self.view.frame.size.height - 165, 70, 70);
    _skillResetText1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_skillResetText1];
    
    _skillResetText2 = [CATextLayer layer];
    _skillResetText2.backgroundColor = [UIColor clearColor].CGColor;
    [_skillResetText2 setString:@"白紙に戻せる"];
    _skillResetText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _skillResetText2.fontSize = 10;
    _skillResetText2.foregroundColor = [UIColor whiteColor].CGColor;
    _skillResetText2.frame = CGRectMake(91, self.view.frame.size.height - 154, 70, 70);
    _skillResetText2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_skillResetText2];
    
    //広告
    MrdIconLoader* iconLoader = [[MrdIconLoader alloc]init]; // (1)
    [iconLoader startLoadWithMediaCode: @"id680098855"]; // (5)
    self.iconLoader = iconLoader;
    
    CGRect frame2 = CGRectMake(8,self.view.frame.size.height - 210,75,75);
    MrdIconCell* iconCell2 = [[MrdIconCell alloc]initWithFrame:frame2]; // (2)
    [iconLoader addIconCell:iconCell2];  // (3)
    
    [self.view addSubview:iconCell2];  // (4)
    
    //戻るボタン
    _goback = [UIButton buttonWithType:UIButtonTypeCustom];
    _goback.frame = CGRectMake(8, self.view.frame.size.height - 130, 70, 70);
    [_goback setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_goback setTitle:@"復帰" forState:UIControlStateNormal];
    [_goback.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_goback setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_goback setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_goback setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_goback];
    
    [_goback addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnGoTextBackgroundLayer4 = [CALayer layer];
    btnGoTextBackgroundLayer4.backgroundColor = [UIColor blackColor].CGColor;
    btnGoTextBackgroundLayer4.opacity = 0.5;
    btnGoTextBackgroundLayer4.frame = CGRectMake(8, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnGoTextBackgroundLayer4];
    
    _goBackText1 = [CATextLayer layer];
    _goBackText1.backgroundColor = [UIColor clearColor].CGColor;
    [_goBackText1 setString:@"状態を"];
    _goBackText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _goBackText1.fontSize = 10;
    _goBackText1.foregroundColor = [UIColor whiteColor].CGColor;
    _goBackText1.frame = CGRectMake(13, self.view.frame.size.height - 85, 70, 70);
    _goBackText1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_goBackText1];
    
    _goBackText2 = [CATextLayer layer];
    _goBackText2.backgroundColor = [UIColor clearColor].CGColor;
    [_goBackText2 setString:@"確認する"];
    _goBackText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _goBackText2.fontSize = 10;
    _goBackText2.foregroundColor = [UIColor whiteColor].CGColor;
    _goBackText2.frame = CGRectMake(13, self.view.frame.size.height - 74, 70, 70);
    _goBackText2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_goBackText2];
    
    //残りスキルポイントを表示

    
}

//ボタンクリック時の設定集


- (void)buttonClicked:(UIButton*)button{
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"go.mp3"];
    
    //ボタン変更処理の共通部分
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSMutableArray *changearr = [[NSMutableArray alloc]initWithArray:delegate.playerSkillEquipedPlist];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"skillList" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    int selectedRowSkillLevel = [[delegate.playerSkillFirst objectAtIndex:_indexPathSkill.row]intValue];
    
    
    //戻るボタン
    if (button == _goback) {
        
        [self performSegueWithIdentifier:@"MagicSetToStatus" sender:self];
    
    //スキルボタン1変更
    }else if(button == _btnGo && _indexPathSkill != nil && selectedRowSkillLevel != 0){
        
        //既にセットされてるスキルをはじく！
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:0]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:1]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:2]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:3]intValue]) {
            return;
        }
        
        
        [changearr removeObjectAtIndex:0];
        [changearr insertObject:[NSNumber numberWithInt:_indexPathSkill.row] atIndex:0];
        delegate.playerSkillEquipedPlist = [changearr copy];
        
        NSString *str0 = [[arr valueForKey:@"iconName"] objectAtIndex:_indexPathSkill.row];
        [_btnGo setTitle:[NSString stringWithFormat:@"%@", str0] forState:UIControlStateNormal];
        
        NSString *str1 = [[arr valueForKey:@"attribute"] objectAtIndex:_indexPathSkill.row];
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
        
        NSString *str2 = [[arr valueForKey:@"icontext1"] objectAtIndex:_indexPathSkill.row];
        [_btnGoOverTextLayer1 setString:[NSString stringWithFormat:@"%@", str2]];
        
        NSString *str3 = [[arr valueForKey:@"icontext2"] objectAtIndex:_indexPathSkill.row];
        [_btnGoOverTextLayer2 setString:[NSString stringWithFormat:@"%@", str3]];
       
        [_btnGo removeFromSuperview];
        [_btnGoOverTextLayer1 removeFromSuperlayer];
        [_btnGoOverTextLayer2 removeFromSuperlayer];
        [_btnGoTextBackgroundLayer removeFromSuperlayer];
        [self.view addSubview:_btnGo];
        [self.view.layer addSublayer:_btnGoTextBackgroundLayer];
        [self.view.layer addSublayer:_btnGoOverTextLayer1];
        [self.view.layer addSublayer:_btnGoOverTextLayer2];
        
        //変更内容を保存
        [self autoSave];
    
    //スキルボタン２変更
    }else if(button == _btnRest && _indexPathSkill != nil && selectedRowSkillLevel != 0){
        
        //既にセットされてるスキルをはじく！
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:0]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:1]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:2]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:3]intValue]) {
            return;
        }

    
        [changearr removeObjectAtIndex:1];
        [changearr insertObject:[NSNumber numberWithInt:_indexPathSkill.row] atIndex:1];
        delegate.playerSkillEquipedPlist = [changearr copy];
                
        NSString *str5 = [[arr valueForKey:@"attribute"] objectAtIndex:_indexPathSkill.row];
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
        NSString *str4 = [[arr valueForKey:@"iconName"] objectAtIndex:_indexPathSkill.row];
        [_btnRest setTitle:[NSString stringWithFormat:@"%@", str4] forState:UIControlStateNormal];
        NSString *str6 = [[arr valueForKey:@"icontext1"] objectAtIndex:_indexPathSkill.row];
        [_btnRestOverTextLayer1 setString:[NSString stringWithFormat:@"%@", str6]];
        NSString *str7 = [[arr valueForKey:@"icontext2"] objectAtIndex:_indexPathSkill.row];
        [_btnRestOverTextLayer2 setString:[NSString stringWithFormat:@"%@", str7]];
        
        [_btnRest removeFromSuperview];
        [_btnRestOverTextLayer1 removeFromSuperlayer];
        [_btnRestOverTextLayer2 removeFromSuperlayer];
        [_btnRestTextBackgroundLayer removeFromSuperlayer];
        [self.view addSubview:_btnRest];
        [self.view.layer addSublayer:_btnRestTextBackgroundLayer];
        [self.view.layer addSublayer:_btnRestOverTextLayer1];
        [self.view.layer addSublayer:_btnRestOverTextLayer2];
        
        [self autoSave];
        
    //スキルボタン3変更
    }else if(button == _btnStatus && _indexPathSkill != nil && selectedRowSkillLevel != 0){
        
        //既にセットされてるスキルをはじく！
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:0]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:1]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:2]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:3]intValue]) {
            return;
        }

        
        [changearr removeObjectAtIndex:2];
        [changearr insertObject:[NSNumber numberWithInt:_indexPathSkill.row] atIndex:2];
        delegate.playerSkillEquipedPlist = [changearr copy];
        
        NSString *st2 = [[arr valueForKey:@"attribute"] objectAtIndex:_indexPathSkill.row];
        
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
        NSString *st1 = [[arr valueForKey:@"iconName"] objectAtIndex:_indexPathSkill.row];
        [_btnStatus setTitle:[NSString stringWithFormat:@"%@", st1] forState:UIControlStateNormal];
        NSString *st3 = [[arr valueForKey:@"icontext1"] objectAtIndex:_indexPathSkill.row];
        [_btnStatusOverTextLayer1 setString:[NSString stringWithFormat:@"%@", st3]];
        NSString *st4 = [[arr valueForKey:@"icontext2"] objectAtIndex:_indexPathSkill.row];
        [_btnStatusOverTextLayer2 setString:[NSString stringWithFormat:@"%@", st4]];

        
        [_btnStatus removeFromSuperview];
        [_btnStatusOverTextLayer1 removeFromSuperlayer];
        [_btnStatusOverTextLayer2 removeFromSuperlayer];
        [_btnStatusTextBackgroundLayer removeFromSuperlayer];
        [self.view addSubview:_btnStatus];
        [self.view.layer addSublayer:_btnStatusTextBackgroundLayer];
        [self.view.layer addSublayer:_btnStatusOverTextLayer1];
        [self.view.layer addSublayer:_btnStatusOverTextLayer2];
        
        [self autoSave];


    //スキルボタン4変更
    }else if(button == _btnSave && _indexPathSkill != nil && selectedRowSkillLevel != 0){
        
        //既にセットされてるスキルをはじく！
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:0]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:1]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:2]intValue]) {
            return;
        }
        
        if (_indexPathSkill.row == [[delegate.playerSkillEquipedPlist objectAtIndex:3]intValue]) {
            return;
        }

        
        [changearr removeObjectAtIndex:3];
        [changearr insertObject:[NSNumber numberWithInt:_indexPathSkill.row] atIndex:3];
        delegate.playerSkillEquipedPlist = [changearr copy];
        
        NSString *s2 = [[arr valueForKey:@"attribute"] objectAtIndex:_indexPathSkill.row];
        
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
        NSString *s1 = [[arr valueForKey:@"iconName"] objectAtIndex:_indexPathSkill.row];
        [_btnSave setTitle:[NSString stringWithFormat:@"%@", s1] forState:UIControlStateNormal];
        NSString *s3 = [[arr valueForKey:@"icontext1"] objectAtIndex:_indexPathSkill.row];
        [_btnSaveOverTextLayer1 setString:[NSString stringWithFormat:@"%@", s3]];
        NSString *s4 = [[arr valueForKey:@"icontext2"] objectAtIndex:_indexPathSkill.row];
        [_btnSaveOverTextLayer2 setString:[NSString stringWithFormat:@"%@", s4]];

        
        
        [_btnSave removeFromSuperview];
        [_btnSaveOverTextLayer1 removeFromSuperlayer];
        [_btnSaveOverTextLayer2 removeFromSuperlayer];
        [_btnSaveTextBackgroundLayer removeFromSuperlayer];
        [self.view addSubview:_btnSave];
        [self.view.layer addSublayer:_btnSaveTextBackgroundLayer];
        [self.view.layer addSublayer:_btnSaveOverTextLayer1];
        [self.view.layer addSublayer:_btnSaveOverTextLayer2];
        
        //変更内容を保存
        [self autoSave];
        
    }else{
        
    }
    
    
}

#pragma mark skillup
- (void)skillupStart{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    if ([[delegate.playerPara valueForKey:@"skillPoint"]intValue] > 0) {
        
        //フラグON
        _isSkillUp = YES;
        
        //メッセージ表示
        CALayer *backGroundLayer = [CALayer layer];
        backGroundLayer.backgroundColor = [UIColor blackColor].CGColor;
        backGroundLayer.frame = CGRectMake(0, self.view.center.y - 30, 320, 45);
        [self.view.layer addSublayer:backGroundLayer];
        
        CABasicAnimation *backgroundAnimation;
        backgroundAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        backgroundAnimation.duration = 1.5f;
        backgroundAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        backgroundAnimation.toValue = [NSNumber numberWithFloat:0];
        backgroundAnimation.autoreverses = NO;
        backgroundAnimation.repeatCount = 1;
        backgroundAnimation.removedOnCompletion = NO;
        backgroundAnimation.fillMode = kCAFillModeForwards;
        [backGroundLayer addAnimation:backgroundAnimation forKey:@"opacityAnimation"];
        
        CATextLayer *skillUpMessage = [CATextLayer layer];
        skillUpMessage.backgroundColor = [UIColor clearColor].CGColor;
        [skillUpMessage setString:[NSString stringWithFormat:@"成長させるスキルを選んでください"]];
        skillUpMessage.alignmentMode = kCAAlignmentCenter;
        skillUpMessage.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
        skillUpMessage.fontSize = 12;
        skillUpMessage.foregroundColor = [UIColor whiteColor].CGColor;
        skillUpMessage.frame = CGRectMake(0,self.view.center.y - 15,320,30);
        skillUpMessage.contentsScale = [UIScreen mainScreen].scale;
        [self.view.layer addSublayer:skillUpMessage];
        
        CABasicAnimation *animation;
        animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.duration = 1.5f;
        animation.fromValue = [NSNumber numberWithFloat:1.0f];
        animation.toValue = [NSNumber numberWithFloat:0];
        animation.autoreverses = NO;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [skillUpMessage addAnimation:animation forKey:@"opacityAnimation"];
        
    }else{
                
        //メッセージ表示
        CALayer *backGroundLayer = [CALayer layer];
        backGroundLayer.backgroundColor = [UIColor blackColor].CGColor;
        backGroundLayer.frame = CGRectMake(0, self.view.center.y - 30, 320, 45);
        [self.view.layer addSublayer:backGroundLayer];
        
        CABasicAnimation *backgroundAnimation;
        backgroundAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        backgroundAnimation.duration = 1.5f;
        backgroundAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        backgroundAnimation.toValue = [NSNumber numberWithFloat:0];
        backgroundAnimation.autoreverses = NO;
        backgroundAnimation.repeatCount = 1;
        backgroundAnimation.removedOnCompletion = NO;
        backgroundAnimation.fillMode = kCAFillModeForwards;
        [backGroundLayer addAnimation:backgroundAnimation forKey:@"opacityAnimation"];
        
        CATextLayer *skillUpMessage = [CATextLayer layer];
        skillUpMessage.backgroundColor = [UIColor clearColor].CGColor;
        [skillUpMessage setString:[NSString stringWithFormat:@"スキルポイントが０です"]];
        skillUpMessage.alignmentMode = kCAAlignmentCenter;
        skillUpMessage.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
        skillUpMessage.fontSize = 12;
        skillUpMessage.foregroundColor = [UIColor whiteColor].CGColor;
        skillUpMessage.frame = CGRectMake(0,self.view.center.y - 15,320,30);
        skillUpMessage.contentsScale = [UIScreen mainScreen].scale;
        [self.view.layer addSublayer:skillUpMessage];
        
        CABasicAnimation *animation;
        animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.duration = 1.5f;
        animation.fromValue = [NSNumber numberWithFloat:1.0f];
        animation.toValue = [NSNumber numberWithFloat:0];
        animation.autoreverses = NO;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [skillUpMessage addAnimation:animation forKey:@"opacityAnimation"];
        
    }
    
}

//スキル上昇の条件付け
- (void)skillUpCondition:(NSIndexPath*)index{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        
    //はじく条件
    //ウォールオブフレイムス
    if (index.row == 1 && [[delegate.playerSkillFirst objectAtIndex:0]intValue] < 3) {
        
        [self skillUpConditionDidNotSatisfyMessage];
        return;
    }
    
    //メテオ
    if (index.row == 2 && [[delegate.playerSkillFirst objectAtIndex:1]intValue] < 3) {
        
        [self skillUpConditionDidNotSatisfyMessage];
        return;
    }

    //ブリザード
    if (index.row == 4 && [[delegate.playerSkillFirst objectAtIndex:3]intValue] < 3) {
        
        [self skillUpConditionDidNotSatisfyMessage];
        return;
    }
    
    //テスタメント
    if (index.row == 5 && [[delegate.playerSkillFirst objectAtIndex:4]intValue] < 3) {
        
        [self skillUpConditionDidNotSatisfyMessage];
        return;
    }
    
    //舞う剣
    if (index.row == 8 && [[delegate.playerSkillFirst objectAtIndex:6]intValue] < 3) {
        
        [self skillUpConditionDidNotSatisfyMessage];
        return;
    }
    
    //結界
    if (index.row == 10 && [[delegate.playerSkillFirst objectAtIndex:9]intValue] < 3) {
        
        [self skillUpConditionDidNotSatisfyMessage];
        return;
    }
    
    //ダーククラウド
    if (index.row == 13 && [[delegate.playerSkillFirst objectAtIndex:12]intValue] < 3) {
        
        [self skillUpConditionDidNotSatisfyMessage];
        return;
    }

    //呪い
    if (index.row == 14 && [[delegate.playerSkillFirst objectAtIndex:13]intValue] < 3) {
        
        [self skillUpConditionDidNotSatisfyMessage];
        return;
    }

    
    //最終確認Alert表示
    SkillUpViewController *skillUpAlert = [[SkillUpViewController alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil];
    skillUpAlert.tag = _indexPathSkill.row;
    [skillUpAlert show];
    
}

- (void)skillUpConditionDidNotSatisfyMessage{
    
    //メッセージ表示
    CALayer *backGroundLayer = [CALayer layer];
    backGroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    backGroundLayer.frame = CGRectMake(0, self.view.center.y - 30, 320, 45);
    [self.view.layer addSublayer:backGroundLayer];
    
    CABasicAnimation *backgroundAnimation;
    backgroundAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    backgroundAnimation.duration = 1.5f;
    backgroundAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    backgroundAnimation.toValue = [NSNumber numberWithFloat:0];
    backgroundAnimation.autoreverses = NO;
    backgroundAnimation.repeatCount = 1;
    backgroundAnimation.removedOnCompletion = NO;
    backgroundAnimation.fillMode = kCAFillModeForwards;
    [backGroundLayer addAnimation:backgroundAnimation forKey:@"opacityAnimation"];
    
    CATextLayer *skillUpMessage = [CATextLayer layer];
    skillUpMessage.backgroundColor = [UIColor clearColor].CGColor;
    [skillUpMessage setString:[NSString stringWithFormat:@"スキル習得条件を満たしていません"]];
    skillUpMessage.alignmentMode = kCAAlignmentCenter;
    skillUpMessage.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    skillUpMessage.fontSize = 12;
    skillUpMessage.foregroundColor = [UIColor whiteColor].CGColor;
    skillUpMessage.frame = CGRectMake(0,self.view.center.y - 15,320,30);
    skillUpMessage.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:skillUpMessage];
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 1.5f;
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0];
    animation.autoreverses = NO;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [skillUpMessage addAnimation:animation forKey:@"opacityAnimation"];
    
}

//スキルアップ後のテーブルリロード
- (void)skillTableReload{
    
    [_skillTable reloadData];
}


//アラートから復帰後のフラグ処理
- (void)skillUpFlagOFF{
    
    _isSkillUp = NO;
    
}

//残りスキル表示
- (void)skillPointLabelUpdate{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    [_skillPointTextLayer setString:[NSString stringWithFormat:@"SKILLPOINT:%@", [delegate.playerPara valueForKey:@"skillPoint"]]];

    
}

#pragma mark skillReset
- (void)skillResetStart{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    //総スキルポイントを収集
    int stockPool = [[delegate.playerPara valueForKey:@"level"]intValue] + 5;
    
//    for (id obj in delegate.playerSkillFirst) {
//        if ([obj intValue] > 0) {
//            
//            stockPool = stockPool + [obj intValue];
//            
//        }
//    }
    
    
    //空っぽのarrを作る
    NSMutableArray *emptyMuarr = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= [delegate.playerSkillFirst count]; i++) {
        
        [emptyMuarr addObject:[NSNumber numberWithInt:0]];
    }
    
    //スキル振りを空にする
    delegate.playerSkillFirst = emptyMuarr;
    [_skillTable reloadData];
    
    //スキルポイントを更新
    NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
    [mudic setValue:[NSNumber numberWithInt:stockPool] forKey:@"skillPoint"];
    delegate.playerPara = mudic;
    
    [self skillPointLabelUpdate];
    
    
    //テキスト告知
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
    [equipMessage setString:[NSString stringWithFormat:@"スキルポイントリセット完了"]];
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

#pragma mark tables
//テーブルの設定
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    
    return [[_skillListLoadedArray valueForKey:@"name"]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 33;
}

//テーブルの内容

-(UITableViewCell *)tableView:
(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //tableviewの基本設定
    static NSString *CellIdentifier = @"Cell";
    _cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( _cell == nil )
    {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //セルの再利用で背景色などが狂ってしまうのでcontentsviewを削除しておく
    for (UIView *subview in [_cell.contentView subviews]) {
        [subview removeFromSuperview];
    }
    for (CALayer *layers in _cell.contentView.layer.sublayers) {
        [layers removeFromSuperlayer];
    }

    
    //セルの間のボーダーを消す
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //スキルの属性によるカラーリング設定
    CALayer *cellBackgroundLayer = [CALayer layer];
    cellBackgroundLayer.frame = CGRectMake(8, 8, 160, 25);
    cellBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    [_cell.contentView.layer addSublayer:cellBackgroundLayer];
    [_cell.contentView.layer insertSublayer:cellBackgroundLayer atIndex:0];
    cellBackgroundLayer.opacity = 0.3;
    
    if ([[[_skillListLoadedArray valueForKey:@"attribute"]objectAtIndex:indexPath.row] isEqual: @"freeze"]) {
        cellBackgroundLayer.backgroundColor = [UIColor blueColor].CGColor;
    }else if([[[_skillListLoadedArray valueForKey:@"attribute"]objectAtIndex:indexPath.row] isEqual: @"fire"]){
        cellBackgroundLayer.backgroundColor = [UIColor redColor].CGColor;
    }else if([[[_skillListLoadedArray valueForKey:@"attribute"]objectAtIndex:indexPath.row] isEqual: @"holy"]){
        cellBackgroundLayer.backgroundColor = [UIColor brownColor].CGColor;
    }else if([[[_skillListLoadedArray valueForKey:@"attribute"]objectAtIndex:indexPath.row] isEqual: @"physical"]){
        cellBackgroundLayer.backgroundColor = [UIColor grayColor].CGColor;
    }else if([[[_skillListLoadedArray valueForKey:@"attribute"]objectAtIndex:indexPath.row] isEqual: @"dark"]){
        cellBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    }

    
    //スキル名前
    _skillNamelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 130, 25)];
    _skillNamelabel.textColor = [UIColor whiteColor];
    _skillNamelabel.backgroundColor = [UIColor clearColor];
    [_skillNamelabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [_skillNamelabel setText:[NSString stringWithFormat:@"%@", [[_skillListLoadedArray valueForKey:@"name"]objectAtIndex:indexPath.row]]];
    [_cell.contentView addSubview:_skillNamelabel];
    
    //スキルレベル
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    _skillLevelLabel = [[UILabel alloc]init];
    _skillLevelLabel.frame = CGRectMake(135, 10, 35, 25);
    _skillLevelLabel.textColor = [UIColor whiteColor];
    [_skillLevelLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    _skillLevelLabel.backgroundColor = [UIColor clearColor];
    [_skillLevelLabel setText:[NSString stringWithFormat:@"LV%@", [delegate.playerSkillFirst objectAtIndex:indexPath.row]]];

    [_cell.contentView addSubview:_skillLevelLabel];
   
    
    return _cell;
}

//セルの透明化設定
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor clearColor];
    
}

//セルタップ時の処理
//主に右カラムにスキルの説明を表示
-(void)tableView:
(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"go.mp3"];
    
    //スキルの名前
    //古い値の削除
    [_skillNameDetailLabel setText:@""];
    
    _skillNameDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(186, 5, 126, 30)];
    _skillNameDetailLabel.textColor = [UIColor whiteColor];
    [_skillNameDetailLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    _skillNameDetailLabel.backgroundColor = [UIColor clearColor];
    _skillNameDetailLabel.text = [NSString stringWithFormat:@"%@", [[_skillListLoadedArray valueForKey:@"name"]objectAtIndex:indexPath.row]];
    [self.view addSubview:_skillNameDetailLabel];
    
    //説明文
    //古い値の削除
    [_skillDescriptionLabel setText:@""];
    
    _skillDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(186, 35, 126, 70)];
    _skillDescriptionLabel.textColor = [UIColor whiteColor];
    [_skillDescriptionLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    _skillDescriptionLabel.backgroundColor = [UIColor clearColor];
    _skillDescriptionLabel.text = [NSString stringWithFormat:@"%@", [[_skillListLoadedArray valueForKey:@"description"]objectAtIndex:indexPath.row]];
    _skillDescriptionLabel.numberOfLines = 4;
    [self.view addSubview:_skillDescriptionLabel];
    
    //属性
    [_skillAttributeLabel setText:@""];
    _skillAttributeLabel = [[UILabel alloc]initWithFrame:CGRectMake(186, 100, 126, 30)];
    _skillAttributeLabel.textColor = [UIColor whiteColor];
    [_skillAttributeLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    _skillAttributeLabel.backgroundColor = [UIColor clearColor];
    _skillAttributeLabel.text = [NSString stringWithFormat:@"属性：%@", [[_skillListLoadedArray valueForKey:@"attribute"]objectAtIndex:indexPath.row]];
    [self.view addSubview:_skillAttributeLabel];
    
    //基礎魔法力
    //古い値の削除
//    [_skillDamageLabel removeFromSuperview];
//    
//    _skillDamageLabel = [[UILabel alloc]initWithFrame:CGRectMake(186, 115, 126, 30)];
//    _skillDamageLabel.textColor = [UIColor whiteColor];
//    [_skillDamageLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
//    _skillDamageLabel.backgroundColor = [UIColor clearColor];
//    _skillDamageLabel.text = [NSString stringWithFormat:@"基礎魔法力：%@", [[_skillListLoadedArray valueForKey:@"baseDamage"]objectAtIndex:indexPath.row]];
//    [self.view addSubview:_skillDamageLabel];
    
    //レベル上昇率
    //古い値の削除
    [_skillDamageUpLabel removeFromSuperview];

    _skillDamageUpLabel = [[UILabel alloc]initWithFrame:CGRectMake(186, 115, 126, 30)];
    _skillDamageUpLabel.textColor = [UIColor whiteColor];
    [_skillDamageUpLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    _skillDamageUpLabel.backgroundColor = [UIColor clearColor];
    NSString *str = [NSString stringWithFormat:@"%.0f", [[[_skillListLoadedArray valueForKey:@"leveledDamageUp"]objectAtIndex:indexPath.row]floatValue] * 100];
    _skillDamageUpLabel.text = [NSString stringWithFormat:@"レベル毎上昇率：%@％", str];
    [self.view addSubview:_skillDamageUpLabel];

    //現在倍率
    [_skillCurrentDamageUpLabel setText:@""];
    
    _skillCurrentDamageUpLabel = [[UILabel alloc]initWithFrame:CGRectMake(186, 130, 126, 30)];
    _skillCurrentDamageUpLabel.textColor = [UIColor whiteColor];
    [_skillCurrentDamageUpLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    _skillCurrentDamageUpLabel.backgroundColor = [UIColor clearColor];
    //NSString *str = [NSString stringWithFormat:@"%.0f", [[[_skillListLoadedArray valueForKey:@"leveledDamageUp"]objectAtIndex:indexPath.row]floatValue] * 100];
    NSString *str2 = [NSString stringWithFormat:@"%.0f", [[[_skillListLoadedArray valueForKey:@"leveledDamageUp"]objectAtIndex:indexPath.row]floatValue] * [[delegate.playerSkillFirst objectAtIndex:indexPath.row]floatValue] * 100 + 100];
    
    _skillCurrentDamageUpLabel.text = [NSString stringWithFormat:@"現在倍率：%@％", str2];
    [self.view addSubview:_skillCurrentDamageUpLabel];
    
    //攻撃回数
//    [_skillAttackTime setText:@""];
//    
//    _skillAttackTime = [[UILabel alloc]initWithFrame:CGRectMake(186, 145, 126, 30)];
//    _skillAttackTime.textColor = [UIColor whiteColor];
//    [_skillAttackTime setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
//    _skillAttackTime.backgroundColor = [UIColor clearColor];
//    NSString *str3 = [NSString stringWithFormat:@"%@", [[_skillListLoadedArray valueForKey:@"attackTime"]objectAtIndex:indexPath.row]];
//    _skillAttackTime.text = [NSString stringWithFormat:@"攻撃回数：%@", str3];
//    [self.view addSubview:_skillAttackTime];
    
    //ディレイターン
    [_skillDelayLabel setText:@""];
    
    _skillDelayLabel = [[UILabel alloc]initWithFrame:CGRectMake(186, 145, 126, 30)];
    _skillDelayLabel.textColor = [UIColor whiteColor];
    [_skillDelayLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    _skillDelayLabel.backgroundColor = [UIColor clearColor];
    NSString *str4 = [NSString stringWithFormat:@"%@", [[_skillListLoadedArray valueForKey:@"delay"]objectAtIndex:indexPath.row]];
    _skillDelayLabel.text = [NSString stringWithFormat:@"ディレイ：%@秒", str4];
    [self.view addSubview:_skillDelayLabel];
    
    //特殊表記
    [_skillSPDescriptionLabel setText:@""];
    
    _skillSPDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(186, 175, 126, 35)];
    _skillSPDescriptionLabel.textColor = [UIColor whiteColor];
    [_skillSPDescriptionLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    _skillSPDescriptionLabel.backgroundColor = [UIColor clearColor];
    NSString *str5 = [NSString stringWithFormat:@"%@", [[_skillListLoadedArray valueForKey:@"SPDescription"]objectAtIndex:indexPath.row]];
    _skillSPDescriptionLabel.text = [NSString stringWithFormat:@"習得条件：%@", str5];
    _skillSPDescriptionLabel.numberOfLines = 3;
    [self.view addSubview:_skillSPDescriptionLabel];

    //スキル変更処理のため一時的に値を保存
    _indexPathSkill = indexPath;
    
    //スキル成長処理ここから
    if (_isSkillUp == YES) {
    
        [self skillUpCondition:indexPath];
        
        

   }
    
}

- (void)flagOFF{
    
    _isSkillUp = NO;
    
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


// アラートが表示される前に呼び出される
- (void)willPresentAlertView:(UIAlertView *)alertView
{
        CGRect alertFrame = CGRectMake(0, 0, 320, 130);
        alertView.frame = alertFrame;
        
        // アラートの表示位置を設定(アラート表示サイズを変更すると位置がずれるため)
        CGPoint alertPoint = CGPointMake(160, self.view.frame.size.height / 2.0);
        alertView.center = alertPoint;
        
}


//reject対策--------------------------------------------
//画面表示しようとするときに、テーブルのリロードと選択のクリアをする
- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    [_skillTableView deselectRowAtIndexPath:[_skillTableView indexPathForSelectedRow] animated:YES];
    [_skillTableView reloadData];
    
}

//画面表示したあとに、スクロールバーを点滅させる
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [_skillTableView flashScrollIndicators];
    
}
// ----------------------------------------------------

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
