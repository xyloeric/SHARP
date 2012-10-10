//
//  DLDetailedGraphViewController.h
//  Shoji
//
//  Created by Zhe Li on 4/2/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSEntity;
@class DLDetailedGraphView;
@interface DLDetailedGraphViewController : UIViewController
{
    MSEntity *entity;
}

@property (weak, nonatomic) IBOutlet DLDetailedGraphView *detailedGraphView;
@property (strong, nonatomic) MSEntity *entity;

- (void) prepareDataRendererWithEntityData:(MSEntity *)_entity;

@end
