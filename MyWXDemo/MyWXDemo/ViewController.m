//
//  ViewController.m
//  MyWXDemo
//
//  Created by mkrq-yh on 2018/10/11.
//  Copyright © 2018年 mkrq-yh. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "WXApi.h"

//获取当前屏幕的宽度
#define kScreenWidth               ([UIScreen mainScreen].bounds.size.width)
//获取当前屏幕的高度
#define kScreenHeight              ([UIScreen mainScreen].bounds.size.height)

#define WX_APP_ID         @"wx2eb7d1548687b9ea"
#define WX_APP_SECRET     @"46fd5119ce2da2f786de7ef6b24dc46e"

@interface ViewController ()

@end

@implementation ViewController
{
    NSString *WX_Code;//微信code
    NSString *WX_AccessToken;
    NSString *WX_OpenID;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSArray *array = @[@"微信好友",@"朋友圈",@"微信登录",@"保存相册"];
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXLogin:) name:@"WXAuthorizationSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXShare:) name:@"WXShareSuccess" object:nil];

//    NSString * str1 = @"中秋送礼必备<br/>好多号优惠券好火内容<div class=\"title\">户外秋冬防风防水冲锋裤</div>";
//    //1.将字符串转化为标准HTML字符串
//    str1 = [self htmlEntityDecode:str1];
//    //2.将HTML字符串转换为attributeString
//    NSAttributedString * attributeStr = [self attributedStringWithHTMLString:str1];
//    //3.使用label加载html字符串
//    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 200)];
//    lb.numberOfLines = 0;
//    lb.attributedText = attributeStr;
//    [self.view addSubview:lb];
    
}


//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}

//去掉 HTML 字符串中的标签
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}



/***********************************/
- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == 0) {
        NSLog(@"微信好友");
        [self shareTextType];
    } else if (sender.tag == 1) {
        NSLog(@"朋友圈");
    } else if (sender.tag == 2) {
        NSLog(@"微信登录");
        [self sendAuthRequest];
        
    } else {
        NSLog(@"保存相册");
        [self toOneVC];
    }
}

- (void)toOneVC
{
    OneViewController *one = [[OneViewController alloc] init];
    [self presentViewController:one animated:YES completion:nil];
}

#pragma mark -- 分享文本 --
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
- (void)WXShare:(NSNotification *)notification
{
    NSString *result = [notification object][@"result"];
    if ([result isEqualToString:@"success"]) {
        NSLog(@"111 分享成功");
    }
}


#pragma mark -- 微信登录请求 --
-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"zhaitu_wx_authorization_code";
    [WXApi sendReq:req];
}

#pragma mark -- 接收微信登录通知 --
- (void)WXLogin:(NSNotification *)notification
{
    WX_Code = [notification object][@"code"];
    NSLog(@"code==%@",WX_Code);
    [self getAccess_token];
}

#pragma mark -- 获取access_token --
-(void)getAccess_token
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_APP_ID,WX_APP_SECRET,self->WX_Code];
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"获取access_token==%@",dic);
                self->WX_AccessToken = [dic objectForKey:@"access_token"];
                self->WX_OpenID = [dic objectForKey:@"openid"];
                if ((self->WX_AccessToken.length > 0)&&(self->WX_OpenID.length > 0))
                {
                    [self getUserInfo];
                }
            }
        });
    });
}

#pragma mark -- 获取用户信息 --
-(void)getUserInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",self->WX_AccessToken,self->WX_OpenID];
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"获取用户信息dict==%@",dict);
//                NSString *weixin_unionid = dic[@"unionid"];
//                NSString *weixin_nickname = dic[@"nickname"];
//                weixin_nickname = [weixin_nickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                [self.login weixinLoginWithUnionid:weixin_unionid andWithNickname:weixin_nickname];
            }
        });

    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXAuthorizationSuccess" object:nil];//移除微信登录通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WXShareSuccess" object:nil];//移除微信分享通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
