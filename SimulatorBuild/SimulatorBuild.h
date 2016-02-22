//
//  SimulatorBuild.h
//  SimulatorBuild
//
//  Created by Minal Soni on 22/02/16.
//  Copyright © 2016 Minal Soni. All rights reserved.
//

#import <AppKit/AppKit.h>

@class SimulatorBuild;

static SimulatorBuild *sharedPlugin;

@interface SimulatorBuild : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end