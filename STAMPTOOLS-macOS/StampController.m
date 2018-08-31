#import <QuickTime/QuickTime.h>
#import "StampController.h"
#import "GlyphDrawing.h"

@implementation StampController

-(id)init
{
	m_isStampNowdate=TRUE;
	m_isDoubleCircle=FALSE;
    m_thickness = 3.0;
	m_size=60;
	m_strTitle=@"Untitled";
	m_strName=@"Untitled";
	m_fontSizeTOP=16;
	m_fontSizeMID=16;
	m_fontSizeBOT=16;
	m_dateFormat=0;
	m_useCustomDateFormat=FALSE;
	m_rotation=0;
	
	return [super init];
}

- (NSSize)drawerWillResizeContents:(NSDrawer *)sender toSize:(NSSize)contentSize
{
	NSSize drawerSize=NSMakeSize(300, 200);
	return drawerSize;
}


- (BOOL)drawerShouldOpen:(NSDrawer *)sender
{
	NSWindow* parentView=[sender parentWindow];
	NSRect largeSize=[parentView frame];
	largeSize.size.height+=80;
	[parentView setFrame:largeSize display:YES animate:YES];
	[m_togglebutton setIntValue:1];

	return YES;
}

- (void)drawerWillOpen:(NSNotification *)notification
{
	NSSize drawerSize=NSMakeSize(300, 200);
	[m_drawer setContentSize:drawerSize];
}
- (void)drawerDidOpen:(NSNotification *)notification
{
}
- (void)drawerWillClose:(NSNotification *)notification
{
	NSSize drawerSize=NSMakeSize(100, 200);
	[m_drawer setContentSize:drawerSize];
}
- (void)drawerDidClose:(NSNotification *)notification
{
}

- (BOOL)drawerShouldClose:(NSDrawer *)sender
{
	NSWindow* parentView=[sender parentWindow];
	NSRect largeSize=[parentView frame];
	largeSize.size.height-=80;
	[parentView setFrame:largeSize display:YES animate:YES];
	[m_togglebutton setIntValue:0];
	

	return YES;
}
 
- (IBAction)toogledrawer:(id)sender;
{
	[m_drawer toggle:sender];
}

- (void)OnTimer:(NSTimer*)aTimer
{
	//NSLog(@"OnTimer");
	[self copyToClipboard:nil];
}


- (void)mouseDown:(NSEvent*)theEvent
{
	NSPoint origin = [MainWindow frame].origin;
	NSPoint old_p = [MainWindow convertBaseToScreen:[theEvent locationInWindow]];
	while ((theEvent = [MainWindow nextEventMatchingMask:NSLeftMouseDraggedMask|NSLeftMouseUpMask])
		   && ([theEvent type] != NSLeftMouseUp)) {
		NSPoint new_p = [MainWindow convertBaseToScreen:[theEvent locationInWindow]];
		origin.x += new_p.x - old_p.x;
		origin.y += new_p.y - old_p.y;
		[MainWindow setFrameOrigin:origin];
		old_p = new_p;
	}
}

/*
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)inSender
{
    return YES;
}
 */
 
- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
	[userdefault setInteger:m_size forKey:@"stampsize"];
	[userdefault setFloat:m_thickness forKey:@"thickness"];
	[userdefault setInteger:m_isDoubleCircle forKey:@"isdoublecircle"];
	[userdefault setInteger:m_isStampNowdate forKey:@"isstampnowdate"];
	[userdefault setObject:m_strTitle forKey:@"strtitle"];
	[userdefault setObject:m_strName forKey:@"strname"];

	[userdefault setInteger:m_fontSizeTOP forKey:@"fontsizetop"];
	[userdefault setInteger:m_fontSizeMID forKey:@"fontsizemid"];
	[userdefault setInteger:m_fontSizeBOT forKey:@"fontsizebot"];
	[userdefault setObject:m_fontNameTOP forKey:@"fontnametop"];
	[userdefault setObject:m_fontNameMID forKey:@"fontnamemid"];
	[userdefault setObject:m_fontNameBOT forKey:@"fontnamebot"];
	
	[userdefault setInteger:m_dateFormat forKey:@"dateformat"];
	[userdefault setInteger:m_useCustomDateFormat forKey:@"useSystemDateFormat"];
	
	[userdefault setInteger:m_rotation forKey:@"stampRotation"];

    [userdefault setInteger:1 forKey:@"stampcolorsaved"];
    [userdefault setFloat:[m_stampcolor redComponent] forKey:@"stampcolorRed"];
    [userdefault setFloat:[m_stampcolor greenComponent] forKey:@"stampcolorGreen"];
    [userdefault setFloat:[m_stampcolor blueComponent] forKey:@"stampcolorBlue"];

	[userdefault synchronize];
}


- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
 	if( userdefault ){
		m_size = [userdefault integerForKey:@"stampsize"];
        m_thickness = [userdefault floatForKey:@"thickness"];
		m_isDoubleCircle = [userdefault integerForKey:@"isdoublecircle"];
		m_isStampNowdate = [userdefault integerForKey:@"isstampnowdate"];
		m_strTitle = [userdefault stringForKey:@"strtitle"];
		m_strName = [userdefault stringForKey:@"strname"];

		m_fontSizeTOP = [userdefault integerForKey:@"fontsizetop"];
		m_fontSizeMID = [userdefault integerForKey:@"fontsizemid"];
		m_fontSizeBOT = [userdefault integerForKey:@"fontsizebot"];
		m_fontNameTOP = [userdefault stringForKey:@"fontnametop"];
		m_fontNameMID = [userdefault stringForKey:@"fontnamemid"];
		m_fontNameBOT = [userdefault stringForKey:@"fontnamebot"];
		
		m_dateFormat = [userdefault integerForKey:@"dateformat"];
		m_useCustomDateFormat = [userdefault integerForKey:@"useSystemDateFormat"];
		
		m_rotation = [userdefault integerForKey:@"stampRotation"];
		[m_sliderRotationValue setIntValue:m_rotation];
        
  		BOOL stampcolorsaved = [userdefault integerForKey:@"stampcolorsaved"];
        if( stampcolorsaved ){
            CGFloat redval=[userdefault floatForKey:@"stampcolorRed"];
            CGFloat greenval=[userdefault floatForKey:@"stampcolorGreen"];
            CGFloat blueval=[userdefault floatForKey:@"stampcolorBlue"];
            m_stampcolor=[NSColor colorWithDeviceRed:redval green:greenval blue:blueval alpha:1.0];
		}
        else {
            m_stampcolor=[NSColor redColor];
       }
	}
	if( m_thickness==0 ){ m_thickness=2.0; }
	if( m_size==0 ){ m_size=60; }
	if( m_fontSizeTOP==0 ){ m_fontSizeTOP=16; }
	if( m_fontSizeMID==0 ){ m_fontSizeMID=16; }
	if( m_fontSizeBOT==0 ){ m_fontSizeBOT=16; }
	if( [m_strTitle length]==0 ){	m_strTitle=@"Untitled"; }
	if( [m_strName length]==0 ){	m_strName=@"Untitled"; }
	if( [m_fontNameTOP length]==0 ){	m_fontNameTOP=@"Osaka"; }
	if( [m_fontNameMID length]==0 ){	m_fontNameMID=@"Osaka"; }
	if( [m_fontNameBOT length]==0 ){	m_fontNameBOT=@"Osaka"; }

	m_isStampNowdate=TRUE; // 常に今の日付を適用する
    
    [m_sliderThickness setFloatValue:m_thickness];
	[m_sliderStampsize setIntValue:m_size/2];
	[m_checkboxIsdoublecircle setIntValue:m_isDoubleCircle];
	[m_checkboxIsnowdate setIntValue:m_isStampNowdate];
	[m_stampstrTOP setStringValue:m_strTitle];
	[m_stampstrBOT setStringValue:m_strName];
	[m_stampDate setDateValue:[NSDate date]];
	[m_stampDate setEnabled:!m_isStampNowdate];
    [m_stampColorWell setColor:m_stampcolor];
	[m_sliderRotation setIntValue:m_rotation];
	
	 NSString* definedTables[]={
		 @"'YY/MM/DD",@"YYYY/MM/DD",
		 @"DD/MM/'YY",@"DD/MM/YYYY",
		 @"MM/DD/'YY",@"MM/DD/YYYY",nil
	 };
	 [m_combo_dateFormat removeAllItems];
	 long index=0;
	 while(TRUE){
		 if( definedTables[index]==nil ){
			 break;
		 }
		 [m_combo_dateFormat addItemWithTitle:definedTables[index]];
		 index++;
	 }
	[m_combo_dateFormat selectItemAtIndex:m_dateFormat];

	[m_drawer setDelegate:self];
	NSSize drawerSize=NSMakeSize(300, 200);
	[m_drawer setMinContentSize:drawerSize];
	[m_drawer setMaxContentSize:drawerSize];
	[m_drawer setContentSize:drawerSize];
	
    [MainWindow setLevel:NSNormalWindowLevel];
	[MainWindow setMovableByWindowBackground:YES];
	
	[self copyToClipboard:nil];
	[NSTimer scheduledTimerWithTimeInterval:30.0
									 target:self
								   selector:@selector(OnTimer:)
								   userInfo:nil
									repeats:YES];		

}

