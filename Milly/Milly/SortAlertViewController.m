//
//  SortAlertViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/06/07.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "SortAlertViewController.h"


@implementation SortAlertViewController

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
    [backGroundLayer setFrame:CGRectMake(0, 50, 320, 270)];
    backGroundLayer.opacity = 0.7;
    [self.layer addSublayer:backGroundLayer];
    
    //タイトル
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 50, 250, 30)];
    [textLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    textLabel.text = @"降順ソートしたいカテゴリを選択してくれ";
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    [super addSubview:textLabel];
    
    //ボタン
    //基礎魔法力ボタン
    UIButton *baseAttackButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 75, 70, 70)];
    baseAttackButton.tag = 0;
    [baseAttackButton setTitle:@"基礎魔法力" forState:UIControlStateNormal];
    [baseAttackButton setTitleEdgeInsets:UIEdgeInsetsMake(55, -5, 0, 0)];
    [baseAttackButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [baseAttackButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [baseAttackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [baseAttackButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:baseAttackButton];
    
    [baseAttackButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *baseAttackText1 = [CATextLayer layer];
    baseAttackText1.backgroundColor = [UIColor clearColor].CGColor;
    [baseAttackText1 setString:@"魔"];
    baseAttackText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    baseAttackText1.fontSize = 50;
    baseAttackText1.foregroundColor = [UIColor blackColor].CGColor;
    baseAttackText1.frame = CGRectMake(38, 75, 50, 70);
    baseAttackText1.opacity = 0.5;
    baseAttackText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:baseAttackText1];
    
    //基礎防壁ボタン
    UIButton *baseDefenseButton = [[UIButton alloc]initWithFrame:CGRectMake(86, 75, 70, 70)];
    baseDefenseButton.tag = 1;
    [baseDefenseButton setTitle:@"防壁展開力" forState:UIControlStateNormal];
    [baseDefenseButton setTitleEdgeInsets:UIEdgeInsetsMake(55, -5, 0, 0)];
    [baseDefenseButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [baseDefenseButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [baseDefenseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [baseDefenseButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:baseDefenseButton];
    
    [baseDefenseButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *baseDefenseText1 = [CATextLayer layer];
    baseDefenseText1.backgroundColor = [UIColor clearColor].CGColor;
    [baseDefenseText1 setString:@"防"];
    baseDefenseText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    baseDefenseText1.fontSize = 50;
    baseDefenseText1.foregroundColor = [UIColor blackColor].CGColor;
    baseDefenseText1.frame = CGRectMake(116, 75, 50, 70);
    baseDefenseText1.opacity = 0.5;
    baseDefenseText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:baseDefenseText1];
    
    //クリティカルボタン
    UIButton *criticalButton = [[UIButton alloc]initWithFrame:CGRectMake(164, 75, 70, 70)];
    criticalButton.tag = 2;
    [criticalButton setTitle:@"クリティカル" forState:UIControlStateNormal];
    [criticalButton setTitleEdgeInsets:UIEdgeInsetsMake(55, 0, 0, 0)];
    [criticalButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [criticalButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [criticalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [criticalButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:criticalButton];
    
    [criticalButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *criticalText1 = [CATextLayer layer];
    criticalText1.backgroundColor = [UIColor clearColor].CGColor;
    [criticalText1 setString:@"必"];
    criticalText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    criticalText1.fontSize = 50;
    criticalText1.foregroundColor = [UIColor blackColor].CGColor;
    criticalText1.frame = CGRectMake(194, 75, 50, 70);
    criticalText1.opacity = 0.5;
    criticalText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:criticalText1];
    
    //回避率ボタン
    UIButton *avoidButton = [[UIButton alloc]initWithFrame:CGRectMake(242, 75, 70, 70)];
    avoidButton.tag = 3;
    [avoidButton setTitle:@"回避率" forState:UIControlStateNormal];
    [avoidButton setTitleEdgeInsets:UIEdgeInsetsMake(55, -25, 0, 0)];
    [avoidButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [avoidButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [avoidButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [avoidButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:avoidButton];
    
    [avoidButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *avoidText1 = [CATextLayer layer];
    avoidText1.backgroundColor = [UIColor clearColor].CGColor;
    [avoidText1 setString:@"避"];
    avoidText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    avoidText1.fontSize = 50;
    avoidText1.foregroundColor = [UIColor blackColor].CGColor;
    avoidText1.frame = CGRectMake(272, 75, 50, 70);
    avoidText1.opacity = 0.5;
    avoidText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:avoidText1];

    //炎熱適正ボタン
    UIButton *fireButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 153, 70, 70)];
    fireButton.tag = 4;
    [fireButton setTitle:@"炎熱適正" forState:UIControlStateNormal];
    [fireButton setTitleEdgeInsets:UIEdgeInsetsMake(55, -15, 0, 0)];
    [fireButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [fireButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [fireButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fireButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:fireButton];
    
    [fireButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *fireText1 = [CATextLayer layer];
    fireText1.backgroundColor = [UIColor clearColor].CGColor;
    [fireText1 setString:@"炎"];
    fireText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    fireText1.fontSize = 50;
    fireText1.foregroundColor = [UIColor blackColor].CGColor;
    fireText1.frame = CGRectMake(38, 153, 50, 70);
    fireText1.opacity = 0.5;
    fireText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:fireText1];

    //氷結適正ボタン
    UIButton *freezeButton = [[UIButton alloc]initWithFrame:CGRectMake(86, 153, 70, 70)];
    freezeButton.tag = 5;
    [freezeButton setTitle:@"氷結適正" forState:UIControlStateNormal];
    [freezeButton setTitleEdgeInsets:UIEdgeInsetsMake(55, -15, 0, 0)];
    [freezeButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [freezeButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [freezeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [freezeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:freezeButton];
    
    [freezeButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *freezeText1 = [CATextLayer layer];
    freezeText1.backgroundColor = [UIColor clearColor].CGColor;
    [freezeText1 setString:@"氷"];
    freezeText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    freezeText1.fontSize = 50;
    freezeText1.foregroundColor = [UIColor blackColor].CGColor;
    freezeText1.frame = CGRectMake(116, 153, 50, 70);
    freezeText1.opacity = 0.5;
    freezeText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:freezeText1];
    
    //聖光ボタン
    UIButton *holyButton = [[UIButton alloc]initWithFrame:CGRectMake(164, 153, 70, 70)];
    holyButton.tag = 6;
    [holyButton setTitle:@"聖光適正" forState:UIControlStateNormal];
    [holyButton setTitleEdgeInsets:UIEdgeInsetsMake(55, -15, 0, 0)];
    [holyButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [holyButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [holyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [holyButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:holyButton];
    
    [holyButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *holyText1 = [CATextLayer layer];
    holyText1.backgroundColor = [UIColor clearColor].CGColor;
    [holyText1 setString:@"聖"];
    holyText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    holyText1.fontSize = 50;
    holyText1.foregroundColor = [UIColor blackColor].CGColor;
    holyText1.frame = CGRectMake(194, 153, 50, 70);
    holyText1.opacity = 0.5;
    holyText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:holyText1];
    
    //暗黒ボタン
    UIButton *darkButton = [[UIButton alloc]initWithFrame:CGRectMake(242, 153, 70, 70)];
    darkButton.tag = 7;
    [darkButton setTitle:@"暗黒適正" forState:UIControlStateNormal];
    [darkButton setTitleEdgeInsets:UIEdgeInsetsMake(55, -15, 0, 0)];
    [darkButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [darkButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [darkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [darkButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:darkButton];
    
    [darkButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *darkText1 = [CATextLayer layer];
    darkText1.backgroundColor = [UIColor clearColor].CGColor;
    [darkText1 setString:@"暗"];
    darkText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    darkText1.fontSize = 50;
    darkText1.foregroundColor = [UIColor blackColor].CGColor;
    darkText1.frame = CGRectMake(272, 153, 50, 70);
    darkText1.opacity = 0.5;
    darkText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:darkText1];


    //物理適正ボタン
    UIButton *physicalButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 231, 70, 70)];
    physicalButton.tag = 8;
    [physicalButton setTitle:@"物理適正" forState:UIControlStateNormal];
    [physicalButton setTitleEdgeInsets:UIEdgeInsetsMake(55, -15, 0, 0)];
    [physicalButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [physicalButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [physicalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [physicalButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:physicalButton];
    
    [physicalButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *physicalText1 = [CATextLayer layer];
    physicalText1.backgroundColor = [UIColor clearColor].CGColor;
    [physicalText1 setString:@"物"];
    physicalText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    physicalText1.fontSize = 50;
    physicalText1.foregroundColor = [UIColor blackColor].CGColor;
    physicalText1.frame = CGRectMake(38, 231, 50, 70);
    physicalText1.opacity = 0.5;
    physicalText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:physicalText1];
    
    //吸収率ボタン
    UIButton *leechButton = [[UIButton alloc]initWithFrame:CGRectMake(86, 231, 70, 70)];
    leechButton.tag = 9;
    [leechButton setTitle:@"吸収率" forState:UIControlStateNormal];
    [leechButton setTitleEdgeInsets:UIEdgeInsetsMake(55, -15, 0, 0)];
    [leechButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [leechButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [leechButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leechButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:leechButton];
    
    [leechButton addTarget:self action:@selector(sortButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *leechText1 = [CATextLayer layer];
    leechText1.backgroundColor = [UIColor clearColor].CGColor;
    [leechText1 setString:@"吸"];
    leechText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    leechText1.fontSize = 50;
    leechText1.foregroundColor = [UIColor blackColor].CGColor;
    leechText1.frame = CGRectMake(116, 231, 50, 70);
    leechText1.opacity = 0.5;
    leechText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:leechText1];

    //キャンセルボタン
    UIButton *cancellButton = [[UIButton alloc]initWithFrame:CGRectMake(164, 231, 70, 70)];
    cancellButton.tag = 10;
    [cancellButton setTitle:@"キャンセル" forState:UIControlStateNormal];
    [cancellButton setTitleEdgeInsets:UIEdgeInsetsMake(55, -15, 0, 0)];
    [cancellButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [cancellButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [cancellButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancellButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:cancellButton];
    
    [cancellButton addTarget:self action:@selector(cancellButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *cancellText1 = [CATextLayer layer];
    cancellText1.backgroundColor = [UIColor clearColor].CGColor;
    [cancellText1 setString:@"戻"];
    cancellText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    cancellText1.fontSize = 50;
    cancellText1.foregroundColor = [UIColor blackColor].CGColor;
    cancellText1.frame = CGRectMake(194, 231, 50, 70);
    cancellText1.opacity = 0.5;
    cancellText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:cancellText1];


}

- (void)cancellButtonClicked{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void)sortButtonClicked:(UIButton*)button{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    
    [self.delegate sort:button.tag];
    [self dismissWithClickedButtonIndex:0 animated:YES];
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
