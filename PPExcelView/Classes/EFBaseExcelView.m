//
//  EFBaseExcelView.m
//  WZEfengAndEtong
//
//  Created by HongpengYu on 2017/11/20.
//  Copyright © 2017年 wanzhao. All rights reserved.
//

#import "EFBaseExcelView.h"


static const CGFloat titleLable_Height = 49;


@interface EFBaseExcelView ()

@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *labelWidthArray;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat right_titleLable_Width;
@property (nonatomic, assign) CGFloat maxWidth;


@end

@implementation EFBaseExcelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _right_titleLable_Width = kScreenWidth * 0.5;
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray {
    self = [super initWithFrame:frame];
    
    if (titleArray.count < 2) {
        return nil;
    }
    
    if (self) {
        _right_titleLable_Width = kScreenWidth * 0.5;
        self.labelWidthArray = @[].mutableCopy;
        self.labelArray = [NSMutableArray array];
        self.leftName = titleArray.firstObject;
        self.titleArr = titleArray;
        
        [self setupViews];
    }
    return self;
}

- (void)show {

    // 检查标题数据
    if (self.titleArr.count < 2) {
        NSLog(@"标题个数小于2个");
        return;
    }
    
    // 检查数据是否和标题匹配
    [self.dataList enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
        if (array.count != _titleArr.count) {
            NSLog(@"数据源中:第%zd组数据错误", idx);
            return;
        }
    }];
    
    
    // 处理数据
    _maxWidth = 0;
    _rightViewWidth = 0;
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableArray *columnWidthArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _titleArr.count; i++) {
        [columnWidthArray removeAllObjects];
        CGFloat columnMaxWidth = 0;
        CGFloat titleTempWidth = [self getLabelWidthWithTitle:_titleArr[i] font:font];
        [columnWidthArray addObject:[NSNumber numberWithFloat:titleTempWidth]];
        for (NSInteger j = 0; j < _dataList.count; j++) {
            NSString *columnText = _dataList[j][i];
            CGFloat columnTempWidth = [self getLabelWidthWithTitle:columnText font:font];
            [columnWidthArray addObject:[NSNumber numberWithFloat:columnTempWidth]];
            NSLog(@"%@, %zd列 %@, 宽度 %f",_titleArr[i], i,columnText,columnTempWidth);
        }
        
        columnMaxWidth = [[columnWidthArray valueForKeyPath:@"@max.floatValue"] floatValue] + 30;
        [self.labelWidthArray addObject:@(columnMaxWidth)];
        
        NSLog(@"%zd 列中最大值是%f", i, columnMaxWidth);
    }
    
    CGFloat contentViwe_X = [self.labelWidthArray[0] floatValue];
    _rightViewWidth = [[self.labelWidthArray valueForKeyPath:@"@sum.floatValue"] floatValue] - contentViwe_X;
    
    _titleLabel.frame = CGRectMake(0, 0, contentViwe_X, titleLable_Height);
//    _titleLabel.backgroundColor = [UIColor purpleColor];
    _titleTableView.frame = CGRectMake(0, titleLable_Height, contentViwe_X, self.bounds.size.height - _titleLabel.bounds.size.height);
    
    _contentView.frame = CGRectMake(contentViwe_X, 0, kScreenWidth - contentViwe_X, self.bounds.size.height);
    _contentView.contentSize = CGSizeMake(_rightViewWidth, 0);

//    _contentView.backgroundColor = [UIColor blueColor];
    
    _contentTableView.frame = CGRectMake(0, _titleLabel.bounds.size.height, _rightViewWidth, self.bounds.size.height - _titleLabel.bounds.size.height);
    
    [self setupLabels];
    
    [self reloadView];
}


- (void)setupViews {
    _titleLabel = [[UILabel alloc] init];
//    _titleLabel.frame = CGRectMake(0, 0, titleLable_Width, titleLable_Height);
    _titleLabel.textColor = [UIColor darkTextColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = self.leftName;
    _titleLabel.font = [UIFont systemFontOfSize:15];

    
    [self addSubview:_titleLabel];
    
    [self setupContentView];
    [self setupContentTableView];
    [self setupTitleTableView];
    
}

- (void)reloadView {
    [self.titleTableView reloadData];
    [self.contentTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataList[indexPath.row];
    if (tableView == _titleTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"nameCell"];
        cell.backgroundColor = [UIColor redColor];
        cell.textLabel.text = array.firstObject;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
        cell.backgroundColor = [UIColor greenColor];
        cell.textLabel.text = array.lastObject;
        return cell;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _titleTableView) {
        [_contentTableView setContentOffset:CGPointMake(_contentTableView.contentOffset.x, _titleTableView.contentOffset.y)];
    }
    if (scrollView == _contentTableView) {
        [_titleTableView setContentOffset:CGPointMake(0, _contentTableView.contentOffset.y)];
    }
}


- (void)setupContentView {
    _contentView = [[UIScrollView alloc] init];
//    _contentView.frame = CGRectMake(titleLable_Width, 0, kScreenWidth - titleLable_Width, self.bounds.size.height);
    _contentView.delegate = self;
    _contentView.bounces = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.showsVerticalScrollIndicator = NO;
    
    
    [self addSubview:self.contentView];
    
//    // 记录上一次控件的位置
//    NSInteger x = 0;
//    for (NSInteger i = 0; i < _titleArr.count; i++) {
//        NSString *title = self.titleArr[i];
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(i * _right_titleLable_Width, 0, _right_titleLable_Width, titleLable_Height);
//        label.text = title;
//        label.font = [UIFont systemFontOfSize:15];
//        label.textColor = [UIColor redColor];
//        label.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:label];
//        [self.labelArray addObject:label];
//        x += label.frame.size.width;
//    }
}


- (void)setupLabels {
    // 记录上一次控件的位置
    NSInteger x = 0;
    for (NSInteger i = 1; i < _titleArr.count; i++) {
        NSString *title = self.titleArr[i];
        CGFloat width = [self.labelWidthArray[i] floatValue];
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(x, 0, width, titleLable_Height);
        label.text = title;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        [self.labelArray addObject:label];
        x += label.frame.size.width;
    }
}

- (void)setupTitleTableView {
//    CGRect frame = CGRectMake(0, _titleLabel.bounds.size.height, titleLable_Width, self.bounds.size.height - _titleLabel.bounds.size.height);
    _titleTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _titleTableView.delegate = self;
    _titleTableView.dataSource = self;
    _titleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _titleTableView.showsVerticalScrollIndicator = NO;
    _titleTableView.showsHorizontalScrollIndicator = NO;
    _titleTableView.bounces = NO;
    _titleTableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:self.titleTableView];
}



- (void)setupContentTableView {
//    CGRect frame = CGRectMake(0, _titleLabel.bounds.size.height, _titleArr.count * _right_titleLable_Width, self.bounds.size.height - _titleLabel.bounds.size.height);
    _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.showsVerticalScrollIndicator = NO;
    _contentTableView.showsHorizontalScrollIndicator = NO;
    _contentTableView.bounces = NO;
    _contentTableView.tableFooterView = [[UIView alloc] init];

    [self.contentView addSubview:self.contentTableView];
}


- (CGFloat)getLabelWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2000, font.lineHeight)];
    lable.text = title;
    lable.font = font;
    [lable sizeToFit];
    return lable.frame.size.width;
}

@end