- (IBAction)changeStampRotationField:(id)sender
{
	m_rotation=[m_sliderRotationValue intValue];
	[m_sliderRotation setIntValue:m_rotation];
	[self copyToClipboard:nil];
}

- (IBAction)changeStampRotation:(id)sender
{
	m_rotation=[m_sliderRotation intValue];
	[m_sliderRotationValue setIntValue:m_rotation];
	[self copyToClipboard:nil];
}

- (IBAction)changeStampStrTOP:(id)sender
{
	m_strTitle=[sender stringValue];
	[self copyToClipboard:nil];
}

- (IBAction)changeStampStrBOT:(id)sender
{
	m_strName=[sender stringValue];
	[self copyToClipboard:nil];
}


- (IBAction)changeThicness:(id)sender
{
	m_thickness=[sender floatValue];
	[self copyToClipboard:nil];
}

- (IBAction)changeStampSize:(id)sender
{
	m_size=(short)[sender floatValue]*2;
	[self copyToClipboard:nil];
}
- (IBAction)changeStampRing:(id)sender
{
	m_isDoubleCircle=(short)[sender intValue];
	[self copyToClipboard:nil];
}

- (IBAction)changeStampDate:(id)sender
{
	m_isStampNowdate=(short)[sender intValue];
	[m_stampDate setEnabled:!m_isStampNowdate];
	[self copyToClipboard:nil];
}

- (IBAction)changeStampDatePicker:(id)sender
{
	[self copyToClipboard:nil];
}

- (IBAction)changeStampColor:(id)sender
{
    m_stampcolor=[m_stampColorWell color];
    
	[self copyToClipboard:nil];
}


- (void)changeFont:(id)sender
{
	NSFont* font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
	NSFont* convertedFont = [sender convertFont:font];
	
	switch (m_fontButtonTag) {
		case 11:	
			m_fontNameTOP = [convertedFont fontName];
			m_fontSizeTOP=[convertedFont pointSize];
			break;
		case 12:	
			m_fontNameMID = [convertedFont fontName];	
			m_fontSizeMID=[convertedFont pointSize];
			break;
		case 13:	
			m_fontNameBOT = [convertedFont fontName];
			m_fontSizeBOT=[convertedFont pointSize];
			break;
	}
	[self copyToClipboard:nil];
}

- (IBAction)changeDateFormat:(id)sender
{
	m_dateFormat=[m_combo_dateFormat indexOfSelectedItem];
	[self copyToClipboard:nil];
}

- (IBAction)changeStampFont:(id)sender
{
	m_fontButtonTag = [sender tag];		

	[m_stampstrTOP setEnabled:FALSE];
	[m_stampstrBOT setEnabled:FALSE];
	
	NSString*   lastFontname;
	int lastFontsize=[NSFont systemFontSize];
	switch (m_fontButtonTag) {
		case 11:	
			lastFontname = m_fontNameTOP;
			lastFontsize=m_fontSizeTOP;
			break;
		case 12:	
			lastFontname = m_fontNameMID;	
			lastFontsize=m_fontSizeMID;
			break;
		case 13:	
			lastFontname = m_fontNameBOT;	
			lastFontsize=m_fontSizeBOT;
			break;
	}
	
	NSFontPanel*	fontPanel;
	fontPanel = [NSFontPanel sharedFontPanel];
	if (![fontPanel isVisible]) {
		[fontPanel orderFront:self];
	}
	[[NSFontManager sharedFontManager] 
		setSelectedFont:[NSFont fontWithName:lastFontname size:lastFontsize] 
		isMultiple:NO];

	[m_stampstrTOP setEnabled:TRUE];
	[m_stampstrBOT setEnabled:TRUE];
}

