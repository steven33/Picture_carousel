//
//  OneViewController.m
//  Steven——图片轮播
//
//  Created by qugo on 16/8/15.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "OneViewController.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width

@interface OneViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *imageArr;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *centerImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, assign) int centerIndex;
@property (strong, nonatomic) UIPageControl *pageControll;


@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self creatImages];
    self.centerIndex = 0;
    
    self.imageArr = @[@"img_01",@"img_02",@"img_03",@"img_04",@"img_05"];
    [self.view addSubview:self.pageControll];
    [self startTimer];
}

- (void)creatImages{
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWidth, 0, kWidth, 200)];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [imageView addGestureRecognizer:tap];
        if (i == 0) {
            self.leftImgView = imageView;
            [self.scrollView addSubview:self.leftImgView];
        }else if(i==1){
            self.centerImgView = imageView;
            [self.scrollView addSubview:self.centerImgView];
        }else if (i==2){
            self.rightImgView = imageView;
            [self.scrollView addSubview:self.rightImgView];
        }
    }
    
}

- (void)setImageArr:(NSArray *)imageArr{
    _imageArr = imageArr;
    self.centerIndex = 0;
    self.pageControll.numberOfPages = self.imageArr.count;
    self.pageControll.currentPage = 0;
    
    
    if (_imageArr.count > 3) {
        self.scrollView.contentSize = CGSizeMake(kWidth * 3, 0);
    }else{
        self.scrollView.contentSize = CGSizeMake(kWidth * _imageArr.count, 0);
    }
    
    [self changeCenterImage];
    [_scrollView setContentOffset:CGPointMake(kWidth, 0) animated:NO];

}

- (void)changeCenterImage{

    if (self.centerIndex == 0) {
        self.leftImgView.image = [UIImage imageNamed:self.imageArr.lastObject];
    }else{
        self.leftImgView.image = [UIImage imageNamed:self.imageArr[self.centerIndex-1]];
    }
    
    self.centerImgView.image = [UIImage imageNamed:self.imageArr[self.centerIndex]];
    
    
    if (self.centerIndex+1 >= self.imageArr.count) {
        self.rightImgView.image = [UIImage imageNamed:self.imageArr.firstObject];
    }else{
        self.rightImgView.image = [UIImage imageNamed:self.imageArr[self.centerIndex+1]];
    }

}
- (void)tapAction{
    NSLog(@"%d",self.centerIndex);
    self.imageArr = @[@"img_05"];
}
- (void)startTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(changeImage)
                                            userInfo:nil
                                             repeats:YES];
    
    // 调整timer 的优先级
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    [mainLoop addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)changeImage {
    CATransition *transition = [CATransition animation];
    transition.subtype = kCATransitionFromLeft;
    transition.type = @"rippleEffect";
    transition.duration = 0.5;
    [self.scrollView.layer addAnimation:transition forKey:@"layerAnimation"];
    [self.scrollView setContentOffset:CGPointMake(2*kWidth, 0) animated:YES];
}
- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark-UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if (point.x >= kWidth*2) {
        self.centerIndex = self.centerIndex + 1;
        [self changeCenterImage];
        [_scrollView setContentOffset:CGPointMake(kWidth, 0) animated:NO];
    }else if (point.x <= 0) {
        self.centerIndex = self.centerIndex-1;
        [self changeCenterImage];
        [scrollView setContentOffset:CGPointMake(kWidth, 0) animated:NO];
    }
    
    self.pageControll.currentPage = self.centerIndex;
    
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self startTimer];
}

- (void)setCenterIndex:(int)centerIndex{
    _centerIndex = centerIndex;
    if (_centerIndex < 0) {
        _centerIndex = (int)(self.imageArr.count)-1;
    }
    if (_centerIndex > self.imageArr.count-1) {
        _centerIndex = 0;
    }

}


#pragma mark-privateUI
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, kWidth, 200)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
    }
    return _scrollView;
}

- (UIPageControl *)pageControll{
    if (!_pageControll) {
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 260, 160, 30)];
        _pageControll.center = CGPointMake(kWidth/2.0, _pageControll.center.y);
        _pageControll.pageIndicatorTintColor = [UIColor orangeColor];
        _pageControll.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControll.currentPage = 0;
    }
    return _pageControll;
}





@end
