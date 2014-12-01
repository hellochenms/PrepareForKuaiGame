//
//  _tempViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14-10-12.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "_tempViewController.h"

@interface _tempViewController ()<UIActionSheetDelegate>
@property (nonatomic) UITextField *textField;
@end

@implementation _tempViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 10, 300, 30);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onTapButton{
//    NSLog(@"%d  %s", ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad), __func__);
    
    UIActionSheet *actionSheetView = [[UIActionSheet alloc] initWithTitle:@"title"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
    actionSheetView.cancelButtonIndex = 2;
    
    [actionSheetView addButtonWithTitle:@"确定"];
    [actionSheetView addButtonWithTitle:@"其他"];
    
    [actionSheetView addButtonWithTitle:@"取消"];
    [actionSheetView showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex(%d)  %s", buttonIndex, __func__);
}

@end
