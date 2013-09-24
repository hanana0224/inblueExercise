//
//  BattleAlertViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/06/11.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "BattleAlertViewController.h"

@implementation BattleAlertViewController

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
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"letsBattle.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"esc01.mp3"];
    
    //デフォルトアラートを隠します
    for (UIView *subview in self.subviews) {
        subview.hidden = YES;
    }
    
    
    //背景
    CALayer *backGroundLayer = [CALayer layer];
    backGroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    [backGroundLayer setFrame:CGRectMake(0, self.layer.frame.size.height/2-65, 320, 130)];
    backGroundLayer.opacity = 0.7;
    [self.layer addSublayer:backGroundLayer];
    
    //タイトル
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.layer.frame.size.height/2-55, 320, 30)];
    [textLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    textLabel.text = @"死を与えるのは私？それとも化物？";
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [super addSubview:textLabel];
    


    
    //戦闘ボタン
    _btnStatus = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStatus.frame = CGRectMake(80, self.layer.frame.size.height/2 - 25, 70, 70);
    [_btnStatus setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnStatus setTitle:@"戦闘" forState:UIControlStateNormal];
    [_btnStatus.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnStatus setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnStatus setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [super addSubview:_btnStatus];
    
    [_btnStatus addTarget:self action:@selector(battleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnStatusTextBackgroundLayer = [CALayer layer];
    btnStatusTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnStatusTextBackgroundLayer.opacity = 0.5;
    btnStatusTextBackgroundLayer.frame = CGRectMake(80, self.layer.frame.size.height/2 + 15, 70, 30);
    [self.layer addSublayer:btnStatusTextBackgroundLayer];
    
    _btnStatusOverTextLayer1 = [CATextLayer layer];
    _btnStatusOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer1 setString:@"消えなよ"];
    _btnStatusOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer1.fontSize = 10;
    _btnStatusOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer1.frame = CGRectMake(85, self.layer.frame.size.height/2 + 20, 70, 70);
    _btnStatusOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnStatusOverTextLayer1];
    
    _btnStatusOverTextLayer2 = [CATextLayer layer];
    _btnStatusOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer2 setString:@"邪魔だからさ"];
    _btnStatusOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer2.fontSize = 10;
    _btnStatusOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer2.frame = CGRectMake(85, self.layer.frame.size.height/2 + 31, 70, 70);
    _btnStatusOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnStatusOverTextLayer2];
    


    
    //逃走ボタン
    
    
    
    _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSave.frame = CGRectMake(170, self.layer.frame.size.height/2 - 25, 70, 70);
    [_btnSave setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnSave setTitle:@"逃走" forState:UIControlStateNormal];
    [_btnSave.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnSave setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    if (delegate.isBOSS == YES) {
        _btnSave.enabled = NO;
    }
    
    [super addSubview:_btnSave];
    
    
    [_btnSave addTarget:self action:@selector(escapeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnSaveTextBackgroundLayer = [CALayer layer];
    btnSaveTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnSaveTextBackgroundLayer.opacity = 0.5;
    btnSaveTextBackgroundLayer.frame = CGRectMake(170, self.layer.frame.size.height/2 + 15, 70, 30);
    [self.layer addSublayer:btnSaveTextBackgroundLayer];
    
    _btnSaveOverTextLayer1 = [CATextLayer layer];
    _btnSaveOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnSaveOverTextLayer1 setString:@"あー…"];
    _btnSaveOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer1.fontSize = 10;
    _btnSaveOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer1.frame = CGRectMake(175, self.layer.frame.size.height/2 + 20, 70, 70);
    _btnSaveOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnSaveOverTextLayer1];
    
    _btnSaveOverTextLayer2 = [CATextLayer layer];
    _btnSaveOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnSaveOverTextLayer2 setString:@"めんどくさい"];
    _btnSaveOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnSaveOverTextLayer2.fontSize = 10;
    _btnSaveOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnSaveOverTextLayer2.frame = CGRectMake(175, self.layer.frame.size.height/2 + 31, 70, 70);
    _btnSaveOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_btnSaveOverTextLayer2];
    
    //FOE演出
    
    
    if(delegate.isFOE == YES) {
        
        //アラート音
        _alarm = [[SimpleAudioEngine sharedEngine]playEffect:@"Alarm.mp3" pitch:1 pan:1 gain:1.2];
        
        //コーション！！！
        [self cautionAppear];
        
    }
    
    //BOSS演出
    
    if (delegate.isBOSS == YES) {
        
        [self performSelector:@selector(flame:) withObject:btnSaveTextBackgroundLayer afterDelay:.5];
        
    }

}

