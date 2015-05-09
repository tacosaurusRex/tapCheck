//
//  PreflightTableViewController.m
//  Checklist
//
//  Created by Robert Mahoney on 1/15/15.
//  Copyright (c) 2015 Robert Mahoney. All rights reserved.
//

#import "PreflightTableViewController.h"
#import "SectionHeaderViewController.h"

@interface PreflightTableViewController ()

@property int sectionCount;
@property int tableCount;
@end

@implementation PreflightTableViewController

- (void)viewDidLoad {
    NSLog(@"I'm in the tableViewController.");
    [super viewDidLoad];
    [self setTableTitle:self.tableView];
    [self loadData];
    [self headerArray:self.tableView];
    [self phaseComplete:self.tableView];
    NSLog(@"I'm done with viewDidLoad.");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    NSLog(@"I am in loadData.\n");
    NSString *PlistPath = [[NSBundle mainBundle] pathForResource:@"list" ofType:@"plist"];
    _plistArray = [[NSArray alloc] initWithContentsOfFile:PlistPath];
    _tableCount = (int)[_plistArray count];

    int i;
    _completedItems = [[NSMutableArray alloc] init];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self userStateFilePath]]) {
        NSLog(@"userState plist file exists");
        _completedItems = [[NSMutableArray alloc] initWithContentsOfFile:[self userStateFilePath]];
        NSLog(@"creating root array from plist");
    }
    else {
        NSLog(@"userStateFile does not exist. Creating new array...");
        for ( i = 0 ; i < _tableCount ; i++ ) {
            [_completedItems addObject:[NSMutableArray new]];
            int s;
            NSLog(@"The item at _completedItems[i] is %@", _completedItems[i]);
            for (s = 0 ; s < (int)[[[_plistArray objectAtIndex:i] objectForKey:@"Sections"] count] ; s++ ) {
                [[_completedItems objectAtIndex:i] addObject:[NSMutableArray new]];
            }
        }
    }
    //NSLog(@"The contents of completedItems is %@", _completedItems);
    NSLog(@"Done with loadData.\n");
}

