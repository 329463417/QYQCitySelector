//
//  AppDelegate.m
//  cosfund
//
//  Created by qiuyaqingMac on 15/9/10.
//  Copyright (c) 2015年 TC. All rights reserved.
//  **************此分类可以直接获取view的x，y，width，height，********


#import <UIKit/UIKit.h>

@interface UIView (Frame)
// 分类不能添加成员属性
// @property如果在分类里面，只会自动生成get,set方法的声明，不会生成成员属性，和方法的实现
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;


@end
