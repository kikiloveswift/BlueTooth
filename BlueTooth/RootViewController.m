//
//  RootViewController.m
//  BlueTooth
//
//  Created by kong on 16/4/2.
//  Copyright © 2016年 kong. All rights reserved.
//

#import "RootViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "ScanTableViewCell.h"
#import "ScanModel.h"

@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation RootViewController{

    //TODO: 扫描结果TableView
    UITableView *_scanTableView;
    
    //TODO: 扫描结果TableView的数据源
    NSArray *_dataArr;
    
    //TODO: 蓝牙
    BabyBluetooth *_buleTooth;
    
    //TODO: 装外设数组
    NSMutableArray *_perisMarr;
    
    //TODO: 装外设的AD数组
    NSMutableArray *_perisADMarr;
    
    //TODO: 装RSSI的数组
    NSMutableArray *_modelMArr;
    
    //TODO: model
    ScanModel *_model;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];

}

/**
 *  初始化UI界面
 */
- (void)initUI{
    
    //扫描按钮
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [scanButton setTitle:@"扫描" forState:UIControlStateNormal];
    
    scanButton.backgroundColor = [UIColor blueColor];
    
    scanButton.frame = CGRectMake(20, KScreenHeight - 49 - 100, 100, 80);
    
    [scanButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:scanButton];
    
    
    //装设备的TableView
    _scanTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 49 - 200 - 30 ) style:UITableViewStylePlain];
    
    _scanTableView.backgroundColor = [UIColor orangeColor];
    
    _scanTableView.delegate = self;
    
    _scanTableView.dataSource = self;
    
    _scanTableView.rowHeight = 100;
    
    [self.view addSubview:_scanTableView];
    
}

/**
 *  开始扫描
 *
 *  @param btn
 */
- (void)btnClick:(UIButton *)btn
{
    
    [self setBlueTooth];
}

/**
 *  初始化BlueTooth
 */
- (void)setBlueTooth
{
    //TODO: 提示
    [SVProgressHUD showInfoWithStatus:@"请打开设备蓝牙"];
    
    //TODO: 单例模式初始化创建一个蓝牙对象
    _buleTooth = [BabyBluetooth shareBabyBluetooth];
    
    //TODO: 初始化数据
    _perisADMarr = [NSMutableArray array];
    
    _perisMarr = [NSMutableArray array];
    
    _modelMArr = [NSMutableArray array];
    
    /**
     *  PS:此时用[NSMutableArray array]创建数组和[[NSMutableArray alloc] init]的区别
     *  1.[[NSMutableArray alloc] init]创建之后,内存释放方式为release
     *  2.[NSMutableArray array] 创建之后，内存释放方式为 autorelease
     */
    
    //TODO: 设置蓝牙代理
    [self blueToothSetting];

}

/**
 *  蓝牙网关设置和代理设置
 */
- (void)blueToothSetting
{
    //取消所有连接
    [_buleTooth cancelAllPeripheralsConnection];
    
    //开始连接
    _buleTooth.scanForPeripherals().begin();
    
    __weak typeof(self) weakSelf = self;
    
    //TODO: 打开蓝牙之后开始扫描
    [_buleTooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central)
    {
        if (central.state == CBCentralManagerStatePoweredOn)
        {
            [SVProgressHUD showInfoWithStatus:@"蓝牙已经打开"];
        }
    }];
    
    //TODO: 扫描到设备
    [_buleTooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI)
    {
        NSLog(@"扫描到了设备 RSSI IS %@",RSSI);
        
       //成功扫描到设备 并把数据插入tableView  peripheral装入数组 advertisementData装入 ad数组
        [weakSelf insertTableview:peripheral With:advertisementData And:RSSI];
        
    }];
    
    
    

}

/**
 *  扫描到的设备数据插入tableViewCell中
 *
 *  @param peripheral
 *  @param advertisementData
 */
- (void)insertTableview:(CBPeripheral *)peripheral With:(NSDictionary *)advertisementData And:(NSNumber *)RSSI{
    
    //如果数组中不包含 就添加
    if (![_perisMarr containsObject:peripheral])
    {
        
        [_perisMarr addObject:peripheral];
        
        [_perisADMarr addObject:advertisementData];
        
        //构建NSIndexPath的数组
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_perisMarr.count - 1 inSection:0];
        
        NSMutableArray *indexPathMArr = [[NSMutableArray alloc] init];
        
        [indexPathMArr addObject:indexPath];
        
        //装入model
        if (_model == nil)
        {
            _model = [[ScanModel alloc] init];
        }
        
        _model.name = peripheral.name;
        
        if (peripheral.name == nil)
        {
            _model.name = @"";
        }
        
        _model.RSSI = RSSI;
        
        if (RSSI == nil)
        {
            _model.RSSI = @0;
        }
  
        [_modelMArr addObject:_model];
        
        //把相应数据插入cell中
        [_scanTableView insertRowsAtIndexPaths:indexPathMArr withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma Mark----UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _perisMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"identify";
    
    ScanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ScanTableViewCell" owner:nil options:nil]lastObject];
    }
    
    //TODO: 处理cell的赋值问题
    cell.model = _modelMArr[indexPath.row];
    
    return cell;
}

@end
