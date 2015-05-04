//
//  SelectListsViewController.m
//  Grouper
//
//  Created by Aaron on 4/15/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "SelectListsViewController.h"
#import "PersonList.h"
#import "PersonListStore.h"
#import "GroupMemberTableViewCell.h"
#import "CreateGroupsViewController.h"

@interface SelectListsViewController ()

@end

@implementation SelectListsViewController
@synthesize selectedPersonLists;


- (id)init {
    self = [super initWithNibName:@"SelectListsViewController" bundle:nil];
    if (self) {
        [[[self navigationController] navigationBar] setHidden:NO];
        
        if (!self.selectedPersonLists) {
            self.selectedPersonLists = [[NSMutableArray alloc] init];
        }
        //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"Pick Lists"];
    [self.tableView reloadData];
    
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createGroupsFromSelectedPersonLists:)];
    UIBarButtonItem *emptyItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *toolbarButtons = [NSArray arrayWithObjects:emptyItem, item1, nil];
    [self setToolbarItems:toolbarButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createGroupsFromSelectedPersonLists:(id)sender {
    CreateGroupsViewController *createGroupsVC = [[CreateGroupsViewController alloc] init];
    [createGroupsVC setSelectedPersonLists:self.selectedPersonLists];
    if (self.selectedPersonLists.count > 0) {
        [[self navigationController] pushViewController:createGroupsVC animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[PersonListStore sharedNameListStore] allPersonLists] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonList *nameList = [[[PersonListStore sharedNameListStore] allPersonLists] objectAtIndex:[indexPath row]];
    
    NSString *uniqueIdentifier = @"GroupCell";
    GroupMemberTableViewCell *cell = nil;
    cell = (GroupMemberTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GroupMemberTableViewCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            cell = (GroupMemberTableViewCell *)currentObject;
            break;
        }
    }
    
    [[cell groupMemberLabel] setText:nameList.listName];
    
    return cell;

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        //TODO: This may cause issues in the future, keep an eye on it
        [self.selectedPersonLists removeObjectIdenticalTo:[[[PersonListStore sharedNameListStore] allPersonLists] objectAtIndex:[indexPath row]]];
        
        
    } else if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedPersonLists addObject:[[[PersonListStore sharedNameListStore] allPersonLists] objectAtIndex:[indexPath row]]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
