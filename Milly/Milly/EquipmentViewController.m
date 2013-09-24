//
//  EquipmentViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/06/03.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "EquipmentViewController.h"

@interface EquipmentViewController ()

{
    ADBannerView *adView;
    BOOL bannerIsVisible;
    BOOL fastViewFlag;
}


@property UITableView *itemTable;
@property UITableViewCell *cell;

@property NSArray *itemNamearr;
@property NSArray *itemPreNamearr;
@property NSArray *itemAfter1Namearr;
@property NSArray *itemAfter2Namearr;

//セル展開用
@property NSMutableDictionary *selectedIndexes;
@property NSMutableArray *selectedIndexPaths;
@property NSIndexPath *index;

//セル内容
@property UILabel *baseDamageAddLabel;
@property UILabel *baseDefenceLabel;
@property UILabel *criticalLabel;
@property UILabel *avoidLabel;
@property UILabel *leechLabel;

@property UILabel *physicalLabel;
@property UILabel *fireLabel;
@property UILabel *freezeLabel;
@property UILabel *holyLabel;
@property UILabel *darkLabel;

//ボタン表記シリーズ
@property UIButton *btnGo;
@property CATextLayer *btnGoOverTextLayer1;
@property CATextLayer *btnGoOverTextLayer2;

@property UIButton *btnRest;
@property CATextLayer *btnRestOverTextLayer1;
@property CATextLayer *btnRestOverTextLayer2;

@property UIButton *btnStatus;
@property CATextLayer *btnStatusOverTextLayer1;
@property CATextLayer *btnStatusOverTextLayer2;

@property UIButton *btnDrop;
@property CATextLayer *btnDropText1;
@property CATextLayer *btnDropText2;

//モード判別
@property BOOL isEquip;
@property BOOL isDrop;

//装備変更スロット
@property int buttonNum;

//装備アイテムナンバー
@property NSMutableDictionary *equipItemMuDic;

//捨てるアイテムインデックス
@property NSIndexPath *dropIndexPath;

//所持数表記
@property UILabel *itemCountLabel;


@end

@implementation EquipmentViewController

//初期のセルの高さ設定
#define kCellHeight 30.0


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
    
    // iAD ------------------------------------------------
    // バナービューの作成
    UIScreen *sc = [UIScreen mainScreen];
    CGRect rect = sc.applicationFrame;
    adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0,rect.size.height - 100,0,0)];
    adView.delegate = self;
    adView.autoresizesSubviews = YES;
    adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:adView];
    adView.alpha = 0.0;
    //-----------------------------------------------------

    
    _isEquip = NO;
    _equipItemMuDic = [NSMutableDictionary dictionary];
    
    //背景セット
    CALayer *backPortrait = [CALayer layer];
    backPortrait.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    
    if (self.view.frame.size.height == 460) {
        backPortrait.contents = (id)[UIImage imageNamed:@"milly02_640x920.png"].CGImage;
    }else{
        backPortrait.contents = (id)[UIImage imageNamed:@"milly02.png"].CGImage;
    }
    
    [self.view.layer addSublayer:backPortrait];
    [self.view.layer insertSublayer:backPortrait atIndex:0];
    
    CALayer *backLayerFilter = [CALayer layer];
    backLayerFilter.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    backLayerFilter.opacity = 0.7;
    backLayerFilter.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:backLayerFilter];
    [self.view.layer insertSublayer:backLayerFilter atIndex:1];

    //右上のアイテム個数の表記
    [self itemCountLabelUpdate];

    
    //テーブルセット
    _itemTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 320, self.view.frame.size.height -150) style:UITableViewStylePlain];
    _itemTable.delegate = self;
    _itemTable.dataSource = self;
    [self.view addSubview:_itemTable];
    
    //セルの展開アニメ
    _selectedIndexes = [[NSMutableDictionary alloc] init];
    _selectedIndexPaths = [[NSMutableArray alloc]init];
    
    //itemのplist4種読み込み
    NSString* filePath0 = [[NSBundle mainBundle] pathForResource:@"itemName" ofType:@"plist"];
    _itemNamearr = [[NSArray alloc] initWithContentsOfFile:filePath0];
    NSString* filePath1 = [[NSBundle mainBundle] pathForResource:@"itemPreName" ofType:@"plist"];
    _itemPreNamearr = [[NSArray alloc] initWithContentsOfFile:filePath1];
    NSString* filePath2 = [[NSBundle mainBundle] pathForResource:@"itemAfter1Name" ofType:@"plist"];
    _itemAfter1Namearr = [[NSArray alloc] initWithContentsOfFile:filePath2];
    NSString* filePath3 = [[NSBundle mainBundle] pathForResource:@"itemAfter2Name" ofType:@"plist"];
    _itemAfter2Namearr = [[NSArray alloc] initWithContentsOfFile:filePath3];
    
