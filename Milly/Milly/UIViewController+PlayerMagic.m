//
//  UIViewController+PlayerMagic.m
//  Milly
//
//  Created by 花澤 長行 on 2013/06/16.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "UIViewController+PlayerMagic.h"

@implementation ViewController (PlayerMagic)

- (void)playerMagicStart:(int)magicID{
    
    //magicIDからアニメーションを選ぶ
    switch (magicID) {
        case 0:
            [self performSelector:@selector(flameAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 1:
            [self performSelector:@selector(flameWallAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 2:
            [self performSelector:@selector(meteoAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 3:
            [self performSelector:@selector(iceCoffenAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 4:
            [self performSelector:@selector(brizzardAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 5:
            [self performSelector:@selector(testamentAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 6:
            [self performSelector:@selector(golemnAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 7:
            [self performSelector:@selector(shieldAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 8:
            [self performSelector:@selector(bladeDancingAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 9:
            [self performSelector:@selector(healingAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 10:
            [self performSelector:@selector(barrierAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 11:
            [self performSelector:@selector(lightKingAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 12:
            [self performSelector:@selector(painAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 13:
            [self performSelector:@selector(darkCroudAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 14:
            [self performSelector:@selector(ghostSpoilAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;
        case 15:
            [self performSelector:@selector(ghostSpoilAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;

        case 16:
            [self performSelector:@selector(ghostSpoilAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;

        case 17:
            [self performSelector:@selector(ghostSpoilAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;

        case 18:
            [self performSelector:@selector(ghostSpoilAnimation:) withObject:[NSNumber numberWithInt:magicID] afterDelay:0.5];
            break;

        default:
            break;
    }
    
}

#pragma mark flame

- (void)flameAnimation:(NSNumber*)magicID{

    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
   
    [self.view.layer addSublayer:magicAnimationLayer];
    
    //ターゲットによる場所選択
    if (targetMonster == 1) {
        
         magicAnimationLayer.frame = CGRectMake(monsterLayer1.frame.size.width/2-75, monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }else if(targetMonster == 2){
        
         magicAnimationLayer.frame = CGRectMake(monsterLayer2.frame.origin.x+(monsterLayer2.frame.size.width/2-75), monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }else{
        
         magicAnimationLayer.frame = CGRectMake(monsterLayer3.frame.origin.x+(monsterLayer3.frame.size.width/2-75), monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }
    
    //複数窓時の特殊処理

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+80,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);
    }else if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 5 && delegate.isBOSS == YES){
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+106,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);

    }
    
    

    CAKeyframeAnimation *flameAnime = [self flameAnimationStart];
    flameAnime.duration= .5;
    flameAnime.repeatCount = 1;
    flameAnime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:flameAnime forKey:@"flame"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(enemyDamageValueAppear:) withObject:magicID afterDelay:0.3];
    
    //効果音再生
     [[SimpleAudioEngine sharedEngine] playEffect:@"flame.mp3"]; //直接鳴らす
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:1.0];


    
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

#pragma mark flameWall
- (void)flameWallAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    magicAnimationLayer.frame = CGRectMake(0, monsterLayer.frame.origin.y+monsterLayer.frame.size.height*.1, 320, 160);

    [self.view.layer addSublayer:magicAnimationLayer];
    
    //全体攻撃なので選択なし
    
    CAKeyframeAnimation *anime = [self flameWallAnimationStart];
    anime.duration= .5;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"flameWall"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(allEnemyDamageValueAppear:) withObject:magicID afterDelay:0.3];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"flameWall.wav" afterDelay:0.1];
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:1.0];
    

    
}

- (CAKeyframeAnimation*)flameWallAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 7 ; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"fw%02d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;

    
}

#pragma mark meteo
- (void)meteoAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [monsterLayer addSublayer:magicAnimationLayer];
    
    if (targetMonster == 1) {
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer1.frame.size.width/2-200, -50, 360, monsterLayer1.frame.size.height*1.2);
        
    }else if(targetMonster == 2){
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer2.frame.origin.x+(monsterLayer2.frame.size.width/2-200), -50, 360, monsterLayer2.frame.size.height*1.2);
        
    }else{
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer3.frame.origin.x+(monsterLayer3.frame.size.width/2-200), -50, 360, monsterLayer3.frame.size.height*1.2);
        
    }
    
    //複数窓時の特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+80,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);
    }else if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 5 && delegate.isBOSS == YES){
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+106,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);
        
    }

    
    CAKeyframeAnimation *anime = [self meteoAnimationStart];
    anime.duration= 1.0;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"meteo"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(enemyDamageValueAppear:) withObject:magicID afterDelay:0.4];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"meteo.mp3" afterDelay:0.27];
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:1.0];
    
}

- (CAKeyframeAnimation*)meteoAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 35; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"litemt%04d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
    
}

#pragma mark icecoffin
- (void)iceCoffenAnimation:(NSNumber*)magicID{
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.view.layer addSublayer:magicAnimationLayer];
    
    //ターゲットによる場所選択
    if (targetMonster == 1) {
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer1.frame.size.width/2-75, monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }else if(targetMonster == 2){
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer2.frame.origin.x+(monsterLayer2.frame.size.width/2-75), monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }else{
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer3.frame.origin.x+(monsterLayer3.frame.size.width/2-75), monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }
    
    //複数窓時の特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+80,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);
    }else if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 5 && delegate.isBOSS == YES){
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+106,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);
        
    }
    
    CAKeyframeAnimation *anime = [self iceCoffinAnimationStart];
    anime.duration= .5;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"iceCoffin"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(enemyDamageValueAppear:) withObject:magicID afterDelay:0.2];
    
    //効果音再生
    [[SimpleAudioEngine sharedEngine] playEffect:@"iceCoffin.mp3"]; //直接鳴らす
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:1.0];
    
}

- (CAKeyframeAnimation*)iceCoffinAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 7; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"ic%02d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;

}

#pragma mark brizzard

- (void)brizzardAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    magicAnimationLayer.frame = CGRectMake(0, monsterLayer.frame.origin.y+monsterLayer.frame.size.height*.1, 320, 160);
    
    [self.view.layer addSublayer:magicAnimationLayer];
    
    //全体攻撃なので選択なし
    
    CAKeyframeAnimation *anime = [self brizzardAnimationStart];
    anime.duration= .8;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"brizzard"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(allEnemyDamageValueAppear:) withObject:magicID afterDelay:0.4];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"brizzard.mp3" afterDelay:0];
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:1.0];
}

- (CAKeyframeAnimation*)brizzardAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 7; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"br%02d",i] ofType:@"png"];
        
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;

}

#pragma mark testament
- (void)testamentAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    magicAnimationLayer.frame = CGRectMake(0, 0, 320, monsterLayer.frame.size.height);
    
    [monsterLayer addSublayer:magicAnimationLayer];
    
    //全体攻撃なので選択なし
    CAKeyframeAnimation *anime = [self testamentAnimationStart];
    anime.duration=2.0;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"testament"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(allEnemyDamageValueAppear:) withObject:magicID afterDelay:2.3];
    
    //効果音再生
    //SounSystemIDの準備
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"testament01.mp3" afterDelay:0.1];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"testament01.mp3" afterDelay:0.4];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"testament02.mp3" afterDelay:1.6];
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:10.0];
    
    //フラグ処理
    isTestament = YES;
    
    //敵モンスターのフリーズ処理
    [self performSelector:@selector(testamentFreeze) withObject:nil afterDelay:2.3];
    

}

- (CAKeyframeAnimation*)testamentAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 26; i < 100; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"ts%04d",i] ofType:@"png"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;

}

