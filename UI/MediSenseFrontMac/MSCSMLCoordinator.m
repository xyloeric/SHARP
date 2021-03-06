//
//  MSCSMLCoordinator.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/1/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import "MSCSMLCoordinator.h"
#import "MSEntity.h"
#import "DLSlidingNavController.h"
#import "MSTableViewController.h"
#import "MSValue.h"
#import "MSDataWrapper.h"

#define HOST @"139.52.149.163"

@implementation MSCSMLCoordinator

@synthesize globalSetting;
@synthesize controlPanelView;
@synthesize patientSelectionPopUp;
@synthesize currentPatient;
@synthesize allEntities;
@synthesize navController;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    [patientSelectionPopUp addItemWithTitle:@"Select a Patient"];
    [self loadPatientList];
    [self initGlobalSetting];
}

- (void)initGlobalSetting
{
    globalSetting = [[NSMutableDictionary alloc] init];
    [globalSetting setObject:@"CSML" forKey:@"mode"];
}

- (void)loadPatientList
{
    @autoreleasepool {
        
        NSError *error = nil;
        NSURL *documentURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://139.52.149.163:8000/pke/rest/kb/patientlist"]];
        //NSURL *documentURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://127.0.0.1:9527/patients"]];
        NSXMLDocument *patientListDocument = [[NSXMLDocument alloc] initWithContentsOfURL:documentURL options:NSXMLDocumentTidyXML error:&error];
        NSArray *patientsArray = [patientListDocument nodesForXPath:@".//patient" error:&error];
        [patientsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *patientID = [(NSXMLNode *)obj stringValue];
            
            [patientSelectionPopUp addItemWithTitle:patientID];
        }];
        
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        
    }
}


- (IBAction)patientPopUpSelected:(id)sender
{
    NSString *_title = [[sender selectedItem] title];
    if ([_title integerValue] != 0) {
        [self loadGraphForPatient:[[sender selectedItem] title] andSettings:globalSetting];
        
    }
}


- (void) loadGraphForPatient:(NSString *)_patientID andSettings:(NSDictionary *)_settings
{
    
    if ([[_settings objectForKey:@"mode"] isEqualToString:@"Predication"]) {
        
    }
    else if ([[_settings objectForKey:@"mode"] isEqualToString:@"General"]) {
        [self parseGeneralAssociationGraphForPatientID:_patientID];
    }
    else if ([[_settings objectForKey:@"mode"] isEqualToString:@"CSML"]) {
        [self parseStandardCSMLGraphForPatientID:_patientID];
    }
    
}

- (void)parseGeneralAssociationGraphForPatientID:(NSString *)_patientID
{
    NSMutableDictionary *entities = [[NSMutableDictionary alloc] init];
    NSError * error;
    
    NSURL *graphURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:9999/graphml_ga/patient/%@?%@", HOST, _patientID, @"0.65"]];
    
    NSXMLDocument *graphMLDocument = [[NSXMLDocument alloc] initWithContentsOfURL:graphURL options:NSXMLDocumentTidyXML error:&error];
    
    NSArray *nodeNodes = [graphMLDocument nodesForXPath:@".//node" error:&error];
    [nodeNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSXMLElement *_nodeElement = (NSXMLElement *)obj;
        
        NSXMLNode *_idAttributeNode = [_nodeElement attributeForName:@"id"];
        NSString *_id = [_idAttributeNode stringValue];
        
        NSXMLNode *_dataNode = [_nodeElement childAtIndex:0];
        NSString *_dataString = [_dataNode stringValue];
        
        MSEntity *newEntity = [[MSEntity alloc] initWithIndex:[_id intValue] andTitle:_dataString];
        newEntity.pid = _patientID;
        [entities setObject:newEntity forKey:_id];
    }];
    
    self.allEntities = entities;
    
    NSArray *linkNodes = [graphMLDocument nodesForXPath:@".//edge" error:&error];
    [linkNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSXMLElement *_linkElement = (NSXMLElement *)obj;
        NSXMLNode *_sourceAttributeNode = [_linkElement attributeForName:@"source"];
        NSString *_source = [_sourceAttributeNode stringValue];
        
        NSXMLNode *_targetAttributeNode = [_linkElement attributeForName:@"target"];
        NSString *_target = [_targetAttributeNode stringValue];
        
        NSXMLNode *_dataNode = [_linkElement childAtIndex:0];
        NSString *_dataString = [_dataNode stringValue];
        
        MSEntity *sourceEntity = [entities objectForKey:_source];
        MSEntity *targetEntity = [entities objectForKey:_target];
        [sourceEntity addChild:targetEntity withRelaType:_dataString];
        
    }];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    
    MSTableViewController *rootViewController = [[MSTableViewController alloc] initWithEntities:allEntities];
    rootViewController.navController = navController;
    [navController popAllViews];
    [navController pushViewController:rootViewController fromParent:nil];
}

