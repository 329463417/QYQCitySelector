//
//  HisAddressCell.h
//  CosFundLife
//
//  Created by qiuyaqingMac on 16/1/6.
//  Copyright © 2016年 上海同传金融信息服务有限公司. All rights reserved.
//  

#import <UIKit/UIKit.h>

@protocol HisAddressCellDelegate <NSObject>

- (void)HisAddressCellLabelClickWithLabelText:(NSString *)text;

@end

@interface HisAddressCell : UITableViewCell

- (void)configArray:(NSArray *)addArr;

@property (nonatomic, weak) id<HisAddressCellDelegate> delegate;
@end
