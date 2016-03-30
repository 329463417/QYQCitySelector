//
//  RootViewController.m
//  CosFundLife
//
//  Created by qiuyaqingMac on 16/1/15.
//  Copyright © 2016年 上海同传金融信息服务有限公司. All rights reserved.
//

#import "RootViewController.h"
#import "TCAddresSelectViewController.h"
#import "AddressBtn.h"

@interface RootViewController ()<TCAddresSelectViewControllerDelegate>

@property (nonatomic, strong) AddressBtn *leftBarButton;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self conFigUI];
}

- (void)conFigUI
{
    self.title = @"城市选择";
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatBurButton];
    
}
#pragma mark - 添加左边导航按钮
- (void)creatBurButton
{
    self.leftBarButton = [AddressBtn buttonWithType:UIButtonTypeCustom];
    //CGRectMake(10, 0, 55, 30)
    [self.leftBarButton setTitle:@"上海" forState:UIControlStateNormal];
    [self.leftBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.leftBarButton setImage:[UIImage imageNamed:@"arr2"] forState:UIControlStateNormal];
    [self.leftBarButton addTarget:self action:@selector(addressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarButton];
}
- (void)addressBtnClick:(UIButton *)button
{
    TCAddresSelectViewController *adVc = [[TCAddresSelectViewController alloc] init];
    
    adVc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:adVc];
    
    
    [self.navigationController presentViewController:navc animated:YES completion:nil];
    
}

#pragma mark - addressSelectViewController代理方法
- (void)TCAddresSelectViewControllerDidSelectTitle:(NSString *)title
{
    [self.leftBarButton setTitle:title forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
