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

+(void)checkForUserWithEmail:(NSString *)email andCompletion:(AllTodosCompletion)completion {
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

                for (NSDictionary *userDictionary in [rootObject allValues]) {
                    if ([email isEqualToString:userDictionary[@"email"]]) {
                        NSArray *userTodos = [userDictionary[@"todos"] allValues];
                        for (NSDictionary *todoDictionary in userTodos) {
                            
                            Todo *currentTodo = [[Todo alloc] init];
                            
                            currentTodo.content = todoDictionary[@"content"];
                            currentTodo.identifier = todoDictionary[@"identifier"];
                            NSNumber *completionFlag = todoDictionary[@"isCompleted"];
                            currentTodo.isCompleted = completionFlag.boolValue;
                            currentTodo.title = todoDictionary[@"title"];
                            
                            [allTodos addObject:currentTodo];
                        }
                        break;
                    }
                }

                
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion([allTodos copy]);
                    });
                }
                
            }] resume];
}

@end
