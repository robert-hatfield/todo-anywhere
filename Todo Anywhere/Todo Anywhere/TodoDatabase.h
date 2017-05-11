//
//  TodoDatabase.h
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/9/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TodoDatabase : NSObject

@property (strong, nonatomic) NSMutableArray *openTodos;
@property (strong, nonatomic) NSMutableArray *completedTodos;

+(instancetype)shared;

- (void)checkuserStatusFrom:(UIViewController *)viewController;
- (void)signOut;
- (void)createTodoWithTitle:(NSString *)title andContent:(NSString *)content;
- (void)updateTodo:(NSString *)identifier withStringValue:(NSString *)value forKey:(NSString *)key;
- (void)completeTodo:(NSString *)identifier;

@end
