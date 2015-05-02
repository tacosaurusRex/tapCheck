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

@property NSMutableArray * listArray;
@property NSDictionary * rootDictionary;
@property NSDictionary * preflightDictionary;
@property NSArray * preflightArray;
@property UIView * headerView;
@property NSArray * sectionHeaderArray;
@property (nonatomic,retain) NSMutableArray *sectionViewControllers;
@property NSArray * itemsArray;
@end
