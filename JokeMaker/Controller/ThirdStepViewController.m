//
//  ThirdStepViewController.m
//  sister
//
//  Created by Dou, Eddie on 9/16/16.
//  Copyright © 2016 Openlab. All rights reserved.
//

#import "ThirdStepViewController.h"
#import "ResultViewController.h"
#import "CommentTableViewCell.h"
#import "AppUtils.h"
#import "AddTableViewCell.h"
#import "AddViewController.h"

@interface ThirdStepViewController ()<CommentEdittedDelegate> {
    NSString *likes;
}

@end

@implementation ThirdStepViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *morebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    morebutton.frame = CGRectMake(0, 5,28, 28);
    [morebutton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [morebutton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:morebutton];

    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setBackgroundColor:[UIColor clearColor]];
    [titleButton setFrame:(CGRect){0,0,100,44}];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton setContentEdgeInsets:UIEdgeInsetsMake(-2, 0, 0, 0)];
    [titleButton setTitle:@"第三步" forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [titleButton.titleLabel setShadowOffset:(CGSize){1,1}];
    [self.navigationItem setTitleView:titleButton];


    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90.0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"CommentTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"AddTableViewCell"];
    
//

}




-(void) nextStep {
    if(![AppUtils isEmptyString:likes]) {
        NSArray *array = [likes componentsSeparatedByString:@","];

        if ([likes rangeOfString:@"，"].location != NSNotFound) {
            array = [likes componentsSeparatedByString:@"，"];
        }

        [AppUtils getMom].likes = [array mutableCopy];
    }


    ResultViewController *vc = [[ResultViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    } else if(section == 1) {
        if([AppUtils getMom].comments == nil) {
            return 1;
        }
        return [[AppUtils getMom].comments count]+1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0 ) {
        CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
        cell.nameLabel.text = @"点赞的用户昵称之间用 ',' 分割，如'孙悟空, 猪八戒'。";
        cell.commentTextView.delegate = self;
        cell.commentTextView.text = [self getLikes];
        return cell;
    } else if (indexPath.section ==1 ) {
        if (indexPath.row == 0) {
            AddTableViewCell *cell = (AddTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AddTableViewCell"];
            cell.nameLabel.text = @"添加评论";
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            CommentItem *item = [[AppUtils getMom].comments objectAtIndex:indexPath.row-1];
            NSString *result = [NSString stringWithFormat:@"%@: %@",item.userNick,item.comment];

            if (![AppUtils isEmptyString:item.replyUserNick]) {
                result = [NSString stringWithFormat:@"%@ 回复 %@: %@",item.userNick,item.replyUserNick,item.comment];
            }
            cell.textLabel.text = result;
            cell.textLabel.numberOfLines = 0;
            return cell;
        }
    }
    return [[UITableViewCell alloc] init];
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if (indexPath.section == 1 && indexPath.row>0)  {
        result = UITableViewCellEditingStyleDelete;
    }
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 1 && indexPath.row>0) {
            [[AppUtils getMom].comments removeObjectAtIndex:indexPath.row-1];

            NSMutableArray *array = [AppUtils getMom].comments;
            for (NSInteger i=0; i<[array count]; i++) {
                CommentItem *item = [array objectAtIndex:i];
                if (item.indexId != i) {
                    item.indexId = i;
                    [array replaceObjectAtIndex:[item indexId] withObject:item];
                }

            }

            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }

    }
}




-(NSString *)getLikes {
    Moments *moment = [AppUtils getMom];

    NSString *result = @"";

    for (int i=0; i<moment.likes.count;i++) {
        NSString *like = [moment.likes objectAtIndex:i];
        if (i == 0) {
            result = [NSString stringWithFormat:@"%@",like];
        }else{
            result = [NSString stringWithFormat:@"%@,%@", result, like];
        }
    }

    return result;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:hint]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    likes = textView.text;

    if (![textView.text isEqualToString:hint]) {
        textView.textColor = [UIColor blackColor];
    }

    CGRect bounds = textView.bounds;

    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;

    textView.bounds = bounds;


    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = hint;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }


    [textView resignFirstResponder];

    NSArray *array = [textView.text componentsSeparatedByString:@","];
    [AppUtils getMom].likes = [array mutableCopy];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"点赞";
    } else if(section == 1) {
        return @"评论";
    }
    return NULL;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {
        AddViewController *vc = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:[NSBundle mainBundle]];
        vc.delegate = self;

        if (indexPath.row == 0) {


        } else {
            NSMutableArray *array = [AppUtils getMom].comments;
            vc.item = [array objectAtIndex:indexPath.row-1];
        }

        [self.navigationController pushViewController:vc animated:true];
    }

    
}

-(void) commentEditted:(CommentItem *) item {
    NSMutableArray *array = [AppUtils getMom].comments;
    if ([AppUtils isEmpty:array]) {
        array = [[NSMutableArray alloc] init];
    }

    if (item.indexId == 9999) {
        item.indexId = [array count];
        [array addObject:item];
    } else {
        [array replaceObjectAtIndex:[item indexId] withObject:item];
    }


    [AppUtils getMom].comments = array;
    [self.tableView reloadData];
}



@end
