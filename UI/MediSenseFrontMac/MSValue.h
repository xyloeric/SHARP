//
//  MSTimeStampedValue.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 2/12/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSValue : NSObject
{
    NSDate *timeStamp;
    NSString *value;
    NSString *value2;
    NSString *unit;
}

@property (strong) NSDate *timeStamp;
@property (strong) NSString *value, *value2, *unit;

@end
