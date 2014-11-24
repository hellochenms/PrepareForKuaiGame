//
//  _tempViewController.m
//  PrepareForKuaiGame
//
//  Created by Chen Meisong on 14-10-12.
//  Copyright (c) 2014年 chenms.m2. All rights reserved.
//

#import "_tempViewController.h"

@interface _tempViewController ()<UITextFieldDelegate>
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
    
    home-cms2014:.ssh chenmeisong$ cat known_hosts
    172.18.3.107 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD0yVZZaDWKfHbCzCh6R6BiXeuSXV1lS/exD6XYRLWA9OuTGoOQvP8pDt4bMn8srzc2h1DZ6NZK8Uyc2+yNiBie992PPiM7+Igp89XsMBpJcFSjMh3QMYTDr8z3CEDMF03bFUdEMzUow8KDh1yXL7VRIK8WfdKn678uJ+UxxLJ3fCACGCCHABQnlhnaAtqVJ0XWN33QHxXNws0IYhK0HPZZuX5t4hGBxMeJd4kcQJmIXwpYbGPP94ezQxM//QW7TeOPcu9Kc+RIUa6e5ofYBvH4B8m/czZHYrtE6zVyhFEf+cAIrKgxyRJy6NxhT+Z4r//VmRHPbCJfgtjBurbIfRVT
    192.168.1.106 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD0yVZZaDWKfHbCzCh6R6BiXeuSXV1lS/exD6XYRLWA9OuTGoOQvP8pDt4bMn8srzc2h1DZ6NZK8Uyc2+yNiBie992PPiM7+Igp89XsMBpJcFSjMh3QMYTDr8z3CEDMF03bFUdEMzUow8KDh1yXL7VRIK8WfdKn678uJ+UxxLJ3fCACGCCHABQnlhnaAtqVJ0XWN33QHxXNws0IYhK0HPZZuX5t4hGBxMeJd4kcQJmIXwpYbGPP94ezQxM//QW7TeOPcu9Kc+RIUa6e5ofYBvH4B8m/czZHYrtE6zVyhFEf+cAIrKgxyRJy6NxhT+Z4r//VmRHPbCJfgtjBurbIfRVT
    github.com,192.30.252.130 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
    192.30.252.131 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
    192.30.252.129 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
    
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYzaFXQD39PFsPXoblLafdGH+wYoTIsLrCbIhEMjH/KUfFITw5ig01TlNOaKHdyHIvCWXpVQ5KIaPlH9xHvM7+9td2Vixv1Z7M+JQ8TcnuLcSnhiIn1QSt3YSVscV/gouNAj2/PE+AkxEe+ceSc0dAon2vB4lI+6/TwdT45IfZroLaMFrMF2ZmKE392PRTGo9GO2VBy1/kaw9yxTMiMfrhz4Yg0UHondBkoD0dIcHOydpiQ8+NIYis38HYXIzskMb+CSnQV4Rw9Z+c+rHB1QFuiU0nHLcuTyp9shMAesbug/EITk/tJngX4MiBtfjWKFsPnUeBQ54B6cic1pygYtDx iami10buxi@sina.com

}

- (void)onTapButton{
    [[UIDevice currentDevice] userInterfaceIdiom];
    NSLog(@"%d  %s", ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad), __func__);
}

@end
