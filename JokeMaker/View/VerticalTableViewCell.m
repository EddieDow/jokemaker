//
//  VerticalTableViewCell.m
//  sister
//
//  Created by Dou, Eddie on 9/12/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "VerticalTableViewCell.h"

@implementation VerticalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {


        _avatar.image = [UIImage imageNamed:@"0.jpg"];
        _avatar.contentMode = UIViewContentModeScaleAspectFill;
        [_avatar setClipsToBounds:YES];

    }
    return self;
}

 

@end