- (void)testamentFreeze{
    
    if (isMonster1Dead == NO) {
        
        CALayer *freezeLayer = [CALayer layer];
        freezeLayer.frame = CGRectMake(monsterLayer1.frame.size.width/2-40,40,80,30);
        freezeLayer.backgroundColor = [UIColor blueColor].CGColor;
        
        //複数窓時の特殊処理
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
            freezeLayer.frame = CGRectMake(monsterLayer.frame.size.width/2-40,40,80,30);
            [monsterLayer addSublayer:freezeLayer];
        
        }else{
        [monsterLayer1 addSublayer:freezeLayer];
        }
        
        
        CATextLayer *freezeText = [CATextLayer layer];
        [freezeText setString:@"FREEZE!"];
        freezeText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
        freezeText.fontSize = 25;
        freezeText.foregroundColor = [UIColor whiteColor].CGColor;
        freezeText.frame = CGRectMake(0,0, 80, 30);
        freezeText.alignmentMode = kCAAlignmentCenter;
        freezeText.contentsScale = [UIScreen mainScreen].scale;
        [freezeLayer addSublayer:freezeText];
        
        [self performSelector:@selector(deleteLayers:) withObject:freezeLayer afterDelay:6.0];
    }
    
    if ([[monsterLifeObject valueForKey:@"monsterLife2"]intValue] > 0 && monsterCount >= 2) {
        
        CALayer *freezeLayer = [CALayer layer];
        freezeLayer.frame = CGRectMake(monsterLayer2.frame.size.width/2-40,40,80,30);
        freezeLayer.backgroundColor = [UIColor blueColor].CGColor;
        [monsterLayer2 addSublayer:freezeLayer];
        
        CATextLayer *freezeText = [CATextLayer layer];
        [freezeText setString:@"FREEZE!"];
        freezeText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
        freezeText.fontSize = 25;
        freezeText.foregroundColor = [UIColor whiteColor].CGColor;
        freezeText.frame = CGRectMake(0,0, 80, 30);
        freezeText.alignmentMode = kCAAlignmentCenter;
        freezeText.contentsScale = [UIScreen mainScreen].scale;
        [freezeLayer addSublayer:freezeText];
        
        [self performSelector:@selector(deleteLayers:) withObject:freezeLayer afterDelay:6.0];
        
    }
    
    if ([[monsterLifeObject valueForKey:@"monsterLife3"]intValue] > 0 && monsterCount == 3) {
        
        CALayer *freezeLayer = [CALayer layer];
        freezeLayer.frame = CGRectMake(monsterLayer3.frame.size.width/2-40,40,80,30);
        freezeLayer.backgroundColor = [UIColor blueColor].CGColor;
        [monsterLayer3 addSublayer:freezeLayer];
        
        CATextLayer *freezeText = [CATextLayer layer];
        [freezeText setString:@"FREEZE!"];
        freezeText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
        freezeText.fontSize = 25;
        freezeText.foregroundColor = [UIColor whiteColor].CGColor;
        freezeText.frame = CGRectMake(0,0, 80, 30);
        freezeText.alignmentMode = kCAAlignmentCenter;
        freezeText.contentsScale = [UIScreen mainScreen].scale;
        [freezeLayer addSublayer:freezeText];
        
        [self performSelector:@selector(deleteLayers:) withObject:freezeLayer afterDelay:6.0];
        
    }
}

#pragma mark golemn
- (void)golemnAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    magicAnimationLayer.frame = CGRectMake(0, monsterLayer.frame.origin.y+monsterLayer.frame.size.height*.1, 320, 160);
    
    [self.view.layer addSublayer:magicAnimationLayer];
    
    //全体攻撃なので選択なし
    
    CAKeyframeAnimation *anime = [self golemnAnimationStart];
    anime.duration= 2.0;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"golemn"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(allEnemyDamageValueAppear:) withObject:magicID afterDelay:0.3];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:[NSString stringWithFormat:@"flameWall.wav"] afterDelay:0.1];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:[NSString stringWithFormat:@"golemn00.mp3"] afterDelay:0.6];
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:2.5];


}

- (CAKeyframeAnimation*)golemnAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 40; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"gl%04d",i] ofType:@"png"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;

    
}

#pragma mark shield
- (void)shieldAnimation:(NSNumber*)magicID{
    
    CALayer *shieldLayer = [CALayer layer];
    shieldLayer.backgroundColor = [UIColor clearColor].CGColor;
    shieldLayer.frame = CGRectMake(15, self.view.frame.size.height - 220, 128, 128);
    [self.view.layer addSublayer:shieldLayer];
    
    CAKeyframeAnimation *anime = [self shieldAnimationStart];
    anime.duration= .8;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [shieldLayer addAnimation:anime forKey:@"shield"];
    
    //シールドフラグON
    isShield = YES;
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"shield.mp3" afterDelay:0.35];
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:shieldLayer afterDelay:1.0];
    
    //シールドの表示メソッドへ
    [self performSelector:@selector(shieldAppear) withObject:shieldLayer afterDelay:1.0];

}

- (CAKeyframeAnimation*)shieldAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 10; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"sh%02d",i] ofType:@"png"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
}

- (void)shieldAppear{
    
    shieldBackLayer = [CALayer layer];
    shieldBackLayer.backgroundColor = [UIColor grayColor].CGColor;
    shieldBackLayer.frame = CGRectMake(15, self.view.frame.size.height - 110, 80, 20);
    [self.view.layer addSublayer:shieldBackLayer];
    
    CATextLayer *shieldTextLayer = [CATextLayer layer];
    shieldTextLayer.backgroundColor = [UIColor clearColor].CGColor;
    [shieldTextLayer setString:@"守護者の召喚"];
    shieldTextLayer.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    shieldTextLayer.fontSize = 11;
    shieldTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    shieldTextLayer.frame = CGRectMake(0, 4, 80, 16);
    shieldTextLayer.alignmentMode = kCAAlignmentCenter;
    shieldTextLayer.contentsScale = [UIScreen mainScreen].scale;
    [shieldBackLayer addSublayer:shieldTextLayer];
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"position"];
    anime.fromValue = [NSValue valueWithCGPoint:CGPointMake(-400, self.view.frame.size.height - 110)];
    anime.toValue = [NSValue valueWithCGPoint:shieldBackLayer.position];
    anime.duration = 0.2;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    [shieldBackLayer addAnimation:anime forKey:@"moveShieldBackLayer"];
    
    //ボタン使用可能
    [self buttonEnableOthers];
    
    //n秒後にスキルが切れる
    //スキルレベルに依存
    NSString *path = [[NSBundle mainBundle]pathForResource:@"skillList" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    //効果時間設定
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    int effectTime = [[[arr objectAtIndex:7]valueForKey:@"attackTime"]intValue];
    int skillLevel = [[delegate.playerSkillFirst objectAtIndex:7]intValue];
    int totalTime = effectTime + skillLevel * 1;
    
    //userInfoで渡すためにdictionaryにレイヤーを保存
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:shieldBackLayer,@"layer", nil];
    
    //タイマーを設定
    [NSTimer scheduledTimerWithTimeInterval:totalTime target:self selector:@selector(shieldMoveOut:) userInfo:dic repeats:NO];
    
    [self buttonCheck];
    
}

- (void)shieldMoveOut:(NSTimer*)timer{
    
    CALayer *layer = [timer.userInfo valueForKey:@"layer"];
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"position"];
    anime.duration = .2;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    anime.fromValue = [NSValue valueWithCGPoint:layer.position];
    anime.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x-320, layer.position.y)];
    [layer addAnimation:anime forKey:@"sheildBackLayerMoveOut"];
    
    //フラグをオフに
    isShield = NO;
    
    [self performSelector:@selector(deleteLayers:) withObject:layer afterDelay:1.0];
    
    
}

#pragma mark bladeDancing
- (void)bladeDancingAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    magicAnimationLayer.frame = CGRectMake(0, 50, 320, monsterLayer.frame.size.height);
    
    [self.view.layer addSublayer:magicAnimationLayer];
    
    //全体攻撃なので選択なし
    
    CAKeyframeAnimation *anime = [self bladeDancingAnimationStart];
    anime.duration= 2.5;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"blade"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(allEnemyDamageValueAppear:) withObject:magicID afterDelay:2.5];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:0.3];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:0.6];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:0.8];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:1.0];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:1.2];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:1.4];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:1.5];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:1.6];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:1.7];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:1.8];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:1.9];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:2.0];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:2.1];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"blade.mp3" afterDelay:2.2];
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"bladeDance01.mp3" afterDelay:2.3];
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:3.0];
}

