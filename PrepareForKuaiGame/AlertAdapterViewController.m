//
//  AlertAdapterViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/12/1.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "AlertAdapterViewController.h"
#import "M2AlertHelper.h"
#import "M2AlertOldStyleHelper.h"

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
    // new style
//    NSDictionary *cancelDict = @{kM2AH_Key_Title: @"取消",
//                                 kM2AH_Key_Handler: ^{
//                                     NSLog(@"取消  %s", __func__);
//                                 }};
//    NSDictionary *okDict = @{kM2AH_Key_Title: @"确定",
//                             kM2AH_Key_Handler: ^{
//                                 NSLog(@"确定  %s", __func__);
//                             }};
//    NSDictionary *otherDict = @{kM2AH_Key_Title: @"其他",
//                             kM2AH_Key_Handler: ^{
//                                 NSLog(@"其他  %s", __func__);
//                             }};
//    NSArray *otherDicts = @[okDict, otherDict];
//    [[M2AlertHelper sharedInstance] showAlertWithTitle:@"Hello iOS8"
//                                               message:@"Hello iOS8 Msg"
//                                      cancelActionDict:cancelDict
//                                      otherActionDicts:otherDicts
//                               presentInViewController:nil];
    
    // old style
    [[M2AlertOldStyleHelper sharedInstance] showAlertWithTitle:@"Hello iOS8"
                                                       message:@"Hello iOS8 Msg"
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@[@"确定", @"其他"]
                                              tapButtonHandler:^(NSInteger clickButtonIndex) {
                                                  NSLog(@"clickButtonIndex(%d)  %s", clickButtonIndex, __func__);
                                              }
                                       presentInViewController:nil];
}
- (void)onTapActionSheetButton {
    // new style
//    NSDictionary *cancelDict = @{kM2AH_Key_Title: @"取消",
//                                 kM2AH_Key_Handler: ^{
//                                     NSLog(@"取消  %s", __func__);
//                                 }};
//    NSDictionary *okDict = @{kM2AH_Key_Title: @"确定",
//                             kM2AH_Key_Handler: ^{
//                                 NSLog(@"确定  %s", __func__);
//                             }};
//    NSDictionary *otherDict = @{kM2AH_Key_Title: @"其他",
//                                kM2AH_Key_Handler: ^{
//                                    NSLog(@"其他  %s", __func__);
//                                }};
//    NSArray *otherDicts = @[okDict, otherDict];
//    [[M2AlertHelper sharedInstance] showActionSheetWithTitle:@"Hello iOS8"
//                                                     message:@"Hello iOS8 Msg"
//                                            cancelActionDict:cancelDict
//                                            otherActionDicts:otherDicts
//                                                  showInView:self.view
//                                     presentInViewController:nil];
     
    // old style
    [[M2AlertOldStyleHelper sharedInstance] showActionSheetWithTitle:@"Hello iOS8"
                                                             message:@"Hello iOS8 Msg"
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@[@"确定", @"其他"]
                                                    tapButtonHandler:^(NSInteger clickButtonIndex) {
                                                        NSLog(@"clickButtonIndex(%d)  %s", clickButtonIndex, __func__);
                                                    }
                                                          showInView:self.view
                                             presentInViewController:nil];
}

@end
