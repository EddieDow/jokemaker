//
//  ThirdStepViewController.h
//  sister
//
//  Created by Dou, Eddie on 9/16/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moments.h"

@interface ThirdStepViewController : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    NSString *hint;
}


@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
