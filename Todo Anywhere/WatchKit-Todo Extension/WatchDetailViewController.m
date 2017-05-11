//
//  WatchDetailViewController.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/9/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "WatchDetailViewController.h"

@interface WatchDetailViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *contentLabel;

@end

@implementation WatchDetailViewController

- (void)awakeWithContext:(id)context {
    self.todo = (Todo *)context;
    [self.titleLabel setText:self.todo.title];
    [self.contentLabel setText:self.todo.content];
}

@end
