@STATIC;1.0;I;23;Foundation/Foundation.jI;15;AppKit/AppKit.ji;7;State.ji;8;Recipe.jt;11846;objj_executeFile("Foundation/Foundation.j", NO);objj_executeFile("AppKit/AppKit.j", NO);objj_executeFile("State.j", YES);objj_executeFile("Recipe.j", YES);
{var the_class = objj_allocateClassPair(CPObject, "AppController"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("theWindow", "CPWindow"), new objj_ivar("_tableView", "CPTableView"), new objj_ivar("_webView", "CPWebView"), new objj_ivar("_splitView", "CPSplitView"), new objj_ivar("_searchField", "CPSearchField"), new objj_ivar("_arrayController", "CPArrayController"), new objj_ivar("_tableDataArray", "CPMutableArray"), new objj_ivar("_state", "State")]);objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("tableArray"), function $AppController__tableArray(self, _cmd)
{
    return self._tableDataArray;
}

,["CPMutableArray"]), new objj_method(sel_getUid("setTableArray:"), function $AppController__setTableArray_(self, _cmd, newValue)
{
    self._tableDataArray = newValue;
}

,["void","CPMutableArray"]), new objj_method(sel_getUid("awakeFromCib"), function $AppController__awakeFromCib(self, _cmd)
{
    ((___r1 = self.theWindow), ___r1 == null ? null : (___r1.isa.method_msgSend["setFullPlatformWindow:"] || _objj_forward)(___r1, "setFullPlatformWindow:", YES));
    var ___r1;
}

,["void"]), new objj_method(sel_getUid("saveState"), function $AppController__saveState(self, _cmd)
{
    ((___r1 = self._state), ___r1 == null ? null : (___r1.isa.method_msgSend["setSearchString:"] || _objj_forward)(___r1, "setSearchString:", ((___r2 = self._searchField), ___r2 == null ? null : (___r2.isa.method_msgSend["stringValue"] || _objj_forward)(___r2, "stringValue"))));
    var archivedState = (CPKeyedArchiver.isa.method_msgSend["archivedDataWithRootObject:"] || _objj_forward)(CPKeyedArchiver, "archivedDataWithRootObject:", self._state);
    var defaults = (CPUserDefaults.isa.method_msgSend["standardUserDefaults"] || _objj_forward)(CPUserDefaults, "standardUserDefaults");
    (defaults == null ? null : (defaults.isa.method_msgSend["setObject:forKey:"] || _objj_forward)(defaults, "setObject:forKey:", (archivedState == null ? null : (archivedState.isa.method_msgSend["rawString"] || _objj_forward)(archivedState, "rawString")), "archivedState"));
    var ___r1, ___r2;
}

,["void"]), new objj_method(sel_getUid("applicationDidFinishLaunching:"), function $AppController__applicationDidFinishLaunching_(self, _cmd, aNotification)
{
    self._tableDataArray = ((___r1 = (CPMutableArray.isa.method_msgSend["alloc"] || _objj_forward)(CPMutableArray, "alloc")), ___r1 == null ? null : (___r1.isa.method_msgSend["init"] || _objj_forward)(___r1, "init"));
    ((___r1 = self._searchField), ___r1 == null ? null : (___r1.isa.method_msgSend["setDelegate:"] || _objj_forward)(___r1, "setDelegate:", self));
    ((___r1 = self._searchField), ___r1 == null ? null : (___r1.isa.method_msgSend["setAction:"] || _objj_forward)(___r1, "setAction:", sel_getUid("searchChanged:")));
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
    var archivedState = ((___r1 = (CPUserDefaults.isa.method_msgSend["standardUserDefaults"] || _objj_forward)(CPUserDefaults, "standardUserDefaults")), ___r1 == null ? null : (___r1.isa.method_msgSend["objectForKey:"] || _objj_forward)(___r1, "objectForKey:", "archivedState"));
    if (archivedState)
    {
        self._state = (CPKeyedUnarchiver.isa.method_msgSend["unarchiveObjectWithData:"] || _objj_forward)(CPKeyedUnarchiver, "unarchiveObjectWithData:", (CPData.isa.method_msgSend["dataWithRawString:"] || _objj_forward)(CPData, "dataWithRawString:", archivedState));
        if (!self._state)
        {
            self._state = ((___r1 = (State.isa.method_msgSend["alloc"] || _objj_forward)(State, "alloc")), ___r1 == null ? null : (___r1.isa.method_msgSend["init"] || _objj_forward)(___r1, "init"));
        }
    }
    ((___r1 = self._searchField), ___r1 == null ? null : (___r1.isa.method_msgSend["setStringValue:"] || _objj_forward)(___r1, "setStringValue:", ((___r2 = self._state), ___r2 == null ? null : (___r2.isa.method_msgSend["searchString"] || _objj_forward)(___r2, "searchString"))));
    var ___r1, ___r2;
}

,["void","CPNotification"]), new objj_method(sel_getUid("connection:didReceiveData:"), function $AppController__connection_didReceiveData_(self, _cmd, connection, dataString)
{
    var tmpArray = (dataString == null ? null : (dataString.isa.method_msgSend["componentsSeparatedByString:"] || _objj_forward)(dataString, "componentsSeparatedByString:", "\n"));
    for (var i = 0; i < tmpArray.length - 1; i++)
    {
        var recipeData = tmpArray[i].split("|");
        var recipe = ((___r1 = (Recipe.isa.method_msgSend["alloc"] || _objj_forward)(Recipe, "alloc")), ___r1 == null ? null : (___r1.isa.method_msgSend["initWithName:folderName:tags:timestamp:"] || _objj_forward)(___r1, "initWithName:folderName:tags:timestamp:", recipeData[1].replace(/-/g, " "), recipeData[1], recipeData[2], parseInt(recipeData[0], 10)));
        ((___r1 = self._arrayController), ___r1 == null ? null : (___r1.isa.method_msgSend["addObject:"] || _objj_forward)(___r1, "addObject:", recipe));
    }
    (self.isa.method_msgSend["setPredicate:"] || _objj_forward)(self, "setPredicate:", ((___r1 = self._state), ___r1 == null ? null : (___r1.isa.method_msgSend["searchString"] || _objj_forward)(___r1, "searchString")));
    if (((___r1 = self._state), ___r1 == null ? null : (___r1.isa.method_msgSend["timestamp"] || _objj_forward)(___r1, "timestamp")) > 0)
    {
        var rowNumberToBeSelected;
        for (var i = 0; i < ((___r1 = self._arrayController), ___r1 == null ? null : (___r1.isa.method_msgSend["arrangedObjects"] || _objj_forward)(___r1, "arrangedObjects")).length; i++)
        {
            if (((___r1 = ((___r2 = self._arrayController), ___r2 == null ? null : (___r2.isa.method_msgSend["arrangedObjects"] || _objj_forward)(___r2, "arrangedObjects"))[i]), ___r1 == null ? null : (___r1.isa.method_msgSend["timestamp"] || _objj_forward)(___r1, "timestamp")) == ((___r1 = self._state), ___r1 == null ? null : (___r1.isa.method_msgSend["timestamp"] || _objj_forward)(___r1, "timestamp")))
            {
                rowNumberToBeSelected = i;
                break;
            }
        }
        if (rowNumberToBeSelected != null)
        {
            var indexSet = (CPIndexSet.isa.method_msgSend["indexSetWithIndex:"] || _objj_forward)(CPIndexSet, "indexSetWithIndex:", rowNumberToBeSelected);
            ((___r1 = self._tableView), ___r1 == null ? null : (___r1.isa.method_msgSend["selectRowIndexes:byExtendingSelection:"] || _objj_forward)(___r1, "selectRowIndexes:byExtendingSelection:", indexSet, NO));
        }
    }
    var ___r1, ___r2;
}

,["void","CPURLConnection","CPString"]), new objj_method(sel_getUid("searchChanged:"), function $AppController__searchChanged_(self, _cmd, sender)
{
    var searchString = (sender == null ? null : (sender.isa.method_msgSend["stringValue"] || _objj_forward)(sender, "stringValue"));
    (self.isa.method_msgSend["saveState"] || _objj_forward)(self, "saveState");
    (self.isa.method_msgSend["setPredicate:"] || _objj_forward)(self, "setPredicate:", searchString);
}

,["void","id"]), new objj_method(sel_getUid("setPredicate:"), function $AppController__setPredicate_(self, _cmd, searchString)
{
    if (searchString.length > 0)
    {
        var predicate = (CPPredicate.isa.method_msgSend["predicateWithFormat:"] || _objj_forward)(CPPredicate, "predicateWithFormat:", "(%K CONTAINS[cd] %@)", "name", searchString);
        ((___r1 = self._arrayController), ___r1 == null ? null : (___r1.isa.method_msgSend["setFilterPredicate:"] || _objj_forward)(___r1, "setFilterPredicate:", predicate));
    }
    else
    {
        ((___r1 = self._arrayController), ___r1 == null ? null : (___r1.isa.method_msgSend["setFilterPredicate:"] || _objj_forward)(___r1, "setFilterPredicate:", nil));
    }
    var ___r1;
}

,["void","CPString"]), new objj_method(sel_getUid("windowDidResize:"), function $AppController__windowDidResize_(self, _cmd, notification)
{
    ((___r1 = self._splitView), ___r1 == null ? null : (___r1.isa.method_msgSend["setPosition:ofDividerAtIndex:"] || _objj_forward)(___r1, "setPosition:ofDividerAtIndex:", 270.0, 0));
    var ___r1;
}

,["void","CPNotification"]), new objj_method(sel_getUid("splitView:constrainMinCoordinate:ofSubviewAt:"), function $AppController__splitView_constrainMinCoordinate_ofSubviewAt_(self, _cmd, splitView, proposedMax, dividerIndex)
{
    return 270.0;
}

,["float","CPSplitView","float","CPInteger"]), new objj_method(sel_getUid("splitView:constrainMaxCoordinate:ofSubviewAt:"), function $AppController__splitView_constrainMaxCoordinate_ofSubviewAt_(self, _cmd, splitView, proposedMax, dividerIndex)
{
    return 270.0;
}

,["float","CPSplitView","float","CPInteger"]), new objj_method(sel_getUid("tableViewSelectionDidChange:"), function $AppController__tableViewSelectionDidChange_(self, _cmd, notification)
{
    if (((___r1 = (notification == null ? null : (notification.isa.method_msgSend["object"] || _objj_forward)(notification, "object"))), ___r1 == null ? null : (___r1.isa.method_msgSend["selectedRow"] || _objj_forward)(___r1, "selectedRow")) != -1)
    {
        var selectedRow = ((___r1 = (notification == null ? null : (notification.isa.method_msgSend["object"] || _objj_forward)(notification, "object"))), ___r1 == null ? null : (___r1.isa.method_msgSend["selectedRow"] || _objj_forward)(___r1, "selectedRow"));
        var recipe = ((___r1 = ((___r2 = self._arrayController), ___r2 == null ? null : (___r2.isa.method_msgSend["arrangedObjects"] || _objj_forward)(___r2, "arrangedObjects"))), ___r1 == null ? null : (___r1.isa.method_msgSend["objectAtIndex:"] || _objj_forward)(___r1, "objectAtIndex:", selectedRow));
        ((___r1 = self._state), ___r1 == null ? null : (___r1.isa.method_msgSend["setTimestamp:"] || _objj_forward)(___r1, "setTimestamp:", (recipe == null ? null : (recipe.isa.method_msgSend["timestamp"] || _objj_forward)(recipe, "timestamp"))));
        var projectPath = "Resources/Cappuccino-Cookbook-Recipes/" + (recipe == null ? null : (recipe.isa.method_msgSend["folderName"] || _objj_forward)(recipe, "folderName")) + "/index.html";
        ((___r1 = self._webView), ___r1 == null ? null : (___r1.isa.method_msgSend["setMainFrameURL:"] || _objj_forward)(___r1, "setMainFrameURL:", projectPath));
    }
    else
    {
        ((___r1 = self._state), ___r1 == null ? null : (___r1.isa.method_msgSend["setTimestamp:"] || _objj_forward)(___r1, "setTimestamp:", -1));
    }
    (self.isa.method_msgSend["saveState"] || _objj_forward)(self, "saveState");
    var ___r1, ___r2;
}

,["void","CPNotification"])]);
}
