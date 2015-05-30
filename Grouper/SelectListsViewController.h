//
//  SelectListsViewController.h
//  Grouper
//
//  Created by Aaron on 4/15/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

@interface SelectListsViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) NSMutableArray *selectedPersonLists;

- (IBAction)createGroupsFromSelectedPersonLists:(id)sender;

@end