-(CGContextRef) createPDFContext:(CGRect)inMediaBox path:(CFStringRef) path
{
    CGContextRef myOutContext = NULL;
    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, // 1
                                         path,
                                         kCFURLPOSIXPathStyle,
                                         false);
    if (url != NULL) {
        myOutContext = CGPDFContextCreateWithURL (url,// 2
                                                  &inMediaBox,
                                                  NULL);
        CFRelease(url);// 3
    }
    return myOutContext;// 4
}

// The lock will keep the cache thread safe. You'll need some place to set 
// it up though
CG_EXTERN void CGFontGetGlyphsForUnichars(CGFontRef font, void* chars, CGGlyph* glyphs, int len)
CG_AVAILABLE_STARTING(__MAC_10_2, __IPHONE_2_0);

-(void)drawStringRect:(NSString*)str fontname:(NSString*)fontName fontsize:(CGFloat)fontSize rect:(NSRect)drawrect context:(CGContextRef)cgcontext
{
    NSMutableDictionary *stringAttributes = [NSMutableDictionary dictionary];
    // Set a font and specify a "fill" color
    [stringAttributes setObject: [NSFont fontWithName:fontName size:fontSize] forKey: NSFontAttributeName];
    [stringAttributes setObject: m_stampcolor forKey: NSForegroundColorAttributeName];


    CGFontRef fontref = CGFontCreateWithFontName((CFStringRef)fontName);
    NSSize drawsize=[str sizeWithAttributes:stringAttributes];
    int accent=CGFontGetAscent(fontref);
    int descent=CGFontGetDescent(fontref);
    int perem=CGFontGetUnitsPerEm(fontref);
    CGFloat pixelaccent=(float)accent*fontSize/(float)perem;
    CGFloat pixeldescent=(float)descent*fontSize/(float)perem;
    CGFloat pixelHeight=pixelaccent+pixeldescent;
    
    CGContextSelectFont (cgcontext, [fontName UTF8String], fontSize, kCGEncodingFontSpecific);

    CGGlyph _glyphs[[str length]];
    unichar _chars[[str length]];
    int i;
    for(i = 0; i < [str length]; i++) {
        _chars[i] = [str characterAtIndex:i];
    }
    
    //CMFontGetGlyphsForUnichars(fontref, _chars, _glyphs, [str length]);
    CGFontGetGlyphsForUnichars(fontref, _chars, _glyphs, [str length]);

    CGContextShowGlyphsAtPoint(cgcontext, drawrect.origin.x+(drawrect.size.width-drawsize.width)/2, drawrect.origin.y+(drawrect.size.height-pixelHeight)/2, _glyphs, [str length]);
    CGFontRelease(fontref);
}

