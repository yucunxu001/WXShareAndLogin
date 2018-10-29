//
//  PageView.h
//  LoopScrollViewImage
//
//  Created by 毕佳－app001 on 15/8/18.
//  Copyright (c) 2015年 毕佳－app001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageViewDelegete <NSObject>

- (void)didSelectPageViewWithNumber:(NSInteger)selectNumber;

@end

@interface PageView : UIView

@property (nonatomic,strong) NSArray *imageArray;

//@property (nonatomic,strong) UIViewController *parentsController;
//@property (nonatomic,strong) NSString *VC;

@property (nonatomic,assign) NSTimeInterval duration;
//判断是不是网络图片
@property (nonatomic,assign) BOOL isWebImage;

- (instancetype)initPageViewFrame:(CGRect)frame withDefaultImage:(UIImage *)image;

@property (nonatomic,weak) id<PageViewDelegete>delegate;

@end
