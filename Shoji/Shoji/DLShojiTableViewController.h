//
//  DLShojiTableViewController.h
//  Shoji
//
//  Created by Zhe Li on 3/2/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSEntity;
@class CXMLElement;

@interface DLShojiTableViewController : UITableViewController <NSURLConnectionDelegate>
{
    NSURLConnection *queryConnection;
    NSMutableData *queryResultData;
    
    NSDictionary *entities;
    
    UIActivityIndicatorView *indicator;
    
    MSEntity *parentEntity;
    NSString *term;
    NSString *pId;
    
}

@property (strong, nonatomic) NSMutableData *queryResultData;
@property (strong, nonatomic) NSURLConnection *queryConnection;
@property (strong, nonatomic) NSDictionary *entities;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@property (strong, nonatomic) MSEntity *parentEntity;
@property (strong, nonatomic) NSString *term;
@property (strong, nonatomic) NSString *pId;

- (id)initWithEntity:(MSEntity *)_entity andPatientID:(NSString *)_pId;
- (id)initWithTerm:(NSString *)_term andPatientID:(NSString *)_pId;

- (void)queryListWithTerm:(NSString *)_term andPatientID:(NSString *)_pId;
- (void)parseQueryResult:(NSData *)_queryResult;

- (MSEntity *)createEntityFromXMLNode:(CXMLElement *)_xmlNode;
- (BOOL) conceptAlreadyOnTrace:(NSString *)_conceptDescription;

- (NSString *)trimURIString:(NSString *)_string;
@end
