//
//  M2AlertHelper.h
//  chenms.m2
//
//  Created by Chen Meisong on 14/12/1.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString *kM2AH_Key_Title;
FOUNDATION_EXTERN NSString *kM2AH_Key_Handler;
typedef void (^M2AHVoidHandler)(void);

@interface M2AlertHelper : NSObject
+ (instancetype)sharedInstance;
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
          cancelActionDict:(NSDictionary *)cancelActionDict
          otherActionDicts:(NSArray *)otherActionDicts
   presentInViewController:(UIViewController *)presentInViewController;
- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                cancelActionDict:(NSDictionary *)cancelActionDict
                otherActionDicts:(NSArray *)otherActionDicts
                      showInView:(UIView *)showInView
         presentInViewController:(UIViewController *)presentInViewController;

@end
