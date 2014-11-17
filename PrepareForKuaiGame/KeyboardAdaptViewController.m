//
//  KeyboardAdaptViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14/11/17.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "KeyboardAdaptViewController.h"
#import "KeyboardAdaptView.h"

@interface KeyboardAdaptViewController ()
@property (nonatomic) KeyboardAdaptView *keyboardAdaptView;
@end

@implementation KeyboardAdaptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.clipsToBounds = YES;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _keyboardAdaptView = [[KeyboardAdaptView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_keyboardAdaptView];
    [self adjustViewlayout];
    
    [_keyboardAdaptView adjustSubViewsLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onApplicationDidChangeStatusBarOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 旋屏通知
- (void)onApplicationDidChangeStatusBarOrientation:(NSNotification *)notification {
    [self adjustViewlayout];
    [self.keyboardAdaptView adjustSubViewsLayout];
}

#pragma mark -
- (void)adjustViewlayout {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect frame = self.keyboardAdaptView.frame;
    if (isIOS8) {
        frame.size.width = screenBounds.size.width;
        frame.size.height = screenBounds.size.height;
    } else {
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationPortrait:
            case UIDeviceOrientationPortraitUpsideDown:
                frame.size.width = screenBounds.size.width;
                frame.size.height = screenBounds.size.height;
                break;
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationLandscapeRight:
                frame.size.width = screenBounds.size.height;
                frame.size.height = screenBounds.size.width;
                break;
            default:
                break;
        }
    }
    
    self.keyboardAdaptView.frame = frame;
    [self.keyboardAdaptView adjustSubViewsLayout];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//#pragma mark - ori
//- (BOOL)shouldAutorotate {
//    return YES;
//}
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskAll;
//}

#pragma mark - dealloc 
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
