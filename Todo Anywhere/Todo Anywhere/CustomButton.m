//
//  CustomButton.m
//  Todo Anywhere
//
//  Created by Robert Hatfield on 5/8/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayerProperties];
}

- (void)updateLayerProperties {
    self.layer.cornerRadius = self.borderRadius;
}

- (void)setBorderRadius:(CGFloat)borderRadius {
    if (borderRadius != _borderRadius) {
        _borderRadius = borderRadius;
        [self updateLayerProperties];
    }
}

@end