//
//  MSCSMLCoordinator.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 1/1/12.
//  Copyright 2012 Dr.Lulu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DLSlidingNavController;

@interface MSCSMLCoordinator : NSObject
{
    NSMutableDictionary *globalSetting;
    NSView *controlPanelView;
    NSPopUpButton *patientSelectionPopUp;
    
    NSString *currentPatient;
    NSDictionary *allEntities;
    
    DLSlidingNavController *navController;
    
}

@property (strong) NSMutableDictionary *globalSetting;
@property (strong) IBOutlet NSView *controlPanelView;
@property (strong) IBOutlet NSPopUpButton *patientSelectionPopUp;
@property (strong) NSString *currentPatient;
@property (strong) NSDictionary *allEntities;
@property (strong) DLSlidingNavController *navController;

//init the global setting: what type of graph do we expect
- (void)initGlobalSetting;
//get the patient list
- (void)loadPatientList;
//action received when user selected a patient
- (IBAction)patientPopUpSelected:(id)sender;
//load the graph based on input patient ID and the global setting dictionary
- (void) loadGraphForPatient:(NSString *)_patientID andSettings:(NSDictionary *)_settings;

//parse the experimental GA relationship graph generated from vector space
- (void)parseGeneralAssociationGraphForPatientID:(NSString *)_patientID;

- (void)parseStandardCSMLGraphForPatientID:(NSString *)_patientID;
@end
