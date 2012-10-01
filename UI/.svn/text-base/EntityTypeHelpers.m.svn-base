//
//  EntityTypeHelpers.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 2/27/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import "EntityTypeHelpers.h"

@implementation EntityTypeHelpers

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(BOOL) entityHasNumVal:(NSString *)_entityType
{
    if ([_entityType isEqualToString:@"EqualsValue"] || [_entityType isEqualToString:@"LargerThanOrEqualValue"] || [_entityType isEqualToString:@"LargerThanValue"] || [_entityType isEqualToString:@"SmallerThanOrEqualValue"] || [_entityType isEqualToString:@"SmallerThanValue"] || [_entityType isEqualToString:@"AbnormalIncreasingTrendValue"] || [_entityType isEqualToString:@"SmallerThanCompositeValue"] || [_entityType isEqualToString:@"ObjectiveReading"])
    {
        return YES;
    }
    
    else {
        return NO;
    }
}


+(BOOL) entityHasCatVal:(NSString *)_entityType
{
    if ([_entityType isEqualToString:@"Qualitative_Present_Value"]) {
        return YES;
    }
    else {
        return NO;
    }
}

+(BOOL) entityHasRawVal:(NSString *)_entityType
{
    if ([EntityTypeHelpers entityHasCatVal:_entityType] || [EntityTypeHelpers entityHasNumVal:_entityType]) {
        return YES;
    }
    else {
        return NO;
    }
}

+(BOOL) entityIsTrigger:(NSString *)_entityType
{
    if ([_entityType isEqualToString:@"And"] || [_entityType isEqualToString:@"Nor"] || [_entityType isEqualToString:@"NOrLess"] || [_entityType isEqualToString:@"NOrMore"] || [_entityType isEqualToString:@"Or"] || [_entityType isEqualToString:@"Xor"])
    {
        return YES;
    }
    
    else {
        return NO;
    }
}

+(BOOL) entityIsExistingDiagnosis:(NSString *)_entityType
{
    if([_entityType isEqualToString:@"ExistingDiagnosis"])
    {
        return YES;
    }
    else {
        return NO;
    }
}

@end
