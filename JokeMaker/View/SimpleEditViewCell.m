//
//  SimpleEditViewCell.m
//  sister
//
//  Created by Dou, Eddie on 9/11/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "SimpleEditViewCell.h"

@implementation SimpleEditViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _resultLabel.textColor = [UIColor grayColor];

    }
    return self;
}

@end
