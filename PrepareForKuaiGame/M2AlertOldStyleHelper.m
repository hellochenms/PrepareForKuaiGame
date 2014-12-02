//
//  M2AlertOldStyleHelper.m
//  chenms.m2
//
//  Created by Chen Meisong on 14/12/2.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "M2AlertOldStyleHelper.h"

@interface M2AlertOldStyleHelper ()<UIAlertViewDelegate, UIActionSheetDelegate>
@property (nonatomic) BOOL isIOS8OrAbove;
@property (nonatomic, copy) M2AOSHIntegerHandler tapButtonHandler;
@property (nonatomic) NSInteger otherButtonTitlesCount;
@end

@implementation M2AlertOldStyleHelper

+ (instancetype)sharedInstance {
    static M2AlertOldStyleHelper *s_instance = nil;
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
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSArray *)otherButtonTitles
          tapButtonHandler:(M2AOSHIntegerHandler)tapButtonHandler
   presentInViewController:(UIViewController *)presentInViewController {
    [self reset];
    self.tapButtonHandler = tapButtonHandler;
    if (self.isIOS8OrAbove) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        // 取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 if (weakSelf.tapButtonHandler) {
                                                                     weakSelf.tapButtonHandler(0);
                                                                 }
                                                             }];
        [alertController addAction:cancelAction];
        
        // 其他按钮
        [otherButtonTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    if (weakSelf.tapButtonHandler) {
                                                                        weakSelf.tapButtonHandler(idx + 1);
                                                                    }
                                                                }];
            [alertController addAction:otherAction];
        }];
        
        // 弹出
        if (!presentInViewController) {
            presentInViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        }
        [presentInViewController presentViewController:alertController
                                              animated:YES
                                            completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelButtonTitle
                                                  otherButtonTitles:nil];
        [otherButtonTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            [alertView addButtonWithTitle:title];
        }];
        [alertView show];
    }
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.tapButtonHandler) {
        self.tapButtonHandler(buttonIndex);
    }
}

#pragma mark - ActionSheet
- (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
               cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitles:(NSArray *)otherButtonTitles
                tapButtonHandler:(M2AOSHIntegerHandler)tapButtonHandler
                      showInView:(UIView *)showInView
         presentInViewController:(UIViewController *)presentInViewController {
    [self reset];
    self.tapButtonHandler = tapButtonHandler;
    if (self.isIOS8OrAbove) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        // 取消按钮
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 if (weakSelf.tapButtonHandler) {
                                                                     weakSelf.tapButtonHandler(0);
                                                                 }
                                                             }];
        [alertController addAction:cancelAction];
        
        // 其他按钮
        [otherButtonTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    if (weakSelf.tapButtonHandler) {
                                                                        weakSelf.tapButtonHandler(idx + 1);
                                                                    }
                                                                }];
            [alertController addAction:otherAction];
        }];
        
        // 弹出
        if (!presentInViewController) {
            presentInViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        }
        [presentInViewController presentViewController:alertController
                                              animated:YES
                                            completion:nil];
    } else {
        UIActionSheet *actionSheetView = [[UIActionSheet alloc] initWithTitle:title
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:nil];
        self.otherButtonTitlesCount = [otherButtonTitles count];
        // 其他按钮
        [otherButtonTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            [actionSheetView addButtonWithTitle:title];
        }];
        // 取消按钮
        [actionSheetView addButtonWithTitle:cancelButtonTitle];
        actionSheetView.cancelButtonIndex = [otherButtonTitles count];
        
        // 弹出
        [actionSheetView showInView:showInView];
    }
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 注意：addButtonWithTitle为了达到init方式的效果，cancel按钮的index不是0
    //      但用户习惯上认为cancel是0，故在此做个转换
    if (self.tapButtonHandler) {
        if (buttonIndex == self.otherButtonTitlesCount) {
            self.tapButtonHandler(0);
        } else {
            self.tapButtonHandler(buttonIndex + 1);
        }
    }
}

#pragma mark - reset
- (void)reset {
    self.tapButtonHandler = nil;
    self.otherButtonTitlesCount = 0;
}

@end
