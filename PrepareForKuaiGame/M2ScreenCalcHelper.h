//
//  M2KeyboardCalcHelper.h
//  chenms.m2
//
//  Created by Chen Meisong on 14/11/17.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//
//  *主要是适配了iOS8与iOS7及之前版本，最低版本iOS8之后的时代，本类就没存在的必要了；

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface M2ScreenCalcHelper : NSObject
// 键盘显示时，其左上角的坐标（适配iOS7、iOS8）
- (CGPoint)keyBoardLeftUpPointWithKeyboardFrame:(CGRect)keyboardFrame toView:(UIView *)view;
// 屏幕左下角坐标（适配iOS7、iOS8）
- (CGPoint)screenLeftBottomPointToView:(UIView *)view;
// 屏幕尺寸（适配iOS7、iOS8）
- (CGRect)screenBounds;
@end
