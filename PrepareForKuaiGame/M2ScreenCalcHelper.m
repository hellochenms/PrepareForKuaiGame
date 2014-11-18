//
//  M2KeyboardCalcHelper.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/11/17.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "M2ScreenCalcHelper.h"

@implementation M2ScreenCalcHelper
// 键盘显示时，其左上角的坐标（适配iOS7、iOS8）
- (CGPoint)keyBoardLeftUpPointWithKeyboardFrame:(CGRect)keyboardFrame toView:(UIView *)view {
    CGPoint keyboardLeftTopPoint = CGPointZero;
    if (isIOS8) {
        keyboardLeftTopPoint = [[UIApplication sharedApplication].keyWindow convertPoint:CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(keyboardFrame)) toView:view];
    } else {
        CGPoint srcPoint = CGPointZero;
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationPortrait:
                srcPoint = CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(keyboardFrame));
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                srcPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(keyboardFrame));
                break;
            case UIDeviceOrientationLandscapeLeft:
                // 注意，iOS7及以前，横屏时，键盘的height取到的是宽，width取到的是高；
                srcPoint = CGPointMake(CGRectGetWidth(keyboardFrame), 0);
                break;
            case UIDeviceOrientationLandscapeRight:
                srcPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(keyboardFrame), CGRectGetHeight([UIScreen mainScreen].bounds));
                break;
            default:
                break;
        }
        keyboardLeftTopPoint = [[UIApplication sharedApplication].keyWindow convertPoint:srcPoint toView:view];
    }
    
    return keyboardLeftTopPoint;
}

// 屏幕左下角坐标（适配iOS7、iOS8）
- (CGPoint)screenLeftBottomPointToView:(UIView *)view {
    CGPoint screenLeftBottomPoint = CGPointZero;
    if (isIOS8) {
        screenLeftBottomPoint = [[UIApplication sharedApplication].keyWindow convertPoint:CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)) toView:view];
    } else {
        CGPoint srcPoint = CGPointZero;
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationPortrait:
                srcPoint = CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds));
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                srcPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0);
                break;
            case UIDeviceOrientationLandscapeLeft:
                srcPoint = CGPointMake(0, 0);
                break;
            case UIDeviceOrientationLandscapeRight:
                srcPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
                break;
            default:
                break;
        }
        screenLeftBottomPoint = [[UIApplication sharedApplication].keyWindow convertPoint:srcPoint toView:view];
    }
    
    return screenLeftBottomPoint;
}

// 屏幕尺寸（适配iOS7、iOS8）
- (CGRect)screenBounds {
    CGRect frame = CGRectZero;
    if (isIOS8) {
        frame = [UIScreen mainScreen].bounds;
    } else {
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationPortrait:
            case UIDeviceOrientationPortraitUpsideDown:
                frame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
                frame.size.height = CGRectGetHeight([UIScreen mainScreen].bounds);
                break;
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationLandscapeRight:
                frame.size.width = CGRectGetHeight([UIScreen mainScreen].bounds);
                frame.size.height = CGRectGetWidth([UIScreen mainScreen].bounds);
                break;
            default:
                frame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
                frame.size.height = CGRectGetHeight([UIScreen mainScreen].bounds);
                break;
        };
    }
    
    return frame;
}

//// 适配textField的layout
//- (void)adjustTextFieldLayoutWithIsShowingKeyboard:(BOOL)isShowingKeyboard {
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        CGRect textFieldFrame = weakSelf.textField.frame;
//        if (isShowingKeyboard) {
//            CGPoint keyboardLeftTopPoint = [weakSelf.screenCalcHelper keyBoardLeftUpPointWithKeyboardFrame:weakSelf.keyboardFrame toView:weakSelf];
//            textFieldFrame.origin.x = keyboardLeftTopPoint.x;
//            textFieldFrame.origin.y = keyboardLeftTopPoint.y - CGRectGetHeight(textFieldFrame);
//        } else {
//            CGPoint screenLeftBottomPoint = [weakSelf.screenCalcHelper screenLeftBottomPointToView:weakSelf];
//            textFieldFrame.origin.x = screenLeftBottomPoint.x;
//            textFieldFrame.origin.y = screenLeftBottomPoint.y;
//        }
//        textFieldFrame.size.width = CGRectGetWidth([weakSelf.screenCalcHelper screenBounds]);
//        [UIView animateWithDuration:weakSelf.keyboardAnimationDuration
//                         animations:^{
//                             weakSelf.textField.frame = textFieldFrame;
//                         }];
//    });
//}

@end
