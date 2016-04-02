//
//  ScanTableViewCell.m
//  BlueTooth
//
//  Created by kong on 16/4/2.
//  Copyright © 2016年 kong. All rights reserved.
//

#import "ScanTableViewCell.h"

@implementation ScanTableViewCell{

    //TODO: 设备名称
    __weak IBOutlet UILabel *_deviceName;
    
    //TODO: 信号强度
    __weak IBOutlet UILabel *_signal;
    
    //TODO: ID
    __weak IBOutlet UILabel *_RSSID;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews{
    
    [super layoutSubviews];

    [self initUI];
    
}

- (void)setModel:(ScanModel *)model{

    if (_model != model)
        
    {
        _model = model;
        
        [self setNeedsLayout];
    }
}

/**
 *  赋值UI
 */
- (void)initUI
{
    _deviceName.text = _model.name;
    
    _signal.text = [NSString stringWithFormat:@"%@",_model.RSSI];

}

@end