- (NSString*)createStampImage
{
    
///	NSString* tempFilename=[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp-stamptools.pdf"];
    
	
	NSString* tempFilename=[NSHomeDirectoryForUser(NSUserName()) stringByAppendingPathComponent:@"tmp-stamptools.pdf"];
    
    CGFloat stampFontSizeTop=m_fontSizeTOP*m_size/100;
    CGFloat stampFontSizeMid=m_fontSizeMID*m_size/100;
    CGFloat stampFontSizeBot=m_fontSizeBOT*m_size/100;
    CGFloat stampFramesize=m_size;
    CGRect stampRect=CGRectMake(10,10,stampFramesize+3,stampFramesize+3);
	if(m_isDoubleCircle){
 //       stampRect=CGRectMake(5-m_thickness,5-m_thickness,stampFramesize,stampFramesize);
    }
    CGContextRef pdfContext = [self createPDFContext:stampRect path:(CFStringRef)tempFilename];
    
    CGRect mediaBox=CGRectMake(0,0,stampFramesize+25,stampFramesize+25);
	if(m_isDoubleCircle){
 //       mediaBox=CGRectMake(0,0,m_size+10+m_thickness*3,m_size+10+m_thickness*3);
    }
    CGContextBeginPage (pdfContext, &mediaBox);
    
	double angle=(double)-m_rotation/360.0*(M_PI*2.0);
	CGContextTranslateCTM(pdfContext, mediaBox.size.width/2.0,mediaBox.size.height/2.0);
	CGContextRotateCTM(pdfContext, angle );
	CGContextTranslateCTM(pdfContext, -mediaBox.size.width/2.0, -mediaBox.size.height/2.0);
	
    //[m_stampcolor set];
    CGContextSetRGBFillColor (pdfContext, 
                              [m_stampcolor redComponent], 
                              [m_stampcolor greenComponent], 
                              [m_stampcolor blueComponent]
                              , 1);
    CGContextSetRGBStrokeColor(pdfContext, 
                               [m_stampcolor redComponent], 
                               [m_stampcolor greenComponent], 
                               [m_stampcolor blueComponent]
                               , 1);

 
	if(m_isDoubleCircle){
        CGContextSetLineWidth(pdfContext, m_thickness);
        CGRect innerRect=CGRectInset(stampRect, -m_thickness*2, -m_thickness*2);
        CGContextStrokeEllipseInRect(pdfContext, innerRect);
        CGContextStrokeEllipseInRect(pdfContext, stampRect);
        // set clipping region
        CGContextBeginPath(pdfContext);
        CGContextAddEllipseInRect( pdfContext, stampRect );
        CGContextClosePath(pdfContext);
        CGContextClip(pdfContext);    
	}
	else {
        CGContextSetLineWidth(pdfContext, m_thickness);
        CGContextStrokeEllipseInRect(pdfContext, stampRect);
        // set clipping region
        CGContextBeginPath(pdfContext);
        CGContextAddEllipseInRect( pdfContext, stampRect );
        CGContextClosePath(pdfContext);
        CGContextClip(pdfContext);    
	}

    CGContextSetLineWidth(pdfContext, m_thickness);
    	
	CGFloat frameheight=stampRect.size.height;
	// make 3row rects
	NSRect topRect=NSMakeRect(stampRect.origin.x,stampRect.origin.y,stampRect.size.width,stampRect.size.height);
	NSRect midRect=topRect;
	NSRect botRect=topRect;
    topRect.origin.y+=frameheight/3*2;
	topRect.size.height=(frameheight/3);
	midRect.origin.y+=frameheight/3;
	midRect.size.height=frameheight/3;
    midRect.origin.x=0;
    midRect.size.width=mediaBox.size.width;
	botRect.size.height=(frameheight/3);
    
	// draw upper lower bar
	CGContextStrokeRect(pdfContext, CGRectMake(midRect.origin.x, midRect.origin.y, midRect.size.width, midRect.size.height));
	
    CGContextSetTextDrawingMode (pdfContext, kCGTextFill);
    CGContextSetLineWidth(pdfContext, m_thickness);
       

    [self drawStringRect:m_strTitle fontname:m_fontNameTOP fontsize:stampFontSizeTop rect:topRect context:pdfContext];
	
	
	
	NSDate* stampdate=[NSDate date];
	if( !m_isStampNowdate ){
		stampdate=[m_stampDate dateValue];
	}
	
	//	NSString* definedTables[]={
	//		@"'YY/MM/DD",
	//		@"YYYY/MM/DD",
	//		@"DD/MM/'YY",
	//		@"DD/MM/YYYY",
	//		@"MM/DD/'YY",
	//		@"MM/DD/YYYY",nil
	//	};
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
	switch(m_dateFormat){
		case 0:
			[dateFormatter setDateFormat:@"''yy/MM/dd" ];
			break;
		case 1:
			[dateFormatter setDateFormat:@"yyyy/MM/dd"  ];
			break;
		case 2:
			[dateFormatter setDateFormat:@"dd/MM/''yy"  ];
			break;
		case 3:
			[dateFormatter setDateFormat:@"dd/MM/yyyy"  ];
			break;
		case 4:
			[dateFormatter setDateFormat:@"MM/dd/''yy"  ];
			break;
		case 5:
			[dateFormatter setDateFormat:@"MM/dd/yyyy"  ];
			break;
	}
	
	NSString* dateStr=[dateFormatter stringFromDate:stampdate];
	[dateFormatter release];
	
	[self drawStringRect:dateStr fontname:m_fontNameMID fontsize:stampFontSizeMid rect:midRect context:pdfContext];
    
    [self drawStringRect:m_strName fontname:m_fontNameBOT fontsize:stampFontSizeBot rect:botRect context:pdfContext];
    
    CGContextEndPage (pdfContext);
    CGContextRelease (pdfContext);   
    
    return tempFilename;
}

