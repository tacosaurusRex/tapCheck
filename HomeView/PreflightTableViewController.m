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

@end

@implementation PreflightTableViewController

- (void)viewDidLoad {
    NSLog(@"I am in viewDidLoad.\n");
    NSLog(@"The contents of _completedItems[0] is %@", _completedItems[0]);
    self.title = @"Preflight";
    [super viewDidLoad];
    
    [self loadData];
    NSLog(@"I'm back in viewDidLoad.\n");
    self.tableView.rowHeight = 44;
    
    int sectionCount = (int)[_itemsArray count];
 
    //NSLog(@"The number of sections in the preflight checklist is: %d\n", sectionCount);

    _sectionViewControllers = [[NSMutableArray alloc] init];

    int i;
    for(i = 0 ; i < sectionCount ; i++) {
        SectionHeaderViewController *tmpSectionHeaderViewController =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"sectionHeader"];
        
        UILabel *tmpLabel = (UILabel *)[tmpSectionHeaderViewController.view viewWithTag:4];
        tmpLabel.text = _sectionHeaderArray[i];
        
        [_sectionViewControllers addObject:tmpSectionHeaderViewController];
    }
    
    _completedItems0 = [[NSMutableArray alloc] initWithArray:_completedItems[0]];
    _completedItems1 = [[NSMutableArray alloc] initWithArray:_completedItems[1]];
    _completedItems2 = [[NSMutableArray alloc] initWithArray:_completedItems[2]];
    _completedItems3 = [[NSMutableArray alloc] initWithArray:_completedItems[3]];
    _completedItems4 = [[NSMutableArray alloc] initWithArray:_completedItems[4]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSLog(@"I'm done with viewDidLoad.\n");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    NSLog(@"I am in loadData.\n");
    NSString *PlistPath = [[NSBundle mainBundle] pathForResource:@"list" ofType:@"plist"];
    _rootDictionary = [[NSDictionary alloc] initWithContentsOfFile:PlistPath];
    _preflightDictionary = [[NSDictionary alloc] initWithDictionary:[_rootDictionary objectForKey:@"Preflight"]];
    _sectionHeaderArray = [[NSArray alloc] initWithObjects:[_preflightDictionary objectForKey:@"Sections"], nil][0];
    _itemsArray = [[NSArray alloc] initWithObjects:[_preflightDictionary objectForKey:@"Items"], nil][0];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self userStateFilePath]]) {
        _completedItems = [[NSArray alloc] initWithContentsOfFile:[self userStateFilePath]];
        NSLog(@"_userStateArray created from plist");
    }
/*
    NSLog(@"The size of _preflightArray is %lu.\n",_preflightArray.count);
    NSLog(@"The contents of the _preflight dictionary are %@\n",_preflightDictionary);
    
    NSLog(@"The size of the _sectionHeaderArray is %lu\n",_sectionHeaderArray.count);
    NSLog(@"The contents of _sectionHeaderArray is %@\n",_sectionHeaderArray);
    
    NSLog(@"The size of _itemsArray is %lu\n", _itemsArray.count);
    NSLog(@"The contents of _itemsArray is %@\n", _itemsArray);

    NSLog(@"The size of _userStateArray is %lu\n", _userStateArray.count);
    NSLog(@"The contents of _userStateArray is %@\n", _userStateArray);
*/
    NSLog(@"Done with loadData.\n");
}

