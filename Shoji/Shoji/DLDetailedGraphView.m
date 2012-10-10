//
//  DLDetailedGraphView.m
//  Shoji
//
//  Created by Zhe Li on 4/2/12.
//  Copyright (c) 2012 Dr.Lulu. All rights reserved.
//

#import "DLDetailedGraphView.h"

@implementation DLDetailedGraphView
@synthesize templateString;
@synthesize currentSettingDict;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)renderDataDescriptors:(NSDictionary *)_descriptorDict
{
    @autoreleasepool {        
        
        NSError *error = nil;
        self.currentSettingDict = _descriptorDict;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];

        self.templateString = [NSMutableString stringWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"template.htm"] encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"%@", templateString);
        
        NSArray *nameArray = [_descriptorDict objectForKey:@"names"];
        NSMutableString *namesString = [[NSMutableString alloc] init];
        for (int i = 0; i < [nameArray count]-1; i++) {
            [namesString appendFormat:@"'%@',", [nameArray objectAtIndex:i]];
        }
        [namesString appendFormat:@"'%@'", [nameArray lastObject]];
        
        NSString *unitString = [NSString stringWithFormat:@"'%@'", [_descriptorDict objectForKey:@"unit"]];
        
        NSString *widthString = [NSString stringWithFormat:@"%f", self.frame.size.width-20];
        
        NSString *heightString = [NSString stringWithFormat:@"%f", self.frame.size.height-20];
        
        NSLog(@"%@, %@", widthString, heightString);
        
        [templateString replaceOccurrencesOfString:@"%names%" withString:namesString options:NSCaseInsensitiveSearch range:NSMakeRange(0, [templateString length])];
        
        [templateString replaceOccurrencesOfString:@"%unit%" withString:unitString options:NSCaseInsensitiveSearch range:NSMakeRange(0, [templateString length])];
        
        [templateString replaceOccurrencesOfString:@"%width%" withString:widthString options:NSCaseInsensitiveSearch range:NSMakeRange(0, [templateString length])];
        
        [templateString replaceOccurrencesOfString:@"%height%" withString:heightString options:NSCaseInsensitiveSearch range:NSMakeRange(0, [templateString length])];
        
        NSURL *baseURL = [NSURL fileURLWithPath:documentsDirectory];
        
        [self loadHTMLString:templateString baseURL:baseURL];
    }
    
}


@end
