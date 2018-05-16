@implementation Recipe : CPObject
{
    int         _timestamp @accessors(property=timestamp);
    CPString    _folderName @accessors(property=folderName);
    CPString    _name @accessors(property=name);
    CPString    _tags @accessors(property=tags);
}

- (id) initWithName:(CPString)name folderName:(CPString)folderName tags:(CPString)tags timestamp:(int)timestamp
{
    self = [super init];

    _timestamp = timestamp;
    _folderName = folderName;
    _name = name;
    _tags = tags;

    return self;
}


@end
