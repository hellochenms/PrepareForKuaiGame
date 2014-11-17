//
//  ImageCommentNoLineView.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14-11-6.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "ImageCommentNoLineView.h"
#import "M7SimpleIdleSpaceFinder.h"

static const NSInteger  kICV_LabelHeight = 25;
#define kICV_Font   ([UIFont systemFontOfSize:15])

@interface ImageCommentNoLineView ()<UIScrollViewDelegate, UITextFieldDelegate>
@property (nonatomic) UIScrollView      *containerView;
@property (nonatomic) UIImageView       *imageView;
@property (nonatomic) NSMutableArray    *commentLabels;
@property (nonatomic) NSMutableArray    *commentModels;
@property (nonatomic) M7SimpleIdleSpaceFinder *idleSpaceFinder;
@property (nonatomic) UITextField       *textField;
@property (nonatomic) CGPoint           curTouchPoint;
@end

@implementation ImageCommentNoLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        _commentLabels = [NSMutableArray array];
        _commentModels = [NSMutableArray array];
        _idleSpaceFinder = [M7SimpleIdleSpaceFinder new];
        
        // 容器
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 64 + 10, 300 , 300)];
        _containerView.backgroundColor = [UIColor blueColor];
        _containerView.minimumZoomScale = 1.0;
        _containerView.maximumZoomScale = 4.0;
        _containerView.delegate = self;
        [self addSubview:_containerView];
        
        // 主图片
        _imageView = [[UIImageView alloc] initWithFrame:_containerView.bounds];
        _imageView.image = [UIImage imageNamed:@"temp_image"];
        _imageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressGesRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [_imageView addGestureRecognizer:longPressGesRec];
        [_containerView addSubview:_imageView];
        
        // 清除吐槽
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = CGRectMake(10, CGRectGetMaxY(_containerView.frame) + 10, 300, 30);
        clearButton.backgroundColor = [UIColor blueColor];
        [clearButton setTitle:@"清除" forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(onTapClearButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearButton];
        
        // 发送请求
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sendButton.frame = CGRectMake(10, CGRectGetMaxY(clearButton.frame) + 10, 300, 30);
//        sendButton.frame = CGRectMake(10, CGRectGetMaxY(_containerView.frame) + 10, 300, 30);
        sendButton.backgroundColor = [UIColor blueColor];
        [sendButton setTitle:@"发送请求" forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(onTapSendButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendButton];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth(self.bounds), 40)];
        _textField.backgroundColor = [UIColor blueColor];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [self addSubview:_textField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //    NSLog(@"zoomScale(%f) %s", scrollView.zoomScale, __func__);
    double scale = 1.0 / scrollView.zoomScale;
    [self.commentLabels enumerateObjectsUsingBlock:^(UILabel *commentLabel, NSUInteger idx, BOOL *stop) {
        commentLabel.transform = CGAffineTransformMakeScale(scale , scale);
    }];
}

#pragma mark - 添加新吐槽
- (void)onLongPress:(UITapGestureRecognizer *)tapGesRec {
    if (tapGesRec.state == UIGestureRecognizerStateBegan) {
        self.curTouchPoint = [tapGesRec locationInView:self.imageView];
        self.textField.text = nil;
        [self.textField becomeFirstResponder];
    }
}

- (void)addComment:(NSString *)text {
    CGPoint curTouchPoint = self.curTouchPoint;
    // 生成最新吐槽
    NSString *commentString = text;
    UILabel *commentLabel = [UILabel new];
    commentLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    commentLabel.layer.borderWidth = 1;
    commentLabel.layer.borderColor = [UIColor blueColor].CGColor;
    commentLabel.font = kICV_Font;
    commentLabel.textAlignment = NSTextAlignmentCenter;
    commentLabel.textColor = [UIColor whiteColor];
    commentLabel.text = commentString;
    
    if ([self.commentLabels count] >= 5) {
        UILabel *label = [self.commentLabels lastObject];
        [label removeFromSuperview];
        [self.commentLabels removeObject:label];
        [self.commentModels removeObject:[self.commentModels lastObject]];
    }
    
    // 对初始frame做防越界处理
    CGRect labelFrame = [self calcLabelFrameWithCommentNSString:commentLabel.text centerPoint:curTouchPoint];
    CGRect modifyFrame = [self.idleSpaceFinder modifyOutOfBoundsFrame:labelFrame containerBounds:self.imageView.bounds];
    commentLabel.frame = modifyFrame;
    commentLabel.transform = CGAffineTransformMakeScale(1 / self.containerView.zoomScale , 1 / self.containerView.zoomScale);
    // 若frame没有和其他frame相交，直接使用就可以
    if (![self.idleSpaceFinder checkIfIntersectTargetFrame:modifyFrame otherViews:self.commentLabels]) {
        [self.imageView addSubview:commentLabel];
        [self.commentLabels insertObject:commentLabel atIndex:0];
        // 记录触点
        [self.commentModels insertObject:[NSValue valueWithCGPoint:curTouchPoint] atIndex:0];
    }
    // 反之，以最新吐槽为准，重新布局吐槽
    else {
        // 先移除旧吐槽
        [self.commentLabels enumerateObjectsUsingBlock:^(UILabel *commentLabel, NSUInteger idx, BOOL *stop) {
            [commentLabel removeFromSuperview];
        }];
        
        [self.commentLabels insertObject:commentLabel atIndex:0];
        // 记录触点
        [self.commentModels insertObject:[NSValue valueWithCGPoint:curTouchPoint] atIndex:0];
        // 重新计算所有吐槽frame
        [self calcFrameForLabels:self.commentLabels];
        
        // 添加吐槽
        [self.commentLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [self.imageView addSubview:label];
        }];
    }
}

