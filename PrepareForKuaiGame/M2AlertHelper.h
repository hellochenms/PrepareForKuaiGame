//
//  M2AlertHelper.h
//  PrepareForKuaiGame
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
   presentInViewController:(UIViewController *)presentInViewController
          cancelActionDict:(NSDictionary *)cancelActionDict
          otherActionDicts:(NSArray *)otherActionDicts;
- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
         presentInViewController:(UIViewController *)presentInViewController
                      showInView:(UIView *)showInView
                cancelActionDict:(NSDictionary *)cancelActionDict
                otherActionDicts:(NSArray *)otherActionDicts;
@end