#pragma mark - equipButton
    
    //装備ボタン
    _btnGo = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnGo.frame = CGRectMake(242, self.view.frame.size.height - 130, 70, 70);
    [_btnGo setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnGo setTitle:@"装備" forState:UIControlStateNormal];
    [_btnGo.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnGo setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnGo setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnGo];
    
    [_btnGo addTarget:self action:@selector(equip) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnGoTextBackgroundLayer = [CALayer layer];
    btnGoTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnGoTextBackgroundLayer.opacity = 0.5;
    btnGoTextBackgroundLayer.frame = CGRectMake(242, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnGoTextBackgroundLayer];
    
    _btnGoOverTextLayer1 = [CATextLayer layer];
    _btnGoOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnGoOverTextLayer1 setString:@"正解は"];
    _btnGoOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnGoOverTextLayer1.fontSize = 10;
    _btnGoOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnGoOverTextLayer1.frame = CGRectMake(247, self.view.frame.size.height - 85, 70, 70);
    _btnGoOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnGoOverTextLayer1];
    
    _btnGoOverTextLayer2 = [CATextLayer layer];
    _btnGoOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnGoOverTextLayer2 setString:@"一つじゃない"];
    _btnGoOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnGoOverTextLayer2.fontSize = 10;
    _btnGoOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnGoOverTextLayer2.frame = CGRectMake(247, self.view.frame.size.height - 74, 70, 70);
    _btnGoOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnGoOverTextLayer2];

#pragma mark sortButton
    //ソートボタン
    _btnRest = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRest.frame = CGRectMake(164, self.view.frame.size.height - 130, 70, 70);
    [_btnRest setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnRest setTitle:@"整列" forState:UIControlStateNormal];
    [_btnRest.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnRest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnRest setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnRest setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnRest];
    
    [_btnRest addTarget:self action:@selector(sortButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnRestTextBackgroundLayer = [CALayer layer];
    btnRestTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnRestTextBackgroundLayer.opacity = 0.5;
    btnRestTextBackgroundLayer.frame = CGRectMake(164, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnRestTextBackgroundLayer];
    
    _btnRestOverTextLayer1 = [CATextLayer layer];
    _btnRestOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnRestOverTextLayer1 setString:@"ソートすれば"];
    _btnRestOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnRestOverTextLayer1.fontSize = 10;
    _btnRestOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnRestOverTextLayer1.frame = CGRectMake(169, self.view.frame.size.height - 85, 70, 70);
    _btnRestOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnRestOverTextLayer1];
    
    _btnRestOverTextLayer2 = [CATextLayer layer];
    _btnRestOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnRestOverTextLayer2 setString:@"見えること"];
    _btnRestOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnRestOverTextLayer2.fontSize = 10;
    _btnRestOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnRestOverTextLayer2.frame = CGRectMake(169, self.view.frame.size.height - 74, 70, 70);
    _btnRestOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnRestOverTextLayer2];
    
#pragma mark DropButton
    //捨てるボタン
    _btnDrop = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDrop.frame = CGRectMake(86, self.view.frame.size.height - 130, 70, 70);
    [_btnDrop setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnDrop setTitle:@"廃棄" forState:UIControlStateNormal];
    [_btnDrop.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnDrop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnDrop setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnDrop setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnDrop];
    
    [_btnDrop addTarget:self action:@selector(itemDroped) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnStatusTextBackgroundLayer2 = [CALayer layer];
    btnStatusTextBackgroundLayer2.backgroundColor = [UIColor blackColor].CGColor;
    btnStatusTextBackgroundLayer2.opacity = 0.5;
    btnStatusTextBackgroundLayer2.frame = CGRectMake(86, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnStatusTextBackgroundLayer2];
    
    _btnDropText1 = [CATextLayer layer];
    _btnDropText1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnDropText1 setString:@"いらない物は"];
    _btnDropText1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnDropText1.fontSize = 10;
    _btnDropText1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnDropText1.frame = CGRectMake(91, self.view.frame.size.height - 85, 70, 70);
    _btnDropText1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnDropText1];
    
    _btnDropText2 = [CATextLayer layer];
    _btnDropText2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnDropText2 setString:@"いらないから"];
    _btnDropText2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnDropText2.fontSize = 10;
    _btnDropText2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnDropText2.frame = CGRectMake(91, self.view.frame.size.height - 74, 70, 70);
    _btnDropText2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnDropText2];



