//
//  MSDataWrapper.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/9/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import "MSDataWrapper.h"
#import "MSValue.h"
#import "TouchXML.h"

#define HOST @"139.52.67.249"

@implementation MSDataWrapper
@synthesize concept, pId;
@synthesize value, unit;
@synthesize queryConnection;
@synthesize queryResultData;
@synthesize delegate;

- (id)initWithConcept:(NSString *)_concept andPatientID:(NSString *)_pId
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            self.pId = _pId;
            
            NSMutableString *_formattedConcept = [_concept mutableCopy];
            _concept = nil;
            
            [_formattedConcept replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [_formattedConcept length])];
            self.concept = _formattedConcept;
            
        }
        
    }
    
    return self;
}

- (id)initWithdataArray:(NSArray *)_data andUnit:(NSString *)_unit
{
    if (self = [super init]) {
        self.value = _data;
        self.unit = _unit;
    }
    
    return self;
}

- (void)dealloc
{
    [queryConnection cancel];
}

- (void)initiateQueryConnection
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@:8000/smartapp/rest/patients/%@/observations/mimic/%@", HOST, pId, concept];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15.0f];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8000/CachingProxyServer/CachingServer", HOST]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
    NSData *queryURLData = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%d", [queryURLData length]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:queryURLData];

    
    NSURLConnection *_connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    self.queryConnection = _connection;
    
    self.queryResultData = [[NSMutableData alloc] init];
    
    [delegate dataWrapperStartedLoading];
}

- (void)parseQueryResult:(NSData *)_queryResult
{
    @autoreleasepool {
        
        
        NSError *error;
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:_queryResult options:CXMLDocumentTidyXML error:&error];
        NSArray *valueQueryResults = [document nodesForXPath:@"//observation-info" error:&error];
        
        NSMutableArray *values = [NSMutableArray array];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [valueQueryResults enumerateObjectsUsingBlock:^(CXMLElement *node, NSUInteger idx, BOOL *stop) {
            NSError *err;
            MSValue *newValue = [[MSValue alloc] init];
            
            CXMLNode *dateAttribute = [node attributeForName:@"date-time"];
            NSString *dateString = [dateAttribute stringValue];
            NSDate *date = [dateFormatter dateFromString:dateString];
            newValue.timeStamp = date;
            
            NSArray *unitXPResult = [node nodesForXPath:@"./obs-unit" error:&err];
            CXMLNode *unitNode;
            if ([unitXPResult count] > 0) {
                unitNode = [unitXPResult lastObject];
                newValue.unit = [unitNode stringValue];
            }
            
            NSArray *valueXPResult = [node nodesForXPath:@"./value" error:&err];
            CXMLNode *value1Node;
            if ([valueXPResult count] > 0) {
                value1Node = [valueXPResult lastObject];
                newValue.value = [value1Node stringValue];
            }
            
            NSArray *value2XPResult = [node nodesForXPath:@"./value2" error:&err];
            CXMLNode *value2Node;
            if ([value2XPResult count] > 0) {
                value2Node = [value2XPResult lastObject];
                newValue.value2 = [value2Node stringValue];
            }
            
            [values addObject:newValue];
        }];
        
        NSArray *sortedValues = [values sortedArrayUsingComparator:^NSComparisonResult(MSValue *obj1, MSValue *obj2) {
            if ([obj1.timeStamp timeIntervalSinceDate:obj2.timeStamp] > 0) {
                return NSOrderedDescending;
            }
            else if([obj1.timeStamp timeIntervalSinceDate:obj2.timeStamp] < 0) {
                return NSOrderedAscending;
            }
            else {
                return NSOrderedSame;
            }
        }];
        
        self.value = sortedValues;
        
        [delegate dataWrapperFinishedLoading];
    }
}
//- (void)parseQueryResult:(NSData *)_queryResult
//{
//    NSError *error;
//    NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:_queryResult options:NSXMLDocumentTidyXML error:&error];
//    NSXMLNode *v1Node = [[document nodesForXPath:@".//v1" error:&error] objectAtIndex:0];
//    NSXMLNode *v2Node = nil;
//    NSArray *v2Nodes = [document nodesForXPath:@".//v2" error:&error];
//    if ([v2Nodes count] > 0) {
//        v2Node = [v2Nodes objectAtIndex:0];
//    }
//    
//    NSArray *v1Units = v1Node.children;
//    NSMutableArray *_v1Parsed = [[NSMutableArray alloc] init];
//    __block NSString *unit;
//    [v1Units enumerateObjectsUsingBlock:^(NSXMLElement * obj, NSUInteger idx, BOOL *stop) {
//        [_v1Parsed removeAllObjects];
//        unit = [[obj attributeForName:@"description"] stringValue];
//        NSArray *values = [obj children];
//        [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSString *_v = [(NSXMLNode *)obj stringValue];
//            [_v1Parsed addObject:_v];
//        }];
//        
//        if (![unit isEqualToString:@"N/A"]) {
//            *stop = YES;
//        }
//    }];
//        
//    self.value1 = _v1Parsed;
//    self.unit1 = unit;
//    
//    if (v2Node != nil) {
//        NSArray *v2Units = v2Node.children;
//        NSMutableArray *_v2Parsed = [[NSMutableArray alloc] init];
//        
//        [v2Units enumerateObjectsUsingBlock:^(NSXMLElement * obj, NSUInteger idx, BOOL *stop) {
//            if ([[[obj attributeForName:@"description"] stringValue] isEqualToString:unit]) {
//                NSArray *values = [obj children];
//                [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    NSString *_v = [(NSXMLNode *)obj stringValue];
//                    [_v2Parsed addObject:_v];
//                }];
//
//            }
//        }];
//        
//        self.value2 = _v2Parsed;
//        self.unit2 = unit;
//    }
//    
//}

#pragma mark -
#pragma mark NSURLConnection Delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == self.queryConnection) {
        [queryResultData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == self.queryConnection) {
        [queryResultData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"failed: %@", [error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connection: %@", connection);
    if (connection == self.queryConnection) {
        [self parseQueryResult:queryResultData];
    }
}

@end
