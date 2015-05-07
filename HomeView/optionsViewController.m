//
//  optionsViewController.m
//  tapCheck
//
//  Created by Robert Mahoney on 5/6/15.
//  Copyright (c) 2015 RobertMahoney. All rights reserved.
//

#import "optionsViewController.h"

@interface optionsViewController ()

@end

@implementation optionsViewController

- (void)viewDidLoad {
    self.title = @"Options";
    self.navigationController.navigationBar.barTintColor = nil;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)resetListButton:(id)sender {
    
    //Deletes the plist to reset check list state.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * plistPath = [documentsDirectory stringByAppendingPathComponent:@"userState.plist"];
    [[NSFileManager defaultManager] removeItemAtPath:plistPath error:NULL];

}

- (void) showAlert {
    
    UIAlertView *resetAlert = [[UIAlertView alloc]
                               initWithTitle:@"Reset!"
                               message:@"Are you sure you want to reset the checklist?"
                               delegate:nil
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:@"Reset", nil];
    [resetAlert show];
}

@end
