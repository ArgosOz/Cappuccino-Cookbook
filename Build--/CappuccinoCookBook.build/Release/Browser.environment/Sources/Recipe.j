@STATIC;1.0;t;1891;
{var the_class = objj_allocateClassPair(CPObject, "Recipe"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_timestamp", "int"), new objj_ivar("_folderName", "CPString"), new objj_ivar("_name", "CPString"), new objj_ivar("_tags", "CPString")]);objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("timestamp"), function $Recipe__timestamp(self, _cmd)
{
    return self._timestamp;
}

,["int"]), new objj_method(sel_getUid("setTimestamp:"), function $Recipe__setTimestamp_(self, _cmd, newValue)
{
    self._timestamp = newValue;
}

,["void","int"]), new objj_method(sel_getUid("folderName"), function $Recipe__folderName(self, _cmd)
{
    return self._folderName;
}

,["CPString"]), new objj_method(sel_getUid("setFolderName:"), function $Recipe__setFolderName_(self, _cmd, newValue)
{
    self._folderName = newValue;
}

,["void","CPString"]), new objj_method(sel_getUid("name"), function $Recipe__name(self, _cmd)
{
    return self._name;
}

,["CPString"]), new objj_method(sel_getUid("setName:"), function $Recipe__setName_(self, _cmd, newValue)
{
    self._name = newValue;
}

,["void","CPString"]), new objj_method(sel_getUid("tags"), function $Recipe__tags(self, _cmd)
{
    return self._tags;
}

,["CPString"]), new objj_method(sel_getUid("setTags:"), function $Recipe__setTags_(self, _cmd, newValue)
{
    self._tags = newValue;
}

,["void","CPString"]), new objj_method(sel_getUid("initWithName:folderName:tags:timestamp:"), function $Recipe__initWithName_folderName_tags_timestamp_(self, _cmd, name, folderName, tags, timestamp)
{
    self = (objj_getClass("Recipe").super_class.method_dtable["init"] || _objj_forward)(self, "init");
    self._timestamp = timestamp;
    self._folderName = folderName;
    self._name = name;
    self._tags = tags;
    return self;
}

,["id","CPString","CPString","CPString","int"])]);
}