#pragma mark goBackButton
    //戻るボタン
    _btnStatus = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnStatus.frame = CGRectMake(8, self.view.frame.size.height - 130, 70, 70);
    [_btnStatus setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [_btnStatus setTitle:@"復帰" forState:UIControlStateNormal];
    [_btnStatus.titleLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:24]];
    [_btnStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnStatus setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnStatus setTitleEdgeInsets:UIEdgeInsetsMake(-25, -17, 0, 0)];
    [self.view addSubview:_btnStatus];
    
    [_btnStatus addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *btnStatusTextBackgroundLayer = [CALayer layer];
    btnStatusTextBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
    btnStatusTextBackgroundLayer.opacity = 0.5;
    btnStatusTextBackgroundLayer.frame = CGRectMake(8, self.view.frame.size.height - 90, 70, 30);
    [self.view.layer addSublayer:btnStatusTextBackgroundLayer];
    
    _btnStatusOverTextLayer1 = [CATextLayer layer];
    _btnStatusOverTextLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer1 setString:@"夏休みも"];
    _btnStatusOverTextLayer1.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer1.fontSize = 10;
    _btnStatusOverTextLayer1.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer1.frame = CGRectMake(13, self.view.frame.size.height - 85, 70, 70);
    _btnStatusOverTextLayer1.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnStatusOverTextLayer1];
    
    _btnStatusOverTextLayer2 = [CATextLayer layer];
    _btnStatusOverTextLayer2.backgroundColor = [UIColor clearColor].CGColor;
    [_btnStatusOverTextLayer2 setString:@"いつか終わる"];
    _btnStatusOverTextLayer2.font = CGFontCreateWithFontName( (CFStringRef)@"HiraMinProN-W6" );
    _btnStatusOverTextLayer2.fontSize = 10;
    _btnStatusOverTextLayer2.foregroundColor = [UIColor whiteColor].CGColor;
    _btnStatusOverTextLayer2.frame = CGRectMake(13, self.view.frame.size.height - 74, 70, 70);
    _btnStatusOverTextLayer2.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:_btnStatusOverTextLayer2];
}

- (void)itemCountLabelUpdate{
    
    [_itemCountLabel removeFromSuperview];
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    
    _itemCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 0, 50, 30)];
    _itemCountLabel.text = [NSString stringWithFormat:@"%d/50",[delegate.playerItem count]];
    _itemCountLabel.backgroundColor = [UIColor clearColor];
    [_itemCountLabel setTextColor:[UIColor whiteColor]];
    [_itemCountLabel setFont:[UIFont fontWithName:@"AmericanCaptain" size:20]];
    [self.view addSubview:_itemCountLabel];

}

#pragma mark equipmentMethod
//装備
- (void)equip{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    _isDrop = NO;
        
    CustomAlertView *alert = [[CustomAlertView alloc]initWithTitle:@"装備変更" message:@"変更する装備欄を選択してください" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"装備1", nil];
    alert.tag = 0;
    
    [alert show];
        
}

- (void)equipNext:(int)buttonNumber{
    
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
    [equipMessage setString:[NSString stringWithFormat:@"装備欄%dに装備したいアイテムを選択してください",buttonNumber]];
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
    
    //フラグ管理
    _isEquip = YES;
    
    _buttonNum = buttonNumber;
    
}

- (void)equipcancel{
    
    //フラグ管理
    _isEquip = NO;
    
}

//ソートする
- (void)sortButtonClicked{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    //フラグ管理
    _isEquip = NO;
    _isDrop = NO;
    
    
    SortAlertViewController *alert = [[SortAlertViewController alloc]initWithTitle:@"装備変更" message:@"変更する装備欄を選択してください" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"装備1", nil];
    alert.tag = 1;
    [alert show];

}

//アイテムソートここから---------------------------------------

- (void)sort:(int)buttonNumber{
       
    if (buttonNumber == 0) {
        NSString *key = @"baseAttack";
        [self sort2:key];
    }else if(buttonNumber == 1){
        NSString *key = @"baseDefence";
        [self sort2:key];
    }else if(buttonNumber == 2){
        NSString *key = @"critical";
        [self sort2:key];
    }else if(buttonNumber == 3){
        NSString *key = @"avoid";
        [self sort2:key];
    }else if(buttonNumber == 4){
        NSString *key = @"fire";
        [self sort2:key];
    }else if(buttonNumber == 5){
        NSString *key = @"freeze";
        [self sort2:key];
    }else if(buttonNumber == 6){
        NSString *key = @"holy";
        [self sort2:key];
    }else if(buttonNumber == 7){
        NSString *key = @"dark";
        [self sort2:key];
    }else if(buttonNumber == 8){
        NSString *key = @"physical";
        [self sort2:key];
    }else if(buttonNumber == 9){
        NSString *key = @"leech";
        [self sort2:key];
    }
    
}
    
