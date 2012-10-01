//
//  MSEntity.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/1/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MSDataWrapper;

@interface MSEntity : NSObject
{
    NSUInteger index;
    
    NSString *title;
    NSString *pid;
    NSString *entityType;
    NSString *entityCategory;
    NSString *entityCodingSystem;
    NSString *entityCode;    
    
    NSMutableDictionary *children;
    NSMutableDictionary *parents;
    
    MSDataWrapper *entityData;
}

@property NSUInteger index;
@property (strong) NSString *title, *pid, *entityCategory, *entityCodingSystem, *entityCode;
@property (strong) NSMutableDictionary *children, *parents;
@property (strong) MSDataWrapper *entityData;

//init a empty entity with index
- (id)initWithIndex:(NSUInteger)_index;
//init with index and title, and init a data retrieving MSDataWrapper using the title
- (id)initWithIndex:(NSUInteger)_index andTitle:(NSString *)_title;
//init with index, coding system and the code of the concept this entity represents
- (id)initWithIndex:(NSUInteger)_index codingSystem:(NSString *)_cSystem andCode:(NSString *)_code;

- (void)setEntityType:(NSString *)_entityType;
- (NSString *)entityType;

- (void)addChild:(MSEntity *)_entity withRelaType:(NSString *)_relaType;

@end
