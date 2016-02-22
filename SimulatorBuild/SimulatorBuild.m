//
//  SimulatorBuild.m
//  SimulatorBuild
//
//  Created by Minal Soni on 22/02/16.
//  Copyright © 2016 Minal Soni. All rights reserved.
//

#import "SimulatorBuild.h"

@interface SimulatorBuild() {
        NSString *buildPath,*destinationPath;
}
@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation SimulatorBuild

+ (instancetype)sharedPlugin {
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti {
    NSMenuItem *simulatorBuildItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (simulatorBuildItem) {
        [[simulatorBuildItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionItem = [[NSMenuItem alloc] initWithTitle:@"Simulator Build" action:@selector(createSimulatorBuild) keyEquivalent:@""];
        [actionItem setTarget:self];
        [[simulatorBuildItem submenu] addItem:actionItem];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createSimulatorBuild {
    NSArray *workspaceWindowControllers = [NSClassFromString(@"IDEWorkspaceWindowController") valueForKey:@"workspaceWindowControllers"];
    id workSpace;
    for (id controller in workspaceWindowControllers) {
        if ([[controller valueForKey:@"window"] isEqual:[NSApp keyWindow]]) {
            workSpace = [controller valueForKey:@"_workspace"];
        }
    }
    destinationPath = [[workSpace valueForKey:@"representingFilePath"] valueForKey:@"_pathString"];
    NSString *derivedPath  = [[[workSpace valueForKey:@"_headerMapFilePath"] valueForKey:@"_parentPath"] valueForKey:@"_pathString"];
    derivedPath = [derivedPath stringByAppendingPathComponent:@"/Build/Products/Debug-iphonesimulator"];
    buildPath  = [self getAppPath:derivedPath];
    NSLog(@"path of application in %@",buildPath);
    if(buildPath) {
        [self copyBuildAtDestination];
    }else {
        [self showNoSimulatorBuildExist];
    }
}

- (NSString *)getAppPath:(NSString *)dirPath {
    BOOL result;
    result = YES;
    NSString *fullPath, *filename;
    NSString *dir =dirPath;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSEnumerator *enumerator = [[fm contentsOfDirectoryAtPath:dir error:nil] objectEnumerator];
    while(filename=[enumerator nextObject]){
        if ([filename hasPrefix:@"."]) { continue;}
        fullPath = [dir stringByAppendingPathComponent:filename];
        if([[filename pathExtension] isEqualToString:@"app"]) {
            return fullPath;
        }
    }
    return fullPath;
}

-(void)showNoSimulatorBuildExist {
    [self showAlertWithMessage:@"There is no simulator build exist.Please build with simulator once again."];
}

-(void)copyBuildAtDestination {
    destinationPath = [[destinationPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SimulatorBuild"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    if (![fm createDirectoryAtPath:destinationPath
       withIntermediateDirectories:NO
                        attributes:nil
                             error:&error]) {
        [self showAlertWithMessage:[NSString stringWithFormat:@"Hey there is error %@",[error localizedDescription]]];
    } else {
        NSError *fileCopyError;
        if([fm isReadableFileAtPath:buildPath]) {
            destinationPath = [destinationPath stringByAppendingPathComponent:[buildPath lastPathComponent]];
            [fm copyItemAtPath:buildPath toPath:destinationPath error:&fileCopyError];
            if(fileCopyError) {
                [self showAlertWithMessage:[NSString stringWithFormat:@"Hey there is error %@",[fileCopyError localizedDescription]]];
            }else {
                [self openFolderOfBuild];
              //  [self showAlertWithMessage:[NSString stringWithFormat:@"Congratulation!!\n Simulator build created at %@",[path stringByDeletingLastPathComponent]]];
            }
        }
    }
}

- (void)showAlertWithMessage:(NSString *)alertMessage {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:alertMessage];
    [alert runModal];
}

- (void)openFolderOfBuild {
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:destinationPath];
    NSArray *fileURLs = [NSArray arrayWithObjects:fileURL, nil];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLs];
}
@end
