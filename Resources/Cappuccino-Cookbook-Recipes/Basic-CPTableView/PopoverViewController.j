@implementation PopoverViewController : CPViewController
{
    @outlet CPTableView         _tableView;
    @outlet CPTextField         _dummyLabel @accessors();
    /* @outlet CPWebView           _dummyWebView; */
    @outlet CPView              _codeView;
    @outlet CPTableCellView     _tableCellViewForText;
            CPMutableArray      _tableDataArray;
            CPString            _codeTemplate;
            /* CPData              _currentHTMLCodeData; */

            int                 _currentMainStepNo;
            CPMutableDictionary _rowDimensionsDictionary;
            
            CPString            _projectName;
            CPString            _baseURL @accessors(property=baseURL);

            BOOL                _subStepsDidChange @accessors(getter=didSubStepsChange, setter=setSubStepsDidChange);
            BOOL                _resetRowHeights;
}

- (id) initWithCibName:(CPString)aCibNameOrNil bundle:(CPBundle)aCibBundleOrNil
{
    self = [super initWithCibName:aCibNameOrNil bundle:aCibBundleOrNil];

    var defaults = [CPUserDefaults standardUserDefaults];
    var rawString = [defaults stringForKey:@"rowDimensionsByMainStepsDictionary"];
    
    if( ! rawString)
        _rowDimensionsDictionary = @{};
    else
        _rowDimensionsDictionary = [CPKeyedUnarchiver unarchiveObjectWithData:[CPData dataWithRawString:rawString]];
    
    
    _projectName = [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CPBundleName"].replace(/ /g, "-");  
    
    var url = [CPURL URLWithString:@"../HTML-Templates/dyno/code.html"];
    var request = [CPURLRequest requestWithURL:url];
    var connection = [[CPURLConnection alloc] initWithRequest:request delegate:self];

    // Two way iframe communication
    // https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage
    // https://gist.github.com/pbojinov/8965299
    window.addEventListener("message", function(e){
        
        var receivedObject = JSON.parse(e.data); 
        /* console.info("receivedObject.row", receivedObject.row, "receivedObject.height", receivedObject.height); */ 
        

        if(receivedObject.row && receivedObject.height){
            
            var rowDimensions = [_rowDimensionsDictionary valueForKey:"" + _currentMainStepNo + "_" + receivedObject.row];
            if(! [rowDimensions rowSize] || [rowDimensions rowSize].height != receivedObject.height){
                [self saveRowSize:CGSizeMake([_tableView frameSize].width, receivedObject.height) andLabelSize:nil forSubStepRow:receivedObject.row];
                [_tableView noteHeightOfRowsWithIndexesChanged:[CPIndexSet indexSetWithIndex:receivedObject.row]];
            }
            /*  */
            /* var view = [_tableView viewAtColumn:0 row:receivedObject.row makeIfNecessary:NO]; */
        }
    }, false);

    return self;
}

- (void) tableReloadDataForMainStepRow:(CPInteger)row
{
    _currentMainStepNo = row;
    [_tableView reloadData];
}

- (void) setTableDataArray:(CPMutableArray)tableDataArray
{
    _tableDataArray = tableDataArray;
}

- (IBAction) closePopover:(id)sender
{
    var notificationCenter = [CPNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"PopoverTermination" object:self userInfo:nil];
}

- (CPString) replacePlaceHolders:(CPString)text
{
    return text.replace(/__PROJECT_NAME__/g, _projectName);
}

- (CPData) htmlData:(CPDictionary)rowData row:row
{
    var htmlCode = _codeTemplate.replace("__REPLACE_THIS__", [rowData valueForKey:@"code"])
                    .replace("__REPLACE_LANGUAGE__", [rowData valueForKey:@"language"])
                    .replace("__PLACE_ROW_NUMBER_HERE__", row)
                    .replace(/__PROJECT_NAME__/g, _projectName);
    return [CPData dataWithRawString:htmlCode];
}

/* - (CGSize) webViewSizeForTableView:(CPTableView)tableView row:(CPInteger)row rowData:(CPDictionary)rowData */
/* { */
/*     var webView = [_codeView subviews][0]; */
/*     [_dummyWebView setFrameSize:[webView frameSize]]; */
/*     [_dummyWebView setMainFrameURL:@"data:text/html;base64," + [[self htmlData:rowData row:row] base64]]; */
/*     console.info(_dummyWebView); */
/* } */

- (CGSize) textFieldSizeForTableView:(CPTableView)tableView row:(CPInteger)row rowData:(CPDictionary)rowData
{

    var targetWidth = [[_tableCellViewForText textField] frameSize].width;  //clipView frameSize].width;
    
    // We need _dummyLabel to find the height of the text block.
    // Because we'll calculate table's row height here.
    // First copy real label's related properties to _dummyLabel...
    [_dummyLabel setFrameSize:[[_tableCellViewForText textField] frameSize]];
    [_dummyLabel setFont:[[_tableCellViewForText textField] font]]; 
    // Set the text which its height in question...
    [_dummyLabel setStringValue:[self replacePlaceHolders:[rowData valueForKey:@"content"]]];
    // Then find new size...
    [_dummyLabel sizeToFit];
    var targetHeight = [_dummyLabel frameSize].height + 18;
    return CGSizeMake(targetWidth, targetHeight);
}

- (CGSize) imageSizeForTableView:(CPTableView)tableView withRowData:(CPDictionary)rowData
{
    var clipView = [tableView superview];

    var targetWidth = [clipView frameSize].width;
    var targetHeight = ([clipView frameSize].width / [rowData valueForKey:@"width"]) * [rowData valueForKey:@"height"];
    return CGSizeMake(targetWidth, targetHeight);
}

// You can pass nil for rowSize or labelSize, rowIndex is mandatory
- (void) saveRowSize:(CGSize)rowSize andLabelSize:(CGSize)labelSize forSubStepRow:(CPInteger)rowIndex
{
    var rowData = [_tableDataArray objectAtIndex:rowIndex];
    var rowDimensions = [_rowDimensionsDictionary valueForKey:"" + _currentMainStepNo+"_" + rowIndex];
    if( ! rowDimensions){
        rowDimensions = [[RowModel alloc] initWithRowSize:rowSize labelSize:labelSize type:[rowData valueForKey:@"type"]];
    } else {
        [rowDimensions setType:[rowData valueForKey:@"type"]];
        if(rowSize)
            [rowDimensions setRowSize:rowSize];
        if(labelSize)
            [rowDimensions setLabelSize:labelSize];
    }
    [_rowDimensionsDictionary setObject:rowDimensions forKey:"" + _currentMainStepNo+"_" + rowIndex];

    var recordData = [CPKeyedArchiver archivedDataWithRootObject:_rowDimensionsDictionary];
    var defaults = [CPUserDefaults standardUserDefaults];
    [defaults setObject:[recordData rawString] forKey:@"rowDimensionsByMainStepsDictionary"];
    /* console.info("" + _currentMainStepNo+"_" + rowIndex); */
    /* console.info(_rowDimensionsDictionary); */
}

/* - (void) resetRowHeights */
/* { */
/*     /1* console.info([_tableDataArray count]); *1/ */
/*     for(var i=0; i<[_tableDataArray count]-1; i++){ */
/*         var rowDimensionsKey = "" + _currentMainStepNo + "_" + i; */
/*         [_rowDimensionsDictionary removeObjectForKey:rowDimensionsKey]; */
/*         var rowDimensions = [_rowDimensionsDictionary valueForKey:rowDimensionsKey]; */
/*         /1* console.info(rowDimensions); *1/ */
/*         /1* console.info(i); *1/ */
/*     } */
/*     [_tableView reloadData]; */
    
/* } */

// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │                        Actions                        │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████

- (IBAction) copyTheCode:(id)sender
{
    var rowData = [_tableDataArray objectAtIndex:[_tableView rowForView:sender]];
    /* console.info([rowData valueForKey:@"code"]); */
    console.info(sender);
    var pasteboard = [CPPasteboard generalPasteboard];
    [pasteboard declareTypes:[CPStringPboardType] owner:nil];
    [pasteboard setString:[rowData valueForKey:@"code"] forType:CPStringPboardType];
    /* var el = document.createElement('textarea'); */
    /* el.style = "position:fixed; top: 63px; right:63px;"; */
    /* el.value = "str"; */
    /* document.body.appendChild(el); */
    /* el.select(); */
    document.execCommand("copy");
    /* var pasteboard = [CPPasteboard generalPasteboard]; */
    /* var types = []; */
    /* [types addObject:CPStringPboardType]; */
    /* [pasteboard declareTypes:types owner:nil]; */
    /* [pasteboard setString:[rowData valueForKey:@"code"] forType:CPStringPboardType]; */
    /* var el = document.createElement('textarea'); */
    /* el.value = [rowData valueForKey:@"code"]; */
    /* document.body.appendChild(el); */
  /* el.select(); */
  /* document.execCommand('copy'); */
  /* document.body.removeChild(el); */
  /* console.info(document.execCommand('copy')); */
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

- (void) connection:(CPURLConnection)connection didReceiveData:(CPString)dataString
{
    if([[connection currentRequest] valueForHTTPHeaderField:@"DownloadType"] == @"CodeFragment"){
        var rowIndex = parseInt([[connection currentRequest] valueForHTTPHeaderField:@"RowIndex"], 10);
        var subStepCode = [_tableView viewAtColumn:0 row:rowIndex makeIfNecessary:NO];
        var webView = [subStepCode subviews][0];
        var rowData = [_tableDataArray objectAtIndex:rowIndex];
        [rowData setValue:dataString forKey:@"code"];

        [webView setMainFrameURL:@"data:text/html;base64," + [[self htmlData:rowData row:rowIndex] base64]]; 
    } else {
        _codeTemplate = dataString; 
    }
    /* console.info("cpurl"); */
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

- (CPInteger) numberOfRowsInTableView:(CPTableView)tableView
{
    return [_tableDataArray count];
}


// ┌───────────────────────────────────────────────────────┐
// │                                                       │
// │                                                       │██
// │                  CPTableViewDelegate                  │██
// │                   Protocol methods                    │██
// │                                                       │██
// │                                                       │██
// └───────────────────────────────────────────────────────┘██
//   █████████████████████████████████████████████████████████
//   █████████████████████████████████████████████████████████

- (BOOL) tableView:(CPTableView)tableView shouldSelectRow:row
{
    return NO;
}

// Interesting: If you don't write any code Cappuccino automatically search for a CIB file named SubStepText for example...
// That's a column identifier. I'll learn more about this behavior.

// This is a one column table view. 

// https://stackoverflow.com/questions/7504546/view-based-nstableview-with-rows-that-have-dynamic-heights/8054170
- (CPView) tableView:(CPTableView)tableView viewForTableColumn:(CPTableColumn)tableColumn row:(CPInteger)row
{
    /* console.info([_tableDataArray objectAtIndex:row]); */
    var rowData = [_tableDataArray objectAtIndex:row];
    var rowSizes = [_rowDimensionsDictionary valueForKey:""+_currentMainStepNo+"_"+row];

    switch([rowData valueForKey:@"type"]){
        case TEXT_TYPE:
            
            var subStepText = [tableView makeViewWithIdentifier:@"SubStepText" owner:self];

            [[subStepText textField] setStringValue:[self replacePlaceHolders:[rowData valueForKey:@"content"]]];
            [[subStepText textField] sizeToFit];

            /* var targetSize = [self textFieldSizeForTableView:tableView row:row rowData:rowData]; */
            /* var newSize = CGSizeMake([[subStepText textField] frameSize].width, targetSize.height); */
            [[subStepText textField] setFrameOrigin:CGPointMake(27,0)];
            
            [[subStepText textField] setFrameSize:[rowSizes labelSize]];
            
            return subStepText;
        
        case IMAGE_TYPE:
            var subStepImage = [tableView makeViewWithIdentifier:@"SubStepImage" owner:self];
            
            var imageName = [rowData valueForKey:@"imageName"];

            var targetSize = [rowSizes rowSize]; 
            // If the computed size is bigger than the original image, use original size
            if(targetSize.width > [rowData valueForKey:@"width"])
                targetSize.width = [rowData valueForKey:@"width"];
            if(targetSize.height > [rowData valueForKey:@"height"])
                targetSize.height = [rowData valueForKey:@"height"];

            var image = [[CPImage alloc] initWithContentsOfFile:_baseURL + imageName size:targetSize];
            [[subStepImage imageView] setImage:image];

            return subStepImage;
        
        case CODE_TYPE:
            var subStepCode = [tableView makeViewWithIdentifier:@"CodeView" owner:self];

            var webView = [subStepCode subviews][0];
            // Prevents disturbing flash effect
            [webView setBackgroundColor:[CPColor colorWithHexString:@"232323"]];

            /* [webView setScrollMode:CPWebViewScrollNone]; */

            

            // This is for preventing iframe from blocking parent page scrolling
            webView._iframe.style.pointerEvents = "none";

            /* console.info(rowData); */
            if([rowData valueForKey:@"codeFileURL"]){
                var url = [CPURL URLWithString:[rowData valueForKey:@"codeFileURL"]];
                var request = [CPURLRequest requestWithURL:url];
                [request setValue:@"CodeFragment" forHTTPHeaderField:@"DownloadType"];
                [request setValue:row forHTTPHeaderField:@"RowIndex"];
                var connection = [[CPURLConnection alloc] initWithRequest:request delegate:self];
            } else {
                [webView setMainFrameURL:@"data:text/html;base64," + [[self htmlData:rowData row:row] base64]];
            }
            /* [webView loadHTMLString:_codeTemplate.replace("__REPLACE_THIS__", [rowData valueForKey:@"code"]) baseURL:@"/index.html"]; */
            
            
            return subStepCode;
    }


    return nil;
}

- (float) tableView:(CPTableView)tableView heightOfRow:(CPInteger)rowIndex
{
    var rowData = [_tableDataArray objectAtIndex:rowIndex];
    var rowDimensionsKey = "" + _currentMainStepNo + "_" + rowIndex;
    var rowDimensions = [_rowDimensionsDictionary valueForKey:rowDimensionsKey];
    
    /* var previouslyRecordedDimensionType = [rowDimensions type]; */
    var currentRowDimensionType = [rowData valueForKey:@"type"]; 
   
    if(currentRowDimensionType != CODE_TYPE && rowDimensions && _subStepsDidChange == NO){
        return [rowDimensions rowSize].height;
    } else {
        
        // After we recalculated all the rows set _subStepsDidChange back to NO.
        _subStepsDidChange = [_tableDataArray count]-1 == rowIndex ? NO : YES;
        var rowSize;
        var labelSize;
        switch([rowData valueForKey:@"type"]){

            case IMAGE_TYPE:
                rowSize = [self imageSizeForTableView:tableView withRowData:rowData];
                break;

            case TEXT_TYPE:
                // Calculate targetRowHeight 
                labelSize = [self textFieldSizeForTableView:tableView row:rowIndex rowData:rowData];
                // and return it.
                rowSize = CGSizeMake([_tableView frameSize].width, labelSize.height < 20 ? 19 : labelSize.height);
                break;

            case CODE_TYPE:
                // Since there's no way for us to know beforehand the height of the code html in the iframe,
                // html page will calculate its own height and let us know milliseconds later using 
                // browser window messaging API. See initWithCibName:bundle: method above.
                rowSize = [rowDimensions rowSize] ? [rowDimensions rowSize] : nil;
                break;
        }    

        [self saveRowSize:rowSize andLabelSize:labelSize forSubStepRow:rowIndex];
        return rowSize != nil ? rowSize.height : 99;
    } 
}

@end


@implementation RowModel : CPObject
{
    CGSize      _rowSize @accessors(property=rowSize);
    CGSize      _labelSize @accessors(property=labelSize);
    int         _type @accessors(property=type);
}

- (id) initWithRowSize:(float)rowSize labelSize:(float)labelSize type:(int)type
{
    self = [super init];
    _rowSize = rowSize;
    _labelSize = labelSize;
    _type = type;
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
    if(_rowSize)
        [encoder encodeSize:_rowSize forKey:@"rowSize"];
    if(_labelSize)
        [encoder encodeSize:_labelSize forKey:@"labelSize"];
    if(_type)
        [encoder encodeObject:_type forKey:@"type"];
}

- (id) initWithCoder:(CPCoder)decoder
{
    self = [super init];
    if(self){
        _rowSize = [decoder decodeSizeForKey:@"rowSize"];
        _labelSize = [decoder decodeSizeForKey:@"labelSize"];
        _type = [decoder decodeIntForKey:@"type"];
    }
    return self;
}

@end
