//
//  AlertAdapterViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/12/1.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "AlertAdapterViewController.h"
#import "M2AlertHelper.h"

@interface AlertAdapterViewController ()<UIAlertViewDelegate, UIActionSheetDelegate>

@end

@implementation AlertAdapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    alertButton.frame = CGRectMake(10, 70, 300, 30);
    alertButton.backgroundColor = [UIColor blueColor];
    [alertButton setTitle:@"Alert" forState:UIControlStateNormal];
    [alertButton addTarget:self action:@selector(onTapAlertButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertButton];
    
    UIButton *actionSheetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionSheetButton.frame = CGRectMake(10, 110, 300, 30);
    actionSheetButton.backgroundColor = [UIColor blueColor];
    [actionSheetButton setTitle:@"ActionSheet" forState:UIControlStateNormal];
    [actionSheetButton addTarget:self action:@selector(onTapActionSheetButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionSheetButton];
}

#pragma mark - 
- (void)onTapAlertButton {
    NSDictionary *cancelDict = @{kM2AH_Key_Title: @"取消",
                                 kM2AH_Key_Handler: ^{
                                     NSLog(@"取消  %s", __func__);
                                 }};
    NSDictionary *okDict = @{kM2AH_Key_Title: @"确定",
                             kM2AH_Key_Handler: ^{
                                 NSLog(@"确定  %s", __func__);
                             }};
    NSDictionary *otherDict = @{kM2AH_Key_Title: @"其他",
                             kM2AH_Key_Handler: ^{
                                 NSLog(@"其他  %s", __func__);
                             }};
    NSArray *otherDicts = @[okDict, otherDict];
    [[M2AlertHelper sharedInstance] showAlertWithTitle:@"Hello iOS8"
                                               message:@"Hello iOS8 Msg"
                               presentInViewController:self
                                      cancelActionDict:cancelDict
                                      otherActionDicts:otherDicts];
    
/* 测试
    if (isIOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hello iOS8"
                                                                                 message:@"Hello iOS8 Msg"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertController *weakAlertController = alertController;
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 NSLog(@"取消  %s", __func__);
                                                             }];
        [weakAlertController addAction:cancelAction];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             NSLog(@"确定  %s", __func__);
                                                         }];
        [weakAlertController addAction:okAction];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"其他"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                NSLog(@"其他  %s", __func__);
                                                            }];
        [weakAlertController addAction:otherAction];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello iOS7"
                                                            message:@"Hello iOS7 Msg"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", @"其他", nil];
        [alertView show];
    }
*/
    
}
- (void)onTapActionSheetButton {
    NSDictionary *cancelDict = @{kM2AH_Key_Title: @"取消",
                                 kM2AH_Key_Handler: ^{
                                     NSLog(@"取消  %s", __func__);
                                 }};
    NSDictionary *okDict = @{kM2AH_Key_Title: @"确定",
                             kM2AH_Key_Handler: ^{
                                 NSLog(@"确定  %s", __func__);
                             }};
    NSDictionary *otherDict = @{kM2AH_Key_Title: @"其他",
                                kM2AH_Key_Handler: ^{
                                    NSLog(@"其他  %s", __func__);
                                }};
    NSArray *otherDicts = @[okDict, otherDict];
    [[M2AlertHelper sharedInstance] showActionSheetWithTitle:@"Hello iOS8"
                                                     message:@"Hello iOS8 Msg"
                                     presentInViewController:self
                                                  showInView:self.view
                                            cancelActionDict:cancelDict
                                            otherActionDicts:otherDicts];
/* 测试
    if (isIOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hello iOS8"
                                                                                 message:@"Hello iOS8 Msg"
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        __weak UIAlertController *weakAlertController = alertController;
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 NSLog(@"取消  %s", __func__);
                                                             }];
        [weakAlertController addAction:cancelAction];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             NSLog(@"确定  %s", __func__);
                                                         }];
        [weakAlertController addAction:okAction];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"其他"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                NSLog(@"其他  %s", __func__);
                                                            }];
        [weakAlertController addAction:otherAction];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Hello iOS8 Msg"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"确定", @"其他", nil];
        [actionSheet showInView:self.view];
        
    }
*/
}

/*
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"取消  %s", __func__);
            break;
        case 1:
            NSLog(@"确定  %s", __func__);
            break;
        case 2:
            NSLog(@"其他  %s", __func__);
            break;
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"取消  %s", __func__);
            break;
        case 1:
            NSLog(@"确定  %s", __func__);
            break;
        case 2:
            NSLog(@"其他  %s", __func__);
            break;
        default:
            break;
    }
}
*/

@end