- (CAKeyframeAnimation*)bladeDancingAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 52; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"bd%04d",i] ofType:@"png"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;

    
}

#pragma mark healing
- (void)healingAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    magicAnimationLayer.frame = CGRectMake(15, self.view.frame.size.height - 220, 128, 128);
    [self.view.layer addSublayer:magicAnimationLayer];
    
    CAKeyframeAnimation *anime = [self healingAnimationStart];
    anime.duration= .8;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"healing"];
    
    //敵体力回復処理&表示
    [self performSelector:@selector(healingCalculate:) withObject:magicID afterDelay:0.4];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"healing.wav" afterDelay:0.35];
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:1.0];

}

- (CAKeyframeAnimation*)healingAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 7; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"hl%02d",i] ofType:@"png"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
 
}

#pragma mark lightKing

- (void)lightKingAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.view.layer addSublayer:magicAnimationLayer];
    
    //ターゲットによる場所選択
    if (targetMonster == 1) {

        magicAnimationLayer.frame = CGRectMake(monsterLayer1.frame.size.width/2-75, monsterLayer1.frame.origin.y, 150, monsterLayer1.frame.size.height+80);

    }else if(targetMonster == 2){

        magicAnimationLayer.frame = CGRectMake(monsterLayer2.frame.origin.x+(monsterLayer2.frame.size.width/2-75), monsterLayer1.frame.origin.y, 150,monsterLayer1.frame.size.height+80);

    }else{

        magicAnimationLayer.frame = CGRectMake(monsterLayer3.frame.origin.x+(monsterLayer3.frame.size.width/2-75), monsterLayer1.frame.origin.y, 150, monsterLayer1.frame.size.height+80);
        
    }
    
    //複数窓時の特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+80,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);
    }else if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 5 && delegate.isBOSS == YES){
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+106,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);
        
    }

    
    CAKeyframeAnimation *anime = [self lightKingAnimationStart];
    anime.duration= .5;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"lightKing"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(enemyDamageValueAppear:) withObject:magicID afterDelay:0.2];
    
    //効果音再生
    [[SimpleAudioEngine sharedEngine] playEffect:@"lightKing.mp3"]; //直接鳴らす
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:1.0];
    
}

- (CAKeyframeAnimation*)lightKingAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 7; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"lk%02d",i] ofType:@"png"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;

}

#pragma mark barrier

- (void)barrierAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    magicAnimationLayer.frame = CGRectMake(15, self.view.frame.size.height - 220, 128, 128);
    [self.view.layer addSublayer:magicAnimationLayer];
    
    CAKeyframeAnimation *anime = [self barrierAnimationStart];
    anime.duration= .8;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"barrier"];
        
    //バリアのアニメ
    [self performSelector:@selector(barrierLayerAppear) withObject:nil afterDelay:1.0];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"barrier.mp3" afterDelay:0.4];
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:1.0];

}

- (CAKeyframeAnimation*)barrierAnimationStart{
 
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 14; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"ba%02d",i] ofType:@"png"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
    
}

- (void)barrierLayerAppear{
    
    barrierBackLayer = [CALayer layer];
    barrierBackLayer.backgroundColor = [UIColor brownColor].CGColor;
    barrierBackLayer.frame = CGRectMake(-400, self.view.frame.size.height - 120, 80, 20);
    [self.view.layer addSublayer:barrierBackLayer];
    
    CATextLayer *barrierTextLayer = [CATextLayer layer];
    barrierTextLayer.backgroundColor = [UIColor clearColor].CGColor;
    [barrierTextLayer setString:@"結界展開"];
    barrierTextLayer.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    barrierTextLayer.fontSize = 11;
    barrierTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    barrierTextLayer.frame = CGRectMake(0, 4, 80, 16);
    barrierTextLayer.alignmentMode = kCAAlignmentCenter;
    barrierTextLayer.contentsScale = [UIScreen mainScreen].scale;
    [barrierBackLayer addSublayer:barrierTextLayer];

    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"position"];
    anime.fromValue = [NSValue valueWithCGPoint:CGPointMake(-400, self.view.frame.size.height - 120)];
    anime.toValue = [NSValue valueWithCGPoint:CGPointMake(55, self.view.frame.size.height - 120)];
    anime.duration = 0.2;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    [barrierBackLayer addAnimation:anime forKey:@"moveShieldBackLayer"];
    
    //結界フラグON
    isBarrier = YES;
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    float time = [[delegate.playerSkillFirst objectAtIndex:10]floatValue] + 1;
    [self performSelector:@selector(barrierRemove:) withObject:barrierBackLayer afterDelay:time];
    
    //[self buttonEnableOthers];
    
    [self buttonCheck];
}

- (void)barrierRemove:(CALayer*)layer{
    
    //結界フラグON
    isBarrier = NO;
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"position"];
    anime.fromValue = [NSValue valueWithCGPoint:CGPointMake(55, self.view.frame.size.height - 120)];
    anime.toValue = [NSValue valueWithCGPoint:CGPointMake(-400, self.view.frame.size.height - 120)];
    anime.duration = 0.2;
    anime.removedOnCompletion = NO;
    anime.fillMode = kCAFillModeForwards;
    [layer addAnimation:anime forKey:@"moveShieldBackLayer"];

    [self performSelector:@selector(deleteLayers:) withObject:layer afterDelay:1.0];
    
    

}

#pragma mark pain
- (void)painAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.view.layer addSublayer:magicAnimationLayer];
    
    //ターゲットによる場所選択
    if (targetMonster == 1) {
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer1.frame.size.width/2-75, monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }else if(targetMonster == 2){
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer2.frame.origin.x+(monsterLayer2.frame.size.width/2-75), monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }else{
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer3.frame.origin.x+(monsterLayer3.frame.size.width/2-75), monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }
    
    //複数窓時の特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+80,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);
    }else if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 5 && delegate.isBOSS == YES){
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+106,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);
        
    }
    
    CAKeyframeAnimation *anime = [self painAnimationStart];
    anime.duration= .4;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"pain"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(enemyDamageValueAppear:) withObject:magicID afterDelay:0.2];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"pain.mp3" afterDelay:0.1];
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:1.0];
}

- (CAKeyframeAnimation*)painAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i <= 4; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"pa%02d",i] ofType:@"png"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
}

#pragma mark darkCroud
- (void)darkCroudAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    magicAnimationLayer.frame = CGRectMake(0, monsterLayer.frame.origin.y+monsterLayer.frame.size.height*.1, 320, 160);
    
    [self.view.layer addSublayer:magicAnimationLayer];
    
    //全体攻撃なので選択なし
    
    CAKeyframeAnimation *anime = [self darkCroudAnimationStart];
    anime.duration= 1.0;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"darkCroud"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(allEnemyDamageValueAppear:) withObject:magicID afterDelay:0.3];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"dark.wav" afterDelay:0.2];
    
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:3.0];
}

- (CAKeyframeAnimation*)darkCroudAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 8; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"dc%02d",i] ofType:@"png"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
}

