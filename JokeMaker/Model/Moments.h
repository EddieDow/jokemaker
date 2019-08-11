//
//  Moments.h
//  sister
//
//  Created by Dou, Eddie on 9/10/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommentItem.h"
#import <UIKit/UIKit.h>

@interface Moments : NSObject

@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) UIImage *product;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *time; //three days ago
@property (nonatomic, strong) NSMutableArray *arrImage;
@property (nonatomic, strong) NSMutableArray *likes; //names
@property (nonatomic, strong) NSMutableArray<CommentItem *> *comments;
//

@end
