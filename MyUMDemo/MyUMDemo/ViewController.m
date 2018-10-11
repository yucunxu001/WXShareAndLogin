//
//  ViewController.m
//  MyUMDemo
//
//  Created by mkrq-yh on 2018/9/30.
//  Copyright © 2018年 mkrq-yh. All rights reserved.
//

#import "ViewController.h"
#import <UShareUI/UShareUI.h>

//获取当前屏幕的宽度
#define kScreenWidth               ([UIScreen mainScreen].bounds.size.width)
//获取当前屏幕的高度
#define kScreenHeight              ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 50)];
    label.text = @"集成友盟分享、推送、统计";
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    NSArray *array = @[@"微信好友",@"朋友圈",@"QQ好友",@"保存相册"];
    CGFloat width = (kScreenWidth-40-20*3)/4;
    for (NSInteger i =0; i < array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+i*(width+20), 300, width, width);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.borderColor = [UIColor greenColor].CGColor;
        btn.layer.borderWidth = 2;
        btn.layer.cornerRadius = btn.frame.size.height/2;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == 0) {
        NSLog(@"微信好友");
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    } else if (sender.tag == 1) {
        NSLog(@"朋友圈");
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    } else if (sender.tag == 2) {
        NSLog(@"QQ好友");
    } else {
        NSLog(@"保存相册");
    }
//    UMSocialPlatformType_WechatSession      = 1, //微信聊天
//    UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
//    UMSocialPlatformType_QQ                 = 4,//QQ聊天页面

    
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//        NSLog(@"platformType==%ld",(long)platformType);
//    }];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString *picture = @"http://img1.imgtn.bdimg.com/it/u=2788946248,2985792853&fm=26&gp=0.jpg";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"友盟分享" descr:@"我正在测试友盟分享，请不要打开网页，谢谢，哈哈哈哈！！" thumImage:picture];
    //设置网页地址
    shareObject.webpageUrl = @"https://baike.baidu.com/item/%E5%9B%BD%E5%BA%86%E8%8A%82/291112?fromtitle=%E5%9B%BD%E5%BA%86&fromid=139153&fr=aladdin";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error)
        {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            //分享失败
            //            shareResultLb.text = @"分享失败";
            //            [self showShareView];
            NSLog(@"分享失败");
            
        }
        else
        {
            if ([data isKindOfClass:[UMSocialShareResponse class]])
            {
                //                UMSocialShareResponse *resp = data;
                //分享成功
                NSLog(@"分享成功");
            }
            else
            {
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
