//
//  CreateGroupsViewController.m
//  Grouper
//
//  Created by Aaron Schendel on 4/19/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "CreateGroupsViewController.h"
#import "PersonList.h"
#import "PersonListStore.h"
#import "Group.h"
#import "GroupStore.h"
#import "GroupDetailViewController.h"

@interface CreateGroupsViewController ()

@end

@implementation CreateGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNumberOfPeopleValue];
    [self.numberOfPeopleLabel setText:[NSString stringWithFormat:@"%ld",(long)self.totalNumberOfPeople]];
    self.groupSetNameTF.delegate = self;
    self.numberOfGroupsTF.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationItem setTitle:@"Create Groups"];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void)setNumberOfPeopleValue {
    self.totalNumberOfPeople = 0;
    for (int i = 0; i < self.selectedPersonLists.count; i++) {
        PersonList *p = [self.selectedPersonLists objectAtIndex:i];
        self.totalNumberOfPeople = self.totalNumberOfPeople + p.names.count;
    }
}

- (IBAction)tapReceived:(id)sender {
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


- (NSMutableArray *)shuffleArray:(NSMutableArray *)array {
// Borrowed from http://eureka.ykyuen.info/2010/06/19/objective-c-how-to-shuffle-a-nsmutablearray/
//FIXME: Verify that this is working as I'm expecting. Does it modify array or create a copy? Pass by reference or value?
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return array;
}


- (IBAction)createGroups:(id)sender {
    
    // Some setup for needed variables
    NSInteger numberOfSubgroups = [self.numberOfGroupsTF.text integerValue];
    NSString *groupSetName = self.groupSetNameTF.text;
    
    // Loop through the selected namelists to get one list of all names
    NSMutableArray *listOfAllNames = [[NSMutableArray alloc] init];
    for (int k = 0; k < self.selectedPersonLists.count; k++) {
        PersonList *personList = [self.selectedPersonLists objectAtIndex:k];
        for (int j = 0; j < personList.names.count; j++) {
            [listOfAllNames addObject:[personList.names objectAtIndex:j]];
        }
            
    }
    
    // Shuffle up the list of names
    [self shuffleArray:listOfAllNames];
    
    NSInteger amountInGroups = floor(self.totalNumberOfPeople / numberOfSubgroups);
    NSInteger remainder = self.totalNumberOfPeople % numberOfSubgroups;
    
    // Group creation logic
    //FIXME: Need to figure out remainder logic
    NSMutableArray *subgroups = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < numberOfSubgroups; i++) {
        NSMutableArray *currSubgroup = [[NSMutableArray alloc] init];
        // If the remainder var isn't 0, put an extra one in that group and then decrement the remainder var
        if (remainder > 0) {
            for (int j = 0; j < amountInGroups + 1; j++) {
                if (!listOfAllNames.count == 0) {
                    [currSubgroup addObject:[listOfAllNames lastObject]];
                    [listOfAllNames removeLastObject];
                }
            }
            remainder = remainder - 1;
        } else {
            for (int j = 0; j < amountInGroups; j++) {
                if (!listOfAllNames.count == 0) {
                    [currSubgroup addObject:[listOfAllNames lastObject]];
                    [listOfAllNames removeLastObject];
                }
            }
        }
        [subgroups addObject:currSubgroup];
    }
    
    Group *newGroup = [[Group alloc] init];
    [newGroup setGroupName:groupSetName];
    [newGroup setNumberOfGroups:numberOfSubgroups];
    [newGroup setSubGroups:subgroups];
    
    [[[GroupStore sharedGroupStore] allGroups] addObject:newGroup];
    
    GroupDetailViewController *groupDetailViewController = [[GroupDetailViewController alloc] init];
    [groupDetailViewController setGroup:newGroup];
    [groupDetailViewController setIsNewGroup:YES];
    [self.navigationController pushViewController:groupDetailViewController animated:YES];
    
}




@end
