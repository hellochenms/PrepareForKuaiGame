//
//  M2AlertOldStyleHelper.h
//  chenms.m2
//
//  Created by Chen Meisong on 14/12/2.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^M2AOSHIntegerHandler)(NSInteger clickButtonIndex);

@interface M2AlertOldStyleHelper : NSObject

+ (instancetype)sharedInstance;
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSArray *)otherButtonTitles
          tapButtonHandler:(M2AOSHIntegerHandler)tapButtonHandler
   presentInViewController:(UIViewController *)presentInViewController;
- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
               cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitles:(NSArray *)otherButtonTitles
                tapButtonHandler:(M2AOSHIntegerHandler)tapButtonHandler
                      showInView:(UIView *)showInView
         presentInViewController:(UIViewController *)presentInViewController;
@end

