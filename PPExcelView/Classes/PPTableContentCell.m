//
//  PPTableContentCell.m
//  Expecta
//
//  Created by HongpengYu on 2017/11/30.
//

#import "PPTableContentCell.h"

static NSString * const contentInfoCell_identifier = @"contentInfoCell_identifier";


@interface PPTableContentCell ()
@property (nonatomic, strong) NSMutableArray *labeslArray;
@end

@implementation PPTableContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)contentCellWithTableView:(UITableView *)tableView labelsWidth:(NSArray *)widths datas:(NSArray *)datas {
    PPTableContentCell *cell = [tableView dequeueReusableCellWithIdentifier:contentInfoCell_identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentInfoCell_identifier labelsWidth:widths datas:datas];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier labelsWidth:(NSArray *)widths datas:(NSArray *)datas {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _datas = datas;
        [self setupViewWithArray:widths];
    }
    return self;
}


//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self setupViewWithArray:_labelWidth];
//}

- (void)setupViewWithArray:(NSArray *)labeWidthArray {
    _labeslArray = [NSMutableArray array];
    NSInteger x = 0;
    for (int i = 0; i < labeWidthArray.count - 1; i++) {
        CGFloat width = [labeWidthArray[i+1] floatValue];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, width, self.bounds.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.text = _datas[i+1];
        label.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 256.0 green:arc4random() % 255  / 256.0 blue:arc4random() % 255  / 256.0 alpha:1.0];
        [self.contentView addSubview:label];
        [_labeslArray addObject:label];
        x += label.frame.size.width;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
