//
//  DLBox.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/26/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import "DLBox.h"

@implementation DLBox

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL)mouseDownCanMoveWindow
{
    return NO;
}

@end
