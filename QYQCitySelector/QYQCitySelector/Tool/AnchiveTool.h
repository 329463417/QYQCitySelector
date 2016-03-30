//
//  AnchiveTool.h
//  CosFundLife
//
//  Created by qiuyaqingMac on 16/1/12.
//  Copyright © 2016年 上海同传金融信息服务有限公司. All rights reserved.
//  /*归档和解归档的一个工具*/

#import <Foundation/Foundation.h>

@interface AnchiveTool : NSObject

+ (void)achiveWithArray:(NSMutableArray *)array FileName:(NSString *)fileName;


+ (NSMutableArray *)unAchiveWithFileName:(NSString *)fileName;

@end
