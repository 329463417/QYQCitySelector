//
//  HisAddressCell.m
//  CosFundLife
//
//  Created by qiuyaqingMac on 16/1/6.
//  Copyright © 2016年 上海同传金融信息服务有限公司. All rights reserved.
//

#import "HisAddressCell.h"



@implementation HisAddressCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configArray:(NSArray *)addArr
{
   
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat leftMargin = 15;        //左边的缝隙
    CGFloat topMargin = 20;        //顶部的缝隙
    
    CGFloat margin = 10;            //Label之间的缝隙
    CGFloat with = ((ScreenWidth-10)-2*leftMargin-2*margin)/3;
    CGFloat height = 44;

    int totalloc = 3;  //总共3列

    for (int i=0; i<addArr.count; i++) {
        
        int loc = i%totalloc;  //列号
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin+(with+margin)*loc, topMargin, with, height)];
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:14];
        [label addGestureRecognizer:tap];
        
        label.text = addArr[i];
        label.textAlignment = NSTextAlignmentCenter;
       
        label.backgroundColor =kTCColor(245, 245, 245);
        
        [self.contentView addSubview:label];
   
    }
}
#pragma mark - 点击Label
- (void)labelTap:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UILabel class]]) {
        
        UILabel *label = (UILabel *)tap.view;
        
        if ([_delegate respondsToSelector:@selector(HisAddressCellLabelClickWithLabelText:)]) {
            
            [_delegate HisAddressCellLabelClickWithLabelText:label.text];
            
        }

        NSLog(@"%@",label.text);
        
    }
}
@end
