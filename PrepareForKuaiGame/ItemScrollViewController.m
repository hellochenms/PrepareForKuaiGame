//
//  ItemScrollViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/11/27.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "ItemScrollViewController.h"
#import "ScrollItemsBrowser.h"

@interface ItemScrollViewController ()

@end

@implementation ItemScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ScrollItemsBrowser *scrollItemsBrowser = [[ScrollItemsBrowser alloc] initWithFrame:CGRectMake(100, 80, 120, 300)];
    [self.view addSubview:scrollItemsBrowser];
//    [scrollItemsBrowser reloadDatas:@[@"0", @"1", @"2", @"3", @"4"]];
//    [scrollItemsBrowser reloadDatas:@[@"0", @"1", @"2", @"3", @"4"]];
    [scrollItemsBrowser reloadDatas:@[@"0", @"1", @"2"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
