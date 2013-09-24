//
//  DropAlertViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/06/11.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "DropAlertViewController.h"


@implementation DropAlertViewController


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
    [backGroundLayer setFrame:CGRectMake(0, 0, 320, 130)];
    backGroundLayer.opacity = 0.7;
    [self.layer addSublayer:backGroundLayer];

    //タイトル
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 320, 30)];
    [textLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    textLabel.text = @"選択したアイテムを本当に捨ててもいい？";
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [super addSubview:textLabel];

    //YESボタン
    _btnStatus = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStatus.frame = CGRectMake(80, 40, 70, 70);
    [_btnStatus setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnStatus setTitle:@"肯定" forState:UIControlStateNormal];
    [_btnStatus.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnStatus setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnStatus setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [super addSubview:_btnStatus];
    
    [_btnStatus addTarget:self action:@selector(yesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnStatusTextBackgroundLayer = [CALayer layer];
    btnStatusTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnStatusTextBackgroundLayer.opacity = 0.5;
    btnStatusTextBackgroundLayer.frame = CGRectMake(80, 80, 70, 30);
    [self.layer addSublayer:btnStatusTextBackgroundLayer];
    
    _btnStatusOverTextLayer1 = [CATextLayer layer];
    _btnStatusOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer1 setString:@"捨てたのは"];
    _btnStatusOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer1.fontSize = 10;
    _btnStatusOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer1.frame = CGRectMake(85, 85, 70, 70);
    _btnStatusOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnStatusOverTextLayer1];
    
    _btnStatusOverTextLayer2 = [CATextLayer layer];
    _btnStatusOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer2 setString:@"己が魂か？"];
    _btnStatusOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer2.fontSize = 10;
    _btnStatusOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer2.frame = CGRectMake(85, 96, 70, 70);
    _btnStatusOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnStatusOverTextLayer2];
    
    //NOボタン
    //ヘルプボタン検討中
    _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSave.frame = CGRectMake(170, 40, 70, 70);
    [_btnSave setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnSave setTitle:@"否定" forState:UIControlStateNormal];
    [_btnSave.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnSave setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [super addSubview:_btnSave];
    
    [_btnSave addTarget:self action:@selector(noButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnSaveTextBackgroundLayer = [CALayer layer];
    btnSaveTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnSaveTextBackgroundLayer.opacity = 0.5;
    btnSaveTextBackgroundLayer.frame = CGRectMake(170, 80, 70, 30);
    [self.layer addSublayer:btnSaveTextBackgroundLayer];
    
    _btnSaveOverTextLayer1 = [CATextLayer layer];
    _btnSaveOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnSaveOverTextLayer1 setString:@"思い出だけは"];
    _btnSaveOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer1.fontSize = 10;
    _btnSaveOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer1.frame = CGRectMake(175, 85, 70, 70);
    _btnSaveOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnSaveOverTextLayer1];
    
    _btnSaveOverTextLayer2 = [CATextLayer layer];
    _btnSaveOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnSaveOverTextLayer2 setString:@"捨てられない"];
    _btnSaveOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer2.fontSize = 10;
    _btnSaveOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer2.frame = CGRectMake(175, 96, 70, 70);
    _btnSaveOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnSaveOverTextLayer2];
        
}
   
- (void)noButtonClicked{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)yesButtonClicked{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    [self.delegate itemDrop2];
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
