//
//  LoationManger.h
//  CosFundLife
//
//  Created by qiuyaqingMac on 16/1/15.
//  Copyright © 2016年 上海同传金融信息服务有限公司. All rights reserved.
//  /*定位的工具*/

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>    //定位的框架


@protocol LoationMangerDelegate <NSObject>

- (void)loationMangerSuccessLocationWithCity:(NSString *)city;
- (void)loationMangerFaildWithError:(NSError *)error;

@end
@interface LoationManger : NSObject<CLLocationManagerDelegate>


@property (nonatomic ,weak)id<LoationMangerDelegate>delegate;


- (void)location;
+ (LoationManger *)sharedManager;

@end
