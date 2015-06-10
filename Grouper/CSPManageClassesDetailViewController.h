//
//  CreateEditDetailViewController.h
//  Grouper
//
//  Created by Aaron Schendel on 3/18/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPStudentList.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>


@interface CSPManageClassesDetailViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) CSPStudentList *personList;

- (IBAction)addNewPerson:(id)sender;

@end