//
//  M2AlertHelper.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/12/1.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "M2AlertHelper.h"

const NSString *kM2AH_Key_Title = @"M2AH_Key_Title";
const NSString *kM2AH_Key_Handler = @"M2AH_Key_Handler";

@interface M2AlertHelper ()<UIAlertViewDelegate, UIActionSheetDelegate>
@property (nonatomic) BOOL isIOS8OrAbove;
@property (nonatomic) NSDictionary *cancelActionDict;
@property (nonatomic) NSArray *otherActionDicts;
@end

@implementation M2AlertHelper
+ (instancetype)sharedInstance {
    static M2AlertHelper *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [self new];
    });
    
    return s_instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _isIOS8OrAbove = ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0);
    }
    
    return self;
}

#pragma mark - Alert
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
   presentInViewController:(UIViewController *)presentInViewController
          cancelActionDict:(NSDictionary *)cancelActionDict
          otherActionDicts:(NSArray *)otherActionDicts {
    [self reset];
    if (self.isIOS8OrAbove) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        // 取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[cancelActionDict objectForKey:kM2AH_Key_Title]
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 M2AHVoidHandler handler = [cancelActionDict objectForKey:kM2AH_Key_Handler];
                                                                 if (handler) {
                                                                     handler();
                                                                 }
                                                             }];
        [alertController addAction:cancelAction];
        
        // 其他按钮
        [otherActionDicts enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:[dict objectForKey:kM2AH_Key_Title]
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 M2AHVoidHandler handler = [dict objectForKey:kM2AH_Key_Handler];
                                                                 if (handler) {
                                                                     handler();
                                                                 }
                                                             }];
            [alertController addAction:otherAction];
        }];
        
        // 弹出
        [presentInViewController presentViewController:alertController
                                              animated:YES
                                            completion:nil];
    } else {
        self.cancelActionDict = cancelActionDict;
        self.otherActionDicts = otherActionDicts;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:[cancelActionDict objectForKey:kM2AH_Key_Title]
                                                  otherButtonTitles:nil];
        [otherActionDicts enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            [alertView addButtonWithTitle:[dict objectForKey:kM2AH_Key_Title]];
        }];
        [alertView show];
    }
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        M2AHVoidHandler handler = [self.cancelActionDict objectForKey:kM2AH_Key_Handler];
        if (handler) {
            handler();
        }
    } else {
        NSDictionary *actionDict = [self.otherActionDicts objectAtIndex:buttonIndex - 1];
        M2AHVoidHandler handler = [actionDict objectForKey:kM2AH_Key_Handler];
        if (handler) {
            handler();
        }
    }
}

#pragma mark - ActionSheet
- (void)showActionSheetWithTitle:(NSString *)title
                   message:(NSString *)message
   presentInViewController:(UIViewController *)presentInViewController
                showInView:(UIView *)showInView
          cancelActionDict:(NSDictionary *)cancelActionDict
          otherActionDicts:(NSArray *)otherActionDicts {
    [self reset];
    if (self.isIOS8OrAbove) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        // 取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[cancelActionDict objectForKey:kM2AH_Key_Title]
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 M2AHVoidHandler handler = [cancelActionDict objectForKey:kM2AH_Key_Handler];
                                                                 if (handler) {
                                                                     handler();
                                                                 }
                                                             }];
        [alertController addAction:cancelAction];
        
        // 其他按钮
        [otherActionDicts enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:[dict objectForKey:kM2AH_Key_Title]
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    M2AHVoidHandler handler = [dict objectForKey:kM2AH_Key_Handler];
                                                                    if (handler) {
                                                                        handler();
                                                                    }
                                                                }];
            [alertController addAction:otherAction];
        }];
        
        // 弹出
        [presentInViewController presentViewController:alertController
                                              animated:YES
                                            completion:nil];
    } else {
        self.cancelActionDict = cancelActionDict;
        self.otherActionDicts = otherActionDicts;
        UIActionSheet *actionSheetView = [[UIActionSheet alloc] initWithTitle:title
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:nil];
        // 其他按钮
        [otherActionDicts enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            [actionSheetView addButtonWithTitle:[dict objectForKey:kM2AH_Key_Title]];
        }];
        // 取消按钮
        [actionSheetView addButtonWithTitle:[cancelActionDict objectForKey:kM2AH_Key_Title]];
        actionSheetView.cancelButtonIndex = [otherActionDicts count];
        
        // 弹出
        [actionSheetView showInView:showInView];
    }
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        M2AHVoidHandler handler = [self.cancelActionDict objectForKey:kM2AH_Key_Handler];
        if (handler) {
            handler();
        }
    } else {
        NSDictionary *actionDict = [self.otherActionDicts objectAtIndex:buttonIndex - 1];
        M2AHVoidHandler handler = [actionDict objectForKey:kM2AH_Key_Handler];
        if (handler) {
            handler();
        }
    }
}

#pragma mark - reset
- (void)reset {
    self.cancelActionDict = nil;
    self.otherActionDicts = nil;
}

@end
