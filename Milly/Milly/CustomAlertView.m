//
//  CustomAlertView.m
//  Milly
//
//  Created by 花澤 長行 on 2013/06/06.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

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
    [backGroundLayer setFrame:CGRectMake(-20, -40, 320, 210)];
    backGroundLayer.opacity = 0.7;
    [self.layer addSublayer:backGroundLayer];
    

    
    //キャンセルボタンを表示
    UIButton *cancell = [[UIButton alloc]initWithFrame:CGRectMake(190, 0, 70, 150)];
    [cancell setTitle:@"キャンセル" forState:UIControlStateNormal];
    [cancell setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [cancell.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    [cancell setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancell setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [cancell setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    [super addSubview:cancell];
    
    [cancell addTarget:self action:@selector(cancellButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *cancellText1 = [CATextLayer layer];
    cancellText1.backgroundColor = [UIColor clearColor].CGColor;
    [cancellText1 setString:@"戻"];
    cancellText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    cancellText1.fontSize = 50;
    cancellText1.foregroundColor = [UIColor blackColor].CGColor;
    cancellText1.frame = CGRectMake(210, 0, 50, 150);
    cancellText1.opacity = 0.5;
    cancellText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:cancellText1];

    
    //タイトル
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, -30, 250, 30)];
    [textLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:14]];
    textLabel.text = @"装備を変更する箇所を選択しろ";
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    [super addSubview:textLabel];
    
    //装備1ボタン
    UIButton *equip1 = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 70, 70)];
    equip1.tag = 1;
    [equip1 setTitle:@"装備壱" forState:UIControlStateNormal];
    [equip1 setTitleEdgeInsets:UIEdgeInsetsMake(55, -25, 0, 0)];
    [equip1 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [equip1.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    [equip1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [equip1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:equip1];
    
    [equip1 addTarget:self action:@selector(equipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *equipText1 = [CATextLayer layer];
    equipText1.backgroundColor = [UIColor clearColor].CGColor;
    [equipText1 setString:@"壱"];
    equipText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    equipText1.fontSize = 50;
    equipText1.foregroundColor = [UIColor blackColor].CGColor;
    equipText1.frame = CGRectMake(50, 0, 50, 70);
    equipText1.opacity = 0.5;
    equipText1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:equipText1];

    
    //装備2ボタン
    UIButton *equip2 = [[UIButton alloc]initWithFrame:CGRectMake(110, 0, 70, 70)];
    equip2.tag = 2;
    [equip2 setTitle:@"装備弐" forState:UIControlStateNormal];
    [equip2 setTitleEdgeInsets:UIEdgeInsetsMake(55, -25, 0, 0)];
    [equip2 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [equip2.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    [equip2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [equip2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:equip2];
    
    [equip2 addTarget:self action:@selector(equipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *equipText2 = [CATextLayer layer];
    equipText2.backgroundColor = [UIColor clearColor].CGColor;
    [equipText2 setString:@"弐"];
    equipText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    equipText2.fontSize = 50;
    equipText2.foregroundColor = [UIColor blackColor].CGColor;
    equipText2.frame = CGRectMake(130, 0, 50, 70);
    equipText2.opacity = 0.5;
    equipText2.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:equipText2];

    
    //装備3ボタン
    UIButton *equip3 = [[UIButton alloc]initWithFrame:CGRectMake(30, 80, 70, 70)];
    equip3.tag = 3;
    [equip3 setTitle:@"装備参" forState:UIControlStateNormal];
    [equip3 setTitleEdgeInsets:UIEdgeInsetsMake(55, -25, 0, 0)];
    [equip3 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [equip3.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    [equip3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [equip3 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:equip3];
    
    [equip3 addTarget:self action:@selector(equipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *equipText3 = [CATextLayer layer];
    equipText3.backgroundColor = [UIColor clearColor].CGColor;
    [equipText3 setString:@"参"];
    equipText3.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    equipText3.fontSize = 50;
    equipText3.foregroundColor = [UIColor blackColor].CGColor;
    equipText3.frame = CGRectMake(50, 80, 50, 70);
    equipText3.opacity = 0.5;
    equipText3.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:equipText3];

    
    //装備4ボタン
    UIButton *equip4 = [[UIButton alloc]initWithFrame:CGRectMake(110, 80, 70, 70)];
    equip4.tag = 4;
    [equip4 setTitle:@"装備肆" forState:UIControlStateNormal];
    [equip4 setTitleEdgeInsets:UIEdgeInsetsMake(55, -25, 0, 0)];
    [equip4 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [equip4.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    [equip4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [equip4 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [super addSubview:equip4];
    
    [equip4 addTarget:self action:@selector(equipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    CATextLayer *equipText4 = [CATextLayer layer];
    equipText4.backgroundColor = [UIColor clearColor].CGColor;
    [equipText4 setString:@"肆"];
    equipText4.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    equipText4.fontSize = 50;
    equipText4.foregroundColor = [UIColor blackColor].CGColor;
    equipText4.frame = CGRectMake(130, 80, 50, 70);
    equipText4.opacity = 0.5;
    equipText4.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:equipText4];

}

- (void)cancellButtonClicked{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    [self dismissWithClickedButtonIndex:0 animated:YES];
    [self.delegate equipcancel];
    
}

- (void)equipButtonClicked:(UIButton*)buttonNumber{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    [self.delegate equipNext:buttonNumber.tag];
    
    
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
