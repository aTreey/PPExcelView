//
//  PPViewController.m
//  PPExcelView
//
//  Created by aTreey on 11/29/2017.
//  Copyright (c) 2017 aTreey. All rights reserved.
//

#import "PPViewController.h"
#import "EFBaseExcelView.h"

@interface PPViewController ()

@end

@implementation PPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *titleArray = @[@"资产类别名称", @"品名", @"账面数量", @"实际数量", @"差额的字数比较多长度也比较长"];
    NSMutableArray *dataList = @[
                                  @[@"车辆-类别", @"电脑显示器", @"100", @"20", @"500"],
                                  @[@"台式电脑显", @"笔记本", @"100", @"20", @"500"],
                                  @[@"类类", @"台式电脑宏基显示器", @"100", @"20", @"500"],
                                  @[@"我是", @"台式电脑宏基显示器", @"100", @"20", @"500"],
                          ].mutableCopy;
    EFBaseExcelView *excelView = [[EFBaseExcelView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) titleArray:titleArray];
    excelView.dataList = dataList;
    [self.view addSubview:excelView];
    excelView.topBackgroundColor = [UIColor purpleColor];
    [excelView show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