#pragma mark ghostSpoil
- (void)ghostSpoilAnimation:(NSNumber*)magicID{
    
    CALayer *magicAnimationLayer = [CALayer layer];
    magicAnimationLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.view.layer addSublayer:magicAnimationLayer];
    
    //ターゲットによる場所選択
    if (targetMonster == 1) {
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer1.frame.size.width/2-75, monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }else if(targetMonster == 2){
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer2.frame.origin.x+(monsterLayer2.frame.size.width/2-75), monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }else{
        
        magicAnimationLayer.frame = CGRectMake(monsterLayer3.frame.origin.x+(monsterLayer3.frame.size.width/2-75), monsterLayer1.frame.origin.y+monsterLayer1.frame.size.height*.4, 150, 150);
        
    }
    
    //複数窓時の特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+80,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);
    }else if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 5 && delegate.isBOSS == YES){
        magicAnimationLayer.frame = CGRectMake(magicAnimationLayer.frame.origin.x+106,magicAnimationLayer.frame.origin.y,magicAnimationLayer.frame.size.width,magicAnimationLayer.frame.size.height);
        
    }
    
    CAKeyframeAnimation *anime = [self ghostSpoilAnimationStart];
    anime.duration= 3.0;
    anime.repeatCount = 1;
    anime.calculationMode = kCAAnimationDiscrete;
    [magicAnimationLayer addAnimation:anime forKey:@"ghost"];
    
    //敵体力減算処理&表示
    [self performSelector:@selector(enemyDamageValueAppear:) withObject:magicID afterDelay:2.7];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"ghost.mp3" afterDelay:0.1];
    
    //忘れるなレイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:magicAnimationLayer afterDelay:4.0];
    
    //特殊効果発動
    isCurse = YES;
    
    //カースレイヤーを設定
    [self performSelector:@selector(curseLayerON) withObject:nil afterDelay:3.0];
    
    
    
}

- (CAKeyframeAnimation*)ghostSpoilAnimationStart{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 30; i++) {
        NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"cu%02d",i] ofType:@"png"];
        [imageArray addObject:(id)[UIImage imageWithContentsOfFile:path].CGImage];
    }
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    animation.values = imageArray;
    
    return animation;
    
}

- (void)curseLayerON{
    
    CALayer *curseBackGroundLayer = [CALayer layer];
    curseBackGroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    if (selectedTarget == 1) {
        curseBackGroundLayer.frame = CGRectMake(monsterLayer1.frame.size.width/2-40,10,80,30);
        
    }else if(selectedTarget == 2){
        curseBackGroundLayer.frame = CGRectMake(monsterLayer2.frame.size.width/2-40,10,80,30);
        
    }else if (selectedTarget == 3){
        curseBackGroundLayer.frame = CGRectMake(monsterLayer3.frame.size.width/2-40,10,80,30);
        
    }

    //複数窓時の特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        curseBackGroundLayer.frame = CGRectMake(monsterLayer.frame.size.width/2-40,10,80,30);
        [monsterLayer addSublayer:curseBackGroundLayer];
    }else{
        
        if (selectedTarget == 1) {
            [monsterLayer1 addSublayer:curseBackGroundLayer];
        }else if(selectedTarget == 2){
            [monsterLayer2 addSublayer:curseBackGroundLayer];
        }else if (selectedTarget == 3){
            [monsterLayer3 addSublayer:curseBackGroundLayer];
        }
        
    }
    

    CATextLayer *curseText = [CATextLayer layer];
    [curseText setString:@"CURSE!"];
    curseText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    curseText.fontSize = 25;
    curseText.foregroundColor = [UIColor whiteColor].CGColor;
    curseText.frame = CGRectMake(0,0, 80, 30);
    curseText.alignmentMode = kCAAlignmentCenter;
    curseText.contentsScale = [UIScreen mainScreen].scale;
    [curseBackGroundLayer addSublayer:curseText];
    
    //カーズフラグ
    cursedTarget = selectedTarget;
    
    //一定時間後カース効果を削除
    [self performSelector:@selector(curseEffectRemove) withObject:nil afterDelay:6.0];
    
    //レイヤー削除
    [self performSelector:@selector(deleteLayers:) withObject:curseBackGroundLayer afterDelay:6.0];
    
    
}

- (void)curseEffectRemove{
    
    isCurse = NO;
    cursedTarget = 0;
    
}

#pragma mark damageCulculate
//ダメージ計算！-------------------------------------
//
//基本式は基礎魔法力*(各種適正+100%)*魔法倍率*敵適正
//
//------------------------------------------------

- (void)enemyDamageValueAppear:(NSNumber*)magicID{
    
    if (playerObject.playerLife <= 0) {
        return;
    }
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"skillList" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    //基礎魔法力
    float base = [self returnTotalPower:@"baseAttack"];
    
    //player適正
    //登録されているスキルの適正から判断する
    NSString *str = [[arr objectAtIndex:[magicID intValue]]valueForKey:@"attribute"];
    float fit = [self returnTotalPower:str];
    
    //スキルレベル
    float skillLevel = [[delegate.playerSkillFirst objectAtIndex:[magicID intValue]]floatValue];
    
    //レベル毎倍率
    float skillbairitu = [[[arr objectAtIndex:[magicID intValue]]valueForKey:@"leveledDamageUp"]floatValue];
    
    //敵の耐性を除くダメージ
    float damageValue = base*(1+fit/100)*(1+skillLevel*skillbairitu);

    //敵の耐性
    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *arr2 = [[NSArray alloc]initWithContentsOfFile:path2];
    float monsterRegist = [[[arr2 objectAtIndex:selectingMonsterID]valueForKey:str]floatValue];
    
    //最終ダメージ
    int ans = roundf(damageValue * ((100 - monsterRegist)/100));
    
    //カース状態はダメージ二倍
    if (isCurse == YES && selectedTarget == cursedTarget){
        
        ans = ans * 2;
        
    }
    
    //クリティカルが発生したらダメージ1.5倍！耐性無視！
    
    //クリティカルのダイスをふる
    int criticalDice = 1 + arc4random() % 100;
    
    if (criticalDice <= [self returnTotalPower:@"critical"]) {
        
        ans = damageValue*1.5;
        
        //クリティカル限定の表現
        [self performSelector:@selector(criticalDamageValueAppear:) withObject:[NSNumber numberWithInt:ans] afterDelay:0.3];

        
    }else{
    
        //通常の表現
        [self performSelector:@selector(damageValueAppear:) withObject:[NSNumber numberWithInt:ans] afterDelay:0.3];
        
    }
    
    //吸血
    int leechValue = ans * [self returnTotalPower:@"leech"]/100;
    
    if (leechValue > 0) {
        
        [self performSelector:@selector(healingValueAppear:) withObject:[NSNumber numberWithInt:leechValue] afterDelay:.5];
        
    }
    
   

    
        
    //敵のライフを減らす
    if (selectedTarget == 1) {
        int num = [[monsterLifeObject valueForKey:@"monsterLife1"]intValue];
        num = num - ans;
        monsterLifeObject.monsterLife1 = num;
                
    }else if(selectedTarget == 2){
        int num = [[monsterLifeObject valueForKey:@"monsterLife2"]intValue];
        num = num - ans;
        monsterLifeObject.monsterLife2 = num;
        
    }else if(selectedTarget == 3){
        int num = [[monsterLifeObject valueForKey:@"monsterLife3"]intValue];
        num = num - ans;
        monsterLifeObject.monsterLife3 = num;
        
    }
    


}

