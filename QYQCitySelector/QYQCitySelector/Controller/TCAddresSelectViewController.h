//
//  TCAddresSelectViewController.h
//  CosFundLife
//
//  Created by qiuyaqingMac on 16/1/6.
//  Copyright © 2016年 上海同传金融信息服务有限公司. All rights reserved.
//  /*定位*/

#import <UIKit/UIKit.h>

@protocol TCAddresSelectViewControllerDelegate <NSObject>

- (void)TCAddresSelectViewControllerDidSelectTitle:(NSString *)title;

@end
@interface TCAddresSelectViewController : UIViewController

//搜索栏
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;

@property (weak, nonatomic) IBOutlet UITableView *tbView;

@property (nonatomic, assign) id<TCAddresSelectViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isLoaction;
@end
