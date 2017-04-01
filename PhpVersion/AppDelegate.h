//
//  AppDelegate.h
//  PhpVersion
//
//  Created by Alwin Drenth on 13/03/2017.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong) IBOutlet NSMenu *statusMenu;
@property (strong) IBOutlet NSStatusItem *statusBar;

- (IBAction)quitClicked:(id)sender;
- (void)updateStatusBar:(NSTimer *)timer;
- (NSString *)refreshVersion;

@end

