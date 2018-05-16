@STATIC;1.0;t;2216;
{var the_class = objj_allocateClassPair(CPObject, "State"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_searchString", "CPString"), new objj_ivar("_timestamp", "int")]);objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("searchString"), function $State__searchString(self, _cmd)
{
    return self._searchString;
}

,["CPString"]), new objj_method(sel_getUid("setSearchString:"), function $State__setSearchString_(self, _cmd, newValue)
{
    self._searchString = newValue;
}

,["void","CPString"]), new objj_method(sel_getUid("timestamp"), function $State__timestamp(self, _cmd)
{
    return self._timestamp;
}

,["int"]), new objj_method(sel_getUid("setTimestamp:"), function $State__setTimestamp_(self, _cmd, newValue)
{
    self._timestamp = newValue;
}

,["void","int"]), new objj_method(sel_getUid("init"), function $State__init(self, _cmd)
{
    self = (objj_getClass("State").super_class.method_dtable["init"] || _objj_forward)(self, "init");
    if (self)
    {
        self._searchString = "";
        self._timestamp = -1;
    }
    return self;
}

,["id"]), new objj_method(sel_getUid("encodeWithCoder:"), function $State__encodeWithCoder_(self, _cmd, encoder)
{
    (encoder == null ? null : (encoder.isa.method_msgSend["encodeObject:forKey:"] || _objj_forward)(encoder, "encodeObject:forKey:", self._searchString, "searchString"));
    (encoder == null ? null : (encoder.isa.method_msgSend["encodeObject:forKey:"] || _objj_forward)(encoder, "encodeObject:forKey:", self._timestamp, "timestamp"));
}

,["void","CPCoder"]), new objj_method(sel_getUid("initWithCoder:"), function $State__initWithCoder_(self, _cmd, decoder)
{
    self = (objj_getClass("State").super_class.method_dtable["init"] || _objj_forward)(self, "init");
    if (self)
    {
        self._searchString = (decoder == null ? null : (decoder.isa.method_msgSend["decodeObjectForKey:"] || _objj_forward)(decoder, "decodeObjectForKey:", "searchString"));
        self._timestamp = (decoder == null ? null : (decoder.isa.method_msgSend["decodeObjectForKey:"] || _objj_forward)(decoder, "decodeObjectForKey:", "timestamp"));
    }
    return self;
}

,["id","CPCoder"])]);
}