- (void)damageValueAppear:(NSNumber*)damageValue{
    
    if (playerObject.playerLife <= 0) {
        return;
    }
    
    CALayer *karilayer = [CALayer layer];
    if (selectedTarget  == 1) {
        karilayer = monsterLayer1;
    }else if(selectedTarget  == 2){
        karilayer = monsterLayer2;
    }else if(selectedTarget  == 3){
        karilayer = monsterLayer3;
    }
    
    
    //被ダメージ表示レイヤーをセット
    CATextLayer *monsterDamageText = [CATextLayer layer];
    monsterDamageText.backgroundColor = [UIColor clearColor].CGColor;
    monsterDamageText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    monsterDamageText.fontSize = 35;
    monsterDamageText.foregroundColor = [UIColor whiteColor].CGColor;
    monsterDamageText.frame = CGRectMake(karilayer.frame.origin.x+karilayer.frame.size.width/2-50,karilayer.frame.origin.y+karilayer.frame.size.height*.4, 100, 70);
    
    //複数窓時の特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        monsterDamageText.frame = CGRectMake(160-50, monsterLayer.frame.size.height*.4, 100, 70);
    }
    
    [monsterDamageText setString:[NSString stringWithFormat:@"%d", [damageValue intValue]]];
    monsterDamageText.alignmentMode = kCAAlignmentCenter;
    monsterDamageText.opacity = 1.0;
    monsterDamageText.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:monsterDamageText];
    
    //被ダメージ表示アニメ
    CABasicAnimation *damageTextAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    damageTextAnimation.fromValue = [NSNumber numberWithFloat:0];
    damageTextAnimation.toValue = [NSNumber numberWithFloat:1];
    damageTextAnimation.duration = 0.4;
    damageTextAnimation.repeatCount = 1;
    damageTextAnimation.autoreverses = YES;
    damageTextAnimation.removedOnCompletion = NO;
    damageTextAnimation.fillMode = kCAFillModeForwards;

    [monsterDamageText addAnimation:damageTextAnimation forKey:@"fadeOut"];
    
    CABasicAnimation *damageTextMove = [CABasicAnimation animationWithKeyPath:@"position"];
    damageTextMove.duration = 1.0;
    damageTextMove.repeatCount = 1;
    damageTextMove.fromValue = [NSValue valueWithCGPoint:monsterDamageText.position];
    damageTextMove.toValue = [NSValue valueWithCGPoint:CGPointMake(monsterDamageText.position.x, monsterDamageText.position.y -30)];
    
    [monsterDamageText addAnimation:damageTextMove forKey:@"textUp"];
    
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"damage0.mp3" afterDelay:0.2];

    
    //使用済みレイヤーを削除
    [self performSelector:@selector(deleteLayer:) withObject:monsterDamageText afterDelay:1];
    
    //敵が点滅する
    [self performSelector:@selector(monsterAnimationFlash:) withObject:karilayer afterDelay:0.1];
    
}

- (void)criticalDamageValueAppear:(NSNumber*)damageValue{
    
    if (playerObject.playerLife <= 0) {
        return;
    }
    
    CALayer *karilayer = [CALayer layer];
    if (selectedTarget == 1) {
        karilayer = monsterLayer1;
    }else if(selectedTarget == 2){
        karilayer = monsterLayer2;
    }else if(selectedTarget == 3){
        karilayer = monsterLayer3;
    }
        
    //被ダメージ表示レイヤーをセット
    CATextLayer *monsterDamageText = [CATextLayer layer];
    monsterDamageText.backgroundColor = [UIColor clearColor].CGColor;
    monsterDamageText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    monsterDamageText.fontSize = 45;
    monsterDamageText.foregroundColor = [UIColor yellowColor].CGColor;
    monsterDamageText.frame = CGRectMake(karilayer.frame.origin.x+karilayer.frame.size.width/2-50,karilayer.frame.origin.y+karilayer.frame.size.height*.4, 100, 70);
    
    //複数窓時の特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        monsterDamageText.frame = CGRectMake(160-50, monsterLayer.frame.size.height*.4, 100, 70);
    }
    
    [monsterDamageText setString:[NSString stringWithFormat:@"%d", [damageValue intValue]]];
    monsterDamageText.alignmentMode = kCAAlignmentCenter;
    monsterDamageText.opacity = 1.0;
    monsterDamageText.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:monsterDamageText];
    
    //被ダメージ表示アニメ
    CABasicAnimation *damageTextAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    damageTextAnimation.fromValue = [NSNumber numberWithFloat:0];
    damageTextAnimation.toValue = [NSNumber numberWithFloat:1];
    damageTextAnimation.duration = 0.4;
    damageTextAnimation.repeatCount = 1;
    damageTextAnimation.autoreverses = YES;
    damageTextAnimation.removedOnCompletion = NO;
    damageTextAnimation.fillMode = kCAFillModeForwards;
    
    [monsterDamageText addAnimation:damageTextAnimation forKey:@"fadeOut"];
    
    CABasicAnimation *damageTextMove = [CABasicAnimation animationWithKeyPath:@"position"];
    damageTextMove.duration = 1.0;
    damageTextMove.repeatCount = 1;
    damageTextMove.fromValue = [NSValue valueWithCGPoint:monsterDamageText.position];
    damageTextMove.toValue = [NSValue valueWithCGPoint:CGPointMake(monsterDamageText.position.x, monsterDamageText.position.y -30)];
    
    [monsterDamageText addAnimation:damageTextMove forKey:@"textUp"];
    
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"critical.mp3" afterDelay:.2];
    
    //使用済みレイヤーを削除
    [self performSelector:@selector(deleteLayer:) withObject:monsterDamageText afterDelay:1];
    
    //敵が点滅する
    [self performSelector:@selector(monsterAnimationFlash:) withObject:karilayer afterDelay:0.1];
    
    
    
}


- (void)deleteLayer:(CALayer*)layer{
    
    [layer removeFromSuperlayer];
}

//全体
- (void)allEnemyDamageValueAppear:(NSNumber*)magicID{
    
    if (playerObject.playerLife <= 0) {
        return;
    }
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"skillList" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    //基礎魔法力
    float base = [self returnTotalPower:@"baseAttack"];
    
    //player適正
    //登録されているスキルの適正から判断する
    NSString *str = [[arr objectAtIndex:[magicID intValue]]valueForKey:@"attribute"];
    float fit = [self returnTotalPower:str];
    
    //スキルレベル
    float skillLevel = [[delegate.playerSkillFirst objectAtIndex:[magicID intValue]]floatValue];
    
    //レベル毎倍率
    float skillbairitu = [[[arr objectAtIndex:[magicID intValue]]valueForKey:@"leveledDamageUp"]floatValue];
    
    //敵の耐性を除くダメージ
    float damageValue = base*(1+fit/100)*(1+skillLevel*skillbairitu);
    
    //敵の耐性
    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"monster" ofType:@"plist"];
    NSArray *arr2 = [[NSArray alloc]initWithContentsOfFile:path2];
    
    
    //敵全てにダメージ表記を！
    float monsterRegist = [[[arr2 objectAtIndex:[[appearMonstersArray objectAtIndex:0]intValue]]valueForKey:str]floatValue];
    int ans = roundf(damageValue * ((100 - monsterRegist)/100));
    
    //カース状態はダメージ二倍
    if (isCurse == YES ){
        
        ans = ans * 2;

    }
    
    //クリティカルが発生したらダメージ1.5倍！耐性無視！
    
    //クリティカルのダイスをふる
    int criticalDice = 1 + arc4random() % 100;
    
    if (criticalDice <= [self returnTotalPower:@"critical"]) {
        
        ans = damageValue*1.5;
        
        //吸血
        int leechValue = ans * [self returnTotalPower:@"leech"]/100;
        
        if (leechValue > 0) {
            [self performSelector:@selector(healingValueAppear:) withObject:[NSNumber numberWithInt:leechValue] afterDelay:.5];
        }
        
        
        
        //クリティカル限定の表現
        
        NSDictionary *numAndLayer = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ans],@"damage",monsterLayer1,@"layer", nil];
        
        [self performSelector:@selector(allCriticalDamageValueAppear:) withObject:numAndLayer afterDelay:0.3];
        
        if ([appearMonstersArray count] >= 2) {
            
            //吸血
            int leechValue2 = ans * [self returnTotalPower:@"leech"]/100;
            
            if (leechValue2 > 0) {
                [self performSelector:@selector(healingValueAppear:) withObject:[NSNumber numberWithInt:leechValue2] afterDelay:.6];
            }
                        
            float monsterRegist = [[[arr2 objectAtIndex:[[appearMonstersArray objectAtIndex:1]intValue]]valueForKey:str]floatValue];
            int ans = roundf(damageValue * ((100 - monsterRegist)/100));
            
            NSDictionary *numAndLayer = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ans],@"damage",monsterLayer2,@"layer", nil];
            
            [self performSelector:@selector(allCriticalDamageValueAppear:) withObject:numAndLayer afterDelay:0.3];
        }
        
        if ([appearMonstersArray count] == 3) {
            
            //吸血
            int leechValue3 = ans * [self returnTotalPower:@"leech"]/100;
            
            if (leechValue3 > 0) {
                [self performSelector:@selector(healingValueAppear:) withObject:[NSNumber numberWithInt:leechValue3] afterDelay:.7];

            }
                        
            float monsterRegist2 = [[[arr2 objectAtIndex:[[appearMonstersArray objectAtIndex:2]intValue]]valueForKey:str]floatValue];
            int ans = roundf(damageValue * ((100 - monsterRegist2)/100));
            
            NSDictionary *numAndLayer = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ans],@"damage",monsterLayer3,@"layer", nil];
            
            [self performSelector:@selector(allCriticalDamageValueAppear:) withObject:numAndLayer afterDelay:0.3];
        }

        
        
    }else{
        
        //通常の表現
        
        //吸血
        int leechValue = ans * [self returnTotalPower:@"leech"]/100;
        [self performSelector:@selector(healingValueAppear:) withObject:[NSNumber numberWithInt:leechValue] afterDelay:.5];
        
        NSDictionary *numAndLayer = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ans],@"damage",monsterLayer1,@"layer", nil];
        
        [self performSelector:@selector(allDamageValueAppear:) withObject:numAndLayer afterDelay:0.3];
        
        if ([appearMonstersArray count] >= 2) {
            
            //吸血
            int leechValue2 = ans * [self returnTotalPower:@"leech"]/100;
            
            if (leechValue2 > 0) {
                [self performSelector:@selector(healingValueAppear:) withObject:[NSNumber numberWithInt:leechValue2] afterDelay:.6];

            }
            
            float monsterRegist = [[[arr2 objectAtIndex:[[appearMonstersArray objectAtIndex:1]intValue]]valueForKey:str]floatValue];
            int ans = roundf(damageValue * ((100 - monsterRegist)/100));
            
            NSDictionary *numAndLayer = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ans],@"damage",monsterLayer2,@"layer", nil];
            
            [self performSelector:@selector(allDamageValueAppear:) withObject:numAndLayer afterDelay:0.3];
        }
        
        if ([appearMonstersArray count] == 3) {
            
            //吸血
            int leechValue3 = ans * [self returnTotalPower:@"leech"]/100;
            if (leechValue3 > 0) {
                [self performSelector:@selector(healingValueAppear:) withObject:[NSNumber numberWithInt:leechValue3] afterDelay:.7];
            }
            
            
            float monsterRegist2 = [[[arr2 objectAtIndex:[[appearMonstersArray objectAtIndex:2]intValue]]valueForKey:str]floatValue];
            int ans = roundf(damageValue * ((100 - monsterRegist2)/100));
            
            NSDictionary *numAndLayer = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ans],@"damage",monsterLayer3,@"layer", nil];
            
            [self performSelector:@selector(allDamageValueAppear:) withObject:numAndLayer afterDelay:0.3];
        }

        
    }
    
}

