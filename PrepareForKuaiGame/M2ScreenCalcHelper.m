//
//  M2KeyboardCalcHelper.h
//  chenms.m2
//
//  Created by Chen Meisong on 14/11/17.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "M2ScreenCalcHelper.h"

@implementation M2ScreenCalcHelper
// 键盘显示时，其左上角的坐标（适配iOS7、iOS8下的横竖屏）
- (CGPoint)keyBoardLeftUpPointWithKeyboardFrame:(CGRect)keyboardFrame toView:(UIView *)view {
    CGPoint keyboardLeftTopPoint = CGPointZero;
    if ([self isForIOS8]) {
        keyboardLeftTopPoint = [[UIApplication sharedApplication].keyWindow convertPoint:CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(keyboardFrame)) toView:view];
    } else {
        CGPoint srcPoint = CGPointZero;
        // 使用[UIDevice currentDevice].orientation不靠谱；
 //        switch ([UIDevice currentDevice].orientation)
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
                srcPoint = CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(keyboardFrame));
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                srcPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(keyboardFrame));
                break;
                // 注意UIInterfaceOrientationLandscapeRight与UIDeviceOrientationLandscapeLeft对应，虽然有道理，但真是坑；
            case UIInterfaceOrientationLandscapeRight:
                // 注意，iOS7及以前，横屏时，键盘的height取到的是宽，width取到的是高；
                srcPoint = CGPointMake(CGRectGetWidth(keyboardFrame), 0);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                srcPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(keyboardFrame), CGRectGetHeight([UIScreen mainScreen].bounds));
                break;
            default:
                break;
        }
        keyboardLeftTopPoint = [[UIApplication sharedApplication].keyWindow convertPoint:srcPoint toView:view];
    }
    
    return keyboardLeftTopPoint;
}

// 屏幕左下角坐标（适配iOS7、iOS8下的横竖屏）
- (CGPoint)screenLeftBottomPointToView:(UIView *)view {
    CGPoint screenLeftBottomPoint = CGPointZero;
    if ([self isForIOS8]) {
        screenLeftBottomPoint = [[UIApplication sharedApplication].keyWindow convertPoint:CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)) toView:view];
    } else {
        CGPoint srcPoint = CGPointZero;
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
                srcPoint = CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds));
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                srcPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0);
                break;
            case UIInterfaceOrientationLandscapeRight:
                srcPoint = CGPointMake(0, 0);
                break;
            case UIInterfaceOrientationLandscapeLeft:
                srcPoint = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
                break;
            default:
                break;
        }
        screenLeftBottomPoint = [[UIApplication sharedApplication].keyWindow convertPoint:srcPoint toView:view];
    }
    
    return screenLeftBottomPoint;
}

// 屏幕尺寸（适配iOS7、iOS8下的横竖屏）
- (CGRect)screenBounds {
    CGRect frame = CGRectZero;
    if ([self isForIOS8]) {
        frame = [UIScreen mainScreen].bounds;
    } else {
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                frame.size.width = CGRectGetWidth([UIScreen mainScreen].bounds);
                frame.size.height = CGRectGetHeight([UIScreen mainScreen].bounds);
                break;
            case UIInterfaceOrientationLandscapeRight:
            case UIInterfaceOrientationLandscapeLeft:
                frame.size.width = CGRectGetHeight([UIScreen mainScreen].bounds);
                frame.size.height = CGRectGetWidth([UIScreen mainScreen].bounds);
                break;
            default:
                break;
        }
    }
    
    return frame;
}

#pragma mark - tools
- (BOOL)isForIOS8{
    return ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0);
}

@end
