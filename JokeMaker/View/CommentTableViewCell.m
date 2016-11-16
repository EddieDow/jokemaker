//
//  CommentTableViewCell.m
//  sister
//
//  Created by Dou, Eddie on 9/17/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = [UIColor grayColor];

    self.commentTextView.font  = [UIFont systemFontOfSize:17.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
