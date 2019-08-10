//
//  CommentItem.h
//  sister
//
//  Created by Dou, Eddie on 9/10/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentItem : NSObject

@property (nonatomic, assign) NSInteger indexId;
@property (nonatomic, strong) NSString *userNick;
@property (nonatomic, strong) NSString *replyUserNick;
@property (nonatomic, strong) NSString *comment;

@end
