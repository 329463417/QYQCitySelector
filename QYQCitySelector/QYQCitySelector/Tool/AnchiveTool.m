//
//  AnchiveTool.m
//  CosFundLife
//
//  Created by qiuyaqingMac on 16/1/12.
//  Copyright © 2016年 上海同传金融信息服务有限公司. All rights reserved.
//

#import "AnchiveTool.h"

@implementation AnchiveTool
//Documents
+ (void)achiveWithArray:(NSMutableArray *)array FileName:(NSString *)fileName
{
    NSString *filePath = @"Documents/";
    NSString *localPath = [filePath stringByAppendingString:fileName] ;
    
    
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:localPath];
    
    BOOL flag = [NSKeyedArchiver archiveRootObject:array toFile:path];
    
    if (flag) {
        
        NSLog(@"归档成功");
    }
    
    else
    {
        NSLog(@"归档失败");
    }

}
+ (NSMutableArray *)unAchiveWithFileName:(NSString *)fileName
{
    NSString *filePath = @"Documents/";
    NSString *localPath = [filePath stringByAppendingString:fileName] ;
    
    NSString * pathMuArrayFindHistory = [NSHomeDirectory() stringByAppendingPathComponent:localPath];
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:pathMuArrayFindHistory];
    
    return arr;
}
@end
