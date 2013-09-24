//
//  OpeningViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/07/10.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "OpeningViewController.h"

@interface OpeningViewController ()

@end

@implementation OpeningViewController

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
    
    //背景描画メソッド
    [self backGraoundDraw];
    
    //音楽再生
    
}

//背景の描画
- (void)backGraoundDraw{
    
    //背景レイヤー
    CALayer *backgroundImageLayer = [CALayer layer];
    NSString *stageName = [NSString stringWithFormat:@"opening"];
    UIImage *backgroundImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:stageName ofType:@"jpg" ]];
    
    float scale = self.view.frame.size.height/backgroundImage.size.height;
    backgroundImageLayer.frame = CGRectMake(-backgroundImage.size.width/2 + 160, 0, backgroundImage.size.width * scale, backgroundImage.size.height * scale);
    
    backgroundImageLayer.contents = (id)backgroundImage.CGImage;
    [self.view.layer addSublayer:backgroundImageLayer];
    [self.view.layer insertSublayer:backgroundImageLayer atIndex:0];
    
    //音楽再生
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"opening.mp3"];
    
    //文字が読みづらいので黒背景
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    layer.opacity = .3;
    [self.view.layer addSublayer:layer];

    //テキスト
    UITextView *openingText = [[UITextView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, self.view.frame.size.height)];
    openingText.text = @"A.D. 4238…\nかつて人類と呼ばれた生物が変わり始める時代。\n\n地球と呼ばれた星は急進する科学によって食い潰された。構造物は朽ち、大地は汚れ、海は腐り果てた。生態系は遺伝子兵器の乱用によって異形化し、空想世界の化け物のような混沌とした生き物が地上を跋扈する…\n\n私達はそんな地球にいる。でも、いつの時代もそうであるように今がとりわけ酷い時代でもないと思う。半世紀ほど前に一人の天才が、科学を超える真実の論理である”魔導科学”という学問分野を生み出したから。魔導科学は生体の霊子構造から従来の熱力学から考えられないようなエネルギーを産み、科学者達を軒並み失職させた。そして、私達人類はこの魔導科学を武器として、この死にかけの地球の再生を試みようとしている。\n\nこの物語は、私、ミリィ・ナイアが廃棄都市の調査及び危険生物排除任務に着いた話だ。誰かが気にとめたり、本になったりするような感動やオチがあるわけじゃない。でも人によっては何かの教訓は得られるかもしれない。";
    openingText.backgroundColor = [UIColor clearColor];
    [openingText setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:12]];
    openingText.textColor = [UIColor whiteColor];
    openingText.editable = NO;
    [self.view addSubview:openingText];
    
    //アニメーション
    [UITextView beginAnimations:nil context:nil];
    [UITextView setAnimationDuration:30.0];
     openingText.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    [UITextView setAnimationCurve:UIViewAnimationCurveLinear];
    [UITextView commitAnimations];
    
    
    //テキストスクロール終了後TAP!の表示が発生
    [self performSelector:@selector(tapAnywhereAppear) withObject:nil afterDelay:28.0];
    
    //テキストスクロール終了後ボタン発生
    [self performSelector:@selector(nextButtonAppear) withObject:nil afterDelay:28.0];
    
    
        
}

- (void)tapAnywhereAppear{
    
    //テキストスクロール終了後TAP!の表示が発生
    CATextLayer *tapText = [CATextLayer layer];
    [tapText setString:@"TAP ANYWHERE!"];
    tapText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
    tapText.fontSize = 20;
    tapText.foregroundColor = [UIColor whiteColor].CGColor;
    tapText.frame = CGRectMake(160, self.view.frame.size.height - 30, 150, 30);
    tapText.alignmentMode = kCAAlignmentRight;
    tapText.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:tapText];
    
    CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anime.duration = .5;
    anime.autoreverses = YES;
    anime.fromValue = [NSNumber numberWithFloat:0];
    anime.toValue = [NSNumber numberWithFloat:1];
    anime.repeatCount = HUGE_VALF;
    [tapText addAnimation:anime forKey:@"opening"];
        
}

- (void)nextButtonAppear{
    
    //NEXTボタン
    UIButton *nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextbtn.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    NSString *path = [[NSBundle mainBundle]pathForResource:@"none" ofType:@"png"];
    nextbtn.imageView.image = [UIImage imageWithContentsOfFile:path];
    [self.view addSubview:nextbtn];
    
    //NEXTボタンクリックメソッド
    [nextbtn addTarget:self action:@selector(segueStart) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)segueStart{
    
    [self performSegueWithIdentifier:@"openingToView" sender:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
