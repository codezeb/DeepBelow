//
//  dbAppDelegate.m
//  DeepBelow
//
//  Created by digitalforest on 04.01.14.
//

// thanks to ScriptingBridge, we can communicate with iTunes.
// https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ScriptingBridgeConcepts/UsingScriptingBridge/UsingScriptingBridge.html
#import "iTunes.h"
#import "dbAppDelegate.h"


// default values, will be overwritten by -(void)plistIn
float   ALPHA =     0.7;    // %, 0.0MIN 1.0MAX
int     SIZE  =     300;    // px, default 300
int     SPACING =   50;     // px, default 50
int     POSITIONX = LEFT;   // LEFT CENTER RIGHT
int     POSITIONY = BOTTOM; // TOP CENTER BOTTOM



@implementation dbAppDelegate

@synthesize cover = _cover;
@synthesize window = _window;
@synthesize information = _information;

iTunesApplication* iTunes; // Holds the link to iTunes
NSImage *coverATM;         // Holds the cover. ATM = At The Moment
NSRect winframe;
NSString *infoTextString;  // Holds the bottom info text ("Artist: Title Album")

-(void)plistIn {
    NSMutableDictionary *settingsPlist = [NSMutableDictionary dictionaryWithContentsOfFile:SETTINGSFILE];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:SETTINGSFILE]) {
        ALPHA     = [[settingsPlist valueForKey:@"alpha"]     floatValue];
        SIZE      = [[settingsPlist valueForKey:@"size"]      intValue];
        SPACING   = [[settingsPlist valueForKey:@"spacing"]   intValue];
        POSITIONX = [[settingsPlist valueForKey:@"horizontal"]intValue];
        POSITIONY = [[settingsPlist valueForKey:@"vertical"]  intValue];
    } else {
        [self plistOut];
    }
    
    NSLog(@"%@",[NSString stringWithFormat:@"Starting DeepBelow, Position (%i|%i), %ipx size, 0.%i  opacity (alpha)",POSITIONX,POSITIONY,SIZE,(int)(ALPHA*10)]);
}
-(void)plistOut {
    // Writes out the default values
    NSMutableDictionary *settingsPlist = [NSMutableDictionary dictionary];
    
    [settingsPlist setObject:[NSNumber numberWithDouble:ALPHA]  forKey:@"alpha"];
    [settingsPlist setObject:[NSNumber numberWithInt:SIZE]      forKey:@"size"];
    [settingsPlist setObject:[NSNumber numberWithInt:SPACING]   forKey:@"spacing"];
    [settingsPlist setObject:[NSNumber numberWithInt:POSITIONX] forKey:@"horizontal"];
    [settingsPlist setObject:[NSNumber numberWithInt:POSITIONY] forKey:@"vertical"];
    
    [settingsPlist writeToFile:SETTINGSFILE atomically:NO];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // init code.
    
    [_window setAlphaValue:0]; // Hide it so the window doesn't "flash".
    
    [self plistIn];
    NSPoint placement; // window placement, based on POSITIONX and POSITIONY
    
    [_window setStyleMask:NSBorderlessWindowMask];
    [_window setLevel:kCGDesktopWindowLevel - 1];
    
    switch(POSITIONX) {
        case LEFT:
        default:
            placement.x = SPACING;
            break;
        case CENTER:
            placement.x = SCREENSIZE.width/2 - SIZE/2;
            break;
        case RIGHT:
            placement.x = SCREENSIZE.width - SIZE - SPACING;
            break;
    }
    switch(POSITIONY) {
        case TOP:
        default:
            placement.y = SCREENSIZE.height - SIZE - SPACING;
            break;
        case CENTER:
            placement.y = SCREENSIZE.height/2 - SIZE/2;
            break;
        case BOTTOM:
            placement.y = SPACING;
            break;
    }
    [_window setFrameOrigin:placement];
    
    winframe = [_window frame];
    winframe.size.width  = SIZE;
    winframe.size.height = SIZE;
    [_window setFrame:winframe display:YES];
    
    //[[NSTimer scheduledTimerWithTimeInterval: 0.25 target:self
    //selector:[@selector(coverLoop:) userInfo:nil repeats:YES] fire];
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(coverLoop:) name:@"com.apple.iTunes.playerInfo" object:nil];
    [_window setAlphaValue:ALPHA];
    
    [self coverLoop:nil];
}

-(void)coverLoop:(NSNotification *)notific {
    iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    
    if([iTunes isRunning] && [iTunes playerState] == iTunesEPlSPlaying) {
        // Song is running.
        // Set alpha value if it was set to zero.
        [_window setAlphaValue:ALPHA];
        
        // Load the cover image.
        coverATM = [[[NSImage alloc] initWithData:[(iTunesArtwork *)[[[[iTunes currentTrack] artworks] get] lastObject] rawData]]autorelease];
        [coverATM setSize:_window.frame.size]; // size like the window
        [_cover setImage:coverATM];
        
        // Build up the information string:
        infoTextString = [[iTunes currentTrack]artist];
        infoTextString = [infoTextString stringByAppendingString:@":\n\""];
        infoTextString = [infoTextString stringByAppendingString:[[iTunes currentTrack]name]];
        infoTextString = [infoTextString stringByAppendingString:@"\"\n"];
        infoTextString = [infoTextString stringByAppendingString:[[iTunes currentTrack]album]];
        [_information setStringValue:infoTextString]; // Set the information string.

    } else {
        // Hide it if not used.
        [_window setAlphaValue:0];
    }
    iTunes = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end