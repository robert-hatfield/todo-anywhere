//
//  TodoTableViewCell.h
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/8/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Todo.h"

@interface TodoTableViewCell : UITableViewCell

@property (strong, nonatomic) Todo *todo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic) Boolean isCompleted;

@end
