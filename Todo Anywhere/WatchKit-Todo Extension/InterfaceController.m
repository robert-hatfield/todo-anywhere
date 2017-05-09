//
//  InterfaceController.m
//  WatchKit-Todo Extension
//
//  Created by Robert Hatfield on 5/9/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "InterfaceController.h"
#import "TodoRowController.h"
#import "Todo.h"

@interface InterfaceController ()

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *table;
@property (strong, nonatomic) NSArray<Todo *> *allTodos;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [self setupTable];
}

- (void)setupTable {
    [self.table setNumberOfRows:self.allTodos.count withRowType:@"TodoRowController"];
    
    for (NSInteger i = 0; i < self.allTodos.count; i++) {
        TodoRowController *rowController = [self.table rowControllerAtIndex:i];
        [rowController.titleLabel setText:self.allTodos[i].title];
        [rowController.contentLabel setText:self.allTodos[i].content];
    }
}

- (NSArray<Todo *> *)allTodos {
    Todo *firstTodo = [[Todo alloc] init];
    firstTodo.title = @"First todo";
    firstTodo.content = @"This is a todo.";
    
    Todo *secondTodo = [[Todo alloc] init];
    secondTodo.title = @"Second todo";
    secondTodo.content = @"This too, is a todo.";
    
    Todo *thirdTodo = [[Todo alloc] init];
    thirdTodo.title = @"Third todo";
    thirdTodo.content = @"And this is a do to do. It's probably past due.";
    
    return @[firstTodo, secondTodo, thirdTodo];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
}

- (IBAction)newTodoPressed {
    
    NSArray *suggestions = @[@"Get groceries", @"Walk the dog", @"Pay bills"];
    [self presentTextInputControllerWithSuggestions:suggestions allowedInputMode:WKTextInputModePlain completion:^(NSArray * _Nullable results) {
        NSLog(@"%@", results);
    }];
}

@end