- (void)sort2:(NSString*)key{
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSMutableArray *muarr = [[NSMutableArray alloc]init];
   
    for (id obj in delegate.playerItem) {

        NSInteger num0 = [[[_itemNamearr valueForKey:key]objectAtIndex:[[obj valueForKey:@"name"]intValue]]integerValue];
        NSInteger num1 = [[[_itemPreNamearr valueForKey:key]objectAtIndex:[[obj valueForKey:@"pre"]intValue]]integerValue];
        NSInteger num2 = [[[_itemAfter1Namearr valueForKey:key]objectAtIndex:[[obj valueForKey:@"after1"]intValue]]integerValue];
        NSInteger num3 = [[[_itemAfter2Namearr valueForKey:key]objectAtIndex:[[obj valueForKey:@"after2"]intValue]]integerValue];
        
        NSInteger total = num0+num1+num2+num3;
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:total],@"total",[obj valueForKey:@"name"],@"name",[obj valueForKey:@"pre"],@"pre",[obj valueForKey:@"after1"],@"after1",[obj valueForKey:@"after2"],@"after2",[obj valueForKey:@"equip"],@"equip",nil];
        
        [muarr addObject:dic];

    }
    
    NSArray *arr = [muarr copy];
    
    //ソート対象となるキーを指定した、NSSortDescriptorの生成
    NSSortDescriptor *sortDescNumber = [[NSSortDescriptor alloc] initWithKey:@"total" ascending:NO];
    
    // NSSortDescriptorは配列に入れてNSArrayに渡す
    NSArray *sortDescArray = [NSArray arrayWithObjects:sortDescNumber, nil];
    
    // ソートの実行
    NSArray *sortArray;
    sortArray = [arr sortedArrayUsingDescriptors:sortDescArray];
    
    delegate.playerItem = sortArray;
    [_itemTable reloadData];

}

//アイテムソートここまで---------------------------------------

//アイテム捨てる
- (void)itemDroped{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
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
    [equipMessage setString:[NSString stringWithFormat:@"捨てるアイテムを選んでください"]];
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
    
    //フラグ管理
    _isEquip = NO;
    _isDrop = YES;
}

- (void)itemDrop2{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSMutableArray *muarr = [[NSMutableArray alloc]initWithArray:delegate.playerItem];
    [muarr removeObjectAtIndex:_dropIndexPath.row];
    NSArray *arr = [muarr copy];
    delegate.playerItem = arr;
    [_itemTable reloadData];
    
    //オートセーブ
    [self autoSave];
    
    //右上のアイテム個数表記を更新
    [self itemCountLabelUpdate];

    
}
// アラートが表示される前に呼び出される
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    
    if(alertView.tag == 1){
        
        CGRect alertFrame = CGRectMake(0, 0, 320, 350);
        alertView.frame = alertFrame;
        
        // アラートの表示位置を設定(アラート表示サイズを変更すると位置がずれるため)
        CGPoint alertPoint = CGPointMake(160, self.view.frame.size.height / 2.0);
        alertView.center = alertPoint;
                
        
    }else if(alertView.tag == 2){
        CGRect alertFrame = CGRectMake(0, 0, 320, 150);
        alertView.frame = alertFrame;
        
        // アラートの表示位置を設定(アラート表示サイズを変更すると位置がずれるため)
        CGPoint alertPoint = CGPointMake(160, self.view.frame.size.height / 2.0);
        alertView.center = alertPoint;

        
    }
}


//前の画面に戻る
- (void)goBack{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    //フラグ管理
    _isEquip = NO;
    _isDrop = NO;
    
    [self performSegueWithIdentifier:@"EquipmentToStatus" sender:self];
    
}

//テーブルの設定
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    return [delegate.playerItem count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If our cell is selected, return double height
	if([self cellIsSelected:indexPath]) {
		return kCellHeight * 4.0;
	}
	
	// Cell isn't selected so return single height
	return kCellHeight;

}


