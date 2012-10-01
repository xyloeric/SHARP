//
//  OverviewLine.h
//  VisualGadgets
//
//  Created by zli on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MedDataGadgetView.h"

@interface OverviewLine : MedDataGadgetView
{
    NSArray *rawData;
    NSArray *renderingData;
    NSArray *normalizedData;
    
    NSTextField *valueLabel;
    NSTextField *unitLabel;
    
}
@property (strong) NSArray *rawData;
@property (nonatomic, strong) NSArray *renderingData;
@property (nonatomic, strong) NSArray *normalizedData;

@property (strong) IBOutlet NSTextField *valueLabel;
@property (strong) IBOutlet NSTextField *unitLabel;

- (id) initWithFrame:(NSRect)frame andRenderingData:(NSArray *)_data;
- (void) setWindowLengthDataDuration:(NSTimeInterval)_timeInterval;
- (void) magnifyViewWithFactor:(CGFloat)_magnityingFactor;

- (NSArray *) copyDataFromValues:(NSArray *)_values;

//refresh the display values of the external labels;
- (void)refreshLabels;
@end
