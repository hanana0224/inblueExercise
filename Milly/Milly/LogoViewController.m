//
//  LogoViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/07/23.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "LogoViewController.h"

@interface LogoViewController ()

@end

@implementation LogoViewController

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
    
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"bgm_maoudamashii_healing03.mp3"];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"logo" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    imgView.frame = CGRectMake(30, -30, 320, 320*img.size.height/img.size.width);
    [self.view addSubview:imgView];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [UIImageView beginAnimations:nil context:nil];  // 条件指定開始
    [UIImageView setAnimationDuration:.7];  // 2秒かけてアニメーションを終了させる
    [UIImageView setAnimationDelay:0];  // 3秒後にアニメーションを開始する
    [UIImageView setAnimationRepeatCount:1];  // アニメーションを5回繰り返す
    [UIImageView setAnimationCurve:UIViewAnimationCurveLinear];  // アニメーションは一定速度
    imgView.frame = CGRectMake(30, self.view.frame.size.height/2, 320, 320*img.size.height/img.size.width);
    
    [UIImageView commitAnimations];  // アニメーション開始！
    
    [self performSelector:@selector(segueGo) withObject:nil afterDelay:3];
    
}

//- (void)soundGo{
//    
//    [[SimpleAudioEngine sharedEngine]playEffect:@"logo.mp3"];
//    
//    [self performSelector:@selector(segueGo) withObject:nil afterDelay:2.2];
//}

- (void)segueGo{
    [self performSegueWithIdentifier:@"logoToStart" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
