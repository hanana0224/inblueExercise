//
//  SkillUpViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/07/08.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "SkillUpViewController.h"

@implementation SkillUpViewController

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
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"skillList" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    //タイトル
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 320, 30)];
    [textLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    textLabel.text = [NSString stringWithFormat:@"『%@』を成長させてもいい？",[[arr objectAtIndex:self.tag]valueForKey:@"name" ]];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [super addSubview:textLabel];
    
    //残りスキルポイント表記
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    _skillPointLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 320, 30)];
    [_skillPointLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    _skillPointLabel.text = [NSString stringWithFormat:@"残りスキルポイント:%@", [delegate.playerPara valueForKey:@"skillPoint"]];
    _skillPointLabel.backgroundColor = [UIColor clearColor];
    _skillPointLabel.textColor = [UIColor whiteColor];
    _skillPointLabel.textAlignment = NSTextAlignmentCenter;
    [super addSubview:_skillPointLabel];

    
    //YESボタン
    _btnStatus = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStatus.frame = CGRectMake(80, 50, 70, 70);
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
    btnStatusTextBackgroundLayer.frame = CGRectMake(80, 90, 70, 30);
    [self.layer addSublayer:btnStatusTextBackgroundLayer];
    
    _btnStatusOverTextLayer1 = [CATextLayer layer];
    _btnStatusOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer1 setString:@"強くなきゃ"];
    _btnStatusOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer1.fontSize = 10;
    _btnStatusOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer1.frame = CGRectMake(85, 95, 70, 70);
    _btnStatusOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnStatusOverTextLayer1];
    
    _btnStatusOverTextLayer2 = [CATextLayer layer];
    _btnStatusOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer2 setString:@"正しくない"];
    _btnStatusOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer2.fontSize = 10;
    _btnStatusOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer2.frame = CGRectMake(85, 106, 70, 70);
    _btnStatusOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnStatusOverTextLayer2];
    
    //NOボタン
    //ヘルプボタン検討中
    _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSave.frame = CGRectMake(170, 50, 70, 70);
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
    btnSaveTextBackgroundLayer.frame = CGRectMake(170, 90, 70, 30);
    [self.layer addSublayer:btnSaveTextBackgroundLayer];
    
    _btnSaveOverTextLayer1 = [CATextLayer layer];
    _btnSaveOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnSaveOverTextLayer1 setString:@"やっぱ"];
    _btnSaveOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer1.fontSize = 10;
    _btnSaveOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer1.frame = CGRectMake(175, 95, 70, 70);
    _btnSaveOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnSaveOverTextLayer1];
    
    _btnSaveOverTextLayer2 = [CATextLayer layer];
    _btnSaveOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnSaveOverTextLayer2 setString:@"やーめとこ"];
    _btnSaveOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer2.fontSize = 10;
    _btnSaveOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer2.frame = CGRectMake(175, 106, 70, 70);
    _btnSaveOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnSaveOverTextLayer2];

}


- (void)yesButtonClicked{
    
    //alertViewを閉じる
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
    //いつもの
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    //選択スキルを+1
    NSMutableArray *muarr = [[NSMutableArray alloc]initWithArray:delegate.playerSkillFirst];
    int num = [[muarr objectAtIndex:self.tag]intValue];
    num = num + 1;
    [muarr replaceObjectAtIndex:self.tag withObject:[NSNumber numberWithInt:num]];
    delegate.playerSkillFirst = muarr;
    
    //スキルポイントを-1
    int value = [[delegate.playerPara valueForKey:@"skillPoint"]intValue];
    value = value - 1;
    NSMutableDictionary *muarr2 = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
    [muarr2 setValue:[NSNumber numberWithInt:value] forKey:@"skillPoint"];
    delegate.playerPara = muarr2;
    
    //ラベルを更新
    [self.delegate skillPointLabelUpdate];

    //効果音再生
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    //MagicSetViewのテーブルをリロード
    [self.delegate skillTableReload];
    
    //フラグをリセット
    [self.delegate flagOFF];
    
    [self autoSave];
    
}

- (void)noButtonClicked{
    
    //効果音再生
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    //MagicSetViewのフラグをオフ
    [self.delegate skillUpFlagOFF];
    
    //alertViewを閉じる
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
    

    
}

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
