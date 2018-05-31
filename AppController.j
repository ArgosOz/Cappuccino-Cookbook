/*
 * AppController.j
 * Cappuccino-CookBook
 *
 * Created by Argos Oz on May 3, 2018.
 * Copyright 2018, Army of Me, Inc. Attribution-NonCommercial-ShareAlike CC BY-NC-SA.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@import "State.j"
@import "Recipe.j"

var GITHUB_REPO = 0;

@implementation AppController : CPObject //<CPTableViewDataSource>
{
    @outlet CPWindow            theWindow;
    @outlet CPTableView         _tableView;
    @outlet CPWebView           _webView;
    @outlet CPSplitView         _splitView;
    @outlet CPSearchField       _searchField;
    @outlet CPArrayController   _arrayController;
            CPMutableArray      _tableDataArray @accessors(property=tableArray);
            State               _state;

}


- (void) awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
}

- (void) saveState
{
    // Save state
    [_state setSearchString:[_searchField stringValue]];
    // Convert to CPData
    var archivedState = [CPKeyedArchiver archivedDataWithRootObject:_state];
    // Save in the browser
    var defaults = [CPUserDefaults standardUserDefaults];
    var projectName = [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CPBundleName"];
    [defaults setObject:[archivedState rawString] forKey:projectName];

}

// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │                 CPApplicationDelegate                 │██
// │                   Protocol methods                    │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████

- (void) applicationDidFinishLaunching:(CPNotification)aNotification
{
    _tableDataArray = [[CPMutableArray alloc] init];

    [_searchField setDelegate:self];
    [_searchField setAction:@selector(searchChanged:)];

    var url = [CPURL URLWithString:@"Resources/recipes.txt"];
    var request = [CPURLRequest requestWithURL:url];
    var connection = [[CPURLConnection alloc] initWithRequest:request delegate:self];

    // When we run a Cappucino app in a CPWebView,
    // the app inside the CPWebView,
    // sets its iframe.parentNode's width and height property to 0px
    // and as a result of this behavior the app stays hidden in the iframe.
    // So I observe iframe.parentNode and act on style attribute changes.

    var targetNode = _webView._iframe;
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
   
    // Load  state
    var projectName = [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CPBundleName"];
    var archivedState = [[CPUserDefaults standardUserDefaults] objectForKey:projectName];
    if(archivedState){
        _state = [CPKeyedUnarchiver unarchiveObjectWithData:[CPData dataWithRawString:archivedState]];
        if(! _state){
            _state = [[State alloc] init];
        }
    }

    
    
    // Now I need to set the _arrayController predicate but the contentArray is 
    // empty at this point because it is being downloaded asynchronously.
    // So I need to set it in connection:didReceiveData: method.

}

/* - (void) applicationWillTerminate:(CPNotification)notification */
/* { */
/* } */


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

    
    var tmpArray = [dataString componentsSeparatedByString:@"\n"];

    for(var i=0; i<tmpArray.length; i++){ 
        var recipeData = tmpArray[i].split("|");
        var recipe = [[Recipe alloc] initWithName:recipeData[1].replace(/-/g, " ") folderName:recipeData[1] tags:recipeData[2] timestamp:parseInt(recipeData[0], 10)];
        [_arrayController addObject:recipe];
    }



    var testName = [[[CPApplication sharedApplication] namedArguments] valueForKey:@"t"];
    if(testName){
        testName = testName.replace(/ /g, "-");
        var rowNumberToBeSelected;
        for(var i=0; i<[_arrayController arrangedObjects].length; i++){
            if([[_arrayController arrangedObjects][i] folderName] == testName){
                rowNumberToBeSelected = i;
                var indexSet = [CPIndexSet indexSetWithIndex:rowNumberToBeSelected];
                [_tableView selectRowIndexes:indexSet byExtendingSelection:NO];
                break;
            }
        }

    } 
    
    if( ! testName && [_state timestamp] > 0){

        [_searchField setStringValue:[_state searchString]];
        // Set state back to saved one...
        // This is the second part of the job, first one is in the applicationDidFinishLaunching method.
        // First we set the predicate
        [self setPredicate:[_state searchString]];
        // If this is true that means we have a row selected before.
        // We need to select it again programmatically.

        var rowNumberToBeSelected;
        for(var i=0; i<[_arrayController arrangedObjects].length; i++){
            if([[_arrayController arrangedObjects][i] timestamp] == [_state timestamp]){
                rowNumberToBeSelected = i;
                break;
            }
        }
        
        if(rowNumberToBeSelected != null){
            var indexSet = [CPIndexSet indexSetWithIndex:rowNumberToBeSelected];
            [_tableView selectRowIndexes:indexSet byExtendingSelection:NO];
        }
    }
}


// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │                        Actions                        │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████

- (void) searchChanged:(id)sender
{
    [_tableView deselectAll];
    var searchString = [sender stringValue];
    [self saveState];
    [self setPredicate:searchString];
}

- (void) setPredicate:(CPString)searchString
{
    if(searchString && searchString.length > 0){
        /* var predicate = [CPPredicate predicateWithFormat:@"(%K CONTAINS[cd] %@) OR (%K CONTAINS[cd] %@)", @"name", searchString, @"tags", searchString]; */

        var predicate = [CPPredicate predicateWithFormat:@"(%K CONTAINS[cd] %@)", "name", searchString];
        [_arrayController setFilterPredicate:predicate];
    } else {
        [_arrayController setFilterPredicate:nil];
    }
    
}


- (IBAction) openLinkInNewTab:(id)sender
{
    var link;
    switch([sender tag]){
        case GITHUB_REPO:
            link = "https://github.com/cappuccino/cappuccino/tree/master/Tests/Manual";
            break;
        default:
            link = "http://www.cappuccino-project.org/learn/";
    }
    window.open(link, "_blank");
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
        var selectedRow = [[notification object] selectedRow];
        var recipe = [[_arrayController arrangedObjects] objectAtIndex:selectedRow];
        
        /* var number = [[CPNumber alloc] initWithInt:[recipe timestamp]]; */
        [_state setTimestamp: [recipe timestamp]];
        
        var projectPath = @"Resources/" + [recipe folderName] + @"/index.html";
        [_webView setMainFrameURL:projectPath];
    } else {
        [_state setTimestamp:-1];
    }

    [self saveState];

    /* [theWindow becomeKeyWindow]; */
}


@end
