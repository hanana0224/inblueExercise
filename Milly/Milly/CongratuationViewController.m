//
//  CongratuationViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/07/28.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "CongratuationViewController.h"

@implementation CongratuationViewController

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
    
    NSLog(@"きた！");
    
    //背景
    CALayer *backGroundLayer = [CALayer layer];
    backGroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    [backGroundLayer setFrame:CGRectMake(0, 0, 320, 400)];
    backGroundLayer.opacity = 0.7;
    [self.layer addSublayer:backGroundLayer];
    
    //背景レイヤーは半透明なため、もう一つ下地レイヤーを用意?
    CALayer *backGroundLayerAnother = [CALayer layer];
    backGroundLayerAnother.backgroundColor = [UIColor clearColor].CGColor;
    [backGroundLayerAnother setFrame:CGRectMake(0, 0, 320, 400)];
    [self.layer addSublayer:backGroundLayerAnother];
    
    //WIN!!の表示
    CATextLayer *winText = [CATextLayer layer];
    winText.backgroundColor = [UIColor clearColor].CGColor;
    [winText setString:@"CONGRATUATION!"];
    winText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    winText.fontSize = 40;
    winText.foregroundColor = [UIColor whiteColor].CGColor;
    winText.frame = CGRectMake(15, 5, 305, 60);
    winText.contentsScale = [UIScreen mainScreen].scale;
    [backGroundLayerAnother addSublayer:winText];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 80, 290, 400)];
    textView.editable = NO;
    textView.text = @"プレイしてくれてありがとうございます。\n開発者のおはなです。( ´・ω・)\n\n現バージョンではミリィ達の旅はここまでです。次回のアップデートにて続きを実装する予定です。大変申し訳ございませんが、しばらくのお待ちをお願いいたします。もし宜しければご意見＆ご感想＆レビューの投稿などをしていただけるとモチベがぐんとあがってリリースが早くなるかもしれません（たぶん）また、「こんなスキルはどう？」などの発案なども大歓迎です。";
    [textView setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    textView.textColor = [UIColor whiteColor];
    textView.backgroundColor = [UIColor clearColor];
    [super addSubview:textView];
    
    //探索ボタン
    UIButton *btnGo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGo.frame = CGRectMake(240, self.frame.size.height - 130, 70, 70);
    [btnGo setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btnGo setTitle:@"評価" forState:UIControlStateNormal];
    [btnGo.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnGo setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnGo setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    btnGo.exclusiveTouch = YES;
    [super addSubview:btnGo];
    
    [btnGo addTarget:self action:@selector(postReview) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnGoTextBackgroundLayer = [CALayer layer];
    btnGoTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnGoTextBackgroundLayer.opacity = 0.5;
    btnGoTextBackgroundLayer.frame = CGRectMake(240, self.frame.size.height - 90, 70, 30);
    [self.layer addSublayer:btnGoTextBackgroundLayer];
    
    CATextLayer *btnGoOverTextLayer1 = [CATextLayer layer];
    btnGoOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [btnGoOverTextLayer1 setString:@"レビューを"];
    btnGoOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    btnGoOverTextLayer1.fontSize = 10;
    btnGoOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    btnGoOverTextLayer1.frame = CGRectMake(245, self.frame.size.height - 85, 70, 70);
    [btnGoOverTextLayer1 setRasterizationScale:[[UIScreen mainScreen] scale]];
    [btnGoOverTextLayer1 setShouldRasterize:YES];
    btnGoOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:btnGoOverTextLayer1];
    
    CATextLayer *btnGoOverTextLayer2 = [CATextLayer layer];
    btnGoOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [btnGoOverTextLayer2 setString:@"投稿する"];
    btnGoOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    btnGoOverTextLayer2.fontSize = 10;
    btnGoOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    btnGoOverTextLayer2.frame = CGRectMake(245, self.frame.size.height - 74, 70, 70);
    btnGoOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:btnGoOverTextLayer2];
    
    
    //休憩ボタン
    UIButton *btnRest = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRest.frame = CGRectMake(160, self.frame.size.height - 130, 70, 70);
    [btnRest setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btnRest setTitle:@"復帰" forState:UIControlStateNormal];
    [btnRest.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [btnRest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRest setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnRest setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    btnRest.exclusiveTouch = YES;
    [super addSubview:btnRest];
    
    [btnRest addTarget:self action:@selector(gobackGame) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnRestTextBackgroundLayer = [CALayer layer];
    btnRestTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnRestTextBackgroundLayer.opacity = 0.5;
    btnRestTextBackgroundLayer.frame = CGRectMake(160, self.frame.size.height - 90, 70, 30);
    [self.layer addSublayer:btnRestTextBackgroundLayer];
    
    CATextLayer *btnRestOverTextLayer1 = [CATextLayer layer];
    btnRestOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [btnRestOverTextLayer1 setString:@"ゲームに"];
    btnRestOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    btnRestOverTextLayer1.fontSize = 10;
    btnRestOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    btnRestOverTextLayer1.frame = CGRectMake(165, self.frame.size.height - 85, 70, 70);
    btnRestOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:btnRestOverTextLayer1];
    
    CATextLayer *btnRestOverTextLayer2 = [CATextLayer layer];
    btnRestOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [btnRestOverTextLayer2 setString:@"戻ります"];
    btnRestOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    btnRestOverTextLayer2.fontSize = 10;
    btnRestOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    btnRestOverTextLayer2.frame = CGRectMake(165, self.frame.size.height - 74, 70, 70);
    btnRestOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:btnRestOverTextLayer2];


}

- (void)postReview{
    
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=680098855&mt=8&type=Purple+Software"];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void)gobackGame{
    
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
