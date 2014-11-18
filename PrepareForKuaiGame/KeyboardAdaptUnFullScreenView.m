//
//  KeyboardAdaptUnFullScreenView.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/11/17.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

//  本Demo处理下面几个问题：
//  1、【非全屏view】调用键盘时，调整子view到合适位置；
//  2、旋屏的适配；
//  3、1与2中，iOS7及以前与iOS8有区别，适配；

#import "KeyboardAdaptUnFullScreenView.h"
#import "M2ScreenCalcHelper.h"

@interface KeyboardAdaptUnFullScreenView ()<UITextFieldDelegate>
@property (nonatomic) UIButton          *button;
@property (nonatomic) UITextField       *textField;
@property (nonatomic) CGRect            keyboardFrame;
@property (nonatomic) NSTimeInterval    keyboardAnimationDuration;
@property (nonatomic) M2ScreenCalcHelper    *screenCalcHelper;
@end

@implementation KeyboardAdaptUnFullScreenView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //
        _screenCalcHelper = [M2ScreenCalcHelper new];
        
        //
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectZero;
        _button.backgroundColor = [UIColor cyanColor];
        [_button setTitle:@"弹出输入框" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        // init方法中view间convert有问题，dispatch_async(dispatch_get_main_queue()中执行就正常了；
//        CGPoint srcPoint = CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - 10);
//        CGPoint destPoint = [[UIApplication sharedApplication].keyWindow convertPoint:srcPoint toView:self];
//        double originY = destPoint.y;
        
        double originY = 0;
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, originY, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
        _textField.backgroundColor = [UIColor greenColor];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        _textField.hidden = YES;
        [self addSubview:_textField];
        
        //
        [self adjustSubViewsLayout];
        
        // 监听键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onKeyboardWillChangeFrame:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onKeyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        // 监听旋屏通知
//        // 这个通知返回的方向多于4个，而且同一方向上可能通知多次（如在一个方向上来回旋转屏幕，但幅度不至于横竖屏切换时）
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                selector:@selector(onDeviceOrientationDidChange:)
//                                                    name:UIDeviceOrientationDidChangeNotification
//                                                   object:nil];
        // 这个通知则不会出现上述两个问题
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onApplicationDidChangeStatusBarOrientation:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        
        // 异步调整textField位置
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf adjustTextFieldLayoutWithIsShowingKeyboard:NO];
        });
    }
    
    return self;
}

#pragma mark - 用户事件
- (void)onTapButton {
    [self.textField becomeFirstResponder];
}

#pragma mark - 键盘通知
- (void)onKeyboardWillShow:(NSNotification *)notification {
    self.keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardAnimationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.textField.hidden = NO;
}
- (void)onKeyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardFrame = keyboardFrame;
    self.keyboardAnimationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self adjustTextFieldLayoutWithIsShowingKeyboard:YES];
}
- (void)onKeyboardWillHide:(NSNotification *)notification {
    [self adjustTextFieldLayoutWithIsShowingKeyboard:NO];
}
- (void)onKeyboardDidHide:(NSNotification *)notification {
    self.keyboardFrame = CGRectZero;
    self.textField.hidden = YES;
}

#pragma mark - 旋屏通知
- (void)onApplicationDidChangeStatusBarOrientation:(NSNotification *)notification {
    [self adjustTextFieldLayoutWithIsShowingKeyboard:NO];
}

// 适配textField的layout
- (void)adjustTextFieldLayoutWithIsShowingKeyboard:(BOOL)isShowingKeyboard {
    CGRect textFieldFrame = self.textField.frame;
    if (isShowingKeyboard) {
        CGPoint keyboardLeftTopPoint = [self.screenCalcHelper keyBoardLeftUpPointWithKeyboardFrame:self.keyboardFrame toView:self];
        textFieldFrame.origin.x = keyboardLeftTopPoint.x;
        textFieldFrame.origin.y = keyboardLeftTopPoint.y - CGRectGetHeight(textFieldFrame);
    } else {
        CGPoint screenLeftBottomPoint = [self.screenCalcHelper screenLeftBottomPointToView:self];
        textFieldFrame.origin.x = screenLeftBottomPoint.x;
        textFieldFrame.origin.y = screenLeftBottomPoint.y;
    }
    textFieldFrame.size.width = CGRectGetWidth([self.screenCalcHelper screenBounds]);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.keyboardAnimationDuration
                     animations:^{
                         weakSelf.textField.frame = textFieldFrame;
                     }];
}


#pragma mark - 
- (void)adjustSubViewsLayout {
    CGRect buttonFrame = CGRectMake(10, 10, CGRectGetWidth(self.bounds) - 10 * 2, 44);
    self.button.frame = buttonFrame;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 业务代码
    
    // 收起键盘
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.textField.delegate = nil;
}


@end
