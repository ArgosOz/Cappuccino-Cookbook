@protocol StepsDataController <CPObject>

@optional
- (void) mainStepsDidLoad:(CPArray)mainStepsArray;
- (void) subStepsDidLoad:(CPArray)subStepsArray subStepsDidChange:(BOOL)subStepsDidChange;

@end

TEXT_TYPE = 0;
IMAGE_TYPE = 1;
CODE_TYPE = 2;

MAINSTEPS_DOWNLOAD = 0;
SUBSTEPS_DOWNLOAD = 1;

@implementation StepsDataController : CPObject
{
    CPArray                     _mainStepsArray;
    CPArray                     _subStepsArray;
    CPDictionary                _downloadQueueDictionary;
    id <StepsDataController>    _delegate @accessors(property=delegate);
}

- (id) init
{
    self = [super init];
    
    _downloadQueueDictionary = @{};
    [self downloadMainStepsURL:@"Resources/steps/steps.plist"];

    return self;
}

- (void) setDelegate:(id)delegate
{
    _delegate = delegate;
}

- (CPDictionary) tableDataArray
{
    return _mainStepsArray; 
}

- (CPString) baseURLForRow:(CPInteger)rowIndex
{
    return [[_mainStepsArray objectAtIndex:rowIndex] valueForKey:@"baseURL"];
}

// Two kinds of substeps we have here:
// 1. External
// 2. Internal
- (void) downloadSubStepsForMainStepRow:(CPInteger)row
{
    // It you find a URL, download the sub steps...
    var rowData = [_mainStepsArray objectAtIndex:row];
    
    if([rowData valueForKey:@"subStepsFileName"]){
        var URL = [rowData valueForKey:@"baseURL"] + [rowData valueForKey:@"subStepsFileName"];
        var connection = [self downloadURL:URL];
        [_downloadQueueDictionary setValue:SUBSTEPS_DOWNLOAD forKey:[connection UID]];
    // If you don't find a URL, you should ask for the array directly and return it using the delegate method
    } else { 
        _subStepsArray = [[_mainStepsArray objectAtIndex:row] valueForKey:@"subSteps"];

        var recordName = @"mainStep" + row + @"_subSteps";
        var defaults = [CPUserDefaults standardUserDefaults];

        var recordData = [CPKeyedArchiver archivedDataWithRootObject:_subStepsArray];

        var subStepsDidChange = [defaults stringForKey:recordName] != [recordData rawString] ? YES : NO;

        
        if( ! [defaults stringForKey:recordName] || subStepsDidChange)
            [defaults setObject:[recordData rawString] forKey:recordName];

        if(_delegate)
            if([_delegate respondsToSelector:@selector(subStepsDidLoad:subStepsDidChange:)])
                [_delegate subStepsDidLoad:_subStepsArray subStepsDidChange:subStepsDidChange];
    }
}


- (void) downloadMainStepsURL:(CPString)URL
{
    var connection = [self downloadURL:URL];
    [_downloadQueueDictionary setValue:MAINSTEPS_DOWNLOAD forKey:[connection UID]];
}

- (id) downloadURL:(CPString)URL
{
    // Put current time workaround browser cache problems
    var url = [CPURL URLWithString:URL + "?t=" + Date.now()]; 
    var request = [CPURLRequest requestWithURL:url];
    var connection = [[CPURLConnection alloc] initWithRequest:request delegate:self];    
    return connection; 
}

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

- (void) connection:(CPURLConnection)connection didReceiveData:(CPString)downloadedString
{
    
    switch([_downloadQueueDictionary valueForKey:[connection UID]]){
        case MAINSTEPS_DOWNLOAD:
            _mainStepsArray = CFPropertyList.propertyListFromXML(downloadedString);
            if(_delegate)
                if([_delegate respondsToSelector:@selector(mainStepsDidLoad:)])
                    [_delegate mainStepsDidLoad:_mainStepsArray];
            break;
        case SUBSTEPS_DOWNLOAD:
            
            var subStepsFileName = [[[connection currentRequest] URL] lastPathComponent];
            var defaults = [CPUserDefaults standardUserDefaults];

            var subStepsDidChange = [defaults stringForKey:subStepsFileName] != downloadedString ? YES : NO;
            
            if( ! [defaults stringForKey:subStepsFileName] || subStepsDidChange)
                [defaults setObject:downloadedString forKey:subStepsFileName];


            _subStepsArray = CFPropertyList.propertyListFromXML(downloadedString);
            
            if(_delegate)
                if([_delegate respondsToSelector:@selector(subStepsDidLoad:subStepsDidChange:)])
                    [_delegate subStepsDidLoad:_subStepsArray subStepsDidChange:subStepsDidChange];
            break;
    }
    
}

@end