- (IBAction)copyIntoClipboard:(id)sender
{
    NSString* pdfpath=[self createStampImage];

    NSURL* pdfURL=[NSURL fileURLWithPath:pdfpath];
    NSImage* dragimage=[[NSImage alloc] initWithContentsOfURL:pdfURL];
    [dragimage autorelease];

    NSData * pdfData = [NSData dataWithContentsOfURL : pdfURL];
    
	NSPasteboard* pasteboard = [NSPasteboard pasteboardWithName:NSGeneralPboard];
    [pasteboard declareTypes:[NSArray arrayWithObjects:NSPDFPboardType, NSTIFFPboardType,nil] owner:self];
    [pasteboard setData:pdfData forType:NSPDFPboardType ];
    [pasteboard setData:[dragimage TIFFRepresentation] forType:NSTIFFPboardType ];

}

- (IBAction)copyToClipboard:(id)sender 
{
	
	NSString* pdfpath=[self createStampImage];
    [m_stampImageView setTempPdfpath:pdfpath];
    NSImage* stampimage=[[NSImage alloc] initWithContentsOfFile:pdfpath];
    [stampimage autorelease];
	[m_stampImageView setImage:stampimage];
	[m_stampImageView display];	
	
	// Change DockIcon
//	[NSApp setApplicationIconImage:stampimage];

//	NSPasteboard *pasteboard  = [ NSPasteboard generalPasteboard ]; // ペーストボードを準備
//	[pasteboard declareTypes:[NSArray arrayWithObject:NSPICTPboardType] owner:self];
//	[pasteboard setData : m_stampPICTdata forType : NSPICTPboardType ];

}

