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
@import WatchConnectivity;

@interface InterfaceController () <WCSessionDelegate>

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

//- (NSArray<Todo *> *)allTodos {
//    Todo *firstTodo = [[Todo alloc] init];
//    firstTodo.title = @"First todo";
//    firstTodo.content = @"This is a todo.";
//    
//    Todo *secondTodo = [[Todo alloc] init];
//    secondTodo.title = @"Second todo";
//    secondTodo.content = @"This too, is a todo.";
//    
//    Todo *thirdTodo = [[Todo alloc] init];
//    thirdTodo.title = @"Third todo";
//    thirdTodo.content = @"And this is a do to do. It's probably past due.";
//    
//    return @[firstTodo, secondTodo, thirdTodo];
//}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user.
    [super willActivate];
    
    [[WCSession defaultSession] setDelegate:self];
    // If session was not fully activated by ExtensionDelegate at launch, reattempt activating session.
    [[WCSession defaultSession] activateSession];
    
    // The message parameter is used to send new Todo data to Firebase. Sending an empty dictionary in current implementation to request updates.
    [[WCSession defaultSession] sendMessage:@{}
                               replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                   
                                NSMutableArray *allTodos = [[NSMutableArray alloc] init];
                                   
                                NSArray *todosDictionaries = replyMessage[@"todos"];
                                   for (NSDictionary *todoObject in todosDictionaries) {
                                       Todo *newTodo = [[Todo alloc] init];
                                       newTodo.title = todoObject[@"title"];
                                       newTodo.content = todoObject[@"content"];
                                       // assign any other values here...
                                       
                                       [allTodos addObject:newTodo];
                                   }
                                   
                                   self.allTodos = [allTodos copy];
                                   [self setupTable];
                                   
    } errorHandler:^(NSError * _Nonnull error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier
                            inTable:(WKInterfaceTable *)table
                           rowIndex:(NSInteger)rowIndex {
    
    return self.allTodos[rowIndex];
    
}

- (IBAction)newTodoPressed {
    NSArray *suggestions = @[@"Get groceries", @"Walk the dog", @"Pay bills"];
    [self presentTextInputControllerWithSuggestions:suggestions
                                   allowedInputMode:WKTextInputModePlain
                                         completion:^(NSArray * _Nullable results) {
        NSLog(@"%@", results);
    }];
}

@end



