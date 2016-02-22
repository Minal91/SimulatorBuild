//
//  NSObject_Extension.m
//  SimulatorBuild
//
//  Created by Minal Soni on 22/02/16.
//  Copyright © 2016 Minal Soni. All rights reserved.
//


#import "NSObject_Extension.h"
#import "SimulatorBuild.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[SimulatorBuild alloc] initWithBundle:plugin];
        });
    }
}
@end
