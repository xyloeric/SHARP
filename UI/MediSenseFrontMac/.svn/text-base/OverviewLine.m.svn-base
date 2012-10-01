//
//  OverviewLine.m
//  VisualGadgets
//
//  Created by zli on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OverviewLine.h"
#import "MSValue.h"

@interface OverviewLine (hidden)
- (void) preprocessData:(NSArray *)_data;
- (CGFloat) normalizeValue:(CGFloat)_originalValue;
- (void) normalizeDataArray:(NSArray *)_array;
@end

@implementation OverviewLine
{
    NSInteger dataCount;
    CGFloat maximumValue;
    CGFloat minimumValue;
    CGFloat valueRange;
    CGFloat rangeHeightRatio;
    
    CGFloat stepWidth;
    CGFloat heightOffset;
    
    NSTimeInterval dataDuration;
    CGFloat durationRatio;
}
@synthesize rawData;
@synthesize renderingData;
@synthesize normalizedData;

@synthesize valueLabel;
@synthesize unitLabel;

- (id)initWithFrame:(NSRect)frame andRenderingData:(NSArray *)_data
{
    self = [super initWithFrame:frame];
    if (self) {        
        
        frameWidth = frame.size.width;
        frameHeight = frame.size.height;
        self.renderingData = _data;
        
    }
    
    return self;
}

- (void) setWindowLengthDataDuration:(NSTimeInterval)_timeInterval
{
    durationRatio = _timeInterval/dataDuration;
    [self resizeSubviewsWithOldSize:CGSizeZero];
    //    NSLog(@"%f", [self.superview frame].size.width/ratio);
    //    [self setFrameSize:NSMakeSize(self.frame.size.width/durationRatio, self.frame.size.height)];
    //    
    //    [self alterParameterForResizing:NSMakeSize(self.frame.size.width/durationRatio, self.frame.size.height)];
    //    [self normalizeDataArray:renderingData];
    //    
    //    [self setNeedsDisplayInRect:drawingRect];
}

- (void) magnifyViewWithFactor:(CGFloat)_magnityingFactor
{
    [self setWindowLengthDataDuration:dataDuration * (1 + _magnityingFactor)];
}

- (void)setRenderingData:(NSArray *)_renderingData
{
    if (_renderingData == nil) {
        self.rawData = nil;
        renderingData = nil;
        NSLog(@"set");
        [self refreshLabels];
        
    }
    else if (_renderingData != renderingData) {
        self.rawData = _renderingData;
        renderingData = [self copyDataFromValues:_renderingData];
        
        [self preprocessData:renderingData];
        [self normalizeDataArray:renderingData];
        
        [self setNeedsDisplayInRect:drawingRect];
        
        [self refreshLabels];
        
        NSDate *startDate = [[rawData objectAtIndex:0] valueForKey:@"timeStamp"];
        NSDate *endDate = [[rawData lastObject] valueForKey:@"timeStamp"];
        dataDuration = [endDate timeIntervalSinceDate:startDate];
        startDate = nil;
        endDate = nil;
        
        NSLog(@"%f", dataDuration/3600/24);
        
        [self setWindowLengthDataDuration:86400.0f];
    }
}


- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSGraphicsContext* theContext = [NSGraphicsContext currentContext];
    [theContext saveGraphicsState];
    [theContext setShouldAntialias:YES];
    
    CGContextRef context = (CGContextRef) [theContext graphicsPort];
    CGContextSetRGBFillColor(context, 0.8,0.8,0.8,0.8);
    CGContextFillRect(context, NSRectToCGRect(dirtyRect));
    
    int i;
    CGFloat stepAccumulate = 0.0f;
    
    [NSBezierPath setDefaultMiterLimit:20.0];
    [NSBezierPath setDefaultFlatness:0.6];
    
    NSBezierPath* aPath = [NSBezierPath bezierPath];
    [aPath moveToPoint:NSMakePoint(stepAccumulate, [[normalizedData objectAtIndex:0] floatValue])];
    for (i = 1; i < dataCount; i++)
    {
        stepAccumulate = stepAccumulate + stepWidth;
        // Draw the object
        [aPath lineToPoint:NSMakePoint(stepAccumulate, [[normalizedData objectAtIndex:i] floatValue])];
    }
    [aPath setLineWidth:1.0];
    [aPath setMiterLimit:5.0];
    [[NSColor blueColor] setStroke];
    [aPath stroke];
    [theContext restoreGraphicsState];
}

