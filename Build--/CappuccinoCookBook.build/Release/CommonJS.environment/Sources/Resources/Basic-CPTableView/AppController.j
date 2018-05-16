@STATIC;1.0;I;23;Foundation/Foundation.jI;15;AppKit/AppKit.jt;4243;objj_executeFile("Foundation/Foundation.j", NO);objj_executeFile("AppKit/AppKit.j", NO);
{var the_class = objj_allocateClassPair(CPObject, "AppController"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("theWindow", "CPWindow"), new objj_ivar("tableView", "CPTableView"), new objj_ivar("tableData", "CPMutableArray")]);objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("applicationDidFinishLaunching:"), function $AppController__applicationDidFinishLaunching_(self, _cmd, aNotification)
{
    self.tableData = ((___r1 = (CPMutableArray.isa.method_msgSend["alloc"] || _objj_forward)(CPMutableArray, "alloc")), ___r1 == null ? null : (___r1.isa.method_msgSend["init"] || _objj_forward)(___r1, "init"));
    var dictionary = (CPMutableDictionary.isa.method_msgSend["dictionary"] || _objj_forward)(CPMutableDictionary, "dictionary");
    (dictionary == null ? null : (dictionary.isa.method_msgSend["setObject:forKey:"] || _objj_forward)(dictionary, "setObject:forKey:", "Benjamin Franklin", "name"));
    (dictionary == null ? null : (dictionary.isa.method_msgSend["setObject:forKey:"] || _objj_forward)(dictionary, "setObject:forKey:", "1/17/1706", "birthdate"));
    ((___r1 = self.tableData), ___r1 == null ? null : (___r1.isa.method_msgSend["addObject:"] || _objj_forward)(___r1, "addObject:", dictionary));
    dictionary = (CPMutableDictionary.isa.method_msgSend["dictionary"] || _objj_forward)(CPMutableDictionary, "dictionary");
    (dictionary == null ? null : (dictionary.isa.method_msgSend["setObject:forKey:"] || _objj_forward)(dictionary, "setObject:forKey:", "Samuel Adams", "name"));
    (dictionary == null ? null : (dictionary.isa.method_msgSend["setObject:forKey:"] || _objj_forward)(dictionary, "setObject:forKey:", "9/27/1722", "birthdate"));
    ((___r1 = self.tableData), ___r1 == null ? null : (___r1.isa.method_msgSend["addObject:"] || _objj_forward)(___r1, "addObject:", dictionary));
    dictionary = (CPMutableDictionary.isa.method_msgSend["dictionary"] || _objj_forward)(CPMutableDictionary, "dictionary");
    (dictionary == null ? null : (dictionary.isa.method_msgSend["setObject:forKey:"] || _objj_forward)(dictionary, "setObject:forKey:", "Thomas Jefferson", "name"));
    (dictionary == null ? null : (dictionary.isa.method_msgSend["setObject:forKey:"] || _objj_forward)(dictionary, "setObject:forKey:", "4/13/1743", "birthdate"));
    ((___r1 = self.tableData), ___r1 == null ? null : (___r1.isa.method_msgSend["addObject:"] || _objj_forward)(___r1, "addObject:", dictionary));
    ((___r1 = self.tableView), ___r1 == null ? null : (___r1.isa.method_msgSend["reloadData"] || _objj_forward)(___r1, "reloadData"));
    var ___r1;
}

,["void","CPNotification"]), new objj_method(sel_getUid("numberOfRowsInTableView:"), function $AppController__numberOfRowsInTableView_(self, _cmd, table)
{
    return ((___r1 = self.tableData), ___r1 == null ? null : (___r1.isa.method_msgSend["count"] || _objj_forward)(___r1, "count"));
    var ___r1;
}

,["CPInteger","CPTableView"]), new objj_method(sel_getUid("tableView:objectValueForTableColumn:row:"), function $AppController__tableView_objectValueForTableColumn_row_(self, _cmd, table, column, rowIndex)
{
    var rowData = ((___r1 = self.tableData), ___r1 == null ? null : (___r1.isa.method_msgSend["objectAtIndex:"] || _objj_forward)(___r1, "objectAtIndex:", rowIndex));
    console.info((rowData == null ? null : (rowData.isa.method_msgSend["valueForKey:"] || _objj_forward)(rowData, "valueForKey:", (column == null ? null : (column.isa.method_msgSend["identifier"] || _objj_forward)(column, "identifier")))));
    return (rowData == null ? null : (rowData.isa.method_msgSend["valueForKey:"] || _objj_forward)(rowData, "valueForKey:", (column == null ? null : (column.isa.method_msgSend["identifier"] || _objj_forward)(column, "identifier"))));
    var ___r1;
}

,["id","CPTableView","CPTableColumn","CPInteger"]), new objj_method(sel_getUid("awakeFromCib"), function $AppController__awakeFromCib(self, _cmd)
{
    ((___r1 = self.theWindow), ___r1 == null ? null : (___r1.isa.method_msgSend["setFullPlatformWindow:"] || _objj_forward)(___r1, "setFullPlatformWindow:", NO));
    var ___r1;
}

,["void"])]);
}
