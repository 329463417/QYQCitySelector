//
//  AddressBtn.m
//  CosFundLife
//
//  Created by qiuyaqingMac on 16/1/6.
//  Copyright © 2016年 上海同传金融信息服务有限公司. All rights reserved.
//

#import "AddressBtn.h"
#import "UIView+Frame.h"

@implementation AddressBtn

- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.contentMode = UIViewContentModeLeft;
  
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.imageView.contentMode = UIViewContentModeLeft;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
       // self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.titleLabel sizeToFit];
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*ergqewrgverger*/
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, self.width*0.75, self.height);
    
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{

    return CGRectMake(self.width*0.75+2, 12,12, 6);
    
}
#pragma mark - 重写父类的这个方法
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    CGRect rect = [self dynamicHeight:title fontSize:13];
    
    CGFloat with = rect.size.width;
    
    self.frame = CGRectMake(10, 0, with+14, 30);
    
}

//计算字符串的大小
- (CGRect)dynamicHeight:(NSString *)str fontSize:(NSInteger)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect;
}
@end