//全体版
- (void)allDamageValueAppear:(NSDictionary*)dic{
    
    if (playerObject.playerLife <= 0) {
        return;
    }
    
    //dicの展開
    NSNumber *damageValue = [dic valueForKey:@"damage"];
    CALayer *layer = [dic valueForKey:@"layer"];
    
    //死んでいたら処理を中途終了する
    if (isMonster1Dead == YES) {
        if (layer.frame.origin.x == 0) {
            return;
        }
    }
    
    if (isMonster2Dead == YES){
        if(layer.frame.origin.x > 0 && layer.frame.origin.x <= 200){
            return;
        }
    }
    
    if(isMonster3Dead == YES){
        if(layer.frame.origin.x > 200){
            return;
        }
    }
    
    //被ダメージ表示レイヤーをセット
    CATextLayer *monsterDamageText = [CATextLayer layer];
    monsterDamageText.backgroundColor = [UIColor clearColor].CGColor;
    monsterDamageText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    monsterDamageText.fontSize = 35;
    monsterDamageText.foregroundColor = [UIColor whiteColor].CGColor;
    monsterDamageText.frame = CGRectMake(layer.frame.origin.x+layer.frame.size.width/2-50,layer.frame.origin.y+layer.frame.size.height*.4, 100, 70);
    
    //複数窓時の特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        monsterDamageText.frame = CGRectMake(160-50, monsterLayer.frame.size.height*.4, 100, 70);
    }

    
    [monsterDamageText setString:[NSString stringWithFormat:@"%d", [damageValue intValue]]];
    monsterDamageText.alignmentMode = kCAAlignmentCenter;
    monsterDamageText.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:monsterDamageText];
    
//    //複数窓時の特殊処理
//    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
//    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
//        monsterDamageText.frame = CGRectMake(monsterDamageText.frame.origin.x+80,monsterDamageText.frame.origin.y,monsterDamageText.frame.size.width,monsterDamageText.frame.size.height);
//    }else if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 5 && delegate.isBOSS == YES){
//        monsterDamageText.frame = CGRectMake(monsterDamageText.frame.origin.x+106,monsterDamageText.frame.origin.y,monsterDamageText.frame.size.width,monsterDamageText.frame.size.height);
//        
//    }

    
    
    //被ダメージ表示アニメ
    CABasicAnimation *damageTextAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    damageTextAnimation.fromValue = [NSNumber numberWithFloat:0];
    damageTextAnimation.toValue = [NSNumber numberWithFloat:1];
    damageTextAnimation.duration = 0.4;
    damageTextAnimation.repeatCount = 1;
    damageTextAnimation.autoreverses = YES;
    damageTextAnimation.removedOnCompletion = NO;
    damageTextAnimation.fillMode = kCAFillModeForwards;
    
    [monsterDamageText addAnimation:damageTextAnimation forKey:@"fadeOut"];
    
    CABasicAnimation *damageTextMove = [CABasicAnimation animationWithKeyPath:@"position"];
    damageTextMove.duration = 1.0;
    damageTextMove.repeatCount = 1;
    damageTextMove.fromValue = [NSValue valueWithCGPoint:monsterDamageText.position];
    damageTextMove.toValue = [NSValue valueWithCGPoint:CGPointMake(monsterDamageText.position.x, monsterDamageText.position.y -30)];
    
    [monsterDamageText addAnimation:damageTextMove forKey:@"textUp"];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"damage0.mp3" afterDelay:0.2];
    
    //使用済みレイヤーを削除
    [self performSelector:@selector(deleteLayer:) withObject:monsterDamageText afterDelay:1];
    
    //敵のライフを減らす
    
    if (layer.frame.origin.x == 0) {
        
        int num = [[monsterLifeObject valueForKey:@"monsterLife1"]intValue];
        
        num = num - [damageValue intValue];
        
        monsterLifeObject.monsterLife1 = num;

        
    }else if(layer.frame.origin.x > 0 && layer.frame.origin.x <= 200){
        
        int num = [[monsterLifeObject valueForKey:@"monsterLife2"]intValue];
        
        num = num - [damageValue intValue];
        
        monsterLifeObject.monsterLife2 = num;
    }else if(layer.frame.origin.x > 200){
        
        int num = [[monsterLifeObject valueForKey:@"monsterLife3"]intValue];
        
        num = num - [damageValue intValue];
        
        monsterLifeObject.monsterLife3 = num;
    }
    
    //敵が点滅する
    [self performSelector:@selector(allMonsterAnimationFlash:) withObject:layer afterDelay:0.1];
    
    
    
}