- (void)cautionAppear{
    
    //上アラートの透明背景
    CALayer *backGroundClearLayer1 = [CALayer layer];
    backGroundClearLayer1.backgroundColor = [UIColor clearColor].CGColor;
    backGroundClearLayer1.frame = CGRectMake(0, self.layer.frame.size.height/2- 120, 320, 35);
    [self.layer addSublayer:backGroundClearLayer1];
    
    //下アラートの透明背景
    CALayer *backGroundClearLayer2 = [CALayer layer];
    backGroundClearLayer2.backgroundColor = [UIColor clearColor].CGColor;
    backGroundClearLayer2.frame = CGRectMake(0, self.layer.frame.size.height/2+ 85, 320, 35);
    [self.layer addSublayer:backGroundClearLayer2];
    
    [self cautionText:backGroundClearLayer1];
    [self cautionText:backGroundClearLayer2];    
    
}

- (void)cautionText:(CALayer*)layer{
    
    //アラート上帯
    CALayer *cautionUp1 = [CALayer layer];
    cautionUp1.frame = CGRectMake(0, 0, 320, 3);
    cautionUp1.backgroundColor = [UIColor yellowColor].CGColor;
    [layer addSublayer:cautionUp1];
    
    //アラート下帯
    CALayer *cautionDown1 = [CALayer layer];
    cautionDown1.frame = CGRectMake(0, 32, 320, 3);
    cautionDown1.backgroundColor = [UIColor yellowColor].CGColor;
    [layer addSublayer:cautionDown1];
    
    //アラート文字
    CATextLayer *cautionText1 = [CATextLayer layer];
    [cautionText1 setString:@"          CAUTION!!!              CAUTION!!!"];
    cautionText1.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    cautionText1.fontSize = 30;
    cautionText1.foregroundColor = [UIColor yellowColor].CGColor;
    cautionText1.frame = CGRectMake(-320, 0, 320, 30);
    cautionText1.contentsScale = [UIScreen mainScreen].scale;
    [layer addSublayer:cautionText1];
    
    //アラート文字
    CATextLayer *cautionText2 = [CATextLayer layer];
    [cautionText2 setString:@"          CAUTION!!!              CAUTION!!!"];
    cautionText2.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    cautionText2.fontSize = 30;
    cautionText2.foregroundColor = [UIColor yellowColor].CGColor;
    cautionText2.frame = CGRectMake(0, 0, 320, 30);
    cautionText2.contentsScale = [UIScreen mainScreen].scale;
    [layer addSublayer:cautionText2];
    
    [self performSelector:@selector(cautionAnimation:) withObject:cautionText1 afterDelay:.1];
    [self performSelector:@selector(cautionAnimation:) withObject:cautionText2 afterDelay:.1];
}



- (void)cautionAnimation:(CALayer*)layer{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:20.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    layer.frame = CGRectMake(layer.frame.origin.x + 320, layer.frame.origin.y, layer.frame.size.width, layer.frame.size.height);
    [CATransaction setCompletionBlock:^{
        
        //layer.opacity = 0;
        
    }];
    [CATransaction commit];
    
}

- (void)flame:(CALayer*)layer{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    magicAnimationLayer.frame = CGRectMake(70, self.layer.frame.size.height/2 - 140, 270, 270);
    //magicAnimationLayer.frame = CGRectMake(100, 100, 100, 100);
    //magicAnimationLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:magicAnimationLayer];
    
    CAKeyframeAnimation *flameAnime = [self flameAnimationStart];
    flameAnime.duration= .7;
    flameAnime.repeatCount = 1;
    flameAnime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:flameAnime forKey:@"flame"];
    
    //効果音再生
    [[SimpleAudioEngine sharedEngine] playEffect:@"flame.mp3"]; //直接鳴らす
    
    //レイヤーなど削除
    [self performSelector:@selector(deleteLayersWithDelay:) withObject:layer afterDelay:.5];
    
}

