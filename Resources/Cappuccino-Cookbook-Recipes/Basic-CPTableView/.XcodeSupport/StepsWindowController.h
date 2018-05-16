#import <Cocoa/Cocoa.h>
#import "xcc_general_include.h"

@interface StepsWindowController : NSWindowController

@property (assign) IBOutlet NSTableView* _tableViewForSteps;
@property (assign) IBOutlet NSTableView* _popoverTableView;
@property (assign) IBOutlet NSPopover* _popover;
@property (assign) IBOutlet NSWindow* _tmpWindow;
@property (assign) IBOutlet NSViewController* _popoverViewController;

@end
