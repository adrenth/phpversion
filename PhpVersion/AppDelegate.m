//
//  AppDelegate.m
//  PhpVersion
//
//  Created by Alwin Drenth on 13/03/2017.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize statusBar = _statusBar;
@synthesize statusMenu = _statusMenu;

- (void) awakeFromNib {
    self.statusBar = [[NSStatusBar systemStatusBar]statusItemWithLength:NSVariableStatusItemLength];
    
    NSString *version = [self refreshVersion];
    self.statusBar.title = version;
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;

    [NSTimer scheduledTimerWithTimeInterval:10.0f
                                     target:self selector:@selector(updateStatusBar:) userInfo:nil repeats:YES];
}

- (IBAction)quitClicked:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

- (void)updateStatusBar:(NSTimer *)timer {
    @try {
        NSString *version = [self refreshVersion];
        self.statusBar.title = version;
    }
    @catch (NSException *e) {
        
    }
}

- (NSString *)refreshVersion {
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    NSTask *task = [[NSTask alloc] init];
    
    task.launchPath = @"/usr/local/bin/php";
    task.arguments = @[@"-v"];
    task.standardOutput = pipe;
    
    [task launch];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return [output substringWithRange:NSMakeRange(4, 3)];
}

@end
