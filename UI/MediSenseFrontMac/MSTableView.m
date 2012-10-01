//
//  MSTableView.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/30/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import "MSTableView.h"
#import "MSTableRowView.h"

@implementation MSTableView


- (CGFloat)yPositionPastLastRow {
    // Only draw the grid past the last visible row
    NSInteger numberOfRows = self.numberOfRows;
    CGFloat yStart = 0;
    if (numberOfRows > 0) {
        yStart = NSMaxY([self rectOfRow:numberOfRows - 1]);
    }
    return yStart;
}

- (void)drawGridInClipRect:(NSRect)clipRect {
    // Only draw the grid past the last visible row
    CGFloat yStart = [self yPositionPastLastRow];
    // Draw the first separator one row past the last row
    yStart += self.rowHeight;
    
    // One thing to do is smarter clip testing to see if we actually need to draw!
    NSRect boundsToDraw = self.bounds;
    NSRect separatorRect = boundsToDraw;
    separatorRect.size.height = 1;
    while (yStart < NSMaxY(boundsToDraw)) {
        separatorRect.origin.y = yStart;
        DrawSeparatorInRect(separatorRect);
        yStart += self.rowHeight;
    }
}

- (void)setFrameSize:(NSSize)size {
    [super setFrameSize:size];
    // We need to invalidate more things when live-resizing since we fill with a gradient and stroke
    if ([self inLiveResize]) {
        CGFloat yStart = [self yPositionPastLastRow];
        if (NSHeight(self.bounds) > yStart) {
            // Redraw our horizontal grid lines
            NSRect boundsPastY = self.bounds;
            boundsPastY.size.height -= yStart;
            boundsPastY.origin.y = yStart;
            [self setNeedsDisplayInRect:boundsPastY];
        }
    }
}

@end
