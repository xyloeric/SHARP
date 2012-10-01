//
//  EntityTypeHelpers.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 2/27/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntityTypeHelpers : NSObject

+(BOOL) entityHasNumVal:(NSString *)_entityType;
+(BOOL) entityHasCatVal:(NSString *)_entityType;
+(BOOL) entityHasRawVal:(NSString *)_entityType;
+(BOOL) entityIsTrigger:(NSString *)_entityType;
+(BOOL) entityIsExistingDiagnosis:(NSString *)_entityType;

@end
