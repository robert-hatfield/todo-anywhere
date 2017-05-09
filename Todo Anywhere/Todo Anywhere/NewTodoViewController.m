//
//  NewTodoViewController.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/8/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "NewTodoViewController.h"

@import Firebase;
@import FirebaseAuth;

@interface NewTodoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

@implementation NewTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)addTodoPressed:(UIButton *)sender {
    FIRDatabaseReference *databaseReference = [[FIRDatabase database] reference];
    FIRUser *currentUser = [[FIRAuth auth] currentUser];
    FIRDatabaseReference *userReference = [[databaseReference child:@"users"] child:currentUser.uid];
    
    FIRDatabaseReference *newtodoReference = [[userReference child:@"todos"] childByAutoId];
    [[newtodoReference child:@"title"] setValue:self.titleTextField.text];
    [[newtodoReference child:@"content"] setValue:self.contentTextField.text];
    self.titleTextField.text = @"";
    self.contentTextField.text = @"";
    [self.titleTextField resignFirstResponder];
    [self.contentTextField resignFirstResponder];
}


@end
