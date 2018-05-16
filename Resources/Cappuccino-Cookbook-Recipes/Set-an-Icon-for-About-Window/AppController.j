/*
 * AppController.j
 * Icon-for-About-Window
 *
 * Created by Argos Oz on May 4, 2018.
 * Copyright 2018, Army of Me, Inc. Attribution-NonCommercial-ShareAlike CC BY-NC-SA.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

var GITHUB_REPO = 0


// TODO Animate the hand pointer.

@implementation AppController : CPObject
{
    @outlet CPWindow    theWindow;
    /* @outlet CPWebView   _webViewTop; */
    /* @outlet CPWebView   _webViewBottom; */

    @outlet CPScrollView    _scrollView;
    @outlet CPView          _viewForScrolling;

    @outlet CPImageView     _code1View;
    @outlet CPImageView     _code2View;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{

    /* [_webViewTop setMainFrameURL:@"Resources/infoplistxml.html"]; */
    /* [_webViewBottom setMainFrameURL:@"Resources/infoplistxmladd.html"]; */

    [_code1View setBackgroundColor:[CPColor whiteColor]];
    [_code2View setBackgroundColor:[CPColor whiteColor]];

    // Necessary to get rid of the ugly scrollbars on Windows
    [CPScrollView setGlobalScrollerStyle:CPScrollerStyleOverlay];
    
    [_scrollView setDocumentView:_viewForScrolling];
}

- (IBAction) openLinkInNewTab:(id)sender
{
    console.info(sender);
    console.info([sender title]);
    switch([sender tag]){
        case GITHUB_REPO:
            window.open("https://github.com/ArgosOz/Cappuccino-Cookbook-Recipes/tree/master/Set-an-Icon-for-About-Window", "_blank");
            break;
    }
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
