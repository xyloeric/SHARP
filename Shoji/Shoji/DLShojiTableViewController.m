//
//  DLShojiTableViewController.m
//  Shoji
//
//  Created by Zhe Li on 3/2/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import "DLShojiTableViewController.h"
#import "TouchXML.h"
#import "UIView+DLShojiSupport.h"
#import "DLShojiNavController.h"
#import "SparklineCell.h"
#import "MSEntity.h"
#import "EntityTypeHelpers.h"
#import "TraceCoordinator.h"
#import <QuartzCore/QuartzCore.h>

#define HOST @"139.52.67.249"

@implementation DLShojiTableViewController
@synthesize queryResultData;
@synthesize queryConnection;
@synthesize entities;
@synthesize indicator;
@synthesize term;
@synthesize pId;
@synthesize parentEntity;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTerm:(NSString *)_term andPatientID:(NSString *)_pId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.term = _term;
        self.pId = _pId;
        self.queryResultData = [[NSMutableData alloc] init];
        
        self.tableView.layer.borderColor = [[UIColor darkGrayColor] CGColor];        
        self.tableView.layer.borderWidth = 1.0;
        self.tableView.layer.cornerRadius = 10.0;
        self.tableView.layer.masksToBounds = YES;
        
    }
    
    return self;
}

- (id)initWithEntity:(MSEntity *)_entity andPatientID:(NSString *)_pId
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.parentEntity = _entity;
        self.term = parentEntity.entityURI;
        self.pId = _pId;
        self.queryResultData = [[NSMutableData alloc] init];
        
        self.tableView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        self.tableView.layer.masksToBounds = YES;
        self.tableView.layer.borderWidth = 1.0;
        self.tableView.layer.cornerRadius = 10.0;

    }
    
    return self;
}

- (void)dealloc
{
    TraceCoordinator *coordinator = [TraceCoordinator defaultTraceCoordinator];
    for (id key in [entities allKeys]) {
        NSArray *relaArray = [entities objectForKey:key];
        [coordinator.displayedEntities removeObjectsInArray:relaArray];
    }
    [coordinator.tappedEntities removeObject:parentEntity];
    
    [queryConnection cancel];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self queryListWithTerm:term andPatientID:pId];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
}


#pragma mark - Connect and parse
- (void)queryListWithTerm:(NSString *)_term andPatientID:(NSString *)_pId
{
    //initiate the query
    @autoreleasepool {
        
        NSString *urlString = [NSString stringWithFormat:@"http://%@:8000/pke/rest/kb/mimic/test/%@/%@", HOST, _pId, _term];
        //NSURL *url = [NSURL URLWithString:urlString];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:8000/CachingProxyServer/CachingServer", HOST]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10];
        NSData *queryURLData = [urlString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *postLength = [NSString stringWithFormat:@"%d", [queryURLData length]];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:queryURLData];
        
        self.queryConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        [queryConnection start];
        
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:indicator];
        
        indicator.frame = CGRectMake((self.view.frame.size.width - 37)/2, (self.view.frame.size.height - 37)/2, 37, 37);
        
        [indicator startAnimating];
    }
}

- (void)parseQueryResult:(NSData *)_queryResult
{
    @autoreleasepool {
        NSError *error = nil;
        CXMLDocument *xmlDoc = [[CXMLDocument alloc] initWithData:_queryResult options:CXMLDocumentTidyHTML error:&error];
        NSArray *relationshipNodes = [xmlDoc nodesForXPath:@"//relationship" error:&error];
        
        NSMutableDictionary *tempEntities = [NSMutableDictionary dictionary];
        
        [relationshipNodes enumerateObjectsUsingBlock:^(CXMLElement *relationshipNode, NSUInteger idx, BOOL *stop) {
            NSError *err;
            
            NSString *relaType = [[relationshipNode attributeForName:@"relationshipType"] stringValue];
            NSMutableArray *conceptsOfType = [NSMutableArray array];
            NSArray *conceptNodes = [relationshipNode nodesForXPath:@"./concept" error:&err];
            
            [conceptNodes enumerateObjectsUsingBlock:^(CXMLElement *conceptNode, NSUInteger idx, BOOL *stop) {
                //NSError * er;
                //NSString *conceptDescription = [[[[conceptNode nodeForXPath:@"./conceptURI" error:&er] stringValue] componentsSeparatedByString:@"#"] objectAtIndex:1];
                NSString *conceptDescription = [[conceptNode attributeForName:@"description"] stringValue];
                
                if (![self conceptAlreadyOnTrace:conceptDescription]) {
                    MSEntity *newEntity = [self createEntityFromXMLNode:conceptNode];
                    
                    [conceptsOfType addObject:newEntity];
                    
                    TraceCoordinator *coordinator = [TraceCoordinator defaultTraceCoordinator];
                    [coordinator.displayedEntities addObject:newEntity];
                }
                
            }];
            
            [tempEntities setObject:conceptsOfType forKey:relaType];
            
        }];
        
        self.entities = tempEntities;
        
        [self.tableView reloadData];
        
    }
}

