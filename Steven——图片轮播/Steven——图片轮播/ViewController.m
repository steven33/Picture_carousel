//
//  ViewController.m
//  Steven——图片轮播
//
//  Created by qugo on 16/8/15.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControll;
@property (nonatomic,strong) NSArray *imageArr;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArr = @[@"img_01",@"img_02",@"img_03",@"img_04",@"img_05"];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControll];
    
    [self creatImages];
    [self startTimer];
    
}

- (void)creatImages{
    for (int i = 0; i < self.imageArr.count + 1; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWidth, 0, kWidth, 200)];
        
        if (i == self.imageArr.count) {
            imageView.image = [UIImage imageNamed:self.imageArr[0]];
        }else{
            imageView.image = [UIImage imageNamed:self.imageArr[i]];
        }
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [imageView addGestureRecognizer:tap];
        
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(kWidth * (self.imageArr.count + 1), 0);
    
}
- (void)tapAction{
    NSLog(@"%ld",(long)self.pageControll.currentPage);
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[OneViewController alloc] init]] animated:YES completion:^{
        
    }];
}
- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:3
                                              target:self
                                            selector:@selector(changeImage)
                                            userInfo:nil
                                             repeats:YES];
    
    // 调整timer 的优先级
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    [mainLoop addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)changeImage {
    [self.scrollView setContentOffset:CGPointMake((self.pageControll.currentPage+1)*kWidth, 0) animated:YES];
}
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark-UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    BOOL isRight = [scrollView.panGestureRecognizer translationInView:scrollView].x < 0;
    //开始显示最后一张图片的时候切换到第二个图
    if (point.x > kWidth*(self.imageArr.count -1)+kWidth*0.5) {
        self.pageControll.currentPage = 0;
    }else if (point.x > kWidth*(self.imageArr.count -1) && isRight){
        self.pageControll.currentPage = 0;
    }else{
        self.pageControll.currentPage = (point.x + kWidth*0.5)/kWidth;
    }
    
    // 开始显示第一张图片的时候切换到倒数第二个图
    if (point.x >= kWidth*self.imageArr.count) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }else if (point.x < 0) {
        [scrollView setContentOffset:CGPointMake(point.x+kWidth*(self.imageArr.count), 0) animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self startTimer];
}

#pragma mark-privateUI
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 200)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
    }
    return _scrollView;
}

- (UIPageControl *)pageControll{
    if (!_pageControll) {
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 160, 160, 30)];
        _pageControll.center = CGPointMake(kWidth/2.0, _pageControll.center.y);
        _pageControll.pageIndicatorTintColor = [UIColor orangeColor];
        _pageControll.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControll.numberOfPages = self.imageArr.count;
        _pageControll.currentPage = 0;
    }
    return _pageControll;
}


@end