-(UITableViewCell *)tableView:
(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //tableviewの基本設定
    static NSString *CellIdentifier = @"Cell";
    _cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( _cell == nil )
    {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for (UIView *subview in [_cell.contentView subviews]) {
        [subview removeFromSuperview];
    }

    
    //セルの間のボーダーを消す
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //装備表記
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [[delegate.playerItem valueForKey:@"equip"]objectAtIndex:indexPath.row];
    
    if ([[[delegate.playerItem valueForKey:@"equip"]objectAtIndex:indexPath.row]intValue] != 0) {
        UILabel *equipMarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 20, 30)];
        equipMarkLabel.backgroundColor = [UIColor clearColor];
        [equipMarkLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
        [equipMarkLabel setTextColor:[UIColor whiteColor]];
        [equipMarkLabel setText:[NSString stringWithFormat:@"E%@",[[delegate.playerItem valueForKey:@"equip"]objectAtIndex:indexPath.row]]];
        [_cell.contentView addSubview:equipMarkLabel];
        
        [_equipItemMuDic setValue:[NSNumber numberWithInteger:indexPath.row] forKey:[NSString stringWithFormat:@"E%@",[[delegate.playerItem valueForKey:@"equip"]objectAtIndex:indexPath.row]]];
        
    }else{
        
    }
    
    
    //アイテム名表記
    UILabel *item = [[UILabel alloc]init];
    item.backgroundColor = [UIColor clearColor];
    [item setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    [item setTextColor:[UIColor whiteColor]];
    item.frame = CGRectMake(30, 5, 280, 30);
    
    int itemIDCall = [[[delegate.playerItem objectAtIndex:indexPath.row]valueForKey:@"name"]intValue];
    int itemPreIDCall = [[[delegate.playerItem objectAtIndex:indexPath.row]valueForKey:@"pre"]intValue];
    int itemAfter1IDCall = [[[delegate.playerItem objectAtIndex:indexPath.row]valueForKey:@"after1"]intValue];
    int itemAfter2IDCall = [[[delegate.playerItem objectAtIndex:indexPath.row]valueForKey:@"after2"]intValue];
        
    item.text = [NSString stringWithFormat:@"%@%@%@%@",[[_itemPreNamearr objectAtIndex:itemPreIDCall]valueForKey:@"preName"] ,[[_itemNamearr objectAtIndex:itemIDCall]valueForKey:@"itemName"],[[_itemAfter2Namearr objectAtIndex:itemAfter2IDCall]valueForKey:@"afterName"],[[_itemAfter1Namearr objectAtIndex:itemAfter1IDCall]valueForKey:@"afterName"]];
    
    //装備している場合Eの文字を追記する
    [_cell.contentView addSubview:item];
    
    
    //セル展開時の情報-----------------------------------
    
    if ([[_selectedIndexes objectForKey:indexPath]intValue] == 1) {
        
        
        int itemHaveNameID = [[[delegate.playerItem valueForKey:@"name"]objectAtIndex:indexPath.row]intValue];
        int itemHavePreNameID = [[[delegate.playerItem valueForKey:@"pre"]objectAtIndex:indexPath.row]intValue];
        int itemHaveAfter1NameID = [[[delegate.playerItem valueForKey:@"after1"]objectAtIndex:indexPath.row]intValue];
        int itemHaveAfter2NameID = [[[delegate.playerItem valueForKey:@"after2"]objectAtIndex:indexPath.row]intValue];
        
        int totalBaseAttack = [[[_itemNamearr valueForKey:@"baseAttack"]objectAtIndex:itemHaveNameID]intValue] + [[[_itemPreNamearr valueForKey:@"baseAttack"]objectAtIndex:itemHavePreNameID]intValue] + [[[_itemAfter1Namearr valueForKey:@"baseAttack"]objectAtIndex:itemHaveAfter1NameID]intValue] + [[[_itemAfter2Namearr valueForKey:@"baseAttack"]objectAtIndex:itemHaveAfter2NameID]intValue];
        
        _baseDamageAddLabel = [[UILabel alloc]init];
        _baseDamageAddLabel.frame = CGRectMake(30, _cell.contentView.frame.origin.y + 30, 160, 30);
        _baseDamageAddLabel.text = [NSString stringWithFormat:@"基礎魔導力 : %d", totalBaseAttack];
        [_baseDamageAddLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
        [_baseDamageAddLabel setTextColor:[UIColor whiteColor]];
        [_baseDamageAddLabel setBackgroundColor:[UIColor clearColor]];

        [_cell.contentView addSubview:_baseDamageAddLabel];

        int totalBaseDefence = [[[_itemNamearr valueForKey:@"baseDefence"]objectAtIndex:itemHaveNameID]intValue] + [[[_itemPreNamearr valueForKey:@"baseDefence"]objectAtIndex:itemHavePreNameID]intValue] + [[[_itemAfter1Namearr valueForKey:@"baseDefence"]objectAtIndex:itemHaveAfter1NameID]intValue] + [[[_itemAfter2Namearr valueForKey:@"baseDefence"]objectAtIndex:itemHaveAfter2NameID]intValue];
        
        _baseDefenceLabel = [[UILabel alloc]init];
        _baseDefenceLabel.frame = CGRectMake(30, _cell.contentView.frame.origin.y + 45, 160, 30);
        _baseDefenceLabel.text = [NSString stringWithFormat:@"基礎防壁力 : %d", totalBaseDefence];
        [_baseDefenceLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
        [_baseDefenceLabel setTextColor:[UIColor whiteColor]];
        [_baseDefenceLabel setBackgroundColor:[UIColor clearColor]];
        
        [_cell.contentView addSubview:_baseDefenceLabel];
        
        int totalCritical = [[[_itemNamearr valueForKey:@"critical"]objectAtIndex:itemHaveNameID]intValue] + [[[_itemPreNamearr valueForKey:@"critical"]objectAtIndex:itemHavePreNameID]intValue] + [[[_itemAfter1Namearr valueForKey:@"critical"]objectAtIndex:itemHaveAfter1NameID]intValue] + [[[_itemAfter2Namearr valueForKey:@"critical"]objectAtIndex:itemHaveAfter2NameID]intValue];

        _criticalLabel = [[UILabel alloc]init];
        _criticalLabel.frame = CGRectMake(30, _cell.contentView.frame.origin.y + 60, 160, 30);
        _criticalLabel.text = [NSString stringWithFormat:@"クリティカル率 : %d％", totalCritical];
        [_criticalLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
        [_criticalLabel setTextColor:[UIColor whiteColor]];
        [_criticalLabel setBackgroundColor:[UIColor clearColor]];
        
        [_cell.contentView addSubview:_criticalLabel];
        
        int totalAvoid = [[[_itemNamearr valueForKey:@"avoid"]objectAtIndex:itemHaveNameID]intValue] + [[[_itemPreNamearr valueForKey:@"avoid"]objectAtIndex:itemHavePreNameID]intValue] + [[[_itemAfter1Namearr valueForKey:@"avoid"]objectAtIndex:itemHaveAfter1NameID]intValue] + [[[_itemAfter2Namearr valueForKey:@"avoid"]objectAtIndex:itemHaveAfter2NameID]intValue];
        
        _avoidLabel = [[UILabel alloc]init];
        _avoidLabel.frame = CGRectMake(30, _cell.contentView.frame.origin.y + 75, 160, 30);
        _avoidLabel.text = [NSString stringWithFormat:@"回避率 : %d％", totalAvoid];
        [_avoidLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
        [_avoidLabel setTextColor:[UIColor whiteColor]];
        [_avoidLabel setBackgroundColor:[UIColor clearColor]];
        
        [_cell.contentView addSubview:_avoidLabel];
        
        int totalLeech = [[[_itemNamearr valueForKey:@"leech"]objectAtIndex:itemHaveNameID]intValue] + [[[_itemPreNamearr valueForKey:@"leech"]objectAtIndex:itemHavePreNameID]intValue] + [[[_itemAfter1Namearr valueForKey:@"leech"]objectAtIndex:itemHaveAfter1NameID]intValue] + [[[_itemAfter2Namearr valueForKey:@"leech"]objectAtIndex:itemHaveAfter2NameID]intValue];

        _leechLabel = [[UILabel alloc]init];
        _leechLabel.frame = CGRectMake(30, _cell.contentView.frame.origin.y + 90, 160, 30);
        _leechLabel.text = [NSString stringWithFormat:@"吸収率 : %d％", totalLeech];
        [_leechLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
        [_leechLabel setTextColor:[UIColor whiteColor]];
        [_leechLabel setBackgroundColor:[UIColor clearColor]];
        
        [_cell.contentView addSubview:_leechLabel];
        
        int totalPhysicalPower = [[[_itemNamearr valueForKey:@"physical"]objectAtIndex:itemHaveNameID]intValue] + [[[_itemPreNamearr valueForKey:@"physical"]objectAtIndex:itemHavePreNameID]intValue] + [[[_itemAfter1Namearr valueForKey:@"physical"]objectAtIndex:itemHaveAfter1NameID]intValue] + [[[_itemAfter2Namearr valueForKey:@"physical"]objectAtIndex:itemHaveAfter2NameID]intValue];
       
        _physicalLabel = [[UILabel alloc]init];
        _physicalLabel.frame = CGRectMake(180, _cell.contentView.frame.origin.y + 30, 160, 30);
        _physicalLabel.text = [NSString stringWithFormat:@"物理適正 : %d％", totalPhysicalPower];
        [_physicalLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
        [_physicalLabel setTextColor:[UIColor whiteColor]];
        [_physicalLabel setBackgroundColor:[UIColor clearColor]];
        
        [_cell.contentView addSubview:_physicalLabel];

        int totalFirePower = [[[_itemNamearr valueForKey:@"fire"]objectAtIndex:itemHaveNameID]intValue] + [[[_itemPreNamearr valueForKey:@"fire"]objectAtIndex:itemHavePreNameID]intValue] + [[[_itemAfter1Namearr valueForKey:@"fire"]objectAtIndex:itemHaveAfter1NameID]intValue] + [[[_itemAfter2Namearr valueForKey:@"fire"]objectAtIndex:itemHaveAfter2NameID]intValue];

        _fireLabel = [[UILabel alloc]init];
        _fireLabel.frame = CGRectMake(180, _cell.contentView.frame.origin.y + 45, 160, 30);
        _fireLabel.text = [NSString stringWithFormat:@"炎熱適正 : %d％", totalFirePower];
        [_fireLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
        [_fireLabel setTextColor:[UIColor whiteColor]];
        [_fireLabel setBackgroundColor:[UIColor clearColor]];
        
        [_cell.contentView addSubview:_fireLabel];
        
        int totalFreezePower = [[[_itemNamearr valueForKey:@"freeze"]objectAtIndex:itemHaveNameID]intValue] + [[[_itemPreNamearr valueForKey:@"freeze"]objectAtIndex:itemHavePreNameID]intValue] + [[[_itemAfter1Namearr valueForKey:@"freeze"]objectAtIndex:itemHaveAfter1NameID]intValue] + [[[_itemAfter2Namearr valueForKey:@"freeze"]objectAtIndex:itemHaveAfter2NameID]intValue];

        _freezeLabel = [[UILabel alloc]init];
        _freezeLabel.frame = CGRectMake(180, _cell.contentView.frame.origin.y + 60, 160, 30);
        _freezeLabel.text = [NSString stringWithFormat:@"氷結適正 : %d％", totalFreezePower];
        [_freezeLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
        [_freezeLabel setTextColor:[UIColor whiteColor]];
        [_freezeLabel setBackgroundColor:[UIColor clearColor]];
        
        [_cell.contentView addSubview:_freezeLabel];
        
        int totalHolyPower = [[[_itemNamearr valueForKey:@"holy"]objectAtIndex:itemHaveNameID]intValue] + [[[_itemPreNamearr valueForKey:@"holy"]objectAtIndex:itemHavePreNameID]intValue] + [[[_itemAfter1Namearr valueForKey:@"holy"]objectAtIndex:itemHaveAfter1NameID]intValue] + [[[_itemAfter2Namearr valueForKey:@"holy"]objectAtIndex:itemHaveAfter2NameID]intValue];

        _holyLabel = [[UILabel alloc]init];
        _holyLabel.frame = CGRectMake(180, _cell.contentView.frame.origin.y + 75, 160, 30);
        _holyLabel.text = [NSString stringWithFormat:@"聖光適正 : %d％", totalHolyPower];
        [_holyLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
        [_holyLabel setTextColor:[UIColor whiteColor]];
        [_holyLabel setBackgroundColor:[UIColor clearColor]];
        
        [_cell.contentView addSubview:_holyLabel];
        
        int totalDarkPower = [[[_itemNamearr valueForKey:@"dark"]objectAtIndex:itemHaveNameID]intValue] + [[[_itemPreNamearr valueForKey:@"dark"]objectAtIndex:itemHavePreNameID]intValue] + [[[_itemAfter1Namearr valueForKey:@"dark"]objectAtIndex:itemHaveAfter1NameID]intValue] + [[[_itemAfter2Namearr valueForKey:@"dark"]objectAtIndex:itemHaveAfter2NameID]intValue];

        _darkLabel = [[UILabel alloc]init];
        _darkLabel.frame = CGRectMake(180, _cell.contentView.frame.origin.y + 90, 160, 30);
        _darkLabel.text = [NSString stringWithFormat:@"暗黒適正 : %d％", totalDarkPower];
        [_darkLabel setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
        [_darkLabel setTextColor:[UIColor whiteColor]];
        [_darkLabel setBackgroundColor:[UIColor clearColor]];
        
        [_cell.contentView addSubview:_darkLabel];
        
    }else if([[_selectedIndexes objectForKey:indexPath]intValue] == 0 & indexPath == _index){
            
    }else{
        
    }
    
    //セル展開時の情報ここまで-----------------------------------

    
    return _cell;
}

-(void)tableView:
(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"go.mp3"];
    
    //装備変更
#pragma mark equipChange
    if (_isEquip == YES) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
        
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        NSMutableArray *muarr = [[NSMutableArray alloc]initWithArray:delegate.playerItem];
            
        //選んだ場所が未装備か既に装備しているか？0ならば未装備、1〜4は装備している
        if ([[[muarr objectAtIndex:indexPath.row]valueForKey:@"equip"]intValue] != 0) {
            
            //装備しているmuarrの箇所とこれから装備するmuarrの箇所を取得
            NSUInteger integOld = [[muarr valueForKey:@"equip"]indexOfObject:[NSNumber numberWithInteger:_buttonNum]];
            //NSUInteger integNew = [[muarr valueForKey:@"equip"]objectAtIndex:indexPath.row];
        
            //それぞれの箇所の装備ナンバーのdicを取得
            NSMutableDictionary *dicOld = [NSMutableDictionary dictionaryWithDictionary:[muarr objectAtIndex:integOld]];
            NSMutableDictionary *dicNew = [NSMutableDictionary dictionaryWithDictionary:[muarr objectAtIndex:indexPath.row]];
            
            [dicOld setValue:[[muarr valueForKey:@"equip"]objectAtIndex:indexPath.row] forKey:@"equip"];
            [dicNew setValue:[NSNumber numberWithInt:_buttonNum] forKey:@"equip"];
            
            //muarに戻す
            [muarr replaceObjectAtIndex:integOld withObject:dicOld];
            [muarr replaceObjectAtIndex:indexPath.row withObject:dicNew];
            
        //装備していなかった場合、旧値の変更
        }else{
            
            NSUInteger integ = [[muarr valueForKey:@"equip"]indexOfObject:[NSNumber numberWithInteger:_buttonNum]];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[muarr objectAtIndex:integ]];
            [dic setValue:[NSNumber numberWithInt:0] forKey:@"equip"];
            [muarr replaceObjectAtIndex:integ withObject:dic];

            //新装備箇所へ
            NSMutableDictionary *changeDic = [NSMutableDictionary dictionaryWithDictionary:[delegate.playerItem objectAtIndex:indexPath.row]];
            [changeDic setValue:[NSNumber numberWithInt:_buttonNum] forKey:@"equip"];

            [muarr replaceObjectAtIndex:indexPath.row withObject:changeDic];
            
        }
        
        delegate.playerItem = [muarr copy];
        
        //フラグ管理
        _isEquip = NO;
        
        //オートセーブ
        [self autoSave];
        
        [tableView reloadData];
        
    
    //アイテム捨てるよ！
    }else if(_isDrop == YES){
        
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        
        //装備中のアイテムは捨てられません
        if ([[[delegate.playerItem valueForKey:@"equip"]objectAtIndex:indexPath.row]intValue] != 0) {
        
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
            [equipMessage setString:[NSString stringWithFormat:@"装備中のアイテムは捨てられません"]];
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

            _isDrop = NO;
            
        //捨てるかどうかの確認
        }else{
        
           //メモ　カスタムアラートを呼んで、捨てるか確認をさせる。
            //ソートや装備のキャンセル時にボタン使用可も追記すること
            DropAlertViewController *alert = [[DropAlertViewController alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"" otherButtonTitles:@"", nil];
            
            _dropIndexPath = indexPath;
            
            [alert show];
            

            
            //フラグ管理
            _isDrop = NO;
        }

    }else{

#pragma mark cellResize
    
        //セル選択時セル高さを変更------------------------------------
        // Deselect cell
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];

        // Toggle 'selected' state
        BOOL isSelected = ![self cellIsSelected:indexPath];

        // Store cell 'selected' state keyed on indexPath
        NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
        [_selectedIndexes setObject:selectedIndex forKey:indexPath];

        // This is where magic happens...
        [_itemTable beginUpdates];
        [_itemTable endUpdates];
        //セル選択時セル高さを変更ここまで------------------------------------

        //セルタップ時にアイテム情報を展開
        if ([[_selectedIndexes objectForKey:indexPath]intValue] == 1) {
            [_selectedIndexPaths addObject:indexPath];
            NSArray *arr0 = [_selectedIndexPaths copy];
            [_itemTable reloadRowsAtIndexPaths:arr0 withRowAnimation:UITableViewRowAnimationFade];
            
        }else if([[_selectedIndexes objectForKey:indexPath]intValue] == 0){
            NSArray *arr = [[NSArray alloc]initWithObjects:indexPath, nil];
            [_selectedIndexPaths removeObject:indexPath];
            _index = indexPath;
            [_itemTable reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
        }else{
            
        }
    
    }
    
}


- (BOOL)cellIsSelected:(NSIndexPath *)indexPath {
	// Return whether the cell at the specified index path is selected or not
	NSNumber *selectedIndex = [_selectedIndexes objectForKey:indexPath];
	return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
}


//セルの透明化設定
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor clearColor];
    
}

//reject対策--------------------------------------------
//画面表示しようとするときに、テーブルのリロードと選択のクリアをする
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [_itemTable deselectRowAtIndexPath:[_itemTable indexPathForSelectedRow] animated:YES];
    [_itemTable reloadData];
    
}

//画面表示したあとに、スクロールバーを点滅させる
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [_itemTable flashScrollIndicators];
    
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

// ----------------------------------------------------

#pragma mark - iAD
// iAD ------------------------------------------------
// 新しい広告がロードされた後に呼ばれる
// 非表示中のバナービューを表示する
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	if (!bannerIsVisible) {
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		[UIView setAnimationDuration:0.3];
        
#ifdef DISP_AD_BOTTOM
		
        banner.frame = CGRectOffset(banner.frame, 0, -CGRectGetHeight(banner.frame));
        
#else
		banner.frame = CGRectOffset(banner.frame, 0, CGRectGetHeight(banner.frame));
        
#endif
        banner.alpha = 1.0;
		[UIView commitAnimations];
		bannerIsVisible = YES;
	}
}

// 広告バナータップ後に広告画面切り替わる前に呼ばれる
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	BOOL shoudExecuteAction = YES; // 広告画面に切り替える場合はYES（通常はYESを指定する）
	if (!willLeave && shoudExecuteAction) {
		// 必要ならココに、広告と競合する可能性のある処理を一時停止する処理を記述する。
	}
	return shoudExecuteAction;
}

// 広告画面からの復帰時に呼ばれる
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    // 必要ならココに、一時停止していた処理を再開する処理を記述する。
}

// 表示中の広告が無効になった場合に呼ばれる
// 表示中のバナービューを非表示にする
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		[UIView setAnimationDuration:0.3];
        
#ifdef DISP_AD_BOTTOM
        banner.frame = CGRectOffset(banner.frame, 0, CGRectGetHeight(banner.frame));
#else
        banner.frame = CGRectOffset(banner.frame, 0, -CGRectGetHeight(banner.frame));
#endif
        banner.alpha = 0.0;
        
        [UIView commitAnimations];
        bannerIsVisible = NO;
    }
}
// --------------------------------------------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
