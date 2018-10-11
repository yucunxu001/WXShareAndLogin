//
//  OneViewController.m
//  MyWXDemo
//
//  Created by mkrq-yh on 2018/10/11.
//  Copyright © 2018年 mkrq-yh. All rights reserved.
//

#import "OneViewController.h"
#import "WXApi.h"

//获取当前屏幕的宽度
#define kScreenWidth               ([UIScreen mainScreen].bounds.size.width)
//获取当前屏幕的高度
#define kScreenHeight              ([UIScreen mainScreen].bounds.size.height)

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 40, 100, 100);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.borderColor = [UIColor greenColor].CGColor;
    btn.layer.borderWidth = 2;
    btn.layer.cornerRadius = btn.frame.size.height/2;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    NSArray *array = @[@"文字分享",@"图片分享",@"视频分享",@"网页分享"];
    CGFloat width = (kScreenWidth-40-20*3)/4;
    for (NSInteger i =0; i < array.count; i++) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(20+i*(width+20), 300, width, width);
        [shareBtn setTitle:array[i] forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        shareBtn.layer.borderColor = [UIColor greenColor].CGColor;
        shareBtn.layer.borderWidth = 2;
        shareBtn.layer.cornerRadius = btn.frame.size.height/2;
        shareBtn.layer.masksToBounds = YES;
        shareBtn.tag = i;
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXShare:) name:@"WXShareSuccess" object:nil];
    
}
- (void)btnClick:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareBtnClick:(UIButton *)sender
{
    if (sender.tag == 0) {
        NSLog(@"文字分享");
        [self shareTextType];
    } else if (sender.tag == 1) {
        NSLog(@"图片分享");
        [self sharePictureType];
    } else if (sender.tag == 2) {
        NSLog(@"视频分享");
        [self shareVideoType];
    } else {
        NSLog(@"网页分享");
        [self shareWebType];
    }
}

#pragma mark -- 文字分享 --
- (void)shareTextType
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = @"分享内容-内容内容内容内容内容内容内容内容";
    req.bText = YES;
    /*
     WXSceneSession          = 0,   聊天界面
     WXSceneTimeline         = 1,   朋友圈
     WXSceneFavorite         = 2,   收藏
     WXSceneSpecifiedSession = 3,   指定联系人
     */
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

#pragma mark -- 图片分享 --
- (void)sharePictureType
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"点开看看，有惊喜";
    message.description = @"去希腊的胖子不能骑驴了...不是歧视胖子，是驴真的快被压死了啊";
    [message setThumbImage:[UIImage imageNamed:@"123.png"]];
    
    WXImageObject *imageObject = [WXImageObject object];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mv" ofType:@"png"];//本地图片
//    imageObject.imageData = [NSData dataWithContentsOfFile:filePath];
    
    NSString *imageUrl = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    imageObject.imageData = data;//网络图片
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

#pragma mark -- 视频分享 --
- (void)shareVideoType
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"标题";
    message.description = @"描述";
    [message setThumbImage:[UIImage imageNamed:@"123.png"]];
    
    WXVideoObject *videoObject = [WXVideoObject object];
    videoObject.videoUrl = @"https://www.iqiyi.com/v_19rr1w9g4k.html";
    videoObject.videoLowBandUrl = videoObject.videoUrl;//低分辨率
    message.mediaObject = videoObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

#pragma mark -- 网页分享 --
- (void)shareWebType
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"标题";
    message.description = @"描述";
    [message setThumbImage:[UIImage imageNamed:@"123.png"]];
    
    WXWebpageObject *webObject = [WXWebpageObject object];
    webObject.webpageUrl = @"https://www.baidu.com";
    message.mediaObject = webObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

- (void)WXShare:(NSNotification *)notification
{
    NSString *result = [notification object][@"result"];
    if ([result isEqualToString:@"success"]) {
        NSLog(@"one 分享成功");
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXShareSuccess" object:nil];//移除微信分享通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
