//
//  HomeViewController.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/8/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "Todo.h"
#import "TodoTableViewCell.h"

@import FirebaseAuth;
@import Firebase;

static CGFloat const kClosedConstraint = 0.0;
static CGFloat const kOpenConstraint = 150.0;
static NSTimeInterval const kShortAnimationDuration = 0.34;

@interface HomeViewController () <UITableViewDataSource>

@property(strong, nonatomic) FIRDatabaseReference *userReference;
@property(strong, nonatomic) FIRUser *currentUser;

@property(nonatomic) FIRDatabaseHandle allTodosHandler;

@property (strong, nonatomic) NSMutableArray *allTodos;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logOutButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *createTodoHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *todoTableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.todoTableView.dataSource = self;
    self.createTodoHeightConstraint.constant = kClosedConstraint;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkUserStatus];
}

- (void)checkUserStatus {
    // Present login view if user is not logged in, otherwise setup Firebase references.
    if (![[FIRAuth auth] currentUser]) {
        LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginController animated:YES completion:nil];
    } else {
        [self setupFirebase];
        [self startMonitoringTodoUpdates];
        [self.logOutButton setEnabled:YES];
    }
}

- (void)setupFirebase {
    FIRDatabaseReference *databaseReference = [[FIRDatabase database] reference];
    self.currentUser = [[FIRAuth auth] currentUser];
    self.userReference = [[databaseReference child:@"users"] child:self.currentUser.uid];
    NSLog(@"User reference: %@", self.userReference);
}

- (void)startMonitoringTodoUpdates {
    self.allTodosHandler = [[self.userReference child:@"todos"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.allTodos = [[NSMutableArray alloc] init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *todoData = child.value;
            NSString *todoTitle = todoData[@"title"];
            NSString *todoContent = todoData[@"content"];
            NSNumber *boolNumber = todoData[@"isCompleted"];
            Boolean isCompleted = boolNumber.boolValue;
            
            // TODO: Append new Todo to allTodos array
            NSLog(@"Todo Title: %@ - Content: %@", todoTitle, todoContent);
            Todo *currentTodo = [[Todo alloc] init];
            currentTodo.title = todoTitle;
            currentTodo.content = todoContent;
            currentTodo.isCompleted = isCompleted;
            [self.allTodos addObject:currentTodo];
        }
        [self.todoTableView reloadData];
    }];
}

//MARK: Tableview delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"# of todos:%lu", (unsigned long)self.allTodos.count);
    return self.allTodos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Todo *currentTodo = self.allTodos[indexPath.row];
    cell.titleLabel.text = currentTodo.title;
    cell.contentLabel.text = currentTodo.content;
    
    return cell;
}

//MARK: User actions
- (IBAction)logOutPressed:(UIBarButtonItem *)sender {
    NSError *signOutError;
    [[FIRAuth auth] signOut:&signOutError];
    
    if(signOutError) {
        NSLog(@"Error signing out: %@", signOutError.localizedDescription);
    } else {
        [self.logOutButton setEnabled:NO];
        [self checkUserStatus];
    }
}

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender {
    if (self.createTodoHeightConstraint.constant == kOpenConstraint) {
        self.createTodoHeightConstraint.constant = kClosedConstraint;
    } else {
        self.createTodoHeightConstraint.constant = kOpenConstraint;
    }
    
    [UIView animateWithDuration:kShortAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

@end
