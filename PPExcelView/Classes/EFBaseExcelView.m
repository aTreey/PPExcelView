//
//  EFBaseExcelView.m
//  WZEfengAndEtong
//
//  Created by HongpengYu on 2017/11/20.
//  Copyright © 2017年 wanzhao. All rights reserved.
//

#import "EFBaseExcelView.h"

#import "PPTableContentCell.h"


static const CGFloat titleLable_Height = 49;

static NSString * const contentInfoCell_identifier = @"contentInfoCell_identifier";


@interface EFBaseExcelView ()

@property (nonatomic, strong) UITableView *titleTableView;//标题TableView
@property (nonatomic, strong) UITableView *contentTableView;//内容TableView
@property (nonatomic, strong) UIScrollView *contentView;//内容容器
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *labelWidthArray;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat right_titleLable_Width;

// 右边tableView 宽度
@property (nonatomic, assign) CGFloat rightViewWidth;

// 列的最大宽度
@property (nonatomic, assign) CGFloat cloumnMaxWidth;


@end

@implementation EFBaseExcelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cloumnMaxWidth = frame.size.width * 0.5;
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
        _cloumnMaxWidth = frame.size.width * 0.5;
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
    if (_titleArr.count < 2) {
        NSAssert(_titleArr.count < 2, @"标题个数不能小于2个");
    }
    
    // 检查数据是否和标题匹配
    [self.dataList enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
        if (array.count != _titleArr.count) {
            NSLog(@"数据源中:第%zd组数据错误", idx);
            return;
        }
    }];
    
    
    // 处理数据
    _rightViewWidth = 0;
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableArray *columnWidthArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _titleArr.count; i++) {
        [columnWidthArray removeAllObjects];
        CGFloat tempColumnMaxWidth = 0;
        CGFloat titleTempWidth = [self labelWidthWithTitle:_titleArr[i] font:font];
        [columnWidthArray addObject:[NSNumber numberWithFloat:titleTempWidth]];
        for (NSInteger j = 0; j < _dataList.count; j++) {
            NSString *columnText = _dataList[j][i];
            NSInteger columnTempWidth = [self labelWidthWithTitle:columnText font:font];
            [columnWidthArray addObject:[NSNumber numberWithFloat:columnTempWidth]];
            NSLog(@"%@, %zd列 %@, 宽度 %zd",_titleArr[i], i,columnText,columnTempWidth);
        }
        
        
        tempColumnMaxWidth = [[columnWidthArray valueForKeyPath:@"@max.floatValue"] floatValue] + 30;
        
        // 是否大于列宽最大值
        if (tempColumnMaxWidth > _cloumnMaxWidth) {
            [self.labelWidthArray addObject:@(_cloumnMaxWidth)];
        } else {
            [self.labelWidthArray addObject:@(tempColumnMaxWidth)];
        }
        
        
        
        NSLog(@"%zd 列中最大值是%f", i, _cloumnMaxWidth);
    }
    
    CGFloat contentViwe_X = [self.labelWidthArray[0] floatValue];
    _rightViewWidth = [[self.labelWidthArray valueForKeyPath:@"@sum.floatValue"] floatValue] - contentViwe_X;
    
    _titleLabel.frame = CGRectMake(0, 0, contentViwe_X, titleLable_Height);
    _titleTableView.frame = CGRectMake(0, titleLable_Height, contentViwe_X, self.bounds.size.height - _titleLabel.bounds.size.height);
    
    
    
    _contentView.frame = CGRectMake(contentViwe_X, 0, kScreenWidth - contentViwe_X, self.bounds.size.height);
    _contentView.contentSize = CGSizeMake(_rightViewWidth, 0);

    
    _contentTableView.frame = CGRectMake(0, _titleLabel.bounds.size.height, _rightViewWidth, self.bounds.size.height - _titleLabel.bounds.size.height);
    
    [self setupLabels];
    
//    if (!_topBackgroundColor) {
//        _titleLabel.backgroundColor = _topBackgroundColor;
//    } else {
//        _titleLabel.backgroundColor = [UIColor lightTextColor];
//    }
    
    _titleLabel.backgroundColor = _topBackgroundColor;
    
    [self reloadView];
}


- (void)extracted {
    [self setupTitleTableView];
}

- (void)setupViews {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor darkTextColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = self.leftName;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:_titleLabel];
    
    [self setupContentView];
    [self setupContentTableView];
    [self extracted];
    
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
        cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 256.0 green:arc4random() % 255  / 256.0 blue:arc4random() % 255  / 256.0 alpha:1.0];
        cell.textLabel.text = array.firstObject;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    } else {
        
        PPTableContentCell *cell = [tableView dequeueReusableCellWithIdentifier:contentInfoCell_identifier];
        cell.backgroundColor = [UIColor greenColor];
        cell.labelWidth = self.labelWidthArray.copy;
        cell.datas = array;
        
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
    _contentView.delegate = self;
    _contentView.bounces = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.showsVerticalScrollIndicator = NO;
    
    
    [self addSubview:self.contentView];
}


- (void)setupLabels {
    // 记录上一次控件的位置
    NSInteger x = 0;
    for (NSInteger i = 1; i < _titleArr.count; i++) {
        NSString *title = self.titleArr[i];
        CGFloat width = [self.labelWidthArray[i] floatValue];
        UILabel *label = [[UILabel alloc] init];
        if (!_topBackgroundColor) {
            label.backgroundColor = _topBackgroundColor;
        } else {
            label.backgroundColor = [UIColor lightTextColor];
        }
        
        label.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 256.0 green:arc4random() % 255  / 256.0 blue:arc4random() % 255  / 256.0 alpha:1.0];
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
    _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.showsVerticalScrollIndicator = NO;
    _contentTableView.showsHorizontalScrollIndicator = NO;
    _contentTableView.bounces = NO;
    _contentTableView.tableFooterView = [[UIView alloc] init];
    [_contentTableView registerClass:[PPTableContentCell class] forCellReuseIdentifier:contentInfoCell_identifier];
    [self.contentView addSubview:self.contentTableView];
}


- (CGFloat)labelWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2000, font.lineHeight)];
    lable.text = title;
    lable.font = font;
    [lable sizeToFit];
    return lable.frame.size.width;
}

@end
