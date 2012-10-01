//
//  MSTableRowView.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/30/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTableRowView : NSTableRowView
{
@private
    BOOL mouseInside;
    NSTrackingArea *trackingArea;
}

// Used by the HoverTableRowView and the HoverTableView
void DrawSeparatorInRect(NSRect rect);

@end