//全体版
- (void)allCriticalDamageValueAppear:(NSDictionary*)dic{
    
    if (playerObject.playerLife <= 0) {
        return;
    }
    
    //dicの展開
    NSNumber *damageValue = [dic valueForKey:@"damage"];
    CALayer *layer = [dic valueForKey:@"layer"];
    
    //死んでいたら処理を中途終了する
    if (isMonster1Dead == YES) {
        if (layer.frame.origin.x == 0) {
            return;
        }
    }
    
    if (isMonster2Dead == YES){
        if(layer.frame.origin.x > 0 && layer.frame.origin.x <= 200){
            return;
        }
    }
    
    if(isMonster3Dead == YES){
        if(layer.frame.origin.x > 200){
            return;
        }
    }
    
    //被ダメージ表示レイヤーをセット
    CATextLayer *monsterDamageText = [CATextLayer layer];
    monsterDamageText.backgroundColor = [UIColor clearColor].CGColor;
    monsterDamageText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    monsterDamageText.fontSize = 45;
    monsterDamageText.foregroundColor = [UIColor yellowColor].CGColor;
    monsterDamageText.frame = CGRectMake(layer.frame.origin.x+layer.frame.size.width/2-50,layer.frame.origin.y+layer.frame.size.height*.4, 100, 70);
    
    //複数窓時の特殊処理
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
        monsterDamageText.frame = CGRectMake(160-50, monsterLayer.frame.size.height*.4, 100, 70);
    }

    
    [monsterDamageText setString:[NSString stringWithFormat:@"%d", [damageValue intValue]]];
    monsterDamageText.alignmentMode = kCAAlignmentCenter;
    monsterDamageText.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:monsterDamageText];
    
//    //複数窓時の特殊処理
//    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
//    if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 2 && [[delegate.playerPara valueForKey:@"currentStage"]intValue] <= 4 && delegate.isBOSS == YES) {
//        monsterDamageText.frame = CGRectMake(monsterDamageText.frame.origin.x+80,monsterDamageText.frame.origin.y,monsterDamageText.frame.size.width,monsterDamageText.frame.size.height);
//    }else if ([[delegate.playerPara valueForKey:@"currentStage"]intValue] >= 5 && delegate.isBOSS == YES){
//        monsterDamageText.frame = CGRectMake(monsterDamageText.frame.origin.x+106,monsterDamageText.frame.origin.y,monsterDamageText.frame.size.width,monsterDamageText.frame.size.height);
//        
//    }
    
    //被ダメージ表示アニメ
    CABasicAnimation *damageTextAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    damageTextAnimation.fromValue = [NSNumber numberWithFloat:0];
    damageTextAnimation.toValue = [NSNumber numberWithFloat:1];
    damageTextAnimation.duration = 0.4;
    damageTextAnimation.repeatCount = 1;
    damageTextAnimation.autoreverses = YES;
    damageTextAnimation.removedOnCompletion = NO;
    damageTextAnimation.fillMode = kCAFillModeForwards;
    
    [monsterDamageText addAnimation:damageTextAnimation forKey:@"fadeOut"];
    
    CABasicAnimation *damageTextMove = [CABasicAnimation animationWithKeyPath:@"position"];
    damageTextMove.duration = 1.0;
    damageTextMove.repeatCount = 1;
    damageTextMove.fromValue = [NSValue valueWithCGPoint:monsterDamageText.position];
    damageTextMove.toValue = [NSValue valueWithCGPoint:CGPointMake(monsterDamageText.position.x, monsterDamageText.position.y -30)];
    
    [monsterDamageText addAnimation:damageTextMove forKey:@"textUp"];
    
    //効果音再生
    [self performSelector:@selector(magicEffectSoundStart:) withObject:@"critical.mp3" afterDelay:.2];
    
    //使用済みレイヤーを削除
    [self performSelector:@selector(deleteLayer:) withObject:monsterDamageText afterDelay:1];
    
    //敵のライフを減らす
    
    if (layer.frame.origin.x == 0) {
        
        int num = [[monsterLifeObject valueForKey:@"monsterLife1"]intValue];
        
        num = num - [damageValue intValue];
        
        monsterLifeObject.monsterLife1 = num;
        
        
    }else if(layer.frame.origin.x > 0 && layer.frame.origin.x <= 200){
        
        int num = [[monsterLifeObject valueForKey:@"monsterLife2"]intValue];
        
        num = num - [damageValue intValue];
        
        monsterLifeObject.monsterLife2 = num;
    }else if(layer.frame.origin.x > 200){
        
        int num = [[monsterLifeObject valueForKey:@"monsterLife3"]intValue];
        
        num = num - [damageValue intValue];
        
        monsterLifeObject.monsterLife3 = num;
    }
    
    //敵が点滅する
    [self performSelector:@selector(allMonsterAnimationFlash:) withObject:layer afterDelay:0.1];
    
}


- (int)returnTotalPower:(NSString*)string{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    int totalPara = [[delegate.playerPara valueForKey:string]intValue];
    
    //itemのplist３種読み込み
    NSString* filePath0 = [[NSBundle mainBundle] pathForResource:@"itemName" ofType:@"plist"];
    NSArray *_itemNamearr = [[NSArray alloc] initWithContentsOfFile:filePath0];
    NSString* filePath1 = [[NSBundle mainBundle] pathForResource:@"itemPreName" ofType:@"plist"];
    NSArray  *_itemPreNamearr = [[NSArray alloc] initWithContentsOfFile:filePath1];
    NSString* filePath2 = [[NSBundle mainBundle] pathForResource:@"itemAfter1Name" ofType:@"plist"];
    NSArray  *_itemAfter1Namearr = [[NSArray alloc] initWithContentsOfFile:filePath2];
    NSString* filePath3 = [[NSBundle mainBundle] pathForResource:@"itemAfter2Name" ofType:@"plist"];
    NSArray *_itemAfter2Namearr = [[NSArray alloc] initWithContentsOfFile:filePath3];

    
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
    
    int total = total1 + total2 + total3 + total4 + total5 + total6 + total7 + total8 + total9 + total10 + total11 + total12 + total13 + total14 + total15 + total16 + totalPara;
    return total;
    
}

//ダメージ計算！ここまで-------------------------------------


- (void)monsterAnimationFlash:(CALayer*)layer{
 
    CABasicAnimation *monsterFlash = [CABasicAnimation animationWithKeyPath:@"opacity"];
    monsterFlash.fromValue = [NSNumber numberWithFloat:1];
    monsterFlash.toValue = [NSNumber numberWithFloat:0];
    monsterFlash.repeatCount = 2;
    monsterFlash.duration = 0.05;
    monsterFlash.autoreverses = YES;
    [layer addAnimation:monsterFlash forKey:@"flash;"];
    
    //ちょっと場違いだけどボタン復帰メソッド起動
    [self buttonCheck];
    
    
}


//全体版
- (void)allMonsterAnimationFlash:(CALayer*)layer{
    
    CABasicAnimation *monsterFlash = [CABasicAnimation animationWithKeyPath:@"opacity"];
    monsterFlash.fromValue = [NSNumber numberWithFloat:1];
    monsterFlash.toValue = [NSNumber numberWithFloat:0];
    monsterFlash.repeatCount = 2;
    monsterFlash.duration = 0.05;
    monsterFlash.autoreverses = YES;
    [layer addAnimation:monsterFlash forKey:@"flash;"];
    
    [self buttonCheck];
    
}

