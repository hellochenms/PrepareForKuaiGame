//
//  ImageCommentView.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14-10-12.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "ImageCommentView.h"

@interface ImageCommentView ()<UIScrollViewDelegate>
@property (nonatomic) UIScrollView  *containerView;
@property (nonatomic) UIImageView   *imageView;
@end

@implementation ImageCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 64 + 10, 300 , 300)];
        _containerView.backgroundColor = [UIColor blueColor];
//        _containerView.minimumZoomScale = 1.0;
//        _containerView.maximumZoomScale = 2.0;
//        _containerView.delegate = self;
        [self addSubview:_containerView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imageView.backgroundColor = [UIColor redColor];
//        _imageView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tapGesRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
//        [_imageView addGestureRecognizer:tapGesRec];
        [_containerView addSubview:_imageView];
    }
    return self;
}

#pragma mark - 
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return self.imageView;
//}

#pragma mark - 
- (void)onTap:(UITapGestureRecognizer *)tapGesRec {
    CGPoint touchInImagePoint = [tapGesRec locationInView:self.imageView];
    NSLog(@"in image: %@  %s", NSStringFromCGPoint(touchInImagePoint), __func__);
    
    CGPoint touchInContainerPoint = [tapGesRec locationInView:self.containerView];
    NSLog(@"in container: %@  %s", NSStringFromCGPoint(touchInContainerPoint), __func__);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
