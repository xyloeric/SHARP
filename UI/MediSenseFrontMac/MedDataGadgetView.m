//
//  MedDataGadgetView.m
//  VisualGadgets
//
//  Created by zli on 9/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MedDataGadgetView.h"

@implementation MedDataGadgetView
@synthesize framesDictionary;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        frameWidth = frame.size.width;
        frameHeight = frame.size.height;
        
        self.framesDictionary = [self _framesForValueViews];
        
        [self setNeedsDisplay:YES];
    }
    
    return self;

}

//- (void)dealloc
//{
//    [framesDictionary release];
//    [super dealloc];
//}

- (void) initializeValueViewsWithValues:(NSDictionary *)_valueDict
{
    
}

- (NSDictionary *)_framesForValueViews
{
    return nil;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    
}

- (void) alterParameterForResizing:(NSSize)_size
{
    frameWidth = _size.width;
    frameHeight = _size.height;
}

- (NSRect)calculateDrawingRectWithFrame:(NSRect)_Originalframe andOffset:(CGFloat)_offset
{
    return NSZeroRect;
}

@end