- (void)buttonCheck{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"skillList" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    if (button1Deley == NO) {
        [buttonObject setButton1Enable:YES];
    }else if( pushedButtonNumber == 1){
        
        float delayTime = [[[arr objectAtIndex:[[delegate.playerSkillEquipedPlist objectAtIndex:pushedButtonNumber - 1]intValue]]valueForKey:@"delay"] floatValue];
        [self performSelector:@selector(delayFlagOn:) withObject:[NSNumber numberWithInt:0] afterDelay:delayTime];
    }
    
    if (button2Deley == NO) {
        [buttonObject setButton2Enable:YES];
    }else if( pushedButtonNumber == 2){
        float delayTime = [[[arr objectAtIndex:[[delegate.playerSkillEquipedPlist objectAtIndex:pushedButtonNumber - 1]intValue]]valueForKey:@"delay"] floatValue];
        [self performSelector:@selector(delayFlagOn:) withObject:[NSNumber numberWithInt:1] afterDelay:delayTime];
    }
    
    if (button3Deley == NO) {
        [buttonObject setButton3Enable:YES];
    }else if( pushedButtonNumber == 3){
        float delayTime = [[[arr objectAtIndex:[[delegate.playerSkillEquipedPlist objectAtIndex:pushedButtonNumber - 1]intValue]]valueForKey:@"delay"] floatValue];
        [self performSelector:@selector(delayFlagOn:) withObject:[NSNumber numberWithInt:2] afterDelay:delayTime];
    }
    
    if (button4Deley == NO) {
        [buttonObject setButton4Enable:YES];
    }else if( pushedButtonNumber == 4){
        float delayTime = [[[arr objectAtIndex:[[delegate.playerSkillEquipedPlist objectAtIndex:pushedButtonNumber - 1]intValue]]valueForKey:@"delay"] floatValue];
        [self performSelector:@selector(delayFlagOn:) withObject:[NSNumber numberWithInt:3] afterDelay:delayTime];
    }
    
}

- (void)delayFlagOn:(NSNumber*)num{
    
    int intNum = [num intValue];
    if (intNum == 0) {
        button1Deley = NO;
        [buttonObject setButton1Enable:YES];
    }
    
    if (intNum == 1) {
        button2Deley = NO;
        [buttonObject setButton2Enable:YES];
    }
    
    if (intNum == 2) {
        button3Deley = NO;
        [buttonObject setButton3Enable:YES];
    }
    
    if (intNum == 3) {
        button4Deley = NO;
        [buttonObject setButton4Enable:YES];
    }
    
    
}


#pragma mark healingCalculate

- (void)healingCalculate:(NSNumber*)magicID{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"skillList" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
    
    //基礎魔法力
    float base = [self returnTotalPower:@"baseAttack"];
    
    //player適正
    //登録されているスキルの適正から判断する
    NSString *str = [[arr objectAtIndex:[magicID intValue]]valueForKey:@"attribute"];
    float fit = [self returnTotalPower:str];
    
    //スキルレベル
    float skillLevel = [[delegate.playerSkillFirst objectAtIndex:[magicID intValue]]floatValue];
    
    //レベル毎倍率
    float skillbairitu = [[[arr objectAtIndex:[magicID intValue]]valueForKey:@"leveledDamageUp"]floatValue];
    
    //敵の耐性を除くダメージ
    float damageValue = base*(1+fit/100)*(1+skillLevel*skillbairitu);
    
    [self performSelector:@selector(healingValueAppear:) withObject:[NSNumber numberWithInt:damageValue] afterDelay:0.3];
    
    [self buttonCheck];

}

- (void)healingValueAppear:(NSNumber*)damageValue{
       
    //表示レイヤーをセット
    CATextLayer *monsterDamageText = [CATextLayer layer];
    monsterDamageText.backgroundColor = [UIColor clearColor].CGColor;
    monsterDamageText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    monsterDamageText.fontSize = 35;
    monsterDamageText.foregroundColor = [UIColor greenColor].CGColor;
    monsterDamageText.frame = CGRectMake(30,self.view.frame.size.height-200, 100, 70);
    [monsterDamageText setString:[NSString stringWithFormat:@"%d", [damageValue intValue]]];
    monsterDamageText.alignmentMode = kCAAlignmentCenter;
    monsterDamageText.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:monsterDamageText];
    
    //表示アニメ
    CABasicAnimation *damageTextAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    damageTextAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(80, self.view.frame.size.height-190)];
    damageTextAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(80, self.view.frame.size.height-250)];
    damageTextAnimation.duration = 0.3;
    damageTextAnimation.repeatCount = 1;
    damageTextAnimation.removedOnCompletion = NO;
    damageTextAnimation.fillMode = kCAFillModeForwards;
    [monsterDamageText addAnimation:damageTextAnimation forKey:@"fadeOut"];
    
    CABasicAnimation *damageTextFadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    damageTextFadeOut.fromValue = [NSNumber numberWithFloat:1];
    damageTextFadeOut.toValue = [NSNumber numberWithFloat:0];
    damageTextFadeOut.duration = 1.0f;
    damageTextFadeOut.removedOnCompletion = NO;
    damageTextFadeOut.fillMode = kCAFillModeForwards;
    [monsterDamageText addAnimation:damageTextFadeOut forKey:@"fadeOut2"];
    
    
    //使用済みレイヤーを削除
    [self performSelector:@selector(deleteLayer:) withObject:monsterDamageText afterDelay:1];
    
    //監視
    if ([[playerObject valueForKey:@"playerLife"]intValue] < 0) {
        return;
    }
    
    //ライフを加算
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    int newValue;
    
    if ([[delegate.playerPara valueForKey:@"currentLife"]intValue] + [damageValue intValue] > [[delegate.playerPara valueForKey:@"maxLife"]intValue]) {
        newValue = [[delegate.playerPara valueForKey:@"maxLife"]intValue];
    }else{
        newValue = [[delegate.playerPara valueForKey:@"currentLife"]intValue] + [damageValue intValue];
    }
    
    //delegateに戻す
    NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithDictionary:delegate.playerPara];
    [mudic setValue:[NSNumber numberWithInt:newValue] forKey:@"currentLife"];
    delegate.playerPara = [NSDictionary dictionaryWithDictionary:mudic];
    
    //表示の更新
    [lifeLabel setText:[NSString stringWithFormat:@"LIFE : %05d / %05d",newValue,[[delegate.playerPara valueForKey:@"maxLife"]intValue]]];
    
    //監視に値を送る
    [playerObject setPlayerLife:newValue];
    
    //ボタン使用可能メソッドへ！
    //[self buttonEnableOthers];
    //
}

#pragma mark - common
//共通部分

- (void)magicEffectSoundStart:(NSString*)string{
    
    [[SimpleAudioEngine sharedEngine]playEffect:string];
}

//レイヤー削除
- (void)deleteLayers:(CALayer*)layer{
    [layer removeFromSuperlayer];
}

//ボタン使用可能へ
- (void)buttonEnableOthers{
    
//    NSArray *arr = [[NSArray alloc]init];
//    if (pushedButtonNumber == 1) {
//        arr = @[[NSNumber numberWithInt:4],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3]];
//    }else if(pushedButtonNumber == 2){
//        arr = @[[NSNumber numberWithInt:4],[NSNumber numberWithInt:1],[NSNumber numberWithInt:3]];
//    }else if(pushedButtonNumber == 3){
//        arr = @[[NSNumber numberWithInt:4],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2]];
//    }else if(pushedButtonNumber == 4){
//        arr = @[[NSNumber numberWithInt:2],[NSNumber numberWithInt:1],[NSNumber numberWithInt:3]];
//    }
//    
//    [self buttonEnable:arr];
    
    
}

//勝利処理へ
- (void)win{
    
    //レイヤー達を削除
    [targetLayer removeFromSuperlayer];
    [monsterLayer removeFromSuperlayer];
    [circleLayer removeFromSuperlayer];
    [effectChargeLayer removeFromSuperlayer];
    
    [targetButton1 removeFromSuperview];
    [targetButton2 removeFromSuperview];
    [targetButton3 removeFromSuperview];
    
    [timerBackGround1 removeFromSuperlayer];
    [timerBackGround2 removeFromSuperlayer];
    [timerBackGround3 removeFromSuperlayer];
    [timerBackGround4 removeFromSuperlayer];
       
    [playerObject removeObserver:self forKeyPath:@"playerLife"];
    
    if (isBarrier == YES) {
        [barrierBackLayer removeFromSuperlayer];
    }
    
    if(isShield == YES){
        [shieldBackLayer removeFromSuperlayer];
    }
    
    [self performSelector:@selector(deleteLayer:) withObject:monsterLayer afterDelay:1.0];
    
    WinAlertViewController *winAlert = [[WinAlertViewController alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil];
        
    winAlert.tag = 5;

    [winAlert show];
    

        
}

@end
