//
//  MSTimeStampedValue.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 2/12/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import "MSValue.h"

@implementation MSValue
@synthesize timeStamp, value, value2, unit;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSString *)description
{
    if (value2 != nil) {
        __autoreleasing NSString *result = [NSString stringWithFormat:@"%@/%@", value, value2];
        return result;
    }
    else {
        return value;
    }
}

@end
