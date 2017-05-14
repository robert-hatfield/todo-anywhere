//
//  CompletedTodoViewController.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/9/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "CompletedTodoViewController.h"
#import "TodoDatabase.h"
#import "TodoTableViewCell.h"

@interface CompletedTodoViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CompletedTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView) name:@"todosChanged" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[TodoDatabase shared] checkuserStatusFrom:self];
}

- (void)updateTableView {
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"todosChanged" object:nil];
}

//MARK: Tableview datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[TodoDatabase shared] completedTodos].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Todo *currentTodo = [TodoDatabase shared].completedTodos[indexPath.row];
    cell.titleLabel.text = currentTodo.title;
    cell.contentLabel.text = currentTodo.content;
    
    return cell;
}

@end