- (void)resizeWithOldSuperviewSize:(NSSize)oldSize
{
    //[self setFrameSize:NSMakeSize([self.superview frame].size.width/durationRatio, [self.superview frame].size.height)];
    
    [self alterParameterForResizing:NSMakeSize([self.superview frame].size.width/durationRatio, [self.superview frame].size.height)];
    [self normalizeDataArray:renderingData];
    
    [self setNeedsDisplayInRect:drawingRect];
}

- (NSArray *) copyDataFromValues:(NSArray *)_values
{
    @autoreleasepool {
        
        
        if (_values != nil) {
            NSMutableArray *dataArray = [NSMutableArray array];
            [_values enumerateObjectsUsingBlock:^(MSValue *value, NSUInteger idx, BOOL *stop) {
                NSString *v = value.value;
                
                [dataArray addObject:v];
                //            NSLog(@"%@", v);
                //            NSLocale *l_en = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
                //            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                //            [f setLocale: l_en];
                //            [f setAllowsFloats:YES];
                //            if ([f numberFromString:v] != nil) {
                //                [dataArray addObject:v];
                //            }
                //            f = nil;
                
            }];
            
            return dataArray;
        }   
        return nil;
    }
}

- (void) preprocessData:(NSArray *)_data
{
    dataCount = [_data count];
    maximumValue = [[_data valueForKeyPath:@"@max.floatValue"] floatValue];
    minimumValue = [[_data valueForKeyPath:@"@min.floatValue"] floatValue];
    valueRange = maximumValue - minimumValue;
    rangeHeightRatio = frameHeight / valueRange;
    
    stepWidth = frameWidth / (dataCount - 1.0f);
    heightOffset = 0.0f;
}

- (void) alterParameterForResizing:(NSSize)_size
{
    [super alterParameterForResizing:_size];
    
    rangeHeightRatio = frameHeight / valueRange;
    
    stepWidth = frameWidth / (dataCount - 1.0f);
    heightOffset = 0.0f;
}

- (void) normalizeDataArray:(NSArray *)_array
{
    @autoreleasepool {
        if (renderingData) {
            NSMutableArray *result = [_array mutableCopy];
            _array = nil;
            
            [_array enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                CGFloat _normalizeValue = [self normalizeValue:[(NSNumber *)obj floatValue]];
                NSNumber *number = [NSNumber numberWithFloat:_normalizeValue];
                
                [result replaceObjectAtIndex:idx withObject:number];
                
            }];
            
            self.normalizedData = result;
        }
        
        
    }
}

- (CGFloat) normalizeValue:(CGFloat)_originalValue
{
    return (_originalValue - minimumValue) * rangeHeightRatio;
}

- (void)refreshLabels
{
    NSLog(@"rd %@", renderingData);
    NSLog(@"rdl %@", [renderingData lastObject]);
    if ([renderingData lastObject]) {
        valueLabel.stringValue = [renderingData lastObject];
    }
    else {
        valueLabel.stringValue = @"";
    }
    
    if ([[rawData lastObject] valueForKey:@"unit"]) {
        unitLabel.stringValue = [[rawData lastObject] valueForKey:@"unit"];
    }
    else {
        unitLabel.stringValue = @"";
    }
}

#pragma mark EVENTS
- (void)scrollWheel:(NSEvent *)theEvent
{
    [self setFrameOrigin:NSMakePoint(self.frame.origin.x + theEvent.scrollingDeltaY, self.frame.origin.y)];
}

- (void)magnifyWithEvent:(NSEvent *)event
{
    [self magnifyViewWithFactor:event.magnification];
}

@end