- (void)calcFrameForLabels:(NSArray *)labels {
    // 循环找到每个吐槽的合适位置
    NSMutableArray *adjustedLabels = [NSMutableArray array];
    __block CGRect labelFrame = CGRectZero;
    __block CGPoint curTouchPoint = CGPointZero;
    __weak typeof(self) weakSelf = self;
    [labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        // 计算当前吐槽的基于触点的frame
        curTouchPoint = [[weakSelf.commentModels objectAtIndex:idx] CGPointValue];
        labelFrame = [self calcLabelFrameWithCommentNSString:label.text centerPoint:curTouchPoint];
        // 基于已调整完的frames调整当前frame
        labelFrame = [self.idleSpaceFinder findIdleSpaceFrameForTargetFrame:labelFrame
                                                                 containerFrame:self.imageView.bounds
                                                                   otherViews:adjustedLabels];
        label.frame = labelFrame;
        [adjustedLabels addObject:label];
    }];
}

#pragma mark - tools
// 计算labelFrame
- (CGRect)calcLabelFrameWithCommentNSString:(NSString *)commentString centerPoint:(CGPoint)centerPoint{
    CGSize size = [self calcLabelSizeWithCommentNSString:commentString];
    CGRect frame = CGRectMake(centerPoint.x - size.width / 2, centerPoint.y - size.height / 2, size.width, kICV_LabelHeight);
    
    return frame;
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
}
- (void)onTapSendButton {
    // 移除旧的吐槽，请求新的吐槽
    [self.commentLabels enumerateObjectsUsingBlock:^(UILabel *commentLabel, NSUInteger idx, BOOL *stop) {
        [commentLabel removeFromSuperview];
    }];
    [self.commentLabels removeAllObjects];
    [self.commentModels removeAllObjects];
    for (NSInteger i = 0; i < 5; i ++) {
        NSString *commentString = [NSString stringWithFormat:@"这是一条吐槽就十个%d", i];
        UILabel *commentLabel = [UILabel new];
        commentLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        commentLabel.layer.borderWidth = 1;
        commentLabel.layer.borderColor = [UIColor blueColor].CGColor;
        commentLabel.font = kICV_Font;
        commentLabel.textAlignment = NSTextAlignmentCenter;
        commentLabel.textColor = [UIColor whiteColor];
        commentLabel.text = commentString;
        [self.commentLabels addObject:commentLabel];
        CGPoint point = CGPointMake(arc4random() % (NSInteger)(CGRectGetWidth(self.imageView.bounds)), arc4random() % (NSInteger)(CGRectGetHeight(self.imageView.bounds)));
        commentLabel.frame = [self calcLabelFrameWithCommentNSString:commentLabel.text centerPoint:point];
        commentLabel.transform = CGAffineTransformMakeScale(1 / self.containerView.zoomScale , 1 / self.containerView.zoomScale);
        [self.commentModels addObject:[NSValue valueWithCGPoint:point]];
    }
    
    // 重新计算所有吐槽frame
    [self calcFrameForLabels:self.commentLabels];
    
    // 添加吐槽
    [self.commentLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        [self.imageView addSubview:label];
    }];
}

#pragma mark - 通知
- (void)onKeyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = 0;
    [animationDurationValue getValue:&animationDuration];
    
    __weak typeof(self) weakSelf = self;
    __block CGRect frame = self.textField.frame;
#warning TODO:chenms:iOS7与iOS8是不一样的
    [UIView animateWithDuration:animationDuration animations:^{
        frame.origin.y = CGRectGetHeight(weakSelf.bounds) - CGRectGetHeight(keyboardFrame) - CGRectGetHeight(weakSelf.textField.bounds);
        weakSelf.textField.frame = frame;
    }];
}

- (void)onKeyboardWillHide:(NSNotification *)notification {
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = 0;
    [animationDurationValue getValue:&animationDuration];
    
    __weak typeof(self) weakSelf = self;
    __block CGRect frame = self.textField.frame;
    [UIView animateWithDuration:animationDuration animations:^{
        frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds);
        weakSelf.textField.frame = frame;
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([text length] > 0) {
        [self addComment:text];
    }
    return YES;
}

@end
