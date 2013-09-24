//
//  ViewController+Player.m
//  Milly
//
//  Created by 花澤 長行 on 2013/06/14.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "ViewController+Player.h"

@implementation ViewController (Player)

//ボタンを判断

- (void)pushedButtonNumber0:(UIButton*)button{
    
    //ターゲットを仮保存
    selectedTarget = targetMonster;
    
    button1Deley = YES;
    
    [self buttonDisable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];

    
    [buttonObject setButton1Enable:NO];
        
    [self playerAttackStart:button.tag];
    
    //インスタンスにボタン番号を仮保存
    pushedButtonNumber = 1;
    
    

}


- (void)pushedButtonNumber1:(UIButton*)button{
    
    //ターゲットを仮保存
    selectedTarget = targetMonster;
    
    button2Deley = YES;
    
    [self buttonDisable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];

    
    [buttonObject setButton2Enable:NO];
   
    [self playerAttackStart:button.tag];
    
    //インスタンスにボタン番号を仮保存
    pushedButtonNumber = 2;
    
    
    
}

- (void)pushedButtonNumber2:(UIButton*)button{
    
    //ターゲットを仮保存
    selectedTarget = targetMonster;

    
    button3Deley = YES;
    
    [buttonObject setButton3Enable:NO];
    
    [self buttonDisable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
   
    
    [self playerAttackStart:button.tag];
    
    //インスタンスにボタン番号を仮保存
    pushedButtonNumber = 3;
    
   
    
}

- (void)pushedButtonNumber3:(UIButton*)button{
    
    //ターゲットを仮保存
    selectedTarget = targetMonster;
    
    button4Deley = YES;
    
    [buttonObject setButton4Enable:NO];
    
    [self buttonDisable:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4], nil]];
   
    
    [self playerAttackStart:button.tag];
    
    //インスタンスにボタン番号を仮保存
    pushedButtonNumber = 4;
    
    
    
}

#pragma mark magicStart

//詠唱開始！
- (void)playerAttackStart:(int)buttonTag{
    
    //buttonTagは選択スキルID
        
    //カテゴリplayerMagicへ！
    [self playerMagicStart:buttonTag];
    
    //チャージを開始！
    [self performSelector:@selector(magicEffectChargeStart) withObject:nil afterDelay:0.2];
    
}

- (void)millyAnimationChange{
    
    //詠唱アニメの準備
    CAKeyframeAnimation *animation = [self playerMagicAnimation];
    animation.duration= .3;
    animation.repeatCount = HUGE_VALF;
    animation.calculationMode = kCAAnimationDiscrete;
    [millyDefault addAnimation:animation forKey:@"bakemono"];
    millyDefault.frame = CGRectMake(15, self.view.frame.size.height - 215, 128, 128);
    
    [self performSelector:@selector(playerAnimationUp) withObject:nil afterDelay:0.2];
    
    //詠唱エフェクト魔法陣
    circleLayer =[CALayer layer];
    circleLayer.frame = CGRectMake(20, self.view.frame.size.height - 215, 130,130);
    circleLayer.opacity = 0.5;
    circleLayer.contents = (id)[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"magicCircle" ofType:@"png"]].CGImage;
    [self.view.layer insertSublayer:circleLayer below:millyDefault];
    
    //[self performSelector:@selector(magicEffectAnimationStart) withObject:nil afterDelay:0.1];
    
    CABasicAnimation* rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.toValue = [NSNumber numberWithFloat:M_PI / 2.0];
    rotate.duration = 0.7;           // 0.5秒で90度回転
    rotate.repeatCount = MAXFLOAT;   // 無限に繰り返す
    rotate.cumulative = YES;         // 効果を累積
    [circleLayer addAnimation:rotate forKey:@"ImageViewRotation"];
    
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

- (void)playerAnimationUp{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.5];
    [CATransaction setCompletionBlock:^{[self playerAnimationDown];}];
    millyDefault.frame = CGRectMake(15, self.view.frame.size.height - 225, 128, 128);
    [CATransaction commit];

}

- (void)playerAnimationDown{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:3.0];
    //[CATransaction setCompletionBlock:^{[self playerAnimationUp];}];
    millyDefault.frame = CGRectMake(15, self.view.frame.size.height - 215, 128, 128);
    [CATransaction commit];
    
    
}
//詠唱アニメここまで---------------------------------------------------

//魔法陣アニメ----------------------------------------------

- (void)magicEffectAnimationStart{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    [CATransaction setCompletionBlock:^{[self magicEffectAnimationFadeOut];}];
    circleLayer.opacity = 0.7;
    [CATransaction commit];
    
}

- (void)magicEffectAnimationFadeOut{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    [CATransaction setCompletionBlock:^{[self magicEffectAnimationStart];}];
    circleLayer.opacity = 0.5;
    [CATransaction commit];
    
}
//魔法陣アニメここまで----------------------------------------------

//詠唱エフェクトチャージここから----------------------------------------------

- (void)magicEffectChargeStart{
    
    //詠唱エフェクトチャージ
    CAKeyframeAnimation *effectChargeAnimation = [self magicEffectChargeAnimation];
    // = [self magicEffectChargeAnimation];
    effectChargeAnimation.duration= .7;
    effectChargeAnimation.repeatCount = 1;
    effectChargeAnimation.calculationMode = kCAAnimationDiscrete;
    
    effectChargeLayer = [CALayer layer];
    effectChargeLayer.frame = CGRectMake(15, self.view.frame.size.height - 230, 128, 128);
    effectChargeLayer.backgroundColor = [UIColor clearColor].CGColor;
    effectChargeLayer.opacity = 0.2;
    [self.view.layer insertSublayer:effectChargeLayer above:millyDefault];
    [effectChargeLayer addAnimation:effectChargeAnimation forKey:@"charge"];
    
    //効果音再生
    [[SimpleAudioEngine sharedEngine]playEffect:@"magicCharge.mp3"];

    
}

- (CAKeyframeAnimation*)magicEffectChargeAnimation{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 7; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%02d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;

    
}

- (void)removeMagicEffectChargeLayer{
    
    [effectChargeLayer removeFromSuperlayer];
    
}

//詠唱エフェクトチャージここまで----------------------------------------------


@end
