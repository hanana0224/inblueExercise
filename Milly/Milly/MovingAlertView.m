//
//  MovingAlertView.m
//  Milly
//
//  Created by 花澤 長行 on 2013/07/12.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "MovingAlertView.h"

@implementation MovingAlertView

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
    [backGroundLayer setFrame:CGRectMake(0, 0, 320, 300)];
    backGroundLayer.opacity = 0.7;
    [self.layer addSublayer:backGroundLayer];
    
    //タイトル
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 320, 30)];
    [textLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    textLabel.text = [NSString stringWithFormat:@"転移したいエリアを選択して？"];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [super addSubview:textLabel];
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    [delegate.playerPara valueForKey:@"maxStage"];
    
    if ([[delegate.playerPara valueForKey:@"maxStage"]intValue] >= 1) {
        [self button1Appear];
    }
    
    if ([[delegate.playerPara valueForKey:@"maxStage"]intValue] >= 2) {
        [self button2Appear];
    }
    
    if ([[delegate.playerPara valueForKey:@"maxStage"]intValue] >= 3) {
        [self button3Appear];
    }
    
    if ([[delegate.playerPara valueForKey:@"maxStage"]intValue] >= 4) {
        [self button4Appear];
    }
    
    if ([[delegate.playerPara valueForKey:@"maxStage"]intValue] >= 5) {
        [self button5Appear];
    }
    
    if ([[delegate.playerPara valueForKey:@"maxStage"]intValue] >= 6) {
        [self button6Appear];
    }
    
    if ([[delegate.playerPara valueForKey:@"maxStage"]intValue] >= 7) {
        [self button7Appear];
    }
    
    //debug用設定
    [self button6Appear];
    
        
    //暗黒ボタン
    UIButton *darkButton = [[UIButton alloc]initWithFrame:CGRectMake(242, 123, 70, 70)];
    darkButton.tag = 7;
    [darkButton setTitle:@"キャンセル" forState:UIControlStateNormal];
    [darkButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0, 0)];
    [darkButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [darkButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:9]];
    [darkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [darkButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:darkButton];
    
    [darkButton addTarget:self action:@selector(cancellClicked) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *darkText1 = [CATextLayer layer];
    darkText1.backgroundColor = [UIColor clearColor].CGColor;
    [darkText1 setString:@"戻"];
    darkText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    darkText1.fontSize = 50;
    darkText1.foregroundColor = [UIColor blackColor].CGColor;
    darkText1.frame = CGRectMake(272, 123, 50, 70);
    darkText1.opacity = 0.5;
    darkText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:darkText1];


}

- (void)button1Appear{

    //ボタン
    //基礎魔法力ボタン
    UIButton *baseAttackButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 45, 70, 70)];
    baseAttackButton.tag = 0;
    [baseAttackButton setTitle:@"シンヂュク郊外" forState:UIControlStateNormal];
    [baseAttackButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0, 0)];
    [baseAttackButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [baseAttackButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:9]];
    [baseAttackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [baseAttackButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:baseAttackButton];
    
    [baseAttackButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *baseAttackText1 = [CATextLayer layer];
    baseAttackText1.backgroundColor = [UIColor clearColor].CGColor;
    [baseAttackText1 setString:@"壱"];
    baseAttackText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    baseAttackText1.fontSize = 50;
    baseAttackText1.foregroundColor = [UIColor blackColor].CGColor;
    baseAttackText1.frame = CGRectMake(38, 45, 50, 70);
    baseAttackText1.opacity = 0.5;
    baseAttackText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:baseAttackText1];

}

- (void)button2Appear{
    
    //基礎防壁ボタン
    UIButton *baseDefenseButton = [[UIButton alloc]initWithFrame:CGRectMake(86, 45, 70, 70)];
    baseDefenseButton.tag = 1;
    [baseDefenseButton setTitle:@"シンヂュク駅前" forState:UIControlStateNormal];
    [baseDefenseButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0, 0)];
    [baseDefenseButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [baseDefenseButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:9]];
    [baseDefenseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [baseDefenseButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:baseDefenseButton];
    
    [baseDefenseButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *baseDefenseText1 = [CATextLayer layer];
    baseDefenseText1.backgroundColor = [UIColor clearColor].CGColor;
    [baseDefenseText1 setString:@"弐"];
    baseDefenseText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    baseDefenseText1.fontSize = 50;
    baseDefenseText1.foregroundColor = [UIColor blackColor].CGColor;
    baseDefenseText1.frame = CGRectMake(116, 45, 50, 70);
    baseDefenseText1.opacity = 0.5;
    baseDefenseText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:baseDefenseText1];

    
}

- (void)button3Appear{
    
    //クリティカルボタン
    UIButton *criticalButton = [[UIButton alloc]initWithFrame:CGRectMake(164, 45, 70, 70)];
    criticalButton.tag = 2;
    //[criticalButton setTitle:@"シンヂュク駅\n56番線" forState:UIControlStateNormal];
    [criticalButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0, 0)];
    [criticalButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [criticalButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:9]];
    [criticalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [criticalButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:criticalButton];
    
    [criticalButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *criticalText1 = [CATextLayer layer];
    criticalText1.backgroundColor = [UIColor clearColor].CGColor;
    [criticalText1 setString:@"参"];
    criticalText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    criticalText1.fontSize = 50;
    criticalText1.foregroundColor = [UIColor blackColor].CGColor;
    criticalText1.frame = CGRectMake(194, 45, 50, 70);
    criticalText1.opacity = 0.5;
    criticalText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:criticalText1];
    
    CATextLayer *threeTextLayer = [CATextLayer layer];
    threeTextLayer.backgroundColor = [UIColor clearColor].CGColor;
    [threeTextLayer setString:@"シンヂュク駅\n56番線"];
    threeTextLayer.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    threeTextLayer.fontSize = 9;
    threeTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    threeTextLayer.frame = CGRectMake(169, 87, 70, 30);
    threeTextLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:threeTextLayer];

    
}

