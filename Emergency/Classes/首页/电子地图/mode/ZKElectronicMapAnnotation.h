//
//  ZKElectronicMapAnnotation.h
//  Emergency
//
//  Created by 王小腊 on 2017/6/28.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAnnotation.h"
@interface ZKElectronicMapAnnotation : NSObject<TAnnotation> {
    NSString *_title;
    CLLocationCoordinate2D _coordinate;
}
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
// 标记
@property (nonatomic, assign) NSInteger annotationTag;
@end
