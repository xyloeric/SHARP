//
//  MSEntity.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/1/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSDataWrapper.h"
@class SparklineCell;

@interface MSEntity : NSObject <MSDataWrapperDelegate>
{
    NSUInteger index;
    
    NSString *title;
    NSString *pid;
    NSString *entityURI;
    NSString *entityType;
    NSString *entityCategory;
    NSString *entityCodingSystem;
    NSString *entityCode;    
    
    MSDataWrapper *entityData;
    
    __weak SparklineCell *visualizationCell;
}

@property NSUInteger index;
@property (strong, nonatomic) NSString *title, *pid, *entityURI, *entityCategory, *entityCodingSystem, *entityCode;
@property (strong, nonatomic) MSDataWrapper *entityData;
@property (weak, nonatomic) SparklineCell *visualizationCell;

//init a empty entity with index
- (id)initWithIndex:(NSUInteger)_index;
//init with index and title, and init a data retrieving MSDataWrapper using the title
- (id)initWithIndex:(NSUInteger)_index andTitle:(NSString *)_title;
//init with index, coding system and the code of the concept this entity represents
- (id)initWithIndex:(NSUInteger)_index codingSystem:(NSString *)_cSystem andCode:(NSString *)_code;

- (void)setEntityType:(NSString *)_entityType;
- (NSString *)entityType;


@end