- (void)button4Appear{
    
    //回避率ボタン
    UIButton *avoidButton = [[UIButton alloc]initWithFrame:CGRectMake(242, 45, 70, 70)];
    avoidButton.tag = 3;
    //[avoidButton setTitle:@"Y AM T 線列車内" forState:UIControlStateNormal];
    [avoidButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0, 0)];
    [avoidButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [avoidButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:9]];
    [avoidButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [avoidButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    avoidButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    avoidButton.titleLabel.numberOfLines = 2;
    [super addSubview:avoidButton];
    
    [avoidButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    CATextLayer *avoidText1 = [CATextLayer layer];
    avoidText1.backgroundColor = [UIColor clearColor].CGColor;
    [avoidText1 setString:@"肆"];
    avoidText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    avoidText1.fontSize = 50;
    avoidText1.foregroundColor = [UIColor blackColor].CGColor;
    avoidText1.frame = CGRectMake(272, 45, 50, 70);
    avoidText1.opacity = 0.5;
    avoidText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:avoidText1];
    
    CATextLayer *fourTextLayer = [CATextLayer layer];
    fourTextLayer.backgroundColor = [UIColor clearColor].CGColor;
    [fourTextLayer setString:@"Y AM T 線\n列車内"];
    fourTextLayer.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    fourTextLayer.fontSize = 9;
    fourTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    fourTextLayer.frame = CGRectMake(247, 87, 70, 30);
    fourTextLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:fourTextLayer];

    
}

- (void)button5Appear{
    
    //炎熱適正ボタン
    UIButton *fireButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 123, 70, 70)];
    fireButton.tag = 4;
    [fireButton setTitle:@"メガ都庁ビル前" forState:UIControlStateNormal];
    [fireButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0, 0)];
    [fireButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [fireButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:9]];
    [fireButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fireButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:fireButton];
    
    [fireButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *fireText1 = [CATextLayer layer];
    fireText1.backgroundColor = [UIColor clearColor].CGColor;
    [fireText1 setString:@"伍"];
    fireText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    fireText1.fontSize = 50;
    fireText1.foregroundColor = [UIColor blackColor].CGColor;
    fireText1.frame = CGRectMake(38, 123, 50, 70);
    fireText1.opacity = 0.5;
    fireText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:fireText1];

    
}

- (void)button6Appear{
    
    //氷結適正ボタン
    UIButton *freezeButton = [[UIButton alloc]initWithFrame:CGRectMake(86, 123, 70, 70)];
    freezeButton.tag = 5;
    [freezeButton setTitle:@"メガ都庁下層" forState:UIControlStateNormal];
    [freezeButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0, 0)];
    [freezeButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [freezeButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:9]];
    [freezeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [freezeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:freezeButton];
    
    [freezeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *freezeText1 = [CATextLayer layer];
    freezeText1.backgroundColor = [UIColor clearColor].CGColor;
    [freezeText1 setString:@"陸"];
    freezeText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    freezeText1.fontSize = 50;
    freezeText1.foregroundColor = [UIColor blackColor].CGColor;
    freezeText1.frame = CGRectMake(116, 123, 50, 70);
    freezeText1.opacity = 0.5;
    freezeText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:freezeText1];

    
}

- (void)button7Appear{
    
    //聖光ボタン
    UIButton *holyButton = [[UIButton alloc]initWithFrame:CGRectMake(164, 123, 70, 70)];
    holyButton.tag = 6;
    [holyButton setTitle:@"メガ都庁上層" forState:UIControlStateNormal];
    [holyButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0, 0)];
    [holyButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [holyButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:9]];
    [holyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [holyButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:holyButton];
    
    //[holyButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *holyText1 = [CATextLayer layer];
    holyText1.backgroundColor = [UIColor clearColor].CGColor;
    [holyText1 setString:@"漆"];
    holyText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    holyText1.fontSize = 50;
    holyText1.foregroundColor = [UIColor blackColor].CGColor;
    holyText1.frame = CGRectMake(194, 123, 50, 70);
    holyText1.opacity = 0.5;
    holyText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:holyText1];

}

- (void)buttonClicked:(UIButton*)button{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
    [mdic setValue:[NSNumber numberWithInt:button.tag] forKey:@"currentStage"];
    delegate.playerPara = mdic;
        
    ViewController *view = [[ViewController alloc] initWithNibName:@"view" bundle:nil];
    [view areaDegreeUpdate];

    
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"warp.mp3"];
    
    //オートセーブ
    [self autoSave];
    
    [self.delegate moveMessageAppear];
    
}

- (void)cancellClicked{
    
    [self dismissWithClickedButtonIndex:0 animated:YES];

    
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
