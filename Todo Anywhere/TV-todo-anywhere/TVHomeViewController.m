//
//  TVHomeViewController.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/9/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "TVHomeViewController.h"
#import "Todo.h"

@interface TVHomeViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Todo *> *allTodos;

@end

@implementation TVHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
}

- (NSArray<Todo *> *)allTodos {
    Todo *firstTodo = [[Todo alloc] init];
    firstTodo.title = @"First todo";
    firstTodo.content = @"This is a todo.";
    
    Todo *secondTodo = [[Todo alloc] init];
    secondTodo.title = @"First todo";
    secondTodo.content = @"This too, is a todo.";
    
    Todo *thirdTodo = [[Todo alloc] init];
    thirdTodo.title = @"First todo";
    thirdTodo.content = @"And this is a do to do. It's probably past due.";
    
    return @[firstTodo, secondTodo, thirdTodo];
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

@end
