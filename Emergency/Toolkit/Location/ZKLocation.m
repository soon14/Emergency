//
//  ZKLocation.m
//  Emergency
//
//  Created by 王小腊 on 2017/7/3.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKLocation.h"
#import "WGS84TOGCJ02.h"
@interface ZKLocation ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, assign) BOOL isLocatio;
@end
@implementation ZKLocation
#pragma mark - public
- (void)beginUpdatingLocation
{
    self.isLocatio = NO;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - location delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //获取新的位置
    CLLocation * newLocation = locations.lastObject;
    
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[newLocation coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[newLocation coordinate]];
        newLocation = nil;
        newLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    }
    //创建自定制位置对象
    Location * location = [[Location alloc] init];
    //存储经度
    location.longitude = newLocation.coordinate.longitude;
    //存储纬度
    location.latitude = newLocation.coordinate.latitude;
    
    //根据经纬度反向地理编译出地址信息
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count > 0 && self.isLocatio == NO) {
            self.isLocatio = YES;
            CLPlacemark * placemark = placemarks.firstObject;
            //存储位置信息
            location.country = placemark.country;
            location.administrativeArea = placemark.administrativeArea;
            location.locality = placemark.locality;
            location.subLocality = placemark.subLocality;
            location.thoroughfare = placemark.thoroughfare;
            location.subThoroughfare = placemark.subThoroughfare;
            
            //设置代理方法
            if ([self.delegate respondsToSelector:@selector(locationDidEndUpdatingLocation:)]) {
                
                [self.delegate locationDidEndUpdatingLocation:location];
            }
        }
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
{
    if (self.isLocatio == NO)
    {
        self.isLocatio = YES;
        if ([self.delegate respondsToSelector:@selector(locationDidFailWithError)]) {
            [self.delegate locationDidFailWithError];
        }
    }
}
#pragma mark - setter and getter
- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        // 设置定位精确度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // 设置过滤器为无
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        
        // 取得定位权限，有两个方法，取决于你的定位使用情况
        // 一个是 requestAlwaysAuthorization
        // 一个是 requestWhenInUseAuthorization
        [_locationManager requestAlwaysAuthorization];//ios8以上版本使用。
    }
    return _locationManager;
}
@end
