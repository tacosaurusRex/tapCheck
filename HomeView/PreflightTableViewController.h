//
//  PreflightTableViewController.h
//  Checklist
//
//  Created by Robert Mahoney on 1/15/15.
//  Copyright (c) 2015 Robert Mahoney. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "MyCustomCell.h"

@interface PreflightTableViewController : UITableViewController
@property NSArray * completedItems;
@property NSMutableArray* completedItems0;
@property NSMutableArray* completedItems1;
@property NSMutableArray* completedItems2;
@property NSMutableArray* completedItems3;
@property NSMutableArray* completedItems4;
@property BOOL section0complete;
@property BOOL section1complete;
@property BOOL section2complete;
@property BOOL section3complete;
@property BOOL section4complete;
@property NSMutableArray * listArray;
@property NSDictionary * rootDictionary;
@property NSDictionary * preflightDictionary;
@property NSArray * preflightArray;
@property UIView * headerView;
@property NSArray * sectionHeaderArray;
@property (nonatomic,retain) NSMutableArray *sectionViewControllers;
@property NSArray * itemsArray;
@property NSArray * userStateArray;

@end
