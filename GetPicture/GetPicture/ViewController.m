//
//  ViewController.m
//  GetPicture
//
//  Created by mkrq-yh on 2018/10/19.
//  Copyright © 2018年 mkrq-yh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ViewController
{
    UIImageView *imgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, self.view.frame.size.width-40, 400)];
    imgView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:imgView];
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 50);
    [photoBtn setTitle:@"获取图片" forState:UIControlStateNormal];
    [photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    photoBtn.backgroundColor = [UIColor greenColor];
    photoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [photoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
}

#pragma mark -- 获取图片 --
- (void)photoBtnClick:(UIButton *)sender
{
    NSLog(@"获取图片");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *one = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionSheetClickedButtonAtIndex:1];
    }];
    UIAlertAction *two = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self actionSheetClickedButtonAtIndex:2];
    }];
    [alert addAction:cancle];
    [alert addAction:one];
    [alert addAction:two];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 选择相册 拍照 --
-(void)actionSheetClickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if (buttonIndex == 1) {//从相册选择
        NSLog(@"从相册选择");
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//图片选择是相册（图片来源自相册）
            picker.delegate=self;//设置代理
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];//模态显示界面
        }
        
    } else {//拍照
        NSLog(@"拍照");
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;//图片选择是拍照
            picker.delegate=self;//设置代理
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];//模态显示界面
        }
    }
}

#pragma mark -- 选择图片 或 拍照完成 代理 --
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {//相册
        imgView.image = image;

    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//相机
        imgView.image = image;

    } else {
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 选择图片 或 拍照取消 代理 --
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"选择图片 或 拍照取消");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