- (NSString *)userStateFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"The documents directory path is %@", [documentsDirectory stringByAppendingPathComponent:@"userState.plist"]);
    return [documentsDirectory stringByAppendingPathComponent:@"userState.plist"];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    _completedItems = [NSArray arrayWithObjects:_completedItems0, _completedItems1, _completedItems2, _completedItems3, _completedItems4, nil];
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
    switch (indexPath.section) {
        case 0:
            if ( [_completedItems0 containsObject:rowNum] ) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 1:
            if ( [_completedItems1 containsObject:rowNum] ) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 2:
            if ( [_completedItems2 containsObject:rowNum] ) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 3:
            if ( [_completedItems3 containsObject:rowNum] ) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case 4:
            if ( [_completedItems4 containsObject:rowNum] ) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        default:
        break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSNumber *rowNumber = [NSNumber numberWithUnsignedInteger:indexPath.row];
    
    NSLog(@"The clicked cell is in section %ld, row %ld.\n", (long)indexPath.section, (long)indexPath.row);

    switch (indexPath.section) {
        case 0:
            if (selectedCell.accessoryType == UITableViewCellAccessoryNone) {
                selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                if ( [_completedItems0 containsObject:rowNumber] )
                { }
                else { [_completedItems0 addObject:rowNumber]; }
            }
            else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                selectedCell.accessoryType = UITableViewCellAccessoryNone;
                if ( [_completedItems0 containsObject:rowNumber] )
                { [_completedItems0 removeObject:rowNumber]; }
            }
            if ( [_completedItems0 count] == [[_itemsArray objectAtIndex:indexPath.section] count]) {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor greenColor];
            }
            else {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor clearColor];
            }
            if ( [_completedItems0 count] == [[_itemsArray objectAtIndex:0] count]) {
                _section0complete = true;
            }
            else {
                _section0complete = false;
            }
            NSLog(@"No. of items in _completedItems0 is %lu. _section0Complete is %s.\n", _completedItems0.count, _section0complete ? "true" : "false");
            break;
    
        case 1:
            if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
            {
                selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                if ( [_completedItems1 containsObject:rowNumber] )
                { }
                else { [_completedItems1 addObject:rowNumber]; }
            }
            else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
            {
                selectedCell.accessoryType = UITableViewCellAccessoryNone;
                if ( [_completedItems1 containsObject:rowNumber] )
                { [_completedItems1 removeObject:rowNumber]; }
            }
            if ( [_completedItems1 count] == [[_itemsArray objectAtIndex:indexPath.section] count]) {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor greenColor];
            }
            else {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor clearColor];
            }
            if ( [_completedItems1 count] == [[_itemsArray objectAtIndex:1] count]) {
                _section1complete = true;
            }
            else {
                _section1complete = false;
            }
            NSLog(@"No. of items in _completedItems1 is %lu. _section1Complete is %s.\n", _completedItems1.count, _section1complete ? "true" : "false");
            break;
            
        case 2:
            if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
            {
                selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                if ( [_completedItems2 containsObject:rowNumber] )
                { }
                else { [_completedItems2 addObject:rowNumber]; }
            }
            else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
            {
                selectedCell.accessoryType = UITableViewCellAccessoryNone;
                if ( [_completedItems2 containsObject:rowNumber] )
                { [_completedItems2 removeObject:rowNumber]; }
            }
            if ( [_completedItems2 count] == [[_itemsArray objectAtIndex:2] count]) {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor greenColor];
            }
            else {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor clearColor];
            }
            if ( [_completedItems2 count] == [[_itemsArray objectAtIndex:2] count]) {
                _section2complete = true;
            }
            else {
                _section2complete = false;
            }
            NSLog(@"No. of items in _completedItems2 is %lu. _section2Complete is %s.\n", _completedItems2.count, _section2complete ? "true" : "false");
            break;
            
        case 3:
            if (selectedCell.accessoryType == UITableViewCellAccessoryNone) {
                selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                if ( [_completedItems3 containsObject:rowNumber] ) {
                }
                else {
                    [_completedItems3 addObject:rowNumber];
                }
            }
            else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                selectedCell.accessoryType = UITableViewCellAccessoryNone;
                if ( [_completedItems3 containsObject:rowNumber] )
                { [_completedItems3 removeObject:rowNumber]; }
            }
            if ( [_completedItems3 count] == [[_itemsArray objectAtIndex:indexPath.section] count]) {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor greenColor];
            }
            else {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor clearColor];
            }
            if ( [_completedItems3 count] == [[_itemsArray objectAtIndex:3] count]) {
                _section3complete = true;
            }
            else {
                _section3complete = false;
            }
            NSLog(@"No. of items in _completedItems3 is %lu. _section3Complete is %s.\n", _completedItems3.count, _section3complete ? "true" : "false");
            break;
            
        case 4:
            if (selectedCell.accessoryType == UITableViewCellAccessoryNone) {
                selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
                if ( [_completedItems4 containsObject:rowNumber] )
                { }
                else { [_completedItems4 addObject:rowNumber]; }
            }
            else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                selectedCell.accessoryType = UITableViewCellAccessoryNone;
                if ( [_completedItems4 containsObject:rowNumber] )
                { [_completedItems4 removeObject:rowNumber]; }
            }
            if ( [_completedItems4 count] == [[_itemsArray objectAtIndex:indexPath.section] count]) {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor greenColor];
            }
            else {
                SectionHeaderViewController  * tmpSectionVC = [_sectionViewControllers objectAtIndex:indexPath.section];
                UILabel *tmpLabel = (UILabel *)[tmpSectionVC.view viewWithTag:4];
                tmpLabel.backgroundColor = [UIColor clearColor];
            }
            if ( [_completedItems4 count] == [[_itemsArray objectAtIndex:4] count]) {
                _section4complete = true;
            }
            else {
                _section4complete = false;
            }
            NSLog(@"No. of items in _completedItems4 is %lu. _section4Complete is %s.\n", _completedItems4.count, _section4complete ? "true" : "false");
            break;

        default:
        break;
    }
    
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
