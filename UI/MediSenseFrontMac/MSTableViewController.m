//
//  MSTableViewController.m
//  MediSenseFrontMac
//
//  Created by Zhe Li on 12/30/11.
//  Copyright 2011 Dr.Lulu. All rights reserved.
//

#import "MSTableViewController.h"
#import "MSTableView.h"
#import "MSTableCellView.h"
#import "MSEntity.h"
#import "MSDataWrapper.h"
#import "OverviewLine.h"
#import "DLSlidingNavController.h"
#import "EntityTypeHelpers.h"

@implementation MSTableViewController
@synthesize allEntities;
@synthesize backwardEntities;
@synthesize _tableView;
@synthesize navController;
@synthesize containerView;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Initialization code here.
//        [_tableView numberOfRows];
//        self.forwardEntities = [[NSArray alloc] initWithObjects:[NSImage imageNamed:NSImageNameMobileMe], [NSImage imageNamed:NSImageNameUserAccounts], [NSImage imageNamed:NSImageNameColorPanel], [NSImage imageNamed:NSImageNameApplicationIcon], [NSImage imageNamed:NSImageNameFolderSmart], [NSImage imageNamed:NSImageNameFontPanel], nil];
//        
//        [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, forwardEntities.count)] withAnimation:NSTableViewAnimationEffectFade];
//    }
//    
//    return self;
//}

- (id)initWithEntities:(NSDictionary *)_entities
{
    self = [super initWithNibName:@"MSTableViewController" bundle:nil];
    if (self) {
        [_tableView numberOfRows];
        
        NSMutableArray *_entityArray = [NSMutableArray array];
        [_entities enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [_entityArray addObject:obj];
        }];
        
        self.allEntities = _entityArray;
        
        [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, allEntities.count)] withAnimation:NSTableViewAnimationEffectFade];
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_tableView reloadData];
        });
        
    }
    
    return self;
}

- (id)initWithCategorizedEntities:(NSDictionary *)_entities
{
    self = [super initWithNibName:@"MSTableViewController" bundle:nil];
    if (self) {
        //[_tableView numberOfRows];
        
        NSMutableArray *_entityArray = [NSMutableArray array];
        [_entities enumerateKeysAndObjectsUsingBlock:^(id key, NSArray * obj, BOOL *stop) {
            [_entityArray addObject:key];
            [_entityArray addObjectsFromArray:obj];
        }];
        
        self.allEntities = _entityArray;
        
        [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, allEntities.count)] withAnimation:NSTableViewAnimationEffectFade];
        
    }
    
    return self;
}

- (id)initWithOriginEntity:(MSEntity *)_entity forwardEntities:(NSDictionary *)_forwardEntities andBackwardEntities:(NSDictionary *)_backwardEntities
{
    self = [super initWithNibName:@"MSTableViewController" bundle:nil];
    if (self) {
        
        NSArray *entities = [self getEntitiesToDisplayFromOrigin:_entity forward:_forwardEntities andBackward:_backwardEntities];
        self.allEntities = entities;
        
        [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, allEntities.count)] withAnimation:NSTableViewAnimationEffectFade];

    }
    
    return self;
}

- (void)awakeFromNib
{
    
    
}