- (NSString *)userStateFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"userState.plist"];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"I'm in viewWillDisappear");
    [_completedItems writeToFile:[self userStateFilePath] atomically:YES];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"I am in cellForRow");
    MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    int i;
    int t = (int)tableView.tag;
    
    for ( i = 0 ; i < _tableCount ; i++ ) {
    
        if (tableView == [tableView viewWithTag:i]) {
            
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"MyCustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
            }

            cell.itemLabel.text = [[[[[_plistArray objectAtIndex:i] objectForKey:@"Items"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item"];
            cell.actionLabel.text = [[[[[_plistArray objectAtIndex:i] objectForKey:@"Items"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"action"];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            NSNumber *rowNum = [NSNumber numberWithUnsignedInteger:indexPath.row];
            int i = (int)indexPath.section;
            
            if (i == indexPath.section) {
                if ([[_completedItems[t] objectAtIndex:i] containsObject:rowNum]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSNumber *rowNumber = [NSNumber numberWithUnsignedInteger:indexPath.row];
    NSLog(@"Clicked cell is in section %d, row %d.\n", (int)indexPath.section, (int)indexPath.row);
    
    int t = (int)(tableView.tag);
    _sectionCount = (int)[[[_plistArray objectAtIndex:t] objectForKey:@"Sections"] count];

    for ( t = 0 ; t < _tableCount ; t++ ) {
        
        if (tableView == [tableView viewWithTag:t]) {
            
            int i;
            for ( i = 0 ; i < _sectionCount ; i++) {
                if (i == indexPath.section) {
                    
                    if (selectedCell.accessoryType == UITableViewCellAccessoryNone) {               //IF selected cell does not have a check mark
                        
                        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;             //ADD checkmark
                        if ( ![[_completedItems[t] objectAtIndex:i] containsObject:rowNumber] ) {   //AND If completion array does not contain row
                            [[_completedItems[t] objectAtIndex:i] addObject:rowNumber];             //ADD row to completion array
                        }
                    }
                    else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {     //IF selected cell does have checkmark
                        selectedCell.accessoryType = UITableViewCellAccessoryNone;                  //REMOVE Checkmark
                        if ([[_completedItems[t] objectAtIndex:i] containsObject:rowNumber]) {      //AND if completion array contains row (as it should)
                            [[_completedItems[t] objectAtIndex:i] removeObject:rowNumber];          //REMOVE row number from completion array.
                        }
                    }
                    
                    if ([[_completedItems[t] objectAtIndex:i] count] == [[[[_plistArray objectAtIndex:t] objectForKey:@"Items"] objectAtIndex:indexPath.section] count]) {
                        SectionHeaderViewController  * tmpSectionVC = [_sectionVCArray objectAtIndex:indexPath.section];
                        UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                        tmpLabel.backgroundColor = [UIColor greenColor];
                    }
                    else {
                        SectionHeaderViewController  * tmpSectionVC = [_sectionVCArray objectAtIndex:indexPath.section];
                        UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                        tmpLabel.backgroundColor = [UIColor clearColor];
                    }
                }
            }
        }
    }
    [self phaseComplete:self.tableView];
}

- (void)phaseComplete:(UITableView *)tableView {
    //NSLog(@"I'm in phaseComplete");
    int t = (int)(tableView.tag);
    int i;
    
    _sectionCount = (int)[[[_plistArray objectAtIndex:t] objectForKey:@"Sections"] count];
    
    _sectionComplete = [[NSMutableArray alloc] init];
    for ( i = 0 ; i < _tableCount ; i++ ) {
        [_sectionComplete addObject:[NSMutableArray new]];
    }
    for ( i = 0 ; i < _sectionCount ; i++ ) {
        if ([[_completedItems[t] objectAtIndex:i] count] == [[[[_plistArray objectAtIndex:t] objectForKey:@"Items"] objectAtIndex:i]count]) {
            [_sectionComplete[t] addObject:[NSNumber numberWithInt:1]];
        }
        else {
            [_sectionComplete[t] addObject:[NSNumber numberWithInt:0]];
        }
    }
    //NSLog(@"The contents of _sectionComplete[t] are %@", _sectionComplete[t]);
    
    if(![_sectionComplete[t] containsObject:[NSNumber numberWithInt:0]]) {
        //self.title = @"Preflight - Complete";
        self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    }
    else {
        //self.title = @"Preflight";
        self.navigationController.navigationBar.barTintColor = nil;
    }
}

- (void)setTableTitle:(UITableView *)tableView {
    NSLog(@"tableView.tag is %d", (int)tableView.tag);
    switch (tableView.tag) {
        case 0 : self.title = @"Preflight"; break;
        case 1 : self.title = @"Takeoff/Cruise"; break;
        case 2 : self.title = @"Landing"; break;
        case 3 : self.title = @"Emergency"; break;
    }
}

#pragma mark - Section / Header Attributes

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int i;
    int count = 0;
    for (i = 0 ; i < _tableCount ; i++ ) {
        if (tableView == [tableView viewWithTag:i]) {
            count = (int)[[[_plistArray objectAtIndex:i] objectForKey:@"Sections"] count];
        }
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int i;
    int count = 0;
    for ( i = 0 ; i < _tableCount ; i++ ) {
        if (tableView == [tableView viewWithTag:i]) {
            count = (int)[[[[_plistArray objectAtIndex:i] objectForKey:@"Items"] objectAtIndex:section] count];
        }
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSLog(@"I'm in viewForHeader");
    SectionHeaderViewController *tmpVC;
    int i;
    for ( i = 0 ; i < _tableCount ; i++ ) {
        if (tableView == [tableView viewWithTag:i]) {
            NSLog(@"The size of _sectionVCArray is %lu", [_sectionVCArray count]);
            NSLog(@"The current table section is %d", (int)section);
            tmpVC = [_sectionVCArray objectAtIndex:section];
            
            SectionHeaderViewController * tmpSectionVC = [_sectionVCArray objectAtIndex:section];
            
            if ([[_completedItems[i] objectAtIndex:section] count] == (int)[[[[_plistArray objectAtIndex:i] objectForKey:@"Items"] objectAtIndex:section] count]) {
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor greenColor];
            }
            else {
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor clearColor];
            }
        }
    }
    return tmpVC.view;
}

- (void) headerArray:(UITableView *)tableView
{
    NSLog(@"I'm in headerArray");
    _sectionVCArray = [[NSMutableArray alloc] init];
    
    int t = (int)(tableView.tag);
    _sectionCount = (int)[[[_plistArray objectAtIndex:t] objectForKey:@"Sections"] count];
    
    int i;
    for ( i = 0 ; i < _sectionCount ; i++ ) {
        SectionHeaderViewController *tmpSectionHeaderViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sectionHeader"];
        UILabel *tmpLabel = (UILabel *)[tmpSectionHeaderViewController.view viewWithTag:4];
        tmpLabel.text = [[[_plistArray objectAtIndex:t] objectForKey:@"Sections"] objectAtIndex:i];
        [_sectionVCArray addObject:tmpSectionHeaderViewController];
    }
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


 #pragma mark - Navigation


/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
*/


@end
