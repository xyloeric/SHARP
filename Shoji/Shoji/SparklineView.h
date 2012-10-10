//
//  SparklineView.h
//  Shoji
//
//  Created by Zhe Li on 3/8/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SparklineView : UIView
{
    NSArray *rawData;
    NSArray *normalizedData;
    
    NSInteger dataCount;
    CGFloat maximumValue;
    CGFloat minimumValue;
    CGFloat valueRange;
    CGFloat rangeHeightRatio;
    
    CGFloat stepWidth;
    CGFloat heightOffset;
    
    NSTimeInterval dataDuration;
    CGFloat durationRatio;
    
    CGFloat xAxisYPosition;
    CGFloat yAxisXPosition;
    
}

@property (strong, nonatomic) NSArray *rawData;
@property (strong, nonatomic) NSArray *normalizedData;


- (void)drawAxis;
- (void)drawData;

- (void)preprocessRawData;
- (void)normalizeRawData;


- (CGFloat) normalizeValue:(CGFloat)_originalValue;

@end
