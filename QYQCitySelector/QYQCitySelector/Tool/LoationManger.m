//
//  LoationManger.m
//  CosFundLife
//
//  Created by qiuyaqingMac on 16/1/15.
//  Copyright © 2016年 上海同传金融信息服务有限公司. All rights reserved.
//

#import "LoationManger.h"

@interface LoationManger()<CLLocationManagerDelegate>
{
    CLLocation *_cllocation;

}


@property (nonatomic , strong)CLLocationManager *locationManager;

@end
@implementation LoationManger

+ (LoationManger *)sharedManager{
    static LoationManger *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
#pragma 地图定位
- (void)location
{
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10;
        [_locationManager requestWhenInUseAuthorization];
        
        [_locationManager startUpdatingLocation];//开启定位
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    // 开始定位
    [_locationManager startUpdatingLocation];
    

}

#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在的城市名
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     
    {
        
        if (array.count > 0)
            
        {
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            
            NSLog(@"%@",placemark.name);
            
            //获取城市
            
            NSString *city = placemark.locality;
            
            if (!city) {
                
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                
                city = placemark.administrativeArea;
                
            }
            
            if ([_delegate respondsToSelector:@selector(loationMangerSuccessLocationWithCity:)]) {
                
                [_delegate loationMangerSuccessLocationWithCity:city];
                
            }
            
        }
        
        else if (error == nil && [array count] == 0)
            
        {
            
            NSLog(@"No results were returned.");
            
        }
        
        else if (error != nil)
            
        {
            
            NSLog(@"An error occurred = %@", error);
            
        }
        
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    
    [manager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager

       didFailWithError:(NSError *)error {
    
    if ([_delegate respondsToSelector:@selector(loationMangerFaildWithError:)]) {
        
        [_delegate loationMangerFaildWithError:error];
        
        
    }
//    if (error.code == kCLErrorDenied) {
//        
//        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
//        
//    }
    
}



@end
