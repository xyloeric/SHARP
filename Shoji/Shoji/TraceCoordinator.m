//
//  TraceCoordinator.m
//  Shoji
//
//  Created by Zhe Li on 3/21/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import "TraceCoordinator.h"
static TraceCoordinator *_defaultTraceCoordinator;


@implementation TraceCoordinator
@synthesize displayedEntities;
@synthesize tappedEntities;

+(TraceCoordinator *) defaultTraceCoordinator
{
    @synchronized(self) {
        if (!_defaultTraceCoordinator) {
            _defaultTraceCoordinator = [[self alloc] init];
        }
    }
    return _defaultTraceCoordinator;
}

-(id) init
{
    self = [super init];
    
    if (self) {
        self.displayedEntities = [NSMutableArray array];
        self.tappedEntities = [NSMutableArray array];
    }
    
    return self;
}

-(void)dealloc
{
    
}


@end
