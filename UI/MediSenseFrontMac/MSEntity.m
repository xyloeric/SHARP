//
//  MSEntity.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/1/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import "MSEntity.h"
#import "MSDataWrapper.h"
#import "EntityTypeHelpers.h"

@implementation MSEntity
@synthesize index;
@synthesize title, pid, entityCategory, entityCodingSystem, entityCode;
@synthesize children, parents;
@synthesize entityData;

- (id)initWithIndex:(NSUInteger)_index
{
    self = [super init];
    if (self) {
        self.index = _index;
        
        self.children = [[NSMutableDictionary alloc] init];
        self.parents = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (id)initWithIndex:(NSUInteger)_index andTitle:(NSString *)_title
{
    self = [super init];
    if (self) {
        self.index = _index;
        self.title = _title;
        
        self.children = [[NSMutableDictionary alloc] init];
        self.parents = [[NSMutableDictionary alloc] init];
        
        self.entityData = [[MSDataWrapper alloc] initWithConcept:_title];
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
        
        self.children = [[NSMutableDictionary alloc] init];
        self.parents = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}

- (void)setEntityType:(NSString *)_entityType
{
    if (_entityType != entityType) {
        entityType = _entityType;
        if ([EntityTypeHelpers entityHasRawVal:_entityType] && entityCode != nil) {
            self.entityData = [[MSDataWrapper alloc] initWithConcept:entityCode];
        }
    }
}

- (NSString *)entityType
{
    return entityType;
}

- (void)addChild:(MSEntity *)_entity withRelaType:(NSString *)_relaType
{
    @autoreleasepool {
         
        if ([children objectForKey:_relaType] == nil) {
            NSMutableArray *_relaTypeArray = [NSMutableArray array];
            [children setObject:_relaTypeArray forKey:_relaType];
        }
        if ([_entity.parents objectForKey:_relaType] == nil) {
            NSMutableArray *_relaTypeArray = [NSMutableArray array];
            [_entity.parents setObject:_relaTypeArray forKey:_relaType];
        }
        
        NSMutableArray *relaTypeC = [children objectForKey:_relaType];
        [relaTypeC addObject:_entity];
        
        NSMutableArray *relaTypeP = [_entity.parents objectForKey:_relaType];
        [relaTypeP addObject:self];
        
    }
}

@end
