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
@property NSMutableArray * completedItems;
@property NSMutableArray* completedItems0;
@property NSMutableArray* completedItems1;
@property NSMutableArray* completedItems2;
@property NSMutableArray* completedItems3;
@property NSMutableArray* completedItems4;
@property NSMutableArray * sectionComplete;
@property int sectionComplete0;
@property int sectionComplete1;
@property int sectionComplete2;
@property int sectionComplete3;
@property int sectionComplete4;
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
