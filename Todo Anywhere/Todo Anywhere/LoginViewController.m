//
//  LoginViewController.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/8/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "LoginViewController.h"
@import FirebaseAuth;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginPressed:(UIButton *)sender {
    [[FIRAuth auth] signInWithEmail:self.emailTextField.text
                           password:self.passwordTextField.text
                         completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error signing in: %@", error.localizedDescription);
        }
        
        if (user) {
            NSLog(@"Logged in user: %@", user);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}

- (IBAction)signUpPressed:(UIButton *)sender {
    [[FIRAuth auth] createUserWithEmail:self.emailTextField.text
                               password:self.passwordTextField.text
                             completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                 
         if (error) {
             NSLog(@"Error signing up: %@", error.localizedDescription);
         }
         
         if (user) {
             NSLog(@"Created user: %@", user);
             [self dismissViewControllerAnimated:YES completion:nil];
         }
         
     }];
}

- (void)signOut {
    NSError *signOutError;
    [[FIRAuth auth] signOut:&signOutError];
}

@end
