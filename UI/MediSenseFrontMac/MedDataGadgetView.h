//
//  MedDataGadgetView.h
//  VisualGadgets
//
//  Created by zli on 9/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MedDataGadgetView : NSView
{
    CGFloat frameWidth;
    CGFloat frameHeight;
    
    CGFloat drawingRectOffset;
    NSRect drawingRect;
    
    NSDictionary *framesDictionary;
}

@property (nonatomic, retain) NSDictionary *framesDictionary;

- (void) alterParameterForResizing:(NSSize)_size;
- (NSRect)calculateDrawingRectWithFrame:(NSRect)_Originalframe andOffset:(CGFloat)_offset;
- (void) initializeValueViewsWithValues:(NSDictionary *)_valueDict;
- (NSDictionary *)_framesForValueViews;

@end
