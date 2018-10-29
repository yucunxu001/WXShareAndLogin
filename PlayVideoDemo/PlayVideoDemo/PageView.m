//
//  PageView.m
//  LoopScrollViewImage
//
//  Created by 毕佳－app001 on 15/8/18.
//  Copyright (c) 2015年 毕佳－app001. All rights reserved.
//

#import "PageView.h"
#import "UIImageView+WebCache.h"
#import "ClassesViewController.h"

@interface PageView () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation PageView
{
    UIImage *defaultImg;
}

- (instancetype)initPageViewFrame:(CGRect)frame withDefaultImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        
        defaultImg = image;
    }
    return self;
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    [self setUPScrollView:imageArray];
    [self setUPImage:imageArray];
    [self setUpPageControl:imageArray];
}

- (void)setDuration:(NSTimeInterval)duration
{
    _duration = duration;
    [self.timer invalidate];
    [self startTimer];
}

//设置scrollView
- (void)setUPScrollView:(NSArray *)array
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageViewClick:)];
    [scrollView addGestureRecognizer:tapGesture];
    
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

//设置scrollView的图片内容：如果是网络图片就用SDWebImage加载，本地则直接设置
- (void)setUPImage:(NSArray *)array
{
    CGSize contentSize;
    CGPoint startPoint;
    if (array.count > 1)
    {
        //多张图片
        for (int i = 0; i < array.count+2; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            if (i == 0)
            {
                //第一个imageView中放最后一张图片
                [imageView sd_setImageWithURL:[NSURL URLWithString:array[array.count-1]] placeholderImage:defaultImg];
            }
            else if (i == array.count+1)
            {
                //最后一个imageView中方第一个图片
                [imageView sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:defaultImg];
            }
            else
            {
                //image顺序：4，1，2，3，4，1一样
                [imageView sd_setImageWithURL:[NSURL URLWithString:array[i-1]] placeholderImage:defaultImg];
            }
            [self.scrollView addSubview:imageView];
            contentSize = CGSizeMake((array.count + 2)*self.frame.size.width, 0);
            startPoint = CGPointMake(self.frame.size.width, 0);
        }
    }
    else
    {
        //只有一张图片
        for (int i = 0; i < array.count+2; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:defaultImg];
            [self.scrollView addSubview:imageView];
        }
        contentSize = CGSizeMake(self.frame.size.width, 0);//一张图片时不可以滚动
//        contentSize = CGSizeMake((array.count + 2)*self.frame.size.width, 0);//一张图片时可以滚动
        startPoint = CGPointZero;
    }
    //开始时的偏移量
    self.scrollView.contentOffset = startPoint;
    //scrollView的大小尺寸
    self.scrollView.contentSize = contentSize;
}

- (void)setUpPageControl:(NSArray *)array
{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.superview.backgroundColor = [UIColor grayColor];
    pageControl.numberOfPages = array.count;
    //默认是0
    pageControl.currentPage = 0;
    //自动计算大小尺寸
    CGSize pageSize = [pageControl sizeForNumberOfPages:array.count];
//    pageControl.bounds = CGRectMake(0, 0, pageSize.width, pageSize.height-15);
    pageControl.frame = CGRectMake((self.frame.size.width-pageSize.width-10)/2, self.frame.size.height-pageSize.height+20, pageSize.width+10, pageSize.height-20);
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    pageControl.center = CGPointMake(self.center.x, self.frame.size.height-20);
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    if (array.count == 1)
    {
        self.pageControl.hidden = YES;
    }
}

- (void)pageChange:(UIPageControl *)page
{
    //获取当前页的宽度
    CGFloat x = page.currentPage * self.bounds.size.width;
    //通过设置scrollView的偏移量了来滚动视图
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

#pragma mark - Timer时间方法
- (void)startTimer
{
    if (!_duration)
    {
        self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    else
    {
        self.timer = [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)updateTimer
{
    if (self.imageArray.count > 1)
    {
        CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), 0);
        [self.scrollView setContentOffset:newOffset animated:YES];
    }
//    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), 0);
//    [self.scrollView setContentOffset:newOffset animated:YES];
}

#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //偏移量没有超出scrollView的大小
    if (scrollView.contentOffset.x < self.frame.size.width)
    {
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width*(self.imageArray.count+1), 0) animated:NO];
    }
    //偏移量超出
    if (scrollView.contentOffset.x > self.frame.size.width*(self.imageArray.count+1))
    {
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    }
    
    int pageCount = scrollView.contentOffset.x/self.frame.size.width;
    if (pageCount > self.imageArray.count)
    {
        pageCount = 0;
    }
    else if (pageCount == 0)
    {
        pageCount = (int)self.imageArray.count-1;
    }
    else
    {
        pageCount--;
    }
    self.pageControl.currentPage = pageCount;
}

#pragma mark - pageViewClick点击手势
- (void)pageViewClick:(UITapGestureRecognizer *)tap
{
    [self.delegate didSelectPageViewWithNumber:self.pageControl.currentPage];
    
//    UIViewController *vc = [self getViewController];
//    NSString *islogin = self.isloginArray[self.pageControl.currentPage];
//    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];


}
//#pragma mark - 获取父视图控制器
//- (UIViewController *)getViewController
//{
//    for (UIView *next1 = [self superview]; next1; next1 = next1.superview)
//    {
//        UIResponder* nextResponder = [next1 nextResponder];
//        if ([self.VC isEqualToString:@"ClassesViewController"])
//        {
//            if ([nextResponder isKindOfClass:[ClassesViewController class]])
//            {
//                return (UIViewController *)nextResponder;
//            }
//        }
//    }
//    return nil;
//}

//停止滚动时
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

//开始拖动时
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    
    [self.timer invalidate];
}

//结束拖动时
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}










@end