//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
//{
//    return [entities objectAtIndex:row];
//    
//}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
    if ([[self _entityForRow:row] isKindOfClass:[NSString class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    if ([[self _entityForRow:row] isKindOfClass:[NSString class]]) {
        return 25.0;
    } else {
        return 75.0;
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    id _obj = [allEntities objectAtIndex:row];
    //it is an entity
    if ([_obj isKindOfClass:[MSEntity class]]) {
        MSEntity *receivedEntity = (MSEntity *)_obj;
        
        if ([EntityTypeHelpers entityHasNumVal:receivedEntity.entityType]) {
            MSTableCellView *cellView = [tableView makeViewWithIdentifier:@"SparklineView" owner:self];
            
            cellView.textField.stringValue = receivedEntity.title;
            if ([receivedEntity.entityData.value count] > 0) {
                [cellView.overviewLine setRenderingData:receivedEntity.entityData.value];
                //NSLog(@"%@", [receivedEntity.entityData.value1 lastObject]);
//                cellView.valueLabel.stringValue = [[receivedEntity.entityData.value1 lastObject] valueForKey:@"value"];
//                //cellView.valueLabel.stringValue = [receivedEntity.entityData.value1 lastObject];
//                
//                if (![receivedEntity.entityData.unit1 isEqualToString:@"N/A"]) {
//                    cellView.unitLabel.stringValue = receivedEntity.entityData.unit1;
//                }
            }
            else {
                [cellView.overviewLine setRenderingData:nil];
            }
            
            return cellView;
        }
        else {
            NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"TextView" owner:self];
            cellView.textField.stringValue = receivedEntity.title;
            return cellView;
        }
        
    }
    //it is an label
    else if ([_obj isKindOfClass:[NSString class]]){
        NSString *title = (NSString *)_obj;
        NSTextField *textView = (NSTextField *)[tableView makeViewWithIdentifier:@"TagView" owner:self];
        [textView setStringValue:title];
        
        return textView;
    }
    
    return nil;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [allEntities count];
    
}

//- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
//{
//    return 150.0f;
//}

- (IBAction)selectedRow:(id)sender
{
    //NSLog(@"%i", [((NSTableView *)sender) selectedRow]);
    NSUInteger selectedIndex = [((NSTableView *)sender) selectedRow];
    
    if (selectedIndex < [allEntities count]) {
        MSEntity *selectedEntity = [allEntities objectAtIndex:selectedIndex];
        NSDictionary *childrenEntities = selectedEntity.children;
        NSDictionary *parentEntities = selectedEntity.parents;
        //if ([childrenEntities count] > 0) {
        MSTableViewController *rootViewController = [[MSTableViewController alloc] initWithOriginEntity:selectedEntity forwardEntities:childrenEntities andBackwardEntities:parentEntities];
        rootViewController.navController = navController;
        [navController pushViewController:rootViewController fromParent:self];
        //}
        
    }
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    // Bold the text in the selected items, and unbold non-selected items
    //    [_tableView enumerateAvailableRowViewsUsingBlock:^(NSTableRowView *rowView, NSInteger row) {
    //        // Enumerate all the views, and find the NSTableCellViews. This demo could hard-code things, as it knows that the first cell is always an NSTableCellView, but it is better to have more abstract code that works in more locations.
    //        for (NSInteger column = 0; column < rowView.numberOfColumns; column++) {
    //            NSView *cellView = [rowView viewAtColumn:column];
    //            // Is this an NSTableCellView?
    //            if ([cellView isKindOfClass:[NSTableCellView class]]) {
    //                NSTableCellView *tableCellView = (NSTableCellView *)cellView;
    //                // It is -- grab the text field and bold the font if selected
    //                NSTextField *textField = tableCellView.textField;
    //                NSInteger fontSize = [textField.font pointSize];
    //                if (rowView.selected) {
    //                    textField.font = [NSFont boldSystemFontOfSize:fontSize];
    //                } else {
    //                    textField.font = [NSFont systemFontOfSize:fontSize];
    //                }
    //            }
    //        }
    //    }];
}

- (id)_entityForRow:(NSInteger)row {
    return [allEntities objectAtIndex:row];
}

- (NSArray *)getEntitiesToDisplayFromOrigin:(MSEntity *)_entity forward:(NSDictionary *)_fEntities andBackward:(NSDictionary *)_bEntities;
{
    NSMutableArray *_entityArray = [NSMutableArray array];
    
    [_bEntities enumerateKeysAndObjectsUsingBlock:^(id key, NSArray * entities, BOOL *stop) {

        [_entityArray addObject:[NSString stringWithFormat:@"← %@", key]];
        
        [entities enumerateObjectsUsingBlock:^(MSEntity *entity, NSUInteger idx, BOOL *stop) {
            if ([EntityTypeHelpers entityHasRawVal:entity.entityType]) {
                [_entityArray addObject:entity];
            }
            else {
                NSArray *expandedEntity = [self expandReviewEntity:entity];
                [_entityArray addObjectsFromArray:expandedEntity];
            }
        }];
        
    }];
    
//    [_fEntities enumerateKeysAndObjectsUsingBlock:^(id key, NSArray * entities, BOOL *stop) {
//        [_entityArray addObject:[NSString stringWithFormat:@"→ %@", key]];
//        //[_entityArray addObjectsFromArray:entities];
//        
//        [entities enumerateObjectsUsingBlock:^(MSEntity *entity, NSUInteger idx, BOOL *stop) {
//            //if ([entity.entityType isEqualToString:@"DiagnosticHypothesis"]) {
//            [_entityArray addObject:entity];
//            //}
//            //else {
//            //    NSArray *expandedEntity = [self expandExploreEntity:entity];
//            //    [_entityArray addObjectsFromArray:expandedEntity];
//            //}
//        }];
//    }];
    
    [self removeDuplicates:_entityArray];
    //NSLog(@"%@", _entityArray);
    return _entityArray;
}

- (NSArray *)expandReviewEntity:(MSEntity *)_entity;
{
    NSMutableArray *result = [NSMutableArray array];
    if ([_entity.entityType isEqualToString:@"ObjectiveObservation"]) {
        [_entity.parents enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *entities, BOOL *stop) {
            //[result addObject:key];
            [entities enumerateObjectsUsingBlock:^(MSEntity *obj, NSUInteger idx, BOOL *stop) {
                if (![EntityTypeHelpers entityIsTrigger:obj.entityType]) {
                    [result addObject:obj];
                }
                NSLog(@"add1: %@", obj.title);

            }];

        }];
    }
    else if ([_entity.entityType isEqualToString:@"DiagnosticHypothesis"] || [_entity.entityType isEqualToString:@"ExistingDiagnosis"]) {
        NSLog(@"add2: %@", _entity.title);
        [result addObject:_entity];
    }
    else if ([EntityTypeHelpers entityIsTrigger:_entity.entityType]){
        [result addObject:_entity.title];
        //NSLog(@"%@, %@, %@", _entity.title, _entity.entityType, _entity.children);
        [_entity.children enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *entities, BOOL *stop) {
            if ([key isEqualToString:@"hasAtomicFact"]) {
                [entities enumerateObjectsUsingBlock:^(MSEntity *entity, NSUInteger idx, BOOL *stop) {
                    NSLog(@"%@", entity.title);
                    NSArray *expansion = [self expandReviewEntity:entity];
                    for (MSEntity *e in expansion) {
                        NSLog(@"%@ -->  %@", _entity.title, e.title);
                    }
                    [result addObjectsFromArray:expansion];
                }];
            }
        }];
    }
    
    [self removeDuplicates:result];
    return result;
}

- (NSArray *)expandExploreEntity:(MSEntity *)_entity
{
    NSMutableArray *result = [NSMutableArray array];
    
    if ([_entity.entityType isEqualToString:@"DiagnosticHypothesis"]) {
        [result addObject:_entity];

    }
    else {
        [_entity.children enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *entities, BOOL *stop) {
            [entities enumerateObjectsUsingBlock:^(MSEntity *entity, NSUInteger idx, BOOL *stop) {
                NSArray *expansion = [self expandExploreEntity:entity];
                [result addObjectsFromArray:expansion];
            }];
        }];
    }
    
    [self removeDuplicates:result];
    return result;
}

- (void)removeDuplicates:(NSMutableArray *)_array
{
    NSArray *copy = [_array copy];
    NSInteger index = [copy count] - 1;
    for (id object in [copy reverseObjectEnumerator]) {
        if ([_array indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
            [_array removeObjectAtIndex:index];
        }
        index--;
    }
    copy = nil;
}

@end
