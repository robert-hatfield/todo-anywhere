//
//  TVLoginViewController.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/11/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "TVLoginViewController.h"
#import "TVHomeViewController.h"
#import "FirebaseAPI.h"

@interface TVLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation TVLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    NSString *email = self.emailTextField.text;
    NSLog(@"email entered: %@", email);
    [FirebaseAPI checkForUserWithEmail:[NSString stringWithFormat:@"%@", email]
                         andCompletion:^(NSArray<Todo *> *allTodos) {
                             
        if (allTodos.count > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No results found"
                                                                           message:[NSString stringWithFormat:@"No todos were found for %@", email]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

}

@end
