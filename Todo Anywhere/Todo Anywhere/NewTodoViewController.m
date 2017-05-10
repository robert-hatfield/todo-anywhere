//
//  NewTodoViewController.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/8/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "NewTodoViewController.h"
#import "TodoDatabase.h"

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
    
    [[TodoDatabase shared] createTodoWithTitle:self.titleTextField.text
                                    andContent:self.contentTextField.text];
    self.titleTextField.text = @"";
    self.contentTextField.text = @"";
    [self.titleTextField resignFirstResponder];
    [self.contentTextField resignFirstResponder];
}


@end
