//
//  FirebaseAPI.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/10/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "FirebaseAPI.h"
#import "Credentials.h"

@implementation FirebaseAPI

+(void)fetchAllTodos:(AllTodosCompletion)completion {
    
    NSString *urlString = [NSString stringWithFormat:@"https://todo-anywhere-b3ac4.firebaseio.com/users.json?auth=%@", APP_KEY];
    NSURL *databaseURL = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    [[session dataTaskWithURL:databaseURL
            completionHandler:^(NSData * _Nullable data,
                                NSURLResponse * _Nullable response,
                                NSError * _Nullable error) {
        NSDictionary *rootObject = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:nil];
                
                NSMutableArray *allTodos = [[NSMutableArray alloc] init];
                
                
                for (NSDictionary *userTodosDictionary in [rootObject allValues]) {
                    NSArray *userTodos = [userTodosDictionary[@"todos"] allValues];
                    
//                    NSLog(@"User todos:%@", userTodos);
                    
                    for (NSDictionary *todoDictionary in userTodos) {
                        Todo *currentTodo = [[Todo alloc] init];
                        currentTodo.identifier = todoDictionary[@"identifier"];
                        currentTodo.title = todoDictionary[@"title"];
                        currentTodo.content = todoDictionary[@"content"];
                        NSNumber *completionFlag = todoDictionary[@"isCompleted"];
                        currentTodo.isCompleted = completionFlag.boolValue;
                        
                        [allTodos addObject:currentTodo];
                    }
                }
//        NSLog(@"ROOT OBJECT: %@", rootObject);
                
                if (completion) {
                    completion(allTodos);
                }
                
    }] resume];
}

@end
