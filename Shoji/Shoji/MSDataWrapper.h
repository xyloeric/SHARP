//
//  MSDataWrapper.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/9/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MSDataWrapperDelegate
- (void)dataWrapperStartedLoading;
- (void)dataWrapperFinishedLoading;
@end

@interface MSDataWrapper : NSObject <NSURLConnectionDelegate>
{
    NSString *concept, *pId;
    
    NSArray *value;
//    NSArray *value2;
    NSString *unit;
//    NSString *unit2;
    
    NSURLConnection *queryConnection;
    
    __weak id<MSDataWrapperDelegate> delegate;
}

@property (strong, nonatomic) NSString *concept, *pId;
@property (strong, nonatomic) NSArray *value;
@property (strong, nonatomic) NSString *unit;
@property (strong, nonatomic) NSURLConnection *queryConnection;
@property (strong, nonatomic) NSMutableData *queryResultData;
@property (weak, nonatomic) id<MSDataWrapperDelegate> delegate;

//init with concept and then retrieve the data value async
- (id)initWithConcept:(NSString *)_concept andPatientID:(NSString *)_pId;
//init with data
- (id)initWithdataArray:(NSArray *)_data andUnit:(NSString *)_unit;

- (void)initiateQueryConnection;

- (void)parseQueryResult:(NSData *)_queryResult;

@end
