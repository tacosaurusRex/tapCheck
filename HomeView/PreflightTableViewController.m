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

@end

@implementation PreflightTableViewController

- (void)viewDidLoad {
    NSLog(@"I am in viewDidLoad.\n");
    self.title = @"Preflight";
    [super viewDidLoad];
    [self loadData];
    NSLog(@"I'm back in viewDidLoad.\n");
    
    self.tableView.rowHeight = 44;
    _sectionCount = (int)[_itemsArray count];
    _sectionViewControllers = [[NSMutableArray alloc] init];
    int i;
    for(i = 0 ; i < _sectionCount ; i++) {
        SectionHeaderViewController *tmpSectionHeaderViewController =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"sectionHeader"];
        
        UILabel *tmpLabel = (UILabel *)[tmpSectionHeaderViewController.view viewWithTag:4];
        tmpLabel.text = _sectionHeaderArray[i];
        
        [_sectionViewControllers addObject:tmpSectionHeaderViewController];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self phaseComplete];
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
    _rootDictionary = [[NSDictionary alloc] initWithContentsOfFile:PlistPath];
    _preflightDictionary = [[NSDictionary alloc] initWithDictionary:[_rootDictionary objectForKey:@"Preflight"]];
    _sectionHeaderArray = [[NSArray alloc] initWithObjects:[_preflightDictionary objectForKey:@"Sections"], nil][0];
    _itemsArray = [[NSArray alloc] initWithObjects:[_preflightDictionary objectForKey:@"Items"], nil][0];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self userStateFilePath]]) {
        _completedItems = [[NSMutableArray alloc] initWithContentsOfFile:[self userStateFilePath]];
        NSLog(@"_completedItemsArray created from plist");
    }
    NSLog(@"Done with loadData.\n");
}

- (NSString *)userStateFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"The documents directory path is %@", [documentsDirectory stringByAppendingPathComponent:@"userState.plist"]);
    return [documentsDirectory stringByAppendingPathComponent:@"userState.plist"];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"I'm in viewWillDisappear");
    [_completedItems writeToFile:[self userStateFilePath] atomically:YES];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MyCustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }

    cell.itemLabel.text = [[[_itemsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"item"];
    cell.actionLabel.text = [[[_itemsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"action"];

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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSNumber *rowNumber = [NSNumber numberWithUnsignedInteger:indexPath.row];
    
    NSLog(@"The clicked cell is in section %ld, row %ld.\n", (long)indexPath.section, (long)indexPath.row);
    
    int i = (int)indexPath.section;
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
            if ( [_completedItems[i] count] == [[_itemsArray objectAtIndex:indexPath.section] count]) {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor greenColor];
            }
            else {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor clearColor];
            }
            if ( [_completedItems[i] count] == [_itemsArray[i] count]) {
                _section0complete = true;
            }
            else {
                _section0complete = false;
            }

        }
    }
    [self phaseComplete];
}

- (void) ifSectionComplete:(int)section {
    
}

- (void) phaseComplete {
    if (_section0complete == true && _section1complete == true && _section2complete == true && _section3complete == true && _section4complete == true) {
        self.title = @"Preflight - Complete";
        self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
    }
    else {
        self.title = @"Preflight";
        self.navigationController.navigationBar.barTintColor = nil;
    }
}

#pragma mark - Section / Header Attributes

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionViewControllers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_itemsArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    SectionHeaderViewController *tmpVC =[_sectionViewControllers objectAtIndex:section];
    return tmpVC.view;
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
