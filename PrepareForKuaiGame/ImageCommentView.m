//
//  ImageCommentView.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14-10-12.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "ImageCommentView.h"
#import "ImageCommentLinesView.h"
#import "M7SimpleIdleSpaceFinder.h"

static const NSInteger  kICV_LabelHeight = 25;
#define kICV_Font   ([UIFont systemFontOfSize:15])

@interface ImageCommentView ()<UIScrollViewDelegate>
@property (nonatomic) UIScrollView      *containerView;
@property (nonatomic) UIImageView       *imageView;
@property (nonatomic) NSMutableArray    *commentLabels;
@property (nonatomic) M7SimpleIdleSpaceFinder *idleSpaceFinder;
@property (nonatomic) ImageCommentLinesView *linesView;
@property (nonatomic) NSMutableArray        *lines;

@end

@implementation ImageCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        _commentLabels = [NSMutableArray array];
        _lines = [NSMutableArray array];
        
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 64 + 10, 300 , 300)];
        _containerView.backgroundColor = [UIColor blueColor];
        _containerView.minimumZoomScale = 1.0;
        _containerView.maximumZoomScale = 4.0;
        _containerView.delegate = self;
        [self addSubview:_containerView];
        
        _imageView = [[UIImageView alloc] initWithFrame:_containerView.bounds];
        _imageView.image = [UIImage imageNamed:@"temp_image"];
        _imageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressGesRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [_imageView addGestureRecognizer:longPressGesRec];
        [_containerView addSubview:_imageView];
        
        _linesView = [[ImageCommentLinesView alloc] initWithFrame:_imageView.bounds];
        [_imageView addSubview:_linesView];
        
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = CGRectMake(10, CGRectGetMaxY(_containerView.frame) + 10, 300, 30);
        clearButton.backgroundColor = [UIColor blueColor];
        [clearButton setTitle:@"清除" forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(onTapClearButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearButton];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = CGRectMake(10, CGRectGetMaxY(clearButton.frame) + 10, 300, 30);
//        sendButton.frame = CGRectMake(10, CGRectGetMaxY(_containerView.frame) + 10, 300, 30);
        sendButton.backgroundColor = [UIColor blueColor];
        [sendButton setTitle:@"发送请求" forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(onTapSendButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];
    }
    return self;
}

#pragma mark -

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"zoomScale(%f) %s", scrollView.zoomScale, __func__);
    double scale = 1.0 / scrollView.zoomScale;
    [self.commentLabels enumerateObjectsUsingBlock:^(UILabel *commentLabel, NSUInteger idx, BOOL *stop) {
        commentLabel.transform = CGAffineTransformMakeScale(scale , scale);
        commentLabel.hidden = (scrollView.zoomScale > 1);
    }];
    self.linesView.hidden = (scrollView.zoomScale > 1);
//    self.linesView.scale = scale;
//    [self.linesView setNeedsDisplay];
    
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@" %s", __func__);
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"scale(%f)  %s", scale, __func__);
}

