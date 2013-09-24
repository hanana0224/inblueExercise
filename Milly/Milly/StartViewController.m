//
//  StartViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/05/29.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@property(nonatomic) AVAudioPlayer *bgm;
@property AVAudioPlayer *soundEffect;

@property CALayer *lay;

@property (nonatomic, retain) MrdIconLoader* iconLoader;

@end

@implementation StartViewController

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
        
    
    //背景セット
    CALayer *backPortrait = [CALayer layer];
    backPortrait.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    
    if (self.view.frame.size.height == 460) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"milly02_640x920" ofType:@"png"];
        backPortrait.contents = (id)[UIImage imageWithContentsOfFile:path].CGImage;
    }else{
        NSString *path = [[NSBundle mainBundle]pathForResource:@"milly02" ofType:@"png"];
        backPortrait.contents = (id)[UIImage imageWithContentsOfFile:path].CGImage;
    }
    
    [self.view.layer addSublayer:backPortrait];
    [self.view.layer insertSublayer:backPortrait atIndex:0];
    
    //黒下地
    CALayer *backGround = [CALayer layer];
    backGround.frame = CGRectMake(0, self.view.frame.size.height - 220, 320, 180);
    backGround.backgroundColor = [UIColor blackColor].CGColor;
    backGround.opacity = .5;
    [self.view.layer addSublayer:backGround];
    
//    CATextLayer *titleLayer = [CATextLayer layer];
//    titleLayer.backgroundColor = [UIColor clearColor].CGColor;
//    [titleLayer setString:@"TOTOTO Project 1.0"];
//    titleLayer.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
//    titleLayer.fontSize = 15;
//    titleLayer.foregroundColor = [UIColor whiteColor].CGColor;
//    titleLayer.alignmentMode = kCAAlignmentRight;
//    titleLayer.frame = CGRectMake(15, self.view.frame.size.height - 160, 295, 40);
//    titleLayer.contentsScale = [UIScreen mainScreen].scale;
//    [self.view.layer addSublayer:titleLayer];

    NSString *str = [[NSBundle mainBundle]pathForResource:@"titlelogo04" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:str];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.frame = CGRectMake(10, self.view.frame.size.height-260, 320, 200);
    [self.view addSubview:imgView];
    
    //ロードボタン
    UIButton *loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loadButton.frame = CGRectMake(240, self.view.frame.size.height - 130, 70, 70);
    [loadButton setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [loadButton setTitle:@"読込" forState:UIControlStateNormal];
    [loadButton.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loadButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [loadButton setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:loadButton];
    
    [loadButton addTarget:self action:@selector(segueLoad) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnGoTextBackgroundLayer = [CALayer layer];
    btnGoTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnGoTextBackgroundLayer.opacity = 0.5;
    btnGoTextBackgroundLayer.frame = CGRectMake(240, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnGoTextBackgroundLayer];
    
    CATextLayer *btnGoOverTextLayer1 = [CATextLayer layer];
    btnGoOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [btnGoOverTextLayer1 setString:@"続きを"];
    btnGoOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    btnGoOverTextLayer1.fontSize = 10;
    btnGoOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    btnGoOverTextLayer1.frame = CGRectMake(245, self.view.frame.size.height - 85, 70, 70);
    btnGoOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:btnGoOverTextLayer1];
    
    CATextLayer *btnGoOverTextLayer2 = [CATextLayer layer];
    btnGoOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [btnGoOverTextLayer2 setString:@"しましょ？"];
    btnGoOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    btnGoOverTextLayer2.fontSize = 10;
    btnGoOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    btnGoOverTextLayer2.frame = CGRectMake(245, self.view.frame.size.height - 74, 70, 70);
    btnGoOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:btnGoOverTextLayer2];

    //最初からボタン
    UIButton *btnRest = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRest.frame = CGRectMake(160, self.view.frame.size.height - 130, 70, 70);
    [btnRest setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btnRest setTitle:@"最初" forState:UIControlStateNormal];
    [btnRest.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [btnRest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRest setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnRest setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:btnRest];
    
    [btnRest addTarget:self action:@selector(segueOpening) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnRestTextBackgroundLayer = [CALayer layer];
    btnRestTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnRestTextBackgroundLayer.opacity = 0.5;
    btnRestTextBackgroundLayer.frame = CGRectMake(160, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnRestTextBackgroundLayer];
    
    CATextLayer *btnRestOverTextLayer1 = [CATextLayer layer];
    btnRestOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [btnRestOverTextLayer1 setString:@"始めから"];
    btnRestOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    btnRestOverTextLayer1.fontSize = 10;
    btnRestOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    btnRestOverTextLayer1.frame = CGRectMake(165, self.view.frame.size.height - 85, 70, 70);
    btnRestOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:btnRestOverTextLayer1];
    
    CATextLayer *btnRestOverTextLayer2 = [CATextLayer layer];
    btnRestOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [btnRestOverTextLayer2 setString:@"したいな"];
    btnRestOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    btnRestOverTextLayer2.fontSize = 10;
    btnRestOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    btnRestOverTextLayer2.frame = CGRectMake(165, self.view.frame.size.height - 74, 70, 70);
    btnRestOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:btnRestOverTextLayer2];
    
    //レビューボタン
    UIButton *btnReview = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReview.frame = CGRectMake(80, self.view.frame.size.height - 130, 70, 70);
    [btnReview setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btnReview setTitle:@"評価" forState:UIControlStateNormal];
    [btnReview.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [btnReview setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnReview setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnReview setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:btnReview];
    
    [btnReview addTarget:self action:@selector(postReview) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnReviewTextBackgroundLayer = [CALayer layer];
    btnReviewTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnReviewTextBackgroundLayer.opacity = 0.5;
    btnReviewTextBackgroundLayer.frame = CGRectMake(80, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnReviewTextBackgroundLayer];
    
    CATextLayer *btnReviewOverTextLayer1 = [CATextLayer layer];
    btnReviewOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [btnReviewOverTextLayer1 setString:@"レビューを"];
    btnReviewOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    btnReviewOverTextLayer1.fontSize = 10;
    btnReviewOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    btnReviewOverTextLayer1.frame = CGRectMake(85, self.view.frame.size.height - 85, 70, 70);
    btnReviewOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:btnReviewOverTextLayer1];
    
    CATextLayer *btnReviewOverTextLayer2 = [CATextLayer layer];
    btnReviewOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [btnReviewOverTextLayer2 setString:@"投稿する"];
    btnReviewOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    btnReviewOverTextLayer2.fontSize = 10;
    btnReviewOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    btnReviewOverTextLayer2.frame = CGRectMake(85, self.view.frame.size.height - 74, 70, 70);
    btnReviewOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:btnReviewOverTextLayer2];
    
    //広告！-------------------------------------------------------------
    MrdIconLoader* iconLoader = [[MrdIconLoader alloc]init]; // (1)
    CGRect frame = CGRectMake(0,self.view.frame.size.height - 130,75,75);
    MrdIconCell* iconCell = [[MrdIconCell alloc]initWithFrame:frame]; // (2)
    [iconLoader addIconCell:iconCell];  // (3)
    [self.view addSubview:iconCell];  // (4)
    [iconLoader startLoadWithMediaCode: @"id680098855"]; // (5)
    iconLoader.refreshInterval = 10;
    _iconLoader = iconLoader; // (6)
    
    //----------------------------------------------------------------------


}


