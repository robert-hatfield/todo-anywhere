//
//  TVHomeViewController.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/9/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "TVHomeViewController.h"
#import "Todo.h"
#import "TVDetailViewController.h"
#import "FirebaseAPI.h"
#import "TVLoginViewController.h"

@interface TVHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Todo *> *allTodos;
@property (strong, nonatomic) NSArray <Todo *> *openTodos;
@property (strong, nonatomic) NSArray <Todo *> *closedTodos;

@end

@implementation TVHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkUserStatus];
}

- (void)checkUserStatus {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [userDefaults stringForKey:@"email"];
    
    if (!email || [email isEqualToString:@""]) {
        TVLoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"TVLoginViewController"];
        [self presentViewController:loginController animated:YES completion:nil];
    } else {
        [FirebaseAPI checkForUserWithEmail:email andCompletion:^(NSArray<Todo *> *allTodos) {
            self.allTodos = allTodos;
            [self.tableView reloadData];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.allTodos[indexPath.row].title;
    cell.detailTextLabel.text = self.allTodos[indexPath.row].content;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTodos.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showTodoDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    TVDetailViewController *destinationVC = segue.destinationViewController;
    Todo *selectedTodo = self.allTodos[self.tableView.indexPathForSelectedRow.row];
    destinationVC.todo = selectedTodo;
}

//MARK: User actions
- (IBAction)signOutPressed:(UIBarButtonItem *)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.allTodos = @[];
    [self.tableView reloadData];
    [self checkUserStatus];
}

- (IBAction)toDoPressed:(UIButton *)sender {
}

- (IBAction)donePressed:(UIButton *)sender {
}


@end