- (void)parseStandardCSMLGraphForPatientID:(NSString *)_patientID
{   
    @autoreleasepool {
        
        //temporary holder for all entities to be generated
        __weak NSMutableDictionary *entities = [NSMutableDictionary dictionary];
        //temporary holder for the "start entities"
        __weak NSMutableDictionary *startEntities = [NSMutableDictionary dictionary];
        NSError *error;
        
        //NSURL *graphURL = [NSURL fileURLWithPath:@"/Users/zli/Desktop/csml7440.xml"];
        //NSURL *graphURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://139.52.67.97:8000/pke/rest/kb/%@",_patientID]];
        NSURL *graphURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://139.52.149.163:8000/pke/rest/kb/mimic/test/%@", _patientID]];
        NSXMLDocument *csmlDocument = [[NSXMLDocument alloc] initWithContentsOfURL:graphURL options:NSXMLDocumentTidyXML error:&error];
        
        NSArray *concepts = [csmlDocument nodesForXPath:@"/csml/concept" error:&error];
        [concepts enumerateObjectsUsingBlock:^(NSXMLElement *xmlElement, NSUInteger idx, BOOL *stop) {
            NSError *err;
            //get the first level elements: id, description
            NSXMLNode *_idAttributeNode = [xmlElement attributeForName:@"id"];
            NSXMLNode *_descriptionNode = [xmlElement attributeForName:@"description"];
            NSString *_id = [_idAttributeNode stringValue];
            NSString *_description = [_descriptionNode stringValue];
            
            //get the concept type
            NSArray *conceptTypeXPResult = [xmlElement nodesForXPath:@"./conceptType" error:&err];
            NSString *_conceptType = nil;
            if ([conceptTypeXPResult count] == 1) {
                NSXMLNode *conceptTypeNode = [conceptTypeXPResult objectAtIndex:0];
                NSString *temp = [conceptTypeNode stringValue];
                //TODO: temporarily handles the conceptTypes marked by URIs
                NSArray *uriHandleArray = [temp componentsSeparatedByString:@"#"];
                if ([uriHandleArray count] > 1) {
                    NSString *cTypeString = [uriHandleArray lastObject];
                    
                    _conceptType = cTypeString;
                }
            }
            
            NSArray *conceptCSXPResult = [xmlElement nodesForXPath:@"./codingSystem" error:&err];
            NSString *_conceptCodingSystem = nil;
            if ([conceptCSXPResult count] > 0) {
                _conceptCodingSystem = [[conceptCSXPResult lastObject] stringValue];
            }
            
            NSArray *conceptCodeXPResult = [xmlElement nodesForXPath:@"./code" error:&err];
            NSString *_conceptCode = nil;
            if ([conceptCodeXPResult count] > 0) {
                _conceptCode = [[conceptCodeXPResult lastObject] stringValue];
            }
            
            MSEntity *newEntity = [[MSEntity alloc] initWithIndex:[_id intValue] codingSystem:_conceptCodingSystem andCode:_conceptCode];
            newEntity.title = _description;
            newEntity.entityType = _conceptType;
            NSLog(@"%@", _conceptType);
            
            //process the data section
            //        NSArray *dataSectionXPResult = [xmlElement nodesForXPath:@"./dataSection" error:&err];
            //        if ([dataSectionXPResult count] == 1) {
            //            //initiate a container to put new data
            //            NSMutableArray *_dataContainer = [NSMutableArray array];
            //            NSString *_dataUnit;
            //            NSXMLNode *dataSectionNode = [dataSectionXPResult objectAtIndex:0];
            //            //get the unit
            //            NSArray *dataUnitXPResult = [dataSectionNode nodesForXPath:@"./dataUnit" error:&err];
            //            if ([dataUnitXPResult count] == 1) {
            //                NSXMLNode *dataUnitNode = [dataUnitXPResult objectAtIndex:0];
            //                _dataUnit = [dataUnitNode stringValue];
            //            }
            //            //get all the data element
            //            NSArray *dataXPResult = [dataSectionNode nodesForXPath:@"./data" error:&err];
            //            
            //            for (int i = 0; i < [dataXPResult count]; i++) {
            //                NSXMLNode *dataElement = [dataXPResult objectAtIndex:i];
            //                NSXMLNode *dataValueNode = [[dataElement nodesForXPath:@"./dataValue" error:&err] lastObject];
            //                NSXMLNode *generateDateNode = [[dataElement nodesForXPath:@"./generateDateTime" error:&err] lastObject];
            //                //get the value
            //                NSString *value = [dataValueNode stringValue];
            //                
            //                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //                [dateFormatter setDateFormat:@"yyyy-MM-dd kk:mm:ss.S zzz"];
            //                //get the date
            //                NSDate *generateDate = [dateFormatter dateFromString:[generateDateNode stringValue]];
            //                dateFormatter = nil;
            //
            //                //initiate the MSValue
            //                MSValue *newValue = [[MSValue alloc] init];
            //                newValue.value = value;
            //                newValue.timeStamp = generateDate;
            //                newValue.unit = _dataUnit;
            //                
            //                [_dataContainer addObject:newValue];
            //                //NSLog(@"%@, %@", value, generateDate);
            //            }
            //            NSSortDescriptor *timeSort = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
            //            NSArray *sortDescriptors = [NSArray arrayWithObject:timeSort];
            //            [_dataContainer sortUsingDescriptors:sortDescriptors];
            //            
            //            MSDataWrapper *dataWrapper = [[MSDataWrapper alloc] initWithdataArray:_dataContainer andUnit:_dataUnit];
            //            newEntity.entityData = dataWrapper;
            //        }
            
            [entities setObject:newEntity forKey:_id];
            
            if ([_conceptType isEqualToString:@"DiagnosticHypothesis"]) {
                [startEntities setObject:newEntity forKey:_id];
            }
            
            //NSLog(@"%@, %@, %@", _id, _description, _conceptType);
            
        }];
        //self.allEntities = entities;
        
        NSArray *relationships = [csmlDocument nodesForXPath:@"/csml/relationship" error:&error];
        [relationships enumerateObjectsUsingBlock:^(NSXMLElement *xmlElement, NSUInteger idx, BOOL *stop) {
            NSError *err;
            
            NSXMLNode *_sourceNode = [[xmlElement nodesForXPath:@"./source" error:&err] lastObject];
            NSString *_source = [_sourceNode stringValue];
            
            NSXMLNode *_targetNode = [[xmlElement nodesForXPath:@"./target" error:&err] lastObject];
            NSString *_target = [_targetNode stringValue];
            
            NSXMLNode *_typeNode = [[xmlElement nodesForXPath:@"./relationshipType" error:&err] lastObject];
            NSString *_typeString = [_typeNode stringValue];
            
            
            MSEntity *sourceEntity = [entities objectForKey:_source];
            MSEntity *targetEntity = [entities objectForKey:_target];
            [sourceEntity addChild:targetEntity withRelaType:_typeString];
            //NSLog(@"%@, %@, %@", sourceEntity, targetEntity, _typeString);
            
        }];
        
        MSTableViewController *rootViewController = [[MSTableViewController alloc] initWithEntities:startEntities];
        rootViewController.navController = navController;
        [navController popAllViews];
        [navController pushViewController:rootViewController fromParent:nil];
    }
}


@end
