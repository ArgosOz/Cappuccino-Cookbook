@STATIC;1.0;I;23;Foundation/Foundation.jI;15;AppKit/AppKit.jt;7042;objj_executeFile("Foundation/Foundation.j", NO);objj_executeFile("AppKit/AppKit.j", NO);
{var the_class = objj_allocateClassPair(CPObject, "AppController"),
meta_class = the_class.isa;
var aProtocol = objj_getProtocol("CPTableViewDataSource");
if (!aProtocol) throw new SyntaxError("*** Could not find definition for protocol \"CPTableViewDataSource\"");
class_addProtocol(the_class, aProtocol);class_addIvars(the_class, [new objj_ivar("theWindow", "CPWindow"), new objj_ivar("_tableView", "CPTableView"), new objj_ivar("_webView", "CPWebView"), new objj_ivar("_splitView", "CPSplitView"), new objj_ivar("_tableDataArray", "CPMutableArray")]);objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("applicationDidFinishLaunching:"), function $AppController__applicationDidFinishLaunching_(self, _cmd, aNotification)
{
    var url = (CPURL.isa.method_msgSend["URLWithString:"] || _objj_forward)(CPURL, "URLWithString:", "Resources/recipes.txt");
    var request = (CPURLRequest.isa.method_msgSend["requestWithURL:"] || _objj_forward)(CPURLRequest, "requestWithURL:", url);
    var connection = ((___r1 = (CPURLConnection.isa.method_msgSend["alloc"] || _objj_forward)(CPURLConnection, "alloc")), ___r1 == null ? null : (___r1.isa.method_msgSend["initWithRequest:delegate:"] || _objj_forward)(___r1, "initWithRequest:delegate:", request, self));
    var targetNode = self._webView._iframe.parentNode;
    var config = {attributes: true};
    var callback =     function(mutationsList)
    {
        var parentOfIFrame = self._webView._iframe.parentNode;
        var oneLevelUpParent = parentOfIFrame.parentNode;
        var targetWidth = oneLevelUpParent.style.getPropertyValue("width");
        var targetHeight = oneLevelUpParent.style.getPropertyValue("height");
        parentOfIFrame.style.setProperty("width", targetWidth);
        parentOfIFrame.style.setProperty("height", targetHeight);
    };
    var observer = new MutationObserver(callback);
    observer.observe(targetNode, config);
    var ___r1;
}

,["void","CPNotification"]), new objj_method(sel_getUid("awakeFromCib"), function $AppController__awakeFromCib(self, _cmd)
{
    ((___r1 = self.theWindow), ___r1 == null ? null : (___r1.isa.method_msgSend["setFullPlatformWindow:"] || _objj_forward)(___r1, "setFullPlatformWindow:", YES));
    var ___r1;
}

,["void"]), new objj_method(sel_getUid("windowDidResize:"), function $AppController__windowDidResize_(self, _cmd, notification)
{
    ((___r1 = self._splitView), ___r1 == null ? null : (___r1.isa.method_msgSend["setPosition:ofDividerAtIndex:"] || _objj_forward)(___r1, "setPosition:ofDividerAtIndex:", 270.0, 0));
    var ___r1;
}

,["void","CPNotification"]), new objj_method(sel_getUid("connection:didReceiveData:"), function $AppController__connection_didReceiveData_(self, _cmd, connection, dataString)
{
    self._tableDataArray = (dataString == null ? null : (dataString.isa.method_msgSend["componentsSeparatedByString:"] || _objj_forward)(dataString, "componentsSeparatedByString:", "\n"));
    ((___r1 = self._tableView), ___r1 == null ? null : (___r1.isa.method_msgSend["reloadData"] || _objj_forward)(___r1, "reloadData"));
    var ___r1;
}

,["void","CPURLConnection","CPString"]), new objj_method(sel_getUid("splitView:constrainMinCoordinate:ofSubviewAt:"), function $AppController__splitView_constrainMinCoordinate_ofSubviewAt_(self, _cmd, splitView, proposedMax, dividerIndex)
{
    return 270.0;
}

,["float","CPSplitView","float","CPInteger"]), new objj_method(sel_getUid("splitView:constrainMaxCoordinate:ofSubviewAt:"), function $AppController__splitView_constrainMaxCoordinate_ofSubviewAt_(self, _cmd, splitView, proposedMax, dividerIndex)
{
    return 270.0;
}

,["float","CPSplitView","float","CPInteger"]), new objj_method(sel_getUid("numberOfRowsInTableView:"), function $AppController__numberOfRowsInTableView_(self, _cmd, tableView)
{
    return ((___r1 = self._tableDataArray), ___r1 == null ? null : (___r1.isa.method_msgSend["count"] || _objj_forward)(___r1, "count")) - 1;
    var ___r1;
}

,["CPInteger","CPTableView"]), new objj_method(sel_getUid("tableViewSelectionDidChange:"), function $AppController__tableViewSelectionDidChange_(self, _cmd, notification)
{
    if (((___r1 = (notification == null ? null : (notification.isa.method_msgSend["object"] || _objj_forward)(notification, "object"))), ___r1 == null ? null : (___r1.isa.method_msgSend["selectedRow"] || _objj_forward)(___r1, "selectedRow")) != -1)
    {
        var rowData = ((___r1 = self._tableDataArray), ___r1 == null ? null : (___r1.isa.method_msgSend["objectAtIndex:"] || _objj_forward)(___r1, "objectAtIndex:", ((___r2 = (notification == null ? null : (notification.isa.method_msgSend["object"] || _objj_forward)(notification, "object"))), ___r2 == null ? null : (___r2.isa.method_msgSend["selectedRow"] || _objj_forward)(___r2, "selectedRow"))));
        var projectPath = "Resources/" + (rowData == null ? null : (rowData.isa.method_msgSend["componentsSeparatedByString:"] || _objj_forward)(rowData, "componentsSeparatedByString:", "|"))[1] + "/index.html";
        ((___r1 = self._webView), ___r1 == null ? null : (___r1.isa.method_msgSend["setMainFrameURL:"] || _objj_forward)(___r1, "setMainFrameURL:", projectPath));
    }
    var ___r1, ___r2;
}

,["void","CPNotification"]), new objj_method(sel_getUid("tableView:viewForTableColumn:row:"), function $AppController__tableView_viewForTableColumn_row_(self, _cmd, tableView, tableColumn, row)
{
    var rowData = self._tableDataArray[row];
    if ((rowData == null ? null : (rowData.isa.method_msgSend["hasPrefix:"] || _objj_forward)(rowData, "hasPrefix:", "GROUP:")))
    {
    }
    else
    {
        var identifier = (tableColumn == null ? null : (tableColumn.isa.method_msgSend["identifier"] || _objj_forward)(tableColumn, "identifier"));
        if ((identifier == null ? null : (identifier.isa.method_msgSend["isEqualToString:"] || _objj_forward)(identifier, "isEqualToString:", "ViewCell")))
        {
            var viewCell = (tableView == null ? null : (tableView.isa.method_msgSend["makeViewWithIdentifier:owner:"] || _objj_forward)(tableView, "makeViewWithIdentifier:owner:", "ViewCell", self));
            var projectName = (rowData == null ? null : (rowData.isa.method_msgSend["componentsSeparatedByString:"] || _objj_forward)(rowData, "componentsSeparatedByString:", "|"))[1];
            projectName = (projectName == null ? null : (projectName.isa.method_msgSend["stringByReplacingOccurrencesOfString:withString:"] || _objj_forward)(projectName, "stringByReplacingOccurrencesOfString:withString:", "-", " "));
            ((___r1 = (viewCell == null ? null : (viewCell.isa.method_msgSend["textField"] || _objj_forward)(viewCell, "textField"))), ___r1 == null ? null : (___r1.isa.method_msgSend["setStringValue:"] || _objj_forward)(___r1, "setStringValue:", projectName));
            return viewCell;
        }
    }
    return nil;
    var ___r1;
}

,["CPView","CPTableView","CPTableColumn","CPInteger"])]);
}
