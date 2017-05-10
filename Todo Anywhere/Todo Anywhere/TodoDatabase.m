//
//  TodoDatabase.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/9/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "TodoDatabase.h"
#import "Todo.h"
#import "LoginViewController.h"

@import FirebaseAuth;
@import Firebase;

@interface TodoDatabase ()


@property(strong, nonatomic) FIRDatabaseReference *userReference;
@property(strong, nonatomic) FIRUser *currentUser;
@property(nonatomic) FIRDatabaseHandle allTodosHandler;
@property(strong, nonatomic) NSNotificationCenter *notificationCenter;

@end

@implementation TodoDatabase

+(instancetype)shared {
    // Create singleton for Employee database.
    static TodoDatabase *shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] init];
    });
    
    return shared;
}

- (void)checkuserStatusFrom:(UIViewController *)viewController {
    // Present login view if user is not logged in, otherwise setup Firebase references.
    if (![[FIRAuth auth] currentUser]) {
        LoginViewController *loginController = [viewController.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [viewController presentViewController:loginController animated:YES completion:nil];
    } else {
        [self setupFirebase];
        [self startMonitoringTodoUpdates];
    }
}

- (void)setupFirebase {
    FIRDatabaseReference *databaseReference = [[FIRDatabase database] reference];
    self.currentUser = [[FIRAuth auth] currentUser];
    self.userReference = [[databaseReference child:@"users"] child:self.currentUser.uid];
    NSLog(@"User reference: %@", self.userReference);
}

- (void)startMonitoringTodoUpdates {
    self.notificationCenter = [NSNotificationCenter defaultCenter];
    self.allTodosHandler = [[self.userReference child:@"todos"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.openTodos = [[NSMutableArray alloc] init];
        self.completedTodos = [[NSMutableArray alloc] init];
        
        for (FIRDataSnapshot *child in snapshot.children) {
            NSDictionary *todoData = child.value;
            NSString *todoTitle = todoData[@"title"];
            NSString *todoContent = todoData[@"content"];
            NSNumber *boolNumber = todoData[@"isCompleted"];
            Boolean isCompleted = boolNumber.boolValue;
            
            NSLog(@"Todo Title: %@ - Content: %@", todoTitle, todoContent);
            Todo *currentTodo = [[Todo alloc] init];
            currentTodo.title = todoTitle;
            currentTodo.content = todoContent;
            currentTodo.isCompleted = isCompleted;
            NSLog(@"%hhu", currentTodo.isCompleted);
            
            if (currentTodo.isCompleted) {
                [self.completedTodos addObject:currentTodo];
            } else {
                [self.openTodos addObject:currentTodo];
            }
        }
        NSLog(@"%@", self.notificationCenter);
        [self.notificationCenter postNotificationName:@"todosChanged" object:nil];
    }];
}

- (void)signOut {
    NSError *signOutError;
    [[FIRAuth auth] signOut:&signOutError];
    
    

}

@end