- (BOOL) conceptAlreadyOnTrace:(NSString *)_conceptDescription
{
    TraceCoordinator *coordinator = [TraceCoordinator defaultTraceCoordinator];
    
    __block BOOL result = NO;
    
    [coordinator.tappedEntities enumerateObjectsUsingBlock:^(MSEntity *entity, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@, %@", entity.title, _conceptDescription);
        if ([entity.title isEqualToString:_conceptDescription]) {
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

- (MSEntity *)createEntityFromXMLNode:(CXMLElement *)_xmlNode
{
    
    NSError * error;
    NSString *conceptDescription = [[_xmlNode attributeForName:@"description"] stringValue];
    
    CXMLNode *conceptTypeURINode = [_xmlNode nodeForXPath:@"./conceptType" error:&error];
    CXMLNode *conceptURINode = [_xmlNode nodeForXPath:@"./conceptURI" error:&error];
    CXMLNode *conceptCodingSystemNode = [_xmlNode nodeForXPath:@"./codingSystem" error:&error];
    CXMLNode *conceptCodeNode = [_xmlNode nodeForXPath:@"./code" error:&error];
    
    NSString *conceptTypeURI = [self trimURIString:[conceptTypeURINode stringValue]];
    NSString *conceptURI = [self trimURIString:[conceptURINode stringValue]];
    NSString *conceptCodingSystem = [conceptCodingSystemNode stringValue];
    NSString *conceptCode = [conceptCodeNode stringValue];
    
    __autoreleasing MSEntity *newEntity = [[MSEntity alloc] init];
    newEntity.pid = pId;
    newEntity.entityCodingSystem = conceptCodingSystem;
    newEntity.entityCode = conceptCode;
    newEntity.entityURI = conceptURI;
    newEntity.title = conceptDescription;
    newEntity.entityType = conceptTypeURI;
    
    return newEntity;
}

- (NSString *)trimURIString:(NSString *)_string
{
    return [[_string componentsSeparatedByString:@"#"] objectAtIndex:1];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[entities allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[entities objectForKey:[[entities allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *conceptOfRela = [entities objectForKey:[[entities allKeys] objectAtIndex:indexPath.section]];
    MSEntity *entity = [conceptOfRela objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier;
    
    if ([EntityTypeHelpers entityHasNumVal:entity.entityType] && entity.entityCode != nil) {
        CellIdentifier = @"SparklineCell";
    }
    else {
        CellIdentifier = @"Cell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        if ([EntityTypeHelpers entityHasNumVal:entity.entityType] && entity.entityCode != nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SparklineCell" owner:nil options:nil];
            for(id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[SparklineCell class]])
                {
                    cell = (SparklineCell *)currentObject;
                    break;
                }
            }
        }
        
        else {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    
    if ([EntityTypeHelpers entityHasNumVal:entity.entityType] && entity.entityCode != nil) {
        ((SparklineCell *)cell).inputEntity = entity;
        entity.visualizationCell = (SparklineCell *)cell;
    }
    else {
        cell.textLabel.text = entity.title;
    }
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *conceptOfRela = [entities objectForKey:[[entities allKeys] objectAtIndex:indexPath.section]];
    MSEntity *entity = [conceptOfRela objectAtIndex:indexPath.row];
    if ([EntityTypeHelpers entityHasNumVal:entity.entityType] && entity.entityCode != nil) {
        return 150;
    }
    else {
        return 50;
    }
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
    NSArray *conceptOfRela = [entities objectForKey:[[entities allKeys] objectAtIndex:indexPath.section]];
    MSEntity *entity = [conceptOfRela objectAtIndex:indexPath.row];
    DLShojiTableViewController *nextViewController =[[DLShojiTableViewController alloc] initWithEntity:entity andPatientID:pId];
    
    TraceCoordinator *coordinator = [TraceCoordinator defaultTraceCoordinator];
    [coordinator.tappedEntities addObject:entity];
    
    DLShojiNavController *navController = [self.view navController];
    [navController pushViewController:nextViewController fromParent:self];
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
