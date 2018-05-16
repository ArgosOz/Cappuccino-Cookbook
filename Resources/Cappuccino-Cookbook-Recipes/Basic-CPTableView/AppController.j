/*
 * AppController.j
 * 0101-CPTableView
 *
 * Created by You on April 14, 2018.
 * Copyright 2018, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

// StepsWindow lives in the StepsWindow.cib file.
// We control it with StepsWindowController.
// So you need to import the StepsWindowController here...
// and define a class variable in the class definition.
// and then initialize it with StepsWindow.cib
// This will let you move and reuse UI and related code in between different application easily.
@import "StepsWindowController.j"


var GITHUB_REPO = 0

@implementation AppController : CPObject
{
    @outlet CPWindow            theWindow;
    @outlet CPTableView         _tableView;
            CPMutableArray      _tableDataArray;
            CPWindowController  _stepsWindowController; // StepsWindowController class variable.
}

- (void) applicationDidFinishLaunching:(CPNotification)aNotification
{
    // The table's data source. 
    // Each row in the table will be a NSDictionary with two
	// items, one for each column.
	_tableDataArray = [[CPMutableArray alloc] init];
	
	// Row 1
    var dictionary = [CPMutableDictionary dictionary];
	[dictionary setObject:@"Spider-Man" forKey:@"movie"];
	[dictionary setObject:@"2002" forKey:@"releasedate"];

	[_tableDataArray addObject:dictionary];
    
	// You can also create a dictionary using the syntax below.
    // For more information see Objective-J 2.0 section at
    // http://www.cappuccino-project.org/learn/objective-j.html    
    // Row 2
	dictionary = @{
        @"movie": @"Iron-Man",
        @"releasedate": @"2008"
    }    
	[_tableDataArray addObject:dictionary];
	
    // Row 3
	dictionary = @{
        @"movie": @"Thor",
        @"releasedate": @"2011"
    }
	[_tableDataArray addObject:dictionary];
    // Following rows...
	dictionary = @{
        @"movie": @"Avengers: Infinity War",
        @"releasedate": @"2018"
    }
	[_tableDataArray addObject:dictionary];
	dictionary = @{
        @"movie": @"Guardians of the Galaxy",
        @"releasedate": @"2014"
    }
	[_tableDataArray addObject:dictionary];
	dictionary = @{
        @"movie": @"Black Panther",
        @"releasedate": @"2018"
    }
	[_tableDataArray addObject:dictionary];
	dictionary = @{
        @"movie": @"Ant-Man",
        @"releasedate": @"2015"
    }
	[_tableDataArray addObject:dictionary];
	dictionary = @{
        @"movie": @"The Incredible Hulk",
        @"releasedate": @"2008"
    }
	[_tableDataArray addObject:dictionary];

		
	[_tableView reloadData];

    _stepsWindowController = [[StepsWindowController alloc] initWithWindowCibName:@"StepsWindow"];
    [_stepsWindowController showWindow:self];

}


- (void) awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
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



- (IBAction) openLinkInNewTab:(id)sender
{
    switch([sender tag]){
        case GITHUB_REPO:
            window.open("https://github.com/ArgosOz/Cappuccino-Cookbook-Recipes/tree/master/Basic-CPTableView", "_blank");
            break;
    }
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

- (CPInteger) numberOfRowsInTableView:(CPTableView)table {
	return [_tableDataArray count];
}


- (id) tableView:(CPTableView)table objectValueForTableColumn:(CPTableColumn)column row:(CPInteger)rowIndex
{
    var rowData = [_tableDataArray objectAtIndex:rowIndex];
    return [rowData valueForKey:[column identifier]];

}



@end
