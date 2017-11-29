//
//  EFBaseExcelView.h
//  WZEfengAndEtong
//
//  Created by HongpengYu on 2017/11/20.
//  Copyright © 2017年 wanzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

//static CGFloat const excellTableViewCell_height = 45;
//static CGFloat const excellTableView_leftView_width = 110;
//static CGFloat const excellTableView_rightView_width = 100;

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)


@interface EFBaseExcelView : UIView <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *titleTableView;//标题TableView
@property (nonatomic, strong) UITableView *contentTableView;//内容TableView
@property (nonatomic, strong) UIScrollView *contentView;//内容容器
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat leftViewWidth;
@property (nonatomic, assign) CGFloat rightViewWidth;

@property (nonatomic, strong) NSArray *titleArr; // 标题数组
@property (nonatomic, copy) NSString *leftName; // 左边表头名字
@property (nonatomic, assign) NSTextAlignment aligment; // 标题对齐方式

@property (nonatomic, strong) NSMutableArray *dataList;

- (void)reloadView;

- (void)show;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

@end
