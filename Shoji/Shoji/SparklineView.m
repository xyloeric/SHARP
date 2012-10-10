//
//  SparklineView.m
//  Shoji
//
//  Created by Zhe Li on 3/8/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import "SparklineView.h"
#import "MSValue.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "DLShojiNavController.h"

@implementation SparklineView
@synthesize rawData;
@synthesize normalizedData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    
//    
//    CGContextSetLineWidth(context, 2.0);
//    
//    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
//    
//    CGFloat components[] = {0.0, 0.0, 1.0, 1.0};
//    
//    CGColorRef color = CGColorCreate(colorspace, components);
//    
//    CGContextSetStrokeColorWithColor(context, color);
//    
//    CGFloat stepAccumulate = 0.0f;
//    MSValue *v1 = [normalizedData objectAtIndex:0];
//    
//    CGContextMoveToPoint(context, 0, [v1.value floatValue]);
//    
//    for (int i = 1; i < [normalizedData count]; i++) {
//        MSValue *value = [normalizedData objectAtIndex:i];
//        CGContextAddLineToPoint(context, stepAccumulate, [value.value floatValue]);
//        stepAccumulate += stepWidth;
//    }
//    
//    CGContextStrokePath(context);
//    CGColorSpaceRelease(colorspace);
//    CGColorRelease(color);
//
//}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self.layer setBackgroundColor:[[UIColor blackColor] CGColor]];
}


- (void)drawRect:(CGRect)rect
{
        
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetRGBFillColor(context, 0,0,0,0.8);
    CGContextFillRect(context, rect);
    
    [self drawAxis];
    [self drawData];
    drawTextLjust([NSString stringWithFormat:@"%.2f", minimumValue], xAxisYPosition - 2.0f, yAxisXPosition - 30.0f, yAxisXPosition - 2.0f, 10, 8);
    // If you have content to draw after the shape,
    // save the current state before changing the transform
    //CGContextSaveGState(aRef);
    
    // Adjust the view's origin temporarily. The oval is
    // now drawn relative to the new origin point.
    //CGContextTranslateCTM(aRef, 50, 50);
      
    
    CGContextRestoreGState(context);
    
    
    // Restore the graphics state before drawing any other content.
    //CGContextRestoreGState(aRef);
}

- (void)drawAxis
{
    UIBezierPath *xAxisPath = [UIBezierPath bezierPath];
    UIBezierPath *yAxisPath = [UIBezierPath bezierPath];
    
    [xAxisPath moveToPoint:CGPointMake(0.0f, xAxisYPosition)];
    [xAxisPath addLineToPoint:CGPointMake(self.frame.size.width, xAxisYPosition)];
    
    [yAxisPath moveToPoint:CGPointMake(yAxisXPosition, 0.0f)];
    [yAxisPath addLineToPoint:CGPointMake(yAxisXPosition, self.frame.size.height)];
    
    [[UIColor greenColor] setStroke];
    xAxisPath.lineWidth = 2.0f;
    [xAxisPath stroke];
    
    [[UIColor whiteColor] setStroke];
    yAxisPath.lineWidth = 2.0f;
    [yAxisPath stroke];
}

- (void)drawData
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    UIBezierPath *bPath = nil;
    // Set the render colors
    
    CGFloat stepAccumulate = yAxisXPosition + 2.0f;
    MSValue *v1 = [normalizedData objectAtIndex:0];
    if (v1.value2 != nil) {
        bPath = [UIBezierPath bezierPath];
        stepWidth = stepWidth * 2;
    }
    
    [aPath moveToPoint:CGPointMake(stepAccumulate, [v1.value floatValue])];
    if (bPath != nil) {
        [bPath moveToPoint:CGPointMake(stepAccumulate, [v1.value2 floatValue])];
    }
    for (int i = 1; i < [normalizedData count]; i++) {
        MSValue *value = [normalizedData objectAtIndex:i];
        [aPath addLineToPoint:CGPointMake(stepAccumulate, [value.value floatValue])];
        
        if (bPath != nil) {
            //NSLog(@"v2: %@", value.value2);
            
            [bPath addLineToPoint:CGPointMake(stepAccumulate, [value.value2 floatValue])];
        }
        //CGContextAddLineToPoint(context, stepAccumulate, [value.value floatValue]);
        
        stepAccumulate += stepWidth;
    }
    
    [[UIColor yellowColor] setStroke];
    
    // Adjust the drawing options as needed.
    aPath.lineWidth = 2;
    
    // Fill the path before stroking it so that the fill
    // color does not obscure the stroked line.
    [aPath stroke];
    
    
    if (bPath != nil) {
        [[UIColor redColor] setStroke];
        
        bPath.lineWidth = 2;
        [bPath stroke];
    }


}

