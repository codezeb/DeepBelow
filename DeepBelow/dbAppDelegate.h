//
//  dbAppDelegate.h
//  DeepBelow
//
//  Created by digitalforest on 04.01.14.
//

#import <Cocoa/Cocoa.h>

#define LEFT    1
#define TOP     1
#define CENTER  2
#define RIGHT   3
#define BOTTOM  3

// 1,1 2,1 3,1
// 2,1 2,2 2,3
// 3,1 3,2 3,3


#define SCREENSIZE [[[NSScreen screens] objectAtIndex:0] visibleFrame].size
#define SETTINGSFILE [NSHomeDirectory() stringByAppendingString:@"/Library/Preferences/org.dyndns.digitalforest.DeepBelow.plist"]

@interface dbAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *cover;
@property (assign) IBOutlet NSTextFieldCell *information;

-(void)plistIn;
-(void)plistOut;
-(void)coverLoop:(NSNotification *)notific;

@end
