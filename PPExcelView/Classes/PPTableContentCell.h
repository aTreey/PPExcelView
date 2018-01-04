//
//  PPTableContentCell.h
//  Expecta
//
//  Created by HongpengYu on 2017/11/30.
//

#import <UIKit/UIKit.h>

@interface PPTableContentCell : UITableViewCell
@property (nonatomic, strong) NSArray *labelWidth;
@property (nonatomic, strong) NSArray *datas;
+ (instancetype)contentCellWithTableView:(UITableView *)tableView labelsWidth:(NSArray *)widths datas:(NSArray *)datas;
@end
