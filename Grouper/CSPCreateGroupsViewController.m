//
//  CreateGroupsViewController.m
//  ClassSplit
//
//  Created by Aaron Schendel on 4/19/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

#import "CSPCreateGroupsViewController.h"
#import "CSPClass.h"
#import "CSPClassStore.h"
#import "CSPGroup.h"
#import "CSPGroupStore.h"
#import "CSPGroupDetailViewController.h"
#import "CSPStudent.h"
#import "CSPExclusionRulesViewController.h"
#import "CSPExclusionRuleRootController.h"

@interface CSPCreateGroupsViewController ()

@end

@implementation CSPCreateGroupsViewController

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
    for (int i = 0; i < self.selectedClasses.count; i++) {
        CSPClass *p = [self.selectedClasses objectAtIndex:i];
        self.totalNumberOfPeople = self.totalNumberOfPeople + p.students.count;
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


- (IBAction)setExclusionRules:(id)sender {
    CSPExclusionRuleRootController *exclusionRuleRootController = [CSPExclusionRuleRootController new];
    exclusionRuleRootController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    exclusionRuleRootController.selectedClass = [self.selectedClasses objectAtIndex:0];
    [self.navigationController presentViewController:exclusionRuleRootController animated:YES completion:nil];
}

- (IBAction)createGroups:(id)sender {
    
    if (self.numberOfGroupsTF.text.integerValue > 1) {
    
        // Some setup for needed variables
        NSInteger numberOfSubgroups = [self.numberOfGroupsTF.text integerValue];
        NSString *groupSetName = self.groupSetNameTF.text;
        
        // Loop through the selected personlists to get one list of all person objects
        NSMutableArray *listOfAllPeople = [[NSMutableArray alloc] init];
        for (int k = 0; k < self.selectedClasses.count; k++) {
            CSPClass *personList = [self.selectedClasses objectAtIndex:k];
            for (int j = 0; j < personList.students.count; j++) {
                [listOfAllPeople addObject:[personList.students objectAtIndex:j]];
            }
                
        }
        
        // Shuffle up the list of names
        [self shuffleArray:listOfAllPeople];
        
        NSInteger amountInGroups = floor(self.totalNumberOfPeople / numberOfSubgroups);
        NSInteger remainder = self.totalNumberOfPeople % numberOfSubgroups;
        
        // Group creation logic
        NSMutableArray *subgroups = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < numberOfSubgroups; i++) {
            NSMutableArray *currSubgroup = [[NSMutableArray alloc] init];
            // If the remainder var isn't 0, put an extra one in that group and then decrement the remainder var
            if (remainder > 0) {
                for (int j = 0; j < amountInGroups + 1; j++) {
                    if (!listOfAllPeople.count == 0) {
                        [currSubgroup addObject:[listOfAllPeople lastObject]];
                        [listOfAllPeople removeLastObject];
                    }
                }
                remainder = remainder - 1;
            } else {
                for (int j = 0; j < amountInGroups; j++) {
                    if (!listOfAllPeople.count == 0) {
                        [currSubgroup addObject:[listOfAllPeople lastObject]];
                        [listOfAllPeople removeLastObject];
                    }
                }
            }
            [subgroups addObject:currSubgroup];
        }
        
        
        NSString *selectedClassName = [[self.selectedClasses firstObject] listName];
        
        
        
        CSPGroup *newGroup = [[CSPGroup alloc] init];
        [newGroup setGroupName:groupSetName];
        [newGroup setNumberOfGroups:numberOfSubgroups];
        [newGroup setSubGroups:subgroups];
        [newGroup setClassCreatedFrom:selectedClassName];
        
        [[[CSPGroupStore sharedGroupStore] allGroups] addObject:newGroup];
        
        CSPGroupDetailViewController *groupDetailViewController = [[CSPGroupDetailViewController alloc] init];
        [groupDetailViewController setGroup:newGroup];
        [groupDetailViewController setIsNewGroup:YES];
        [self.navigationController pushViewController:groupDetailViewController animated:YES];
        
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Create 2 or More Groups"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
        
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}




@end
