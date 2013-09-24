//
//  ManualViewController.m
//  Milly
//
//  Created by 花澤 長行 on 2013/07/20.
//  Copyright (c) 2013年 花澤 長行. All rights reserved.
//

#import "ManualViewController.h"

@interface ManualViewController ()

@property UIScrollView *scrollView;
@property UIPageControl *pageControl;

@end

@implementation ManualViewController

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
    
    NSInteger pageSize = 7; // ページ数
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    // UIScrollViewのインスタンス化
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = self.view.bounds;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"manual00" ofType:@"png"];
    UIImage *backgroundImage = [UIImage imageWithContentsOfFile:path];
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    // 横スクロールのインジケータを非表示にする
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    // ページングを有効にする
    _scrollView.pagingEnabled = YES;
    
    _scrollView.userInteractionEnabled = YES;
    _scrollView.delegate = self;
    
    // スクロールの範囲を設定
    [_scrollView setContentSize:CGSizeMake((pageSize * width), height)];
    
    // スクロールビューを貼付ける
    [self.view addSubview:_scrollView];
    
    // スクロールビューにコンテンツを表示
    [self pageContentsDraw:_scrollView];
    
    // ページコントロールのインスタンス化
    CGFloat x = (width - 300) / 2;
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(x, self.view.frame.size.height -80, 300, 50)];
    
    // 背景色を設定
    _pageControl.backgroundColor = [UIColor clearColor];
    
    // ページ数を設定
    _pageControl.numberOfPages = pageSize;
    
    // 現在のページを設定
    _pageControl.currentPage = 0;
    
    // ページコントロールをタップされたときに呼ばれるメソッドを設定
    _pageControl.userInteractionEnabled = YES;
    [_pageControl addTarget:self
                    action:@selector(pageControl_Tapped:)
          forControlEvents:UIControlEventValueChanged];
    
    // ページコントロールを貼付ける
    [self.view addSubview:_pageControl];
}