// based on QuickDraw
/*
- (void)drawStringInRect:(char*)messtring rect:(Rect)dstrect
{
	FontInfo 	theFontInfo;
	GetFontInfo(&theFontInfo);
	Rect localBox=dstrect;
	short boxWidth = (short) (localBox.right - localBox.left);
	short boxHeight = (short) (localBox.bottom - localBox.top);
	short widthOfString=StringWidth(messtring);
	SInt16 fontHeight=theFontInfo.ascent+theFontInfo.descent;
	// centering
	localBox.top += theFontInfo.ascent;
	localBox.top += (short) ((boxHeight - fontHeight) / 2);
	localBox.left += (short) ((boxWidth - widthOfString) / 2);
	MoveTo(localBox.left,localBox.top);
	DrawString(messtring);
}

- (NSImage*)getStampImage
{
	NSImage* stampimage=NULL;
	short picframesize=100;
	Rect picRect={0,0,picframesize,picframesize};
	const RGBColor	Color_White	= { 65535, 65535, 65535 };
	const RGBColor	Color_Black = { 0, 0, 0 };
	
	PicHandle	thepicture=OpenPicture(&picRect);
    long redcol=[m_stampcolor redComponent]*65535;
    long grncol=[m_stampcolor greenComponent]*65535;
    long blucol=[m_stampcolor blueComponent]*65535;
    
	RGBColor foreColor={redcol,grncol,blucol};
	RGBForeColor(&foreColor);
	RGBBackColor( &Color_White );
	if(m_isDoubleCircle){
		PenSize(1,1);
	}
	else {
		PenSize(3,3);
	}
	Rect framerect={0,0,picframesize,picframesize};
	FrameOval(&framerect);
	if(m_isDoubleCircle){
		InsetRect(&framerect,3,3);
		FrameOval(&framerect);
	}
	// set clipping region
	RgnHandle curClipRgn=NewRgn();
	GetClip(curClipRgn);
	RgnHandle clippingRgn=NewRgn();
	OpenRgn();
	Rect clippingRect=framerect;
	InsetRect(&clippingRect, 1, 1);
	FrameOval(&clippingRect);	
	CloseRgn(clippingRgn);
	SetClip(clippingRgn);
	DisposeRgn(clippingRgn);
	
	short frameheight=framerect.bottom-framerect.top;
	// make 3row rects
	Rect topRect=framerect;
	Rect midRect=framerect;
	Rect botRect=framerect;
	topRect.bottom-=(frameheight/3)*2;
	midRect.top+=frameheight/3;
	midRect.bottom-=frameheight/3;
	midRect.left-=4;
	midRect.right+=4;
	botRect.top+=(frameheight/3)*2;

	PenSize(3,3);
	// draw upper lower bar
	FrameRect(&midRect);
	
	char fontnamestrTOP[128];
	char* fontnamestrtmp=[m_fontNameTOP UTF8String];
	memcpy(fontnamestrTOP+1, fontnamestrtmp, [m_fontNameTOP length]);
	fontnamestrTOP[0]=[m_fontNameTOP length];

	char fontnamestrMID[128];
	fontnamestrtmp=[m_fontNameMID UTF8String];
	memcpy(fontnamestrMID+1, fontnamestrtmp, [m_fontNameMID length]);
	fontnamestrMID[0]=[m_fontNameMID length];
	
	char fontnamestrBOT[128];
	fontnamestrtmp=[m_fontNameBOT UTF8String];
	memcpy(fontnamestrBOT+1, fontnamestrtmp, [m_fontNameBOT length]);
	fontnamestrBOT[0]=[m_fontNameBOT length];
	
	short fontNumberTOP;
	GetFNum(fontnamestrTOP,&fontNumberTOP);
	short fontNumberMID;
	GetFNum(fontnamestrMID,&fontNumberMID);
	short fontNumberBOT;
	GetFNum(fontnamestrBOT,&fontNumberBOT);
	
	NSString* datestr=m_strDate;
	NSLog(@"m_strDate=%@",m_strDate);
	char message2[64];
	char* messagetmp=[datestr UTF8String];
	memcpy(message2+1, messagetmp, [datestr length]);
	message2[0]=[datestr length];

	NSLog(@"m_strTitle=%@",m_strTitle);
	NSData* sjisData1 = [ m_strTitle dataUsingEncoding:NSShiftJISStringEncoding allowLossyConversion:YES];	
	char message1[64];
	messagetmp=[sjisData1 bytes];
	memcpy(message1+1, messagetmp, [sjisData1 length]);
	message1[0]=[sjisData1 length];
	
	NSLog(@"m_strName=%@",m_strName);
	NSData* sjisData2 = [ m_strName dataUsingEncoding:NSShiftJISStringEncoding allowLossyConversion:YES];	
	char message3[64];
	messagetmp=[sjisData2 bytes];
	memcpy(message3+1, messagetmp, [sjisData2 length]);
	message3[0]=[sjisData2 length];
	
	TextFont(fontNumberTOP);
	TextSize(m_fontSizeTOP);
	
	OffsetRect(&topRect,2,3);
	[self drawStringInRect:message1 rect:topRect];

	TextFont(fontNumberMID);
	TextSize(m_fontSizeMID);
	OffsetRect(&midRect,2,0);
	[self drawStringInRect:message2 rect:midRect];
	
	TextFont(fontNumberBOT);
	TextSize(m_fontSizeBOT);
	[self drawStringInRect:message3 rect:botRect];

	SetClip(curClipRgn);
	DisposeRgn(curClipRgn);
	
	ClosePicture();
	if (thepicture) {
		short stampFramesize=m_size;
		Rect stampRect={0,0,stampFramesize,stampFramesize};
		PicHandle stampPict=OpenPicture(&stampRect);
		RGBForeColor( &Color_Black );
		RGBBackColor( &Color_White );
		DrawPicture(thepicture,&stampRect);
		ClosePicture();
		KillPicture(thepicture);
		
		if (stampPict) {
			HLockHi((Handle) stampPict);
			unsigned length = GetHandleSize((Handle) stampPict);
			m_stampPICTdata =[[NSData alloc] initWithBytes:*stampPict length:length];
			stampimage =[[[NSImage alloc] initWithData:m_stampPICTdata] autorelease];
			KillPicture(stampPict);
		}
	}
	return stampimage;
}
*/


@end
