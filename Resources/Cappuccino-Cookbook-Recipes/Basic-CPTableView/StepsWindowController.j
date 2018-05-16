
@import "StepsDataController.j"

@import "PopoverViewController.j"

@implementation StepsWindowController : CPWindowController
{
    @outlet CPTableView             _tableViewForSteps;
    @outlet CPTableView             _popoverTableView;
    @outlet CPPopover               _popover;
    @outlet CPWindow                _tmpWindow;
    @outlet CPViewController        _popoverViewController;
            CPMutableArray          _stepsDataControllerForCurrentRecipe;
            CPMutableArray          _currentSubSteps @accessors(property=currentSubSteps);
            StepsDataController     _stepsDataController;

            PopoverViewController   _popoverSubViewController;
}

- (id) initWithWindow:(CPWindow)window
{
    self = [super initWithWindow:window];
    if(self){
        _stepsDataController = [[StepsDataController alloc] init];
        [_stepsDataController setDelegate:self];

        var notificationCenter = [CPNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(terminatePopover) name:@"PopoverTermination" object:nil];
        

    }

    return self;
}

- (void) windowDidLoad
{
    [super windowDidLoad];        

    _popoverSubViewController = [[PopoverViewController alloc] initWithCibName:@"PopoverView" bundle:nil];
    [[_popoverSubViewController view] setFrameSize:[[_popoverViewController view] frameSize]];
    [[_popoverViewController view] addSubview:[_popoverSubViewController view]];

    /* [[_popoverSubViewController _dummyLabel] setBackgroundColor:[CPColor yellowColor]]; */
    /* [[_tmpWindow contentView] addSubview:[_popoverSubViewController _dummyLabel]]; */
    /* [[_popoverViewController view] setAutoResizingMask:CPViewWidthSizable | CPViewHeightSizable]; */
    
}

- (void) terminatePopover
{
    [_popover close];
    [_tableViewForSteps deselectAll];
}

// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │              StepsDataControllerDelegate              │██
// │                   Protocol methods                    │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████

- (void) mainStepsDidLoad:(CPArray)mainStepsArray
{
    [_tableViewForSteps reloadData];
}

- (void) subStepsDidLoad:(CPArray)subStepsArray subStepsDidChange:(BOOL)subStepsDidChange
{
    [_popoverSubViewController setTableDataArray:subStepsArray];
    [_popoverSubViewController setBaseURL:[_stepsDataController baseURLForRow:[_tableViewForSteps selectedRow]]];

    var rowNo = [_tableViewForSteps selectedRow];

    console.info("subStepsDidChange: ", subStepsDidChange);

    var rowView = [_tableViewForSteps viewAtColumn:0 row:rowNo makeIfNecessary:NO];
    [_popover showRelativeToRect:[rowView bounds] ofView:rowView preferredEdge:CPMaxXEdge];
    
    [_popoverSubViewController setSubStepsDidChange:subStepsDidChange];
    [_popoverSubViewController tableReloadDataForMainStepRow:rowNo];
    // Since CPPopover steals the focus, we give the focus back to the steps window.
    [[self window] becomeKeyWindow];

}



// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │                 CPTableViewDataSource                 │██
// │                   Protocol methods                    │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████

- (CPInteger) numberOfRowsInTableView:(CPTableView)tableView
{
    return [[_stepsDataController tableDataArray] count];
}


- (id) tableView:(CPTableView)table objectValueForTableColumn:(CPTableColumn)column row:(CPInteger)rowIndex
{

    var rowData = [[_stepsDataController tableDataArray] objectAtIndex:rowIndex];
    return [CPString stringWithFormat:@"%d. ", rowIndex+1] + [rowData valueForKey:[column identifier]]; // identifier is step

}

// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │                  CPTableViewDelegate                  │██
// │                   Protocol methods                    │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████


- (void) tableViewSelectionDidChange:(CPNotification)notification
{
    // 
    if([[notification object] selectedRow] != -1){

        var rowNo = [[notification object] selectedRow];
        [_stepsDataController downloadSubStepsForMainStepRow:rowNo];

    } else {
        /* [_state setTimestamp:-1]; */
    }

    /* [self saveState]; */
}



// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │                   CPPopoverDelegate                   │██
// │                   Protocol methods                    │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████

// CPPopover closing animation takes time to complete but I need
// an immediate response here, so using popoverWillClose event.
- (void) popoverWillClose:(CPPopover)popover
{
    [_tableViewForSteps deselectAll];
}


@end