- (CAKeyframeAnimation*)flameAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 9; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"fl%02d",i] ofType:@"png"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
    
}

- (void)deleteLayersWithDelay:(CALayer*)layer{
    [self deleteLayer:_btnSaveOverTextLayer1];
    [self deleteLayer:_btnSaveOverTextLayer2];
    [self deleteLayer:layer];
    [self deleteView:_btnSave];
}

- (void)deleteLayer:(CALayer*)layer{
    
    [layer removeFromSuperlayer];
    
}

- (void)deleteView:(UIView*)view{
    [view removeFromSuperview];
    
}

- (void)battleButtonClicked{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"letsBattle.mp3"];
    [self dismissWithClickedButtonIndex:0 animated:YES];
    [self removeFromSuperview];
    
    if (delegate.isBOSS == YES) {
        
        [self.delegate bossBattleStarted];
        return;
    }
    
    if (delegate.isFOE == YES) {
        
        [self.delegate FOEBatteleStarted];
        [[SimpleAudioEngine sharedEngine]stopEffect:_alarm];
    
    }else{
    
    [self.delegate battleStarted];
    
    }
}

- (void)escapeButtonClicked{
    
    //逃走判定ロール
    int ran = arc4random() % 3;
    
    //逃走失敗！
    if (ran == 0) {
        
        [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine]playEffect:@"escapeMiss.mp3" pitch:1.5f pan:1.0f gain:1.5f];
        
        CALayer *backGround = [CALayer layer];
        backGround.frame = CGRectMake(0,self.frame.size.height/2-50,320,130);
        backGround.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:backGround];
        
        UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0,self.frame.size.height/2-40,320,130)];
        message.text = @"逃走失敗";
        [message setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:40]];
        message.backgroundColor = [UIColor clearColor];
        message.textColor = [UIColor whiteColor];
        message.textAlignment = NSTextAlignmentCenter;
        [super addSubview:message];
        
        [self performSelector:@selector(battleButtonClicked) withObject:nil afterDelay:1.5f];
        
//        CATextLayer *equipMessage = [CATextLayer layer];
//        equipMessage.backgroundColor = [UIColor blackColor].CGColor;
//        [equipMessage setString:[NSString stringWithFormat:@"逃走失敗"]];
//        equipMessage.alignmentMode = kCAAlignmentCenter;
//        equipMessage.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
//        equipMessage.fontSize = 40;
//        equipMessage.foregroundColor = [UIColor whiteColor].CGColor;
//        equipMessage.frame = CGRectMake(0,self.frame.size.height/2-10,320,130);
//        equipMessage.contentsScale = [UIScreen mainScreen].scale;
//        equipMessage.contentsGravity = kCAGravityCenter;
//        [self.layer addSublayer:equipMessage];
//        
//        CABasicAnimation *animation;
//        animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//        animation.duration = 1.5f;
//        animation.fromValue = [NSNumber numberWithFloat:1.0f];
//        animation.toValue = [NSNumber numberWithFloat:0];
//        animation.autoreverses = NO;
//        animation.repeatCount = 1;
//        animation.removedOnCompletion = NO;
//        animation.fillMode = kCAFillModeForwards;
//        animation.delegate = self;
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//        [equipMessage addAnimation:animation forKey:@"opacityAnimation"];
        

    //逃走成功！
    }else{
        
        //効果音再生
        [[SimpleAudioEngine sharedEngine]playEffect:@"esc01.mp3"];
        
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        
        //FOEの場合
        if (delegate.isFOE == YES) {
            
            [[SimpleAudioEngine sharedEngine]stopEffect:_alarm];
            delegate.isFOE = NO;
            
        }
        
        [self autoSave];
        
        [self dismissWithClickedButtonIndex:0 animated:YES];
        [self removeFromSuperview];
        [self.delegate escapeSelected];

    }
    
    
    
        
    
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
        
    [self battleButtonClicked];
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
