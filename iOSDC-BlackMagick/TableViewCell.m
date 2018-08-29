//
//  TableViewCell.m
//  iOSDC-BlackMagick
//
//  Created by Yudai.Hirose on 2018/08/29.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [tableViewCell _prepareToEnterReuseQueue];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
