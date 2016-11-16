//
//  CommentTableViewCell.h
//  sister
//
//  Created by Dou, Eddie on 9/17/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UITextView *commentTextView;

@end
