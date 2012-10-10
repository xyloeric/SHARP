//
//  MSEntity.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/1/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import "MSEntity.h"
#import "EntityTypeHelpers.h"
#import "SparklineCell.h"

@implementation MSEntity
@synthesize index;
@synthesize title, pid, entityCategory, entityURI, entityCodingSystem, entityCode;
@synthesize entityData;
@synthesize visualizationCell;

- (id)initWithIndex:(NSUInteger)_index
{
    self = [super init];
    if (self) {
        self.index = _index;
        
    }
    
    return self;
}

- (id)initWithIndex:(NSUInteger)_index andTitle:(NSString *)_title
{
    self = [super init];
    if (self) {
        self.index = _index;
        self.title = _title;
        
        //self.entityData = [[MSDataWrapper alloc] initWithConcept:_title];
    }
    
    return self;
}

- (id)initWithIndex:(NSUInteger)_index codingSystem:(NSString *)_cSystem andCode:(NSString *)_code
{
    self = [super init];
    if (self) {
        self.index = _index;
        self.entityCodingSystem = _cSystem;
        self.entityCode = _code;
    }
    
    return self;
}

- (void)setEntityType:(NSString *)_entityType
{
    if (_entityType != entityType) {
        entityType = _entityType;
        if ([EntityTypeHelpers entityHasNumVal:_entityType] && entityCode != nil) {
            self.entityData = [[MSDataWrapper alloc] initWithConcept:entityCode andPatientID:pid];
            entityData.delegate = self;
            [entityData initiateQueryConnection];
        }
    }
}

- (NSString *)entityType
{
    return entityType;
}

- (void)dataWrapperStartedLoading
{
    NSLog(@"started");
}

- (void)dataWrapperFinishedLoading
{
    NSLog(@"finished");
    [visualizationCell refreshGraph];
}

@end
