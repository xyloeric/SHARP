//
//  TraceCoordinator.h
//  Shoji
//
//  Created by Zhe Li on 3/21/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TraceCoordinator : NSObject
{
    NSMutableArray *displayedEntities;
    NSMutableArray *tappedEntities;
}

@property (nonatomic, strong) NSMutableArray *displayedEntities, *tappedEntities;

+(TraceCoordinator *) defaultTraceCoordinator;
@end