- (void)pageContentsDraw:(UIView*)view{
    
    CGFloat width = self.view.bounds.size.width;
    //CGFloat height = self.view.bounds.size.height;

    
    //1ページ目
    CALayer *catLayer = [CALayer layer];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yua" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    catLayer.contents = (id)img.CGImage;
    catLayer.frame = CGRectMake(0, 15, img.size.width/2, img.size.height/2);
    [view.layer addSublayer:catLayer];
    

    
    UITextView *text1 = [[UITextView alloc]initWithFrame:CGRectMake(img.size.width/2, 10, 320-img.size.width/2, img.size.height/2+20)];
    [text1 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    text1.textColor = [UIColor whiteColor];
    text1.backgroundColor = [UIColor clearColor];
    text1.text = @"はいはーい。ゆあですー。ゲームの操作説明をしちゃうんだにゃ。よく聞かないと死にますよー。このゲームの目的は、「ミリィ・ナイア」を操って廃棄都市シンヂュクの調査及び危険生物排除任務を完了すること。んー、むつかしいこと抜きに話すと、各エリアの制圧度を100％にすればいいにゃ。";
    text1.editable = NO;
    [view addSubview:text1];
    
    UIImage *img2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"manual01" ofType:@"png"] ];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(img2.size.width/4, text1.frame.size.height + 20, img2.size.width/2, img2.size.height/2)];
    [imgView setImage:img2];
    [view addSubview:imgView];
    
    UITextView *text2 = [[UITextView alloc]initWithFrame:CGRectMake(15, imgView.frame.origin.y + imgView.frame.size.height + 20, 300, 300)];
    [text2 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    text2.textColor = [UIColor whiteColor];
    text2.backgroundColor = [UIColor clearColor];
    text2.text = @"実際のゲーム画面で言うとここだにゃ。こーんな感じで右上にエリアが表示されるから、どんどん「探索」ボタンをタップしてエリア制圧度を100%にしてほしいんだにゃ。ちなみに100％を達成すると、コマンド「状態」>「転移」から違うエリアに移動することが可能になるにゃ〜。";
    text2.editable = NO;
    [view addSubview:text2];
    
    //2ページ目
    float scale = 1;
    
    UITextView *text3 = [[UITextView alloc]initWithFrame:CGRectMake(scale*width + 15, 10, 305, 30)];
    [text3 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    text3.textColor = [UIColor whiteColor];
    text3.backgroundColor = [UIColor clearColor];
    text3.text = @"これは探索時の操作ボタンだにゃ。";
    text3.editable = NO;
    [view addSubview:text3];

    UIImage *img3 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"manual02" ofType:@"png"] ];
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(scale*width + 160-img3.size.width/4, text3.frame.size.height +10, img3.size.width/2, img3.size.height/2)];
    //UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(scale*width + 15, text3.frame.size.height + 70, img3.size.width/2, img3.size.height/2)];
    [imgView2 setImage:img3];
    [view addSubview:imgView2];
    
    //UITextView *text4 = [[UITextView alloc]initWithFrame:CGRectMake(scale*width +imgView2.frame.size.width + 10, text3.frame.size.height + 10, 320- imgView2.frame.size.width, 300)];
    UITextView *text4 = [[UITextView alloc]initWithFrame:CGRectMake(scale*width + 15, imgView2.frame.origin.y + imgView2.frame.size.height, 145, 300)];
    [text4 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    text4.textColor = [UIColor whiteColor];
    text4.backgroundColor = [UIColor clearColor];
    text4.text = @"■説明\n今あたしがしてるこの説明を再確認できるにゃ。\n\n\n■休憩\n減ったLIFEを回復するにゃ。でも時々敵に襲われちゃうこともあるから油断してると死にますよー。";
    text4.editable = NO;
    [view addSubview:text4];
    
    UITextView *text42 = [[UITextView alloc]initWithFrame:CGRectMake(scale*width + 15+160, imgView2.frame.origin.y + imgView2.frame.size.height , 145, 300)];
    [text42 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    text42.textColor = [UIColor whiteColor];
    text42.backgroundColor = [UIColor clearColor];
    text42.text = @"■状態\nミリィのステータスを確認したり、装備を変更したりできるにゃ。\n\n■探索\n周囲を調査して制圧度を上昇させるにゃ。一定確率で危ない生き物にも出会うから注意してにゃ。";
    text42.editable = NO;
    [view addSubview:text42];
    
    //3ページ目
    scale = 2;
    
    UITextView *text5 = [[UITextView alloc]initWithFrame:CGRectMake(scale*width + 15, 10, 305, 40)];
    [text5 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    text5.textColor = [UIColor whiteColor];
    text5.backgroundColor = [UIColor clearColor];
    text5.text = @"こんどは戦闘時の操作ボタンだにゃ。";
    text5.editable = NO;
    [view addSubview:text5];

    UIImage *img4 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"manual03" ofType:@"png"] ];
    //UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(scale*width + img3.size.width/4, text3.frame.size.height + 20, img3.size.width/2, img3.size.height/2)];
    UIImageView *imgView3 = [[UIImageView alloc]initWithFrame:CGRectMake(scale*width + 160 - img4.size.width/4, text5.frame.size.height + 10, img4.size.width/2, img4.size.height/2)];
    [imgView3 setImage:img4];
    [view addSubview:imgView3];

    UITextView *text6 = [[UITextView alloc]initWithFrame:CGRectMake(scale*width + 15, imgView3.frame.origin.y + imgView3.frame.size.height + 10, 305, 200)];
    [text6 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    text6.textColor = [UIColor whiteColor];
    text6.backgroundColor = [UIColor clearColor];
    text6.text = @"状態>魔導でセットされたボタンで攻撃するにゃ！ただし、上の画像だと左下のボタンが使用不可ににゃってる。これは一回魔導攻撃をすると、しばらくその魔導は使えないよっていう表示にゃ（使用不可になる時間は魔導画面で確認にゃ！）強い攻撃ばっかりバンバンぶっ放して勝ち抜けるほど人生はイージーじゃないですよー。";
    text6.editable = NO;
    [view addSubview:text6];
    
    scale = 3;
    
    //4ページ目
    UIImage *img5 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"manual04" ofType:@"png"] ];
    //UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(scale*width + img3.size.width/4, text3.frame.size.height + 20, img3.size.width/2, img3.size.height/2)];
    UIImageView *imgView4 = [[UIImageView alloc]initWithFrame:CGRectMake(scale*width + width/2 -img5.size.width/4, 10, img5.size.width/2, img5.size.height/2)];
    [imgView4 setImage:img5];
    [view addSubview:imgView4];
    
    UITextView *text7 = [[UITextView alloc]initWithFrame:CGRectMake(scale*width + 15, imgView4.frame.origin.y + imgView4.frame.size.height + 10, 305, 250)];
    [text7 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    text7.textColor = [UIColor whiteColor];
    text7.backgroundColor = [UIColor clearColor];
    text7.text = @"さてこんどは探索時に状態ボタンをタップすると出る画面の解説にゃ。理解するのが面倒かもだけど、ここの情報は結構重要にゃ！\n\n■基礎魔導力:魔導攻撃の基礎となるパラメーターにゃ。\n■防壁展開力:敵から受けるダメージを減らすにゃ。\n■クリティカル率:この確率でクリティカルが発生するにゃ。\n■回避率:この確率で攻撃をかわせるにゃ。\n■吸収率:与えたダメージの割合分LIFEを回復にゃ。\n■○○適正:それぞれの属性の攻撃、防御両面で割合分補正がかかるにゃ。敵や自分のボタンなどは物理は灰色、炎熱は赤色、氷結は青色、聖光は茶色、暗黒は黒色で表現されてるにゃ。";
    text7.editable = NO;
    [view addSubview:text7];
    
    scale = 4;
    //5ページ目
    UIImage *img6 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"manual05" ofType:@"png"] ];
    //UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(scale*width + img3.size.width/4, text3.frame.size.height + 20, img3.size.width/2, img3.size.height/2)];
    UIImageView *imgView5 = [[UIImageView alloc]initWithFrame:CGRectMake(scale*width + width/2 -img6.size.width/4, 10, img6.size.width/2, img6.size.height/2)];
    [imgView5 setImage:img6];
    [view addSubview:imgView5];
    
    UITextView *text8 = [[UITextView alloc]initWithFrame:CGRectMake(scale*width + 10, imgView5.frame.origin.y + imgView5.frame.size.height, 305, 250)];
    [text8 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:10]];
    text8.textColor = [UIColor whiteColor];
    text8.backgroundColor = [UIColor clearColor];
    text8.text = @"さていよいよ最後にゃ！探索時に状態ボタン>魔導ボタンの順にタップするとこの画面になるにゃ。この画面では戦闘時の攻撃方法をセットしたり、魔導スキルの成長をさせたりができるにゃ。\n\n【魔導スキルのセット方法】\nセットしたいスキルをタップして選択状態にしてから、右側の４つのボタンをタップすれば切り替わるにゃ。ただし、LVが0だと習得してないってことだからその場合はセットできないし、同じスキルを2つダブってセットもできないにゃ。\n\n魔導スキルは再振ボタンを押せば何度でも違う育て方ができるにゃ！いろいろ試してみるといいにゃー。";
    text8.editable = NO;
    [view addSubview:text8];

    
    scale = 5;
    
    UITextView *text10 = [[UITextView alloc]initWithFrame:CGRectMake(scale*width + 10, 5, 300, 390)];
    [text10 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    text10.textColor = [UIColor whiteColor];
    text10.backgroundColor = [UIColor clearColor];
    text10.text = @"FAQ\n\nQ1.敵が強いです。すぐ死んでしまいます。\nA.装備と魔導の組み合わせを試してみてください。常に余裕を持ってLIFEは八割をキープするだけで大分違います。敵の攻撃が厳しいなら「守護者の召喚」でダメージを軽減してみてはどうでしょう？あるいは一つの攻撃用魔導にスキルポイントを集中して、殺られる前に殺りましょう。\n\nQ2.装備がよくわかんない。どうすりゃいいの？\nA.自由に試してみてください。どのパラメーターも高い数値ならば高い効力を発揮します。ただし、炎熱適正が高いのに氷結属性の魔導ばっかりセットしてたら意味がありませんのでご注意を。\n\nQ3.敵が装備を落としたけど適正がマイナスだよ！にゃんだこれ！\nA.装備品につくエンチャント（例：「炎の」スタッフの「炎の」の箇所をエンチャントと呼びます）の多くはパラメーターを伸ばす効果もありますが低下する効果もあります。長所があれば短所もあるのです。人間と同じですね。\n\nQ4.すぐ死んで制圧度があがりません…。ショボン。\nA.何も出現する敵全てと戦わなくてもいいのです。戦闘前にアラームが表示されるのは危険な敵です。自信がなければスルーしてもいいのです。";
    text10.editable = NO;
    [view addSubview:text10];
    
    
    scale = 6;
    
    //7ページ目
    UITextView *text9 = [[UITextView alloc]initWithFrame:CGRectMake(scale*width + 10, 10, 300, 400)];
    [text9 setFont:[UIFont fontWithName:@"HiraMinProN-W6" size:11]];
    text9.textColor = [UIColor whiteColor];
    text9.backgroundColor = [UIColor clearColor];
    text9.text = @"SPECIAL THANKS\n\n【イラスト】\n明梨りるる様\n\n【モンスター素材】\nqut様\nとも職様\nニルバーナ展覧会機関\n\n【エフェクト素材】\nぴぽや様\n\n【音楽・効果音素材】\ntunluck様\n魔王魂様\n稿屋 隆様\n\n【企画協力】\nあさみっふぃー様";
    text9.editable = NO;
    [view addSubview:text9];
    
    //作者のHPにとぶ
    
    UIButton *btn00 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn00.tag = 0;
    btn00.frame = CGRectMake(scale*width +230, 72, 80, 15);
    [btn00 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btn00 setTitle:@"GO WEBSITE!" forState:UIControlStateNormal];
    [btn00.titleLabel setFont:[UIFont fontWithName:@"AmericanCaptain" size:10]];
    [btn00 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn00 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn00 setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    btn00.exclusiveTouch = YES;
    [view addSubview:btn00];
    
    [btn00 addTarget:self action:@selector(openSafari:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn01 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn01.tag = 1;
    btn01.frame = CGRectMake(scale*width +230, 125, 80, 15);
    [btn01 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btn01 setTitle:@"GO WEBSITE!" forState:UIControlStateNormal];
    [btn01.titleLabel setFont:[UIFont fontWithName:@"AmericanCaptain" size:10]];
    [btn01 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn01 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn01 setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    btn01.exclusiveTouch = YES;
    [view addSubview:btn01];
    
    [btn01 addTarget:self action:@selector(openSafari:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn02 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn02.tag = 2;
    btn02.frame = CGRectMake(scale*width +230, 144, 80, 15);
    [btn02 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btn02 setTitle:@"GO WEBSITE!" forState:UIControlStateNormal];
    [btn02.titleLabel setFont:[UIFont fontWithName:@"AmericanCaptain" size:10]];
    [btn02 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn02 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn02 setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    btn02.exclusiveTouch = YES;
    [view addSubview:btn02];
    
    [btn02 addTarget:self action:@selector(openSafari:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn03 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn03.tag = 7;
    btn03.frame = CGRectMake(scale*width +230, 163, 80, 15);
    [btn03 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btn03 setTitle:@"GO WEBSITE!" forState:UIControlStateNormal];
    [btn03.titleLabel setFont:[UIFont fontWithName:@"AmericanCaptain" size:10]];
    [btn03 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn03 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn03 setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    btn03.exclusiveTouch = YES;

    [view addSubview:btn03];
    
    [btn03 addTarget:self action:@selector(openSafari:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn06 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn06.tag = 3;
    btn06.frame = CGRectMake(scale*width +230, 215, 80, 15);
    [btn06 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btn06 setTitle:@"GO WEBSITE!" forState:UIControlStateNormal];
    [btn06.titleLabel setFont:[UIFont fontWithName:@"AmericanCaptain" size:10]];
    [btn06 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn06 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn06 setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [view addSubview:btn06];
    
    [btn06 addTarget:self action:@selector(openSafari:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *btn04 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn04.tag = 6;
    btn04.frame = CGRectMake(scale*width +230, 270, 80, 15);
    [btn04 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btn04 setTitle:@"GO WEBSITE!" forState:UIControlStateNormal];
    [btn04.titleLabel setFont:[UIFont fontWithName:@"AmericanCaptain" size:10]];
    [btn04 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn04 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn04 setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [view addSubview:btn04];
    
    [btn04 addTarget:self action:@selector(openSafari:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *btn05= [UIButton buttonWithType:UIButtonTypeCustom];
    btn05.tag = 4;
    btn05.frame = CGRectMake(scale*width +230, 289, 80, 15);
    [btn05 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btn05 setTitle:@"GO WEBSITE!" forState:UIControlStateNormal];
    [btn05.titleLabel setFont:[UIFont fontWithName:@"AmericanCaptain" size:10]];
    [btn05 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn05 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn05 setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [view addSubview:btn05];
    
    [btn05 addTarget:self action:@selector(openSafari:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn07 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn07.tag = 5;
    btn07.frame = CGRectMake(scale*width +230, 308, 80, 15);
    [btn07 setBackgroundColor:[UIColor colorWithRed:0.557 green:0 blue:0.8 alpha:1.0]];
    [btn07 setTitle:@"GO WEBSITE!" forState:UIControlStateNormal];
    [btn07.titleLabel setFont:[UIFont fontWithName:@"AmericanCaptain" size:10]];
    [btn07 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn07 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn07 setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [view addSubview:btn07];
    
    [btn05 addTarget:self action:@selector(openSafari:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    for (int num = 0; num <= 5; num++) {
        
        //テキストスクロール終了後TAP!の表示が発生
        CATextLayer *tapText = [CATextLayer layer];
        [tapText setString:@"GO BACK"];
        tapText.font = CGFontCreateWithFontName( (CFStringRef)@"AmericanCaptain" );
        tapText.fontSize = 20;
        tapText.foregroundColor = [UIColor whiteColor].CGColor;
        tapText.frame = CGRectMake(0 + num*width, self.view.frame.size.height - 40, 320, 30);
        tapText.alignmentMode = kCAAlignmentCenter;
        tapText.contentsScale = [UIScreen mainScreen].scale;
        [view.layer addSublayer:tapText];
        
        CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"opacity"];
        anime.duration = .5;
        anime.autoreverses = YES;
        anime.fromValue = [NSNumber numberWithFloat:0];
        anime.toValue = [NSNumber numberWithFloat:1];
        anime.repeatCount = HUGE_VALF;
        [tapText addAnimation:anime forKey:@"opening"];
        
        //NEXTボタン
        UIButton *nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextbtn.frame = CGRectMake(0 + num*width, self.view.frame.size.height - 40, 320, 30);
        NSString *imgPath = [[NSBundle mainBundle]pathForResource:@"none" ofType:@"png"];
        nextbtn.imageView.image = [UIImage imageWithContentsOfFile:imgPath];
        [view addSubview:nextbtn];
        
        //NEXTボタンクリックメソッド
        [nextbtn addTarget:self action:@selector(segueBack) forControlEvents:UIControlEventTouchUpInside];
        
    }


}

- (void)openSafari:(UIButton*)button{
    
    if (button.tag == 1) {
        NSURL *url = [NSURL URLWithString:@"http://lud.sakura.ne.jp/index.html"];
        [[UIApplication sharedApplication] openURL:url];
    }else if(button.tag == 2){
        NSURL *url = [NSURL URLWithString:@"http://www.geocities.jp/tomoshoku/"];
        [[UIApplication sharedApplication] openURL:url];

    }else if(button.tag == 3){
        NSURL *url = [NSURL URLWithString:@"http://piposozai.blog76.fc2.com"];
        [[UIApplication sharedApplication] openURL:url];
        
    }else if(button.tag == 4){
        NSURL *url = [NSURL URLWithString:@"http://maoudamashii.jokersounds.com"];
        [[UIApplication sharedApplication] openURL:url];
        
    }else if(button.tag == 5){
        NSURL *url = [NSURL URLWithString:@"http://dova-s.jp"];
        [[UIApplication sharedApplication] openURL:url];
        
    }else if(button.tag == 6){
        NSURL *url = [NSURL URLWithString:@"http://www.muzie.ne.jp/artist/a013028/"];
        [[UIApplication sharedApplication] openURL:url];

    }else if(button.tag == 0){
        NSURL *url = [NSURL URLWithString:@"http://akari-riruru.tumblr.com"];
        [[UIApplication sharedApplication] openURL:url];
        
    }else if(button.tag == 7){
        NSURL *url = [NSURL URLWithString:@"http://castlenirvana.sakura.ne.jp/index.html"];
        [[UIApplication sharedApplication] openURL:url];
        
    }

    
}

- (void)segueBack{
    
    [self performSegueWithIdentifier:@"manualToView" sender:self]; 
}

/**
 * スクロールビューがスワイプされたとき
 * @attention UIScrollViewのデリゲートメソッド
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    if ((NSInteger)fmod(scrollView.contentOffset.x , pageWidth) == 0) {
        // ページコントロールに現在のページを設定
        _pageControl.currentPage = scrollView.contentOffset.x / pageWidth;
    }
}

/**
 * ページコントロールがタップされたとき
 */
- (void)pageControl_Tapped:(id)sender
{
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * _pageControl.currentPage;
    [_scrollView scrollRectToVisible:frame animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
