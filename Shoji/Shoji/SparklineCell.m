//
//  SparklineCell.m
//  Shoji
//
//  Created by Zhe Li on 3/8/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import "SparklineCell.h"
#import "MSEntity.h"
#import "SparklineView.h"
#import "MSEntity.h"
#import "MSValue.h"
#import "MSDataWrapper.h"
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "DLShojiNavController.h"

#import "DLDetailedGraphViewController.h"

@implementation SparklineCell
@synthesize titleLabel, valueLabel, unitLabel, dateTimeLabel;
@synthesize sparklineView;
@synthesize inputEntity;
@synthesize indicator;
@synthesize alertView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [sparklineView addSubview:indicator];
    [indicator startAnimating];
    
    alertView.layer.cornerRadius = 8.0f;
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
//    tapGestureRecognizer.delegate = self;
//    tapGestureRecognizer.numberOfTapsRequired = 2;
//    tapGestureRecognizer.numberOfTouchesRequired = 1;
//    [self addGestureRecognizer:tapGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchGestureRecognizer.delegate = self;
    //[panGestureRecognizer setCancelsTouchesInView:NO];
    [self addGestureRecognizer:pinchGestureRecognizer];

    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutGraph];
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    DLShojiNavController *navController = appDelegate.slidingNavController;
    
    DLDetailedGraphViewController *vc = [[DLDetailedGraphViewController alloc] initWithNibName:@"DLDetailedGraphViewController" bundle:nil];
    vc.entity = self.inputEntity;
    
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [navController presentModalViewController:vc animated:YES];
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.scale > 1.1f) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        DLShojiNavController *navController = appDelegate.slidingNavController;
        
        DLDetailedGraphViewController *vc = [[DLDetailedGraphViewController alloc] initWithNibName:@"DLDetailedGraphViewController" bundle:nil];
        vc.entity = self.inputEntity;
        
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [navController presentModalViewController:vc animated:YES];
    }
}

- (void)toggleAlert
{
    CABasicAnimation* alertAnimation = (CABasicAnimation *)[self.backgroundView.layer animationForKey:@"selectionAnimation"];

    if (alertAnimation == nil) {
        
        alertAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        alertAnimation.toValue = (id)[UIColor redColor].CGColor;
        alertAnimation.repeatCount = HUGE_VALF;
        alertAnimation.duration = 1.0f;
        alertAnimation.autoreverses = YES;
        
        [alertView.layer addAnimation:alertAnimation forKey:@"selectionAnimation"];
    }    
    else {
        [alertView.layer removeAnimationForKey:@"selectionAnimation"];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInputEntity:(MSEntity *)_inputEntity
{
    inputEntity = _inputEntity;
    self.titleLabel.text = inputEntity.title;
    if ([inputEntity.entityData.value count] > 0) {
        if (indicator) {
            [indicator stopAnimating];
            [indicator removeFromSuperview];
            self.indicator = nil;
        }
        sparklineView.rawData = inputEntity.entityData.value;
        
        MSValue * lastValue = [inputEntity.entityData.value lastObject];
        self.valueLabel.text = [lastValue description];
        self.unitLabel.text = lastValue.unit;
        self.dateTimeLabel.text = [lastValue.timeStamp description];
    }
}


- (void)refreshGraph
{
    if (indicator) {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        self.indicator = nil;
    }
    sparklineView.rawData = inputEntity.entityData.value;
    MSValue * lastValue = [inputEntity.entityData.value lastObject];
    self.valueLabel.text = [lastValue description];
    self.unitLabel.text = lastValue.unit;
    self.dateTimeLabel.text = [lastValue.timeStamp description];
    
}

- (void)relayoutGraph
{
    if (inputEntity.entityData.value != nil) {
        sparklineView.rawData = inputEntity.entityData.value;
        MSValue * lastValue = [inputEntity.entityData.value lastObject];
        self.valueLabel.text = [lastValue description];
        self.unitLabel.text = lastValue.unit;
        self.dateTimeLabel.text = [lastValue.timeStamp description];
    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"%@", event);
//    
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"%@", event);
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    if (touch.tapCount == 2) {
//        
//    }
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"%@", event);
//    
//}

@end