static void drawTextLjust(NSString* text, CGFloat y, CGFloat left, CGFloat right,
                          int maxFontSize, int minFontSize) {
    
    [[UIColor whiteColor] setFill];

    CGPoint point = CGPointMake(left, y);
    UIFont *font = [UIFont systemFontOfSize:maxFontSize];
    [text drawAtPoint:point forWidth:right - left withFont:font
          minFontSize:minFontSize actualFontSize:NULL
        lineBreakMode:UILineBreakModeTailTruncation
   baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
}

static void drawTextRjust(NSString* text, CGFloat y, CGFloat left, CGFloat right,
                          int maxFontSize, int minFontSize) {
    
    [[UIColor whiteColor] setFill];
    
    CGPoint point = CGPointMake(left, y);
    UIFont *font = [UIFont systemFontOfSize:maxFontSize];
    [text drawAtPoint:point forWidth:right - left withFont:font
          minFontSize:minFontSize actualFontSize:NULL
        lineBreakMode:UILineBreakModeTailTruncation
   baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
}

- (void)setRawData:(NSArray *)_rawData
{
    rawData = _rawData;
    if (rawData && [rawData count] > 0) {
        [self preprocessRawData];
        [self normalizeRawData];
        [self setNeedsDisplay];
    }
    
}

- (void)preprocessRawData;
{
    dataCount = 0;
    
    CGFloat xMaximal = self.frame.size.height - 10.0f;
    CGFloat xPercent = self.frame.size.height - (self.frame.size.height / 10.0f);
    xAxisYPosition = (xMaximal < xPercent)?xMaximal:xPercent; 
    
    CGFloat yMinimal = 30.0f;
    CGFloat yPercent = self.frame.size.width / 15.0f;
    yAxisXPosition = (yMinimal > yPercent)?yMinimal:yPercent;
    
    maximumValue = CGFLOAT_MIN;
    minimumValue = CGFLOAT_MAX;
    dispatch_queue_t queue = dispatch_queue_create("com.drlulu.shoji.queue1", NULL);

    heightOffset = 4.0f;
    
    [rawData enumerateObjectsUsingBlock:^(MSValue *value, NSUInteger idx, BOOL *stop) {
        //dispatch_async(queue, ^{
      
        float fvalue = [value.value floatValue];
        if (fvalue > maximumValue) {
            maximumValue = fvalue;
            NSLog(@"max: %f", maximumValue);

        }
        if (fvalue < minimumValue) {
            minimumValue = fvalue;
            NSLog(@"min: %f", maximumValue);

        }
        
        if (value.value2 != nil) {
            dataCount ++;
            float fvalue2 = [value.value2 floatValue];
            if (fvalue2 > maximumValue) {
                maximumValue = fvalue2;
            }
            if (fvalue2 < minimumValue) {
                minimumValue = fvalue2;
            }
        }
        dataCount ++;

        //});
    }];
    
    if (minimumValue == CGFLOAT_MAX) {
        minimumValue = 0.0f;
    }
    
    NSLog(@"%f, %f", maximumValue, minimumValue);
    dispatch_release(queue);
    
    valueRange = maximumValue - minimumValue;
    
    rangeHeightRatio = ((xAxisYPosition - heightOffset)/ valueRange);
    
    stepWidth = (self.frame.size.width - yAxisXPosition - 2.0f) / (dataCount - 1);
}

- (void)normalizeRawData
{
    @autoreleasepool {
        dispatch_queue_t queue = dispatch_queue_create("com.drlulu.shoji.queue1", NULL);

        
        NSMutableArray *result = [NSMutableArray array];
        [rawData enumerateObjectsUsingBlock:^(MSValue *value, NSUInteger idx, BOOL *stop) {
            //dispatch_async(queue, ^{
                MSValue *normValue = [[MSValue alloc] init];
                normValue.unit = value.unit;
                
                CGFloat normV = [self normalizeValue:[value.value floatValue]];
                normValue.value = [NSString stringWithFormat:@"%f", normV];
                
                if (value.value2) {
                    CGFloat normV2 = [self normalizeValue:[value.value2 floatValue]];
                    normValue.value2 = [NSString stringWithFormat:@"%f", normV2];
                }
                
                [result addObject:normValue]; 
            //});
        }];
        
        self.normalizedData = result;
        
        dispatch_release(queue);

    }
}

- (CGFloat) normalizeValue:(CGFloat)_originalValue
{
    return self.frame.size.height - (((_originalValue - minimumValue) * rangeHeightRatio)) - (self.frame.size.height - xAxisYPosition) - 2.0f;
}


@end
