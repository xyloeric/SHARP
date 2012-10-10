//
//  SparklineCell.h
//  Shoji
//
//  Created by Zhe Li on 3/8/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSEntity;
@class SparklineView;

@interface SparklineCell : UITableViewCell
{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *valueLabel;
    __weak IBOutlet UILabel *unitLabel;
    __weak IBOutlet UILabel *dateTimeLabel;
    
    __weak IBOutlet SparklineView *sparklineView;
    
    MSEntity *inputEntity;
    
    __weak UIView *alertView;
    
    UIActivityIndicatorView *indicator;
}

@property (nonatomic, weak) UILabel *titleLabel, *valueLabel, *unitLabel, *dateTimeLabel;
@property (nonatomic, weak) SparklineView *sparklineView;

@property (nonatomic, strong) MSEntity *inputEntity;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIView *alertView;

- (void)refreshGraph;
- (void)toggleAlert;

- (void)relayoutGraph;

@end
