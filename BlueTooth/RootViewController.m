//
//  RootViewController.m
//  BlueTooth
//
//  Created by kong on 16/3/17.
//  Copyright © 2016年 kong. All rights reserved.
//

#import "RootViewController.h"

//导入蓝牙第三方库
#import "BabyBluetooth.h"

@interface RootViewController (){

    BabyBluetooth *_blueTooth;
    
    NSMutableArray *_peripherials; //外设
    
    NSMutableArray *_periphetialsAD;//外设services
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor orangeColor];
    
    self.title = @"首页";
    
    [self initUI];
    
}


/**
 *  初始化UI
 */
- (void)initUI{
    
    _blueTooth = [BabyBluetooth shareBabyBluetooth];
    
    _peripherials = [NSMutableArray array];
    
    _periphetialsAD = [NSMutableArray array];
    
    
    //蓝牙网管设置
//    [self blueToothDelegate];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(( KScreenWidth - 100 ) / 2, ( KScreenHeight - 50 ) / 2, 100, 50);
    
    [button setTitle:@"蓝牙连接" forState:UIControlStateNormal];
    
    button.backgroundColor = [UIColor blueColor];
    
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

/**
 *  蓝牙连接按钮
 *
 *  @param btn
 */
- (void)btnClick:(UIButton *)btn{
    
    [SVProgressHUD showInfoWithStatus:@"准备打开蓝牙"];
      
    //蓝牙高级设置
    _blueTooth.scanForPeripherals().connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForCharacteristic().begin();


}

/**
 *  蓝牙网管设置
 */
- (void)blueToothDelegate{
    
    __weak typeof(self) weakself = self;
    
    //打开蓝牙 开始扫描
    [_blueTooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
       
        if (central.state == CBCentralManagerStatePoweredOn) {
            
            [SVProgressHUD showInfoWithStatus:@"设备已经打开蓝牙,开始扫描"];
            
            NSLog(@"打开了蓝牙,正在扫描");
        }
    }];
    
    //扫描设备
    [_blueTooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //扫描弹框提示是否连接该设备
        [weakself showAlert:peripheral.name];
        
        NSLog(@"扫描到了设备:%@",peripheral.name);
    }];
    
}

/**
 *  弹框提醒
 *
 *  @param periphirialsName 外设名称
 */
- (void)showAlert:(NSString *)periphirialsName{
    
   //使用UIAlertView的时候被告知 已经被弃用  官方SDK的方法是
    /*
     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
     message:@"This is an alert."
     preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
     handler:^(UIAlertAction * action) {}];
     
     [alert addAction:defaultAction];
     [self presentViewController:alert animated:YES completion:nil];
     */
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"你确定要与“%@”连接吗？",periphirialsName] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}




@end
