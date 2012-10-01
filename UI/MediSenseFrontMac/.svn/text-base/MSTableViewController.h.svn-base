//
//  MSTableViewController.h
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/30/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MSTableView;
@class DLSlidingNavController;
@class DLSlidingChildView;
@class MSEntity;

@interface MSTableViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
{
    MSTableView *_tableView;
    NSArray *allEntities;
    NSArray *backwardEntities;
    
    DLSlidingNavController *navController;
    __weak DLSlidingChildView *containerView;
}

@property (strong) NSArray *allEntities, *backwardEntities;
@property (strong) IBOutlet MSTableView *_tableView;
@property (strong) DLSlidingNavController *navController;
@property (weak) DLSlidingChildView *containerView;

- (id)initWithEntities:(NSDictionary *)_entities;
- (id)initWithCategorizedEntities:(NSDictionary *)_entities;
- (id)initWithOriginEntity:(MSEntity *)_entity forwardEntities:(NSDictionary *)_forwardEntities andBackwardEntities:(NSDictionary *)_backwardEntities;

- (IBAction)selectedRow:(id)sender;

- (id)_entityForRow:(NSInteger)row;


- (NSArray *)getEntitiesToDisplayFromOrigin:(MSEntity *)_entity forward:(NSDictionary *)_fEntities andBackward:(NSDictionary *)_bEntities;
- (NSArray *)expandReviewEntity:(MSEntity *)_entity;
- (NSArray *)expandExploreEntity:(MSEntity *)_entity;
- (void)removeDuplicates:(NSMutableArray *)_array;

@end
