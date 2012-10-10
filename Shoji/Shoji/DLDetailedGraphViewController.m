//
//  DLDetailedGraphViewController.m
//  Shoji
//
//  Created by Zhe Li on 4/2/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import "DLDetailedGraphViewController.h"
#import "DLDetailedGraphView.h"
#import "MSEntity.h"
#import "MSValue.h"
#import "MSDataWrapper.h"

@interface DLDetailedGraphViewController ()

@end

@implementation DLDetailedGraphViewController
@synthesize detailedGraphView;
@synthesize entity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareDataRendererWithEntityData:self.entity];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setDetailedGraphView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void) prepareDataRendererWithEntityData:(MSEntity *)_entity
{
    @autoreleasepool {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        NSLocale *l_en = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setLocale: l_en];
        
        MSDataWrapper *dataWrapper = _entity.entityData;
        
        if ([dataWrapper.value count] > 0) {
            NSError *error = nil;
            NSMutableDictionary *renderSettingDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"400", @"width", @"400", @"height", nil];
            NSMutableString *csvString = [NSMutableString string];
            NSMutableString *csvString2 = [NSMutableString string];
            
            BOOL hasValue2 = NO;
            
            NSLog(@"%@, %@", renderSettingDict, _entity);
            
            
            
            for (int i = 0; i < [dataWrapper.value count]; i++) {            
                MSValue *dataValue = [dataWrapper.value objectAtIndex:i];
                    
                NSDate *date = dataValue.timeStamp;
                NSLog(@"%@", date);
                    //NSLog(@"%@, %@", date, [dataDict objectForKey:time]);
                NSString *formattedDateString = [dateFormatter stringFromDate:date];
                
                NSNumber *value1 = [f numberFromString:dataValue.value];
                if (value1) {
                    [csvString appendFormat:@"%@,%@\n", formattedDateString, value1];
                }
                
                if (dataValue.unit) {
                    [renderSettingDict setObject:dataValue.unit forKey:@"unit"];
                }
                
                if (dataValue.value2) {
                    NSNumber *value2 = [f numberFromString:dataValue.value2];
                    if (value2) {
                        [csvString2 appendFormat:@"%@,%@\n", formattedDateString, dataValue.value2];
                        hasValue2 = YES;
                    }
                }
            }
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            if (hasValue2) {
                NSArray *names = [NSArray arrayWithObjects:_entity.title, [NSString stringWithFormat:@"%@2", _entity.title], nil];
                [renderSettingDict setObject:names forKey:@"names"];
                
                NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", _entity.title]];
                [csvString writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error];
                
                NSString *path2 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@2.csv", _entity.title]];
                [csvString2 writeToFile:path2 atomically:NO encoding:NSUTF8StringEncoding error:&error];
            }
            else {
                NSArray *names = [NSArray arrayWithObjects:_entity.title, nil];
                [renderSettingDict setObject:names forKey:@"names"];
                
                NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", _entity.title]];
                NSLog(@"%@", path);
                [csvString writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error];
                
                if (error) {
                    NSLog(@"%@", [error localizedDescription]);
                }
            }
            
//            NSLog(@"%@", csvString);
            
            [detailedGraphView renderDataDescriptors:renderSettingDict];
            
//            NSLog(@"%@", [[NSBundle mainBundle] pathForResource:@"template" ofType:@"htm"]);
//            NSLog(@"%@", [NSString stringWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"WBC.csv"] encoding:NSUTF8StringEncoding error:&error]);
            
        }
    }
    
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

//- (void) renderDataWithGraphRenderer:(NSArray *)_array
//{
//    if ([_array count] > 0) {
//        NSMutableDictionary *renderSettingDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"400", @"width", @"400", @"height", nil];
//        NSMutableString *csvString = [NSMutableString string];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
//        
//        
//        NSError *error = nil;
//        
//        [renderSettingDict setObject:[[_array objectAtIndex:0] valueForKey:@"doseUnit"] forKey:@"unit"];
//        NSArray *names = [NSArray arrayWithObjects:@"MED", nil];
//        [renderSettingDict setObject:names forKey:@"names"];
//        for (int i = 0; i < [_array count] - 1; i++) {
//            NSManagedObject *event = [_array objectAtIndex:i];
//            NSDate *date = [event valueForKey:@"chartTime"];            
//            NSString *formattedDateString = [dateFormatter stringFromDate:date];
//            NSString *dose = [event valueForKey:@"dose"];
//            
//            if ([dose length] > 0) {
//                [csvString appendFormat:@"%@,%@\n", formattedDateString, dose];
//                if (i == [_array count] - 1) {
//                    [csvString appendFormat:@"%@,%@", formattedDateString, dose];
//                }
//            }
//            
//        }
//        
//        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MED.csv"];
//        [csvString writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error];
//        
//        
//        //NSLog(@"%@", renderSettingDict);
//        [(DLDetailedGraphView *)self.view renderDataDescriptors:renderSettingDict];
//    }
//    
//}


@end