- (void)viewDidDisappear:(BOOL)animated{
    [_bgm stop];
}

- (void)segueOpening{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    //最初からの場合（装備スキル）
    delegate.playerSkillEquipedPlist = @[[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:3],[NSNumber numberWithInt:9]];
    
    //最初からの場合（スキルレベル）
    NSString* path = [[NSBundle mainBundle] pathForResource:@"playerSkillLevelFirst" ofType:@"plist"];
    delegate.playerSkillFirst = [[NSArray alloc]initWithContentsOfFile:path];
    
    //最初からの場合（アイテム）
    NSString *itemPath = [[NSBundle mainBundle]pathForResource:@"playerItemFirst" ofType:@"plist"];
    delegate.playerItem = [[NSArray alloc]initWithContentsOfFile:itemPath];
    
    //最初からの場合（パラメーター）
    NSString *statusPath = [[NSBundle mainBundle]pathForResource:@"playerFirst" ofType:@"plist"];
    delegate.playerPara = [NSDictionary dictionaryWithContentsOfFile:statusPath];

    
    [self performSegueWithIdentifier:@"start" sender:self];
    [self.view removeFromSuperview];
    
}

- (void)segueLoad{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString* path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"playerEquipSkill1.plist"];
    BOOL rt = [manager fileExistsAtPath:path];
    //NSLog(@"rt: %d",rt);
    
    if (rt == 0) {
        
        //セーブしましたのメッセージ
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
        [equipMessage setString:[NSString stringWithFormat:@"ゲームデータが存在しません。"]];
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

        
        
    }else{
    
    
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        
        //続きからの場合（装備スキル）
        NSString *fileName0 = @"playerEquipSkill1.plist";
        NSString *pathHome0 = NSHomeDirectory();
        NSString *filePath0 = [[pathHome0 stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName0];
        NSArray *fileData0 = [[NSArray alloc] initWithContentsOfFile:filePath0];
        delegate.playerSkillEquipedPlist = fileData0;
        
        //続きからの場合（スキルレベル）
        NSString *fileName1 = @"playerSkill1.plist";
        NSString *pathHome1 = NSHomeDirectory();
        NSString *filePath1 = [[pathHome1 stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName1];
        NSArray *fileData1 = [[NSArray alloc] initWithContentsOfFile:filePath1];
        delegate.playerSkillFirst = fileData1;
        
        //続きからアイテム
        NSString *fileName2 = @"playerItem1.plist";
        NSString *pathHome2 = NSHomeDirectory();
        NSString *filePath2 = [[pathHome2 stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName2];
        NSArray *fileData2 = [[NSArray alloc] initWithContentsOfFile:filePath2];
        delegate.playerItem = fileData2;
        
        //続きからパラメーター
        NSString *fileName3 = @"playerPara1.plist";
        NSString *pathHome3 = NSHomeDirectory();
        NSString *filePath3 = [[pathHome3 stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName3];
        NSDictionary *fileData3 = [NSDictionary dictionaryWithContentsOfFile:filePath3];
        delegate.playerPara = fileData3;
        
        [self performSegueWithIdentifier:@"load" sender:self];
        
        [self.view removeFromSuperview];
    }
    
}

- (void)postReview{
    
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/jp/app/maoto-mo-fato-gui-fangto/id680098855?mt=8"];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
