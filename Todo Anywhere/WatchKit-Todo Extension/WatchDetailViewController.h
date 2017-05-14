//
//  WatchDetailViewController.h
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/9/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import "Todo.h"

@interface WatchDetailViewController : WKInterfaceController

@property (strong, nonatomic) Todo *todo;

@end
