/*
 * AppController.j
 * Cappuccino-CookBook
 *
 * Created by Argos Oz on May 3, 2018.
 * Copyright 2018, Army of Me, Inc. Attribution-NonCommercial-ShareAlike CC BY-NC-SA.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>


@implementation AppController : CPObject <CPTableViewDataSource>
{
    @outlet CPWindow        theWindow;
    @outlet CPTableView     _tableView;
    @outlet CPWebView       _webView;
    @outlet CPSplitView     _splitView;
            CPMutableArray  _tableDataArray;
            /* CPTimer         _correctionTimer; */
            /* int             _correctionCounter; */
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
    var url = [CPURL URLWithString:@"Resources/recipes.txt"];
    var request = [CPURLRequest requestWithURL:url];
    var connection = [[CPURLConnection alloc] initWithRequest:request delegate:self];

    // When I run a Cappucino app in a CPWebView,
    // the app inside the CPWebView,
    // sets its iframe.parentNode's width and height property to 0px
    // and as a result of this behavior the app stays hidden in the iframe.
    // So I observe iframe.parentNode and act on style attribute changes.
    var targetNode = _webView._iframe.parentNode;
    var config = {attributes:true};
    var callback = function(mutationsList){
        var parentOfIFrame = _webView._iframe.parentNode;
        var oneLevelUpParent = parentOfIFrame.parentNode;
        var targetWidth = oneLevelUpParent.style.getPropertyValue("width");
        var targetHeight = oneLevelUpParent.style.getPropertyValue("height");
        parentOfIFrame.style.setProperty("width", targetWidth);
        parentOfIFrame.style.setProperty("height", targetHeight);
    };
    var observer = new MutationObserver(callback);
    observer.observe(targetNode, config);

}

// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │                   CPWindowDelegate                    │██
// │                   Protocol methods                    │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████

- (void) windowDidResize:(CPNotification)notification
{
    [_splitView setPosition:270.0 ofDividerAtIndex:0];
}

// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │                CPURLConnectionDelegate                │██
// │                   Protocol methods                    │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████

- (void) connection:(CPURLConnection)connection didReceiveData:(CPString)dataString
{
    _tableDataArray = [dataString componentsSeparatedByString:@"\n"];
    [_tableView reloadData];
}

// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │                  CPSplitViewDelegate                  │██
// │                   Protocol methods                    │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████

- (float) splitView:(CPSplitView)splitView constrainMinCoordinate:(float)proposedMax ofSubviewAt:(CPInteger)dividerIndex
{
    return 270.0;
}

- (float) splitView:(CPSplitView)splitView constrainMaxCoordinate:(float)proposedMax ofSubviewAt:(CPInteger)dividerIndex
{
    return 270.0;
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
    return [_tableDataArray count] - 1; // Because last line is empty
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
    if([[notification object] selectedRow] != -1){
        var rowData = [_tableDataArray objectAtIndex:[[notification object] selectedRow]];
        // Second part of the row is project name
        var projectPath = @"Resources/" + [rowData componentsSeparatedByString:@"|"][1] + @"/index.html";
        /* projectPath = @"Resources/"; */
        [_webView setMainFrameURL:projectPath];


        // I poll iframe.parentNode's width and height property and set it back to right values
        /* var callback = function(){ */
        /*     var parentOfIFrame = _webView._iframe.parentNode; */
        /*     var oneLevelUpParent = parentOfIFrame.parentNode; */
        /*     var currentWidth = parentOfIFrame.style.getPropertyValue("width"); */
        /*     var currentHeight = parentOfIFrame.style.getPropertyValue("height"); */
        /*     /1* console.info(currentWidth, currentHeight); *1/ */
        /*     if(currentWidth == "0px" || currentHeight == "0px"){ */
        /*         _correctionCounter = 0; */
        /*         var targetWidth = oneLevelUpParent.style.getPropertyValue("width"); */
        /*         parentOfIFrame.style.setProperty("width", targetWidth); */
        /*         var targetHeight = oneLevelUpParent.style.getPropertyValue("height"); */
        /*         parentOfIFrame.style.setProperty("height", targetHeight); */
        /*     } */
        /*     _correctionCounter++; */
        /*     if(_correctionCounter > 18){ */
        /*         /1* console.info("done"); *1/ */
        /*         [_correctionTimer invalidate]; */
        /*     } */
        /* } */
        /* _correctionCounter = 0; */
        /* _correctionTimer = [CPTimer scheduledTimerWithTimeInterval:0.18 callback:callback repeats:YES]; */
    }
}

- (CPView) tableView:(CPTableView)tableView viewForTableColumn:(CPTableColumn)tableColumn row:(CPInteger)row
{
    var rowData = _tableDataArray[row];
    if([rowData hasPrefix:@"GROUP:"]){
        // This is a group row
    } else {
        // This is a data row
        var identifier = [tableColumn identifier];
        if([identifier isEqualToString:@"ViewCell"]){
            var viewCell = [tableView makeViewWithIdentifier:@"ViewCell" owner:self];
            // Second part of the row is project name
            var projectName = [rowData componentsSeparatedByString:@"|"][1];
            // Replace dashes with spaces
            projectName = [projectName stringByReplacingOccurrencesOfString:@"-" withString:@" "];
            [[viewCell textField] setStringValue:projectName];
            return viewCell;
        }
    }
    return nil;
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
}

@end