#pragma mark - 
- (void)onLongPress:(UITapGestureRecognizer *)tapGesRec {
    if (tapGesRec.state == UIGestureRecognizerStateBegan) {
        CGPoint touchInImagePoint = [tapGesRec locationInView:self.imageView];
//        NSLog(@"in image: %@  %s", NSStringFromCGPoint(touchInImagePoint), __func__);
        
        CGPoint labelOriginCenter = touchInImagePoint;
        if (touchInImagePoint.y <= CGRectGetWidth(self.imageView.bounds) / 2) {
            labelOriginCenter.y -= kICV_LabelHeight * 1.2;
        } else {
            labelOriginCenter.y += kICV_LabelHeight * 1.2;
        }
        
        if (labelOriginCenter.y + kICV_LabelHeight / 2 > CGRectGetHeight(self.imageView.bounds)) {
            labelOriginCenter.y = CGRectGetHeight(self.imageView.bounds) - kICV_LabelHeight / 2;
        }
        
        NSString *commentString = @"这是一条吐槽就十个字";
        CGRect labelFrame = [self calcLabelSizeWithCommentNSString:commentString centerPoint:labelOriginCenter];
        if (!self.idleSpaceFinder) {
            self.idleSpaceFinder = [M7SimpleIdleSpaceFinder new];
        }
       
        CGRect frame = [self.idleSpaceFinder findIdleSpaceFrameForTargetFrame:labelFrame
                                                               containerFrame:self.imageView.bounds
                                                                 otherViews:self.commentLabels];
        if (!CGRectEqualToRect(frame, CGRectZero)) {
            labelFrame = frame;
            NSLog(@"找到空闲位置：%@  %s", NSStringFromCGRect(labelFrame), __func__);
        }
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:labelFrame];
        commentLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        commentLabel.layer.borderWidth = 1;
        commentLabel.layer.borderColor = [UIColor blueColor].CGColor;
        commentLabel.font = kICV_Font;
        commentLabel.textAlignment = NSTextAlignmentCenter;
        commentLabel.textColor = [UIColor whiteColor];
        commentLabel.text = commentString;
        commentLabel.transform = CGAffineTransformMakeScale(1 / self.containerView.zoomScale , 1 / self.containerView.zoomScale);
        [self.commentLabels addObject:commentLabel];
        [_imageView addSubview:commentLabel];
        
        
        CGPoint lineEndPoint = commentLabel.center;
        if (touchInImagePoint.y <= commentLabel.center.y) {
            lineEndPoint.y -= CGRectGetHeight(commentLabel.bounds) / 2;
        } else {
            lineEndPoint.y += CGRectGetHeight(commentLabel.bounds) / 2;
        }
        [self.lines addObject:@[[NSValue valueWithCGPoint:touchInImagePoint], [NSValue valueWithCGPoint:lineEndPoint]]];
        self.linesView.Lines = self.lines;
        [self.linesView setNeedsDisplay];
    }
    
//    CGPoint touchInContainerPoint = [tapGesRec locationInView:self.containerView];
//    NSLog(@"in container: %@  %s", NSStringFromCGPoint(touchInContainerPoint), __func__);
}

- (CGRect)calcLabelSizeWithCommentNSString:(NSString *)commentString centerPoint:(CGPoint)centerPoint{
    CGSize size = [self calcLabelSizeWithCommentNSString:commentString];
    CGRect frame = CGRectMake(centerPoint.x - size.width / 2, centerPoint.y - size.height / 2, size.width, kICV_LabelHeight);
    
    return frame;
}

- (BOOL)isIntersectWithTargetRect:(CGRect)targetRect{
    __block BOOL isIntersect = NO;
    [self.commentLabels enumerateObjectsUsingBlock:^(UILabel *commentLabel, NSUInteger idx, BOOL *stop) {
        if (CGRectIntersectsRect(targetRect, commentLabel.frame)) {
            *stop = YES;
            isIntersect = YES;
        }
    }];
    
    return isIntersect;
}

- (CGSize)calcLabelSizeWithCommentNSString:(NSString *)commentString {
    NSDictionary *attributes = @{NSFontAttributeName: kICV_Font};
    CGSize size = [commentString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                               options:NSStringDrawingTruncatesLastVisibleLine
                                            attributes:attributes
                                               context:nil].size;
    
    return size;
}

#pragma mark -
- (void)onTapClearButton {
    [self.commentLabels enumerateObjectsUsingBlock:^(UILabel *commentLabel, NSUInteger idx, BOOL *stop) {
        [commentLabel removeFromSuperview];
    }];
    [self.commentLabels removeAllObjects];
    [self.lines removeAllObjects];
    self.linesView.Lines = self.lines;
    [self.linesView setNeedsDisplay];
}
- (void)onTapSendButton {
    
}

@end
