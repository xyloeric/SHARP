//
//  PatientSelectionTableViewController.m
//  Shoji
//
//  Created by Zhe Li on 3/24/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import "PatientSelectionTableViewController.h"
#import "TouchXML.h"

@interface PatientSelectionTableViewController ()

@end

@implementation PatientSelectionTableViewController
@synthesize delegate;
@synthesize patientIDs;
@synthesize queryConnection;
@synthesize queryResultData;
@synthesize indicator;

- (id)initWithDelegate:(id<PatientSelectionTableViewControllerDelegate>)_delegate
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        @autoreleasepool {
            self.delegate = _delegate;
            
            self.queryResultData = [[NSMutableData alloc] init];
            
        }
    }
    return self;
}

- (void)dealloc
{
    if (queryConnection) {
        [queryConnection cancel];
    }
}

- (void)parseQueryResult:(NSData *)_queryResult
{
    @autoreleasepool {
        NSError *error = nil;
        CXMLDocument *xmlDoc = [[CXMLDocument alloc] initWithData:_queryResult options:CXMLDocumentTidyHTML error:&error];
        NSArray *patientIDNodes = [xmlDoc nodesForXPath:@"//patient" error:&error];
        NSMutableArray *result = [NSMutableArray array];
        [patientIDNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *patientID = [(CXMLNode *)obj stringValue];
            [result addObject:patientID];
        }];
        self.patientIDs = result;
        
        patientIDs = [patientIDs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            int obj1v = [obj1 intValue];
            int obj2v = [obj2 intValue];
            if (obj1v == obj2v) {
                return NSOrderedSame;
            }
            else if (obj1v > obj2v)
            {
                return NSOrderedDescending;
            }
            else {
                return NSOrderedAscending;
            }
        }];
                
        [self.tableView reloadData];
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSURL *documentURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://139.52.67.249:8000/pke/rest/kb/patientlist"]];   
    NSURLRequest *request = [NSURLRequest requestWithURL:documentURL];
    self.queryConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [queryConnection start];
    
    self.contentSizeForViewInPopover = CGSizeMake(350.0f, 200.0f);
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:indicator];
    NSLog(@"%@ %f %f %f %f", self.view.superview, self.view.superview.bounds.origin.x, self.view.superview.bounds.origin.y, self.view.superview.bounds.size.width, self.view.superview.bounds.size.height);
    
    indicator.frame = CGRectMake((self.contentSizeForViewInPopover.width - 37)/2, (self.contentSizeForViewInPopover.height - 37)/2, 37, 37);
    
    [indicator startAnimating];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [patientIDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *pid = [patientIDs objectAtIndex:indexPath.row];
    cell.textLabel.text = pid;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSString *pid = [patientIDs objectAtIndex:indexPath.row];
    [delegate selectedPatient:pid];
}

#pragma mark - Connection delegate
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
    if (connection == self.queryConnection) {
        [self parseQueryResult:queryResultData];
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
        self.indicator = nil;
    }
}


@end
