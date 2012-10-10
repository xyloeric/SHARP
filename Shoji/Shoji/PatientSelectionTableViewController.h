//
//  PatientSelectionTableViewController.h
//  Shoji
//
//  Created by Zhe Li on 3/24/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PatientSelectionTableViewControllerDelegate

- (void)selectedPatient:(NSString *)_pid;

@end

@interface PatientSelectionTableViewController : UITableViewController
{
    __weak id<PatientSelectionTableViewControllerDelegate> delegate;
    
    NSArray *patientIDs;
    NSURLConnection *queryConnection;
    NSMutableData *queryResultData;
    
    UIActivityIndicatorView *indicator;
}

@property (weak, nonatomic) id<PatientSelectionTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *patientIDs;
@property (nonatomic, strong) NSURLConnection *queryConnection;
@property (nonatomic, strong) NSMutableData *queryResultData;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

- (id)initWithDelegate:(id<PatientSelectionTableViewControllerDelegate>)_delegate;

@end
