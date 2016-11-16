//
//  FirstStepViewController.h
//  sister
//
//  Created by Dou, Eddie on 9/11/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Moments.h"
#import "EditorViewController.h"


@interface FirstStepViewController : UIViewController<ResultEditted,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
