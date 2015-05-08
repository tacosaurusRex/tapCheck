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
    NSLog(@"I am in viewDidLoad.\n");
    self.title = @"Preflight";
    [super viewDidLoad];
    [self loadData];
    NSLog(@"I'm back in viewDidLoad.\n");
    
    self.tableView.rowHeight = 44;
    
    //[self phaseComplete];
    NSLog(@"I'm done with viewDidLoad.\n");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    NSLog(@"I am in loadData.\n");
    
    _completedItems0 = [[NSMutableArray alloc] init];
    _completedItems1 = [[NSMutableArray alloc] init];
    _completedItems2 = [[NSMutableArray alloc] init];
    _completedItems3 = [[NSMutableArray alloc] init];
    _completedItems4 = [[NSMutableArray alloc] init];
    _completedItems = [NSMutableArray arrayWithObjects:_completedItems0, _completedItems1, _completedItems2, _completedItems3, _completedItems4, nil];

    NSString *PlistPath = [[NSBundle mainBundle] pathForResource:@"list" ofType:@"plist"];
    _plistArray = [[NSArray alloc] initWithContentsOfFile:PlistPath];
    _tableCount = (int)[_plistArray count];
    NSLog(@"Size of _plistArray is %d", _tableCount);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self userStateFilePath]]) {
        _completedItems = [[NSMutableArray alloc] initWithContentsOfFile:[self userStateFilePath]];
    }
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
    NSLog(@"I am in cellForRow");
    
    MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    int i;
    for ( i = 0 ; i < _tableCount ; i++ ) {
    
        if (tableView == [tableView viewWithTag:(i+10)]) {
            
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"MyCustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
            }

            cell.itemLabel.text = [[[[[_plistArray objectAtIndex:i] objectForKey:@"Items"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item"];
            cell.actionLabel.text = [[[[[_plistArray objectAtIndex:i] objectForKey:@"Items"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"action"];
            
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            NSNumber *rowNum = [NSNumber numberWithUnsignedInteger:indexPath.row];
            int i = (int)indexPath.section;
            
            for ( i = 0 ; i < _sectionCount ; i++) {
                if ( i == indexPath.section ) {
                    if ([_completedItems[i] containsObject:rowNum]) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    else {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
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
    NSLog(@"The clicked cell is in section %ld, row %ld.\n", (long)indexPath.section, (long)indexPath.row);
    
    int t;
    for ( t = 0 ; t < _tableCount ; t++ ) {
        
        if (tableView == [tableView viewWithTag:(t+10)]) {
            
            int i;
            for ( i = 0 ; i < _sectionCount ; i++) {
                if (i == indexPath.section) {
                    if (selectedCell.accessoryType == UITableViewCellAccessoryNone) {
                        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                        if ( [_completedItems[i] containsObject:rowNumber] )
                        { }
                        else { [_completedItems[i] addObject:rowNumber]; }
                    }
                    else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                        selectedCell.accessoryType = UITableViewCellAccessoryNone;
                        if ( [_completedItems[i] containsObject:rowNumber] )
                        { [_completedItems[i] removeObject:rowNumber]; }
                    }
                    if ( [_completedItems[i] count] == [[[_plistArray objectAtIndex:t] objectForKey:@"items"] count] ) {
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
            //[self phaseComplete];
}
/*
- (void) phaseComplete {
    
    //bool sectComp[_sectionCount];
    _sectionComplete = [[NSMutableArray alloc] init];
    
    int i;
    for ( i = 0 ; i < _sectionCount ; i++ ) {
        //NSLog(@"completedItems[%d] count %lu, itemsArray[%d] count %lu", i, (unsigned long)[_completedItems[i] count], i, (unsigned long)[_itemsArray[i] count]);
        if ([_completedItems[i] count] == [[[_plistArray objectAtIndex:t] objectForKey:@"items"] count]) {
            [_sectionComplete addObject:[NSNumber numberWithInt:1]];
        }
        else {
            [_sectionComplete addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    if(![_sectionComplete containsObject:[NSNumber numberWithInt:0]]) {
        self.title = @"Preflight - Complete";
        self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    }
    else {
        self.title = @"Preflight";
        self.navigationController.navigationBar.barTintColor = nil;
    }
    //NSLog(@"the contents of _sectionComplete are %@", _sectionComplete);
}*/

#pragma mark - Section / Header Attributes

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int i;
    int count = 0;
    for (i = 0 ; i < _tableCount ; i++ ) {
        if (tableView == [tableView viewWithTag:(i+10)]) {
            count = (int)[[[_plistArray objectAtIndex:i] objectForKey:@"Sections"] count];
        }
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //int t;// = (int)[tableView tag];
    NSLog(@"I am in numberOfRowsInSection");
    NSLog(@"section is %ld", (long)section);
    int i;
    int count = 0;
    for ( i = 0 ; i < _tableCount ; i++ ) {
        if (tableView == [tableView viewWithTag:(i+10)]) {
            count = (int)[[[[_plistArray objectAtIndex:i] objectForKey:@"Items"] objectAtIndex:section] count];
            NSLog(@"The number of rows in section %ld is %d", (long)section, (int)[[[[_plistArray objectAtIndex:i] objectForKey:@"Items"] objectAtIndex:section] count]);
        }
    }
    return count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    SectionHeaderViewController *tmpVC;
    int t;
    //int sectionCount = 0;
    for ( t = 0 ; t < _tableCount ; t++ ) {
        if (tableView == [tableView viewWithTag:(t+10)]) {
            
            tmpVC = [_sectionVCArray objectAtIndex:section];
            
            SectionHeaderViewController * tmpSectionVC = [_sectionVCArray objectAtIndex:section];
            
            if ([_completedItems[section] count] == (int)[[[_plistArray objectAtIndex:t] objectForKey:@"items"] count]) {
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

- (void) headerArray {
    int i;
    for(i = 0 ; i < _sectionCount ; i++) {
        SectionHeaderViewController *tmpSectionHeaderViewController =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"sectionHeader"];
        
        UILabel *tmpLabel = (UILabel *)[tmpSectionHeaderViewController.view viewWithTag:4];
        tmpLabel.text = _sectionHeaderArray[i];
        
        [_sectionVCArray addObject:tmpSectionHeaderViewController];
    }
    _tableViewsArray = [[NSMutableArray alloc] init];

    NSLog(@"Table count is %d", _tableCount);
    for (i = 0 ; i < _tableCount ; i++ ) {
        UITableView *tmpTableView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"preflightTable"];
        [_tableViewsArray addObject:tmpTableView];
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
