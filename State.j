@implementation State : CPObject
{
    CPString        _searchString @accessors(property=searchString);
    int             _timestamp @accessors(property=timestamp);
}

- (id) init
{
    self = [super init];
    if(self){
        _searchString = @"";
        _timestamp = -1;
    }

    return self;
}

// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │                Necessary for use with                 │██
// │          CPKeyedArchiver & CPKeyedUnarchiver          │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████

- (void) encodeWithCoder:(CPCoder)encoder
{
    [encoder encodeObject:_searchString forKey:@"searchString"];
    [encoder encodeObject:_timestamp forKey:@"timestamp"];
}

- (id) initWithCoder:(CPCoder)decoder
{
    self = [super init];
    if(self){
        _searchString = [decoder decodeObjectForKey:@"searchString"];
        _timestamp = [decoder decodeObjectForKey:@"timestamp"];
    }
    return self;
}

@end

