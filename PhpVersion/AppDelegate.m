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
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    NSString *version = [self refreshVersion];
    
    self.statusBar.menu = self.statusMenu;

    [self updateStatusBarTitle:version];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0f
                                     target:self
                                   selector:@selector(updateStatusBar:)
                                   userInfo:nil
                                    repeats:YES];
}

- (IBAction)php70Clicked:(id)sender {
    [self runPhpSwitcher:@"7.0"];
}

- (IBAction)php71Clicked:(id)sender {
    [self runPhpSwitcher:@"7.1"];
}

- (IBAction)php72Clicked:(id)sender {
    [self runPhpSwitcher:@"7.2"];
}

- (IBAction)php73Clicked:(id)sender {
    [self runPhpSwitcher:@"7.3"];
}

- (void)runPhpSwitcher:(NSString *)version {
    //[NSWorkspace.sharedWorkspace openURL:[NSURL fileURLWithPath:@"/Applications/iTerm.app"]];
}

- (IBAction)quitClicked:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

- (void)updateStatusBar:(NSTimer *)timer {
    @try {
        NSString *version = [self refreshVersion];
        [self updateStatusBarTitle:version];
    }
    @catch (NSException *e) {
        NSLog(@"%@", [e description]);
    }
}

- (void)updateStatusBarTitle:(NSString *)title
{
    NSDictionary *titleAttributes = @{
                                      NSForegroundColorAttributeName: [NSColor alternateSelectedControlColor],
                                      NSFontAttributeName: [NSFont fontWithName:@"Helvetica" size:14.0f],
                                      };
    
    NSAttributedString* blueTitle = [[NSAttributedString alloc] initWithString:title
                                                                    attributes:titleAttributes];
    
    [self.statusBar.button setAttributedTitle:blueTitle];
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

    bool notFound = true;
    int index = 4;
    
    while (notFound) {
        if ([output characterAtIndex:index] == 32) {
            notFound = false;
        }
        index++;
    }
    
    return [output substringWithRange:NSMakeRange(4, index - 4)];
}

@end
