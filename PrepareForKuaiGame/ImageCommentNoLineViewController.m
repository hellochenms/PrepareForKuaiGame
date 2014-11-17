//
//  ImageCommentNoLineViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14-11-6.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "ImageCommentNoLineViewController.h"
#import "ImageCommentNoLineView.h"

@interface ImageCommentNoLineViewController ()

@end

@implementation ImageCommentNoLineViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        // view中有scrollView且使用系统的naviBar时，不写下句，则系统会自动调整scrollView的inset。
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        ImageCommentNoLineView *mainView = [[ImageCommentNoLineView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:mainView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
