//
//  UIView+MSSAutoLayout.m
//  TabbedPageViewController
//
//  Created by Merrick Sapsford on 24/12/2015.
//  Copyright © 2015 Merrick Sapsford. All rights reserved.
//

#import "UIView+MSSAutoLayout.h"

NSInteger const MSSViewDefaultZIndex = -1;

@implementation UIView (MSSAutoLayout)

- (void)mss_addExpandingSubview:(UIView *)subview {
    [self mss_addExpandingSubview:subview edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)mss_addExpandingSubview:(UIView *)subview edgeInsets:(UIEdgeInsets)insets {
    [self mss_addExpandingSubview:subview edgeInsets:insets atZIndex:MSSViewDefaultZIndex];
}

- (void)mss_addExpandingSubview:(UIView *)subview edgeInsets:(UIEdgeInsets)insets atZIndex:(NSInteger)index {
    [self addView:subview atZIndex:index];
    NSDictionary *views = NSDictionaryOfVariableBindings(subview);
    
    NSString *verticalConstraints = [NSString stringWithFormat:@"V:|-%f-[subview]-%f-|", insets.top, insets.bottom];
    NSString *horizontalConstraints = [NSString stringWithFormat:@"H:|-%f-[subview]-%f-|", insets.left, insets.right];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraints
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraints
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

- (void)mss_addPinnedToTopAndSidesSubview:(UIView *)subview withHeight:(CGFloat)height {
    [self addView:subview atZIndex:MSSViewDefaultZIndex];
    NSDictionary *views = NSDictionaryOfVariableBindings(subview);
    
    NSDictionary *metrics = @{@"viewHeight":@(height)};
    NSString *verticalConstraints = [NSString stringWithFormat:@"V:|-[subview(viewHeight)]"];
    NSString *horizontalConstraints = [NSString stringWithFormat:@"H:|-[subview]-|"];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraints
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraints
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

#pragma mark - Utils

- (void)mss_clearSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

#pragma mark - Internal

- (void)addView:(UIView *)subview atZIndex:(NSInteger)index {
    if (subview.superview) {
        [subview removeFromSuperview];
    }
    if (index >= 0) {
        [self insertSubview:subview atIndex:index];
    } else {
        [self addSubview:subview];
    }
    subview.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
