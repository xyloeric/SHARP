//
//  DLDetailedGraphView.h
//  Shoji
//
//  Created by Zhe Li on 4/2/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLDetailedGraphView : UIWebView
{
    NSMutableString * templateString;
    NSDictionary * currentSettingDict;
}

@property (nonatomic, retain) NSMutableString * templateString;
@property (nonatomic, retain) NSDictionary * currentSettingDict;

- (void)renderDataDescriptors:(NSDictionary *)_descriptorDict;

@end
