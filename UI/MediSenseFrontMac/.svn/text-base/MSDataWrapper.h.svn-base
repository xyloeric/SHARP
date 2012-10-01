//
//  MSDataWrapper.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/9/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSDataWrapper : NSObject <NSURLConnectionDelegate>
{
    NSArray *value;
//    NSArray *value2;
    NSString *unit;
//    NSString *unit2;
    
    NSURLConnection *queryConnection;
}

@property (strong) NSArray *value;
@property (strong) NSString *unit;
@property (strong) NSURLConnection *queryConnection;
@property (strong) NSMutableData *queryResultData;

//init with data
- (id)initWithdataArray:(NSArray *)_data andUnit:(NSString *)_unit;
//init with concept and then retrieve the data value async
- (id)initWithConcept:(NSString *)_concept;
- (void)parseQueryResult:(NSData *)_queryResult;

@end
