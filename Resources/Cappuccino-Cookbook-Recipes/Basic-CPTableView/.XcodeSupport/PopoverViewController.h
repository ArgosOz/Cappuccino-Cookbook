#import <Cocoa/Cocoa.h>
#import "xcc_general_include.h"

@interface PopoverViewController : NSViewController

@property (assign) IBOutlet NSTableView* _tableView;
@property (assign) IBOutlet NSTextField* _dummyLabel;
@property (assign) IBOutlet NSView* _codeView;
@property (assign) IBOutlet NSTableCellView* _tableCellViewForText;

- (IBAction)closePopover:(id)sender;
- (IBAction)copyTheCode:(id)sender;

@end

@interface RowModel : NSObject
@end
