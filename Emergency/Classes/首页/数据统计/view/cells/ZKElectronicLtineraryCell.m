//
//  ZKRunningTrackCell.m
//  yjPingTai
//
//  Created by Daqsoft-Mac on 15/9/18.
//  Copyright (c) 2015年 WangXiaoLa. All rights reserved.
//

#import "ZKElectronicLtineraryCell.h"

@implementation ZKElectronicLtineraryCell

{
    
    UIImageView*lefImage;
    
    UILabel *tiemLabel;
    
    UILabel *busnameLabel;
    
    UILabel *zuobiaoLabel;
    
    UILabel *indexLabel;
    
}
- (void)awakeFromNib {
    // Initialization code
      [super awakeFromNib];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame] ;
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        
        float lef =12;
        float fot =12;
        UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(lef+5, 0, 1,80)];
        lin.backgroundColor = CYBColorGreen;
        [self addSubview:lin];
        
        lefImage = [[UIImageView alloc]initWithFrame:CGRectMake(lef, 5, 10, 10)];
        [self addSubview:lefImage];
        tiemLabel = [[UILabel alloc]initWithFrame:CGRectMake(lef*2+14,fot, 300, 20)];
        tiemLabel.textAlignment =NSTextAlignmentLeft;
        tiemLabel.font =[UIFont systemFontOfSize:14];
        tiemLabel.textColor = CYBColorGreen;
        [self addSubview:tiemLabel];
        
        busnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(lef*2+14, fot+25, _SCREEN_WIDTH-lef*2-14-10, 20)];
        busnameLabel.textAlignment =NSTextAlignmentLeft;
        busnameLabel.font =[UIFont systemFontOfSize:12];
        busnameLabel.textColor = CYBColorGreen;
        [self addSubview:busnameLabel];
        
        zuobiaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(lef*2+14, fot+48, _SCREEN_WIDTH-lef*2-14-10, 20)];
        zuobiaoLabel.textAlignment = NSTextAlignmentLeft;
        zuobiaoLabel.font =[UIFont systemFontOfSize:12];
        zuobiaoLabel.textColor = CYBColorGreen;
        [self addSubview:zuobiaoLabel];
        
        lefImage.frame = CGRectMake(0, 0, 20, 26);
        lefImage.center = CGPointMake(18, 22);
        
        indexLabel = [[UILabel alloc]initWithFrame:lefImage.bounds];
        indexLabel.textAlignment =NSTextAlignmentCenter;
        indexLabel.center =CGPointMake(10, 11);
        indexLabel.textColor =[UIColor whiteColor];
        indexLabel.font =[UIFont systemFontOfSize:12];
        [lefImage addSubview:indexLabel];
        
    }
    
    return self;
}
-(void)update:(ZKElectronicLtineraryMode*)list Largen:(BOOL)la index:(NSInteger)dex;
{
    if (la  ==YES)
    {
        lefImage.image = [UIImage imageNamed:@"annont_1"];
        tiemLabel.textColor = RGB(255, 110, 0);
        busnameLabel.textColor = RGB(255, 110, 0);
        zuobiaoLabel.textColor = RGB(255, 110, 0);

    }else{
        
        lefImage.image = [UIImage imageNamed:@"annont_0"];
        tiemLabel.textColor = CYBColorGreen;
        busnameLabel.textColor = CYBColorGreen;
        zuobiaoLabel.textColor = CYBColorGreen;

    }
    tiemLabel.text = list.time;
    indexLabel.text = [NSString stringWithFormat:@"%ld",dex+1];
    busnameLabel.text = [NSString stringWithFormat:@"行程安排: %@",list.journey];
    if (strIsEmpty(list.hotel)) {
        
        list.hotel = @"未知酒店";
    }
    zuobiaoLabel.text =[NSString stringWithFormat:@"入住酒店: %@",list.hotel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
