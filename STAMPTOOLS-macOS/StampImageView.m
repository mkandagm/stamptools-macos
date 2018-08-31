#import "StampImageView.h"

@implementation StampImageView

/*
 // can not display high quality.
- (void)drawRect:(NSRect)dirtyRect {
	// set any NSColor for filling, say white:
	[[NSColor grayColor] setFill];
	NSRectFill(dirtyRect);
	[super drawRect:dirtyRect];
}
*/

- (unsigned int)draggingSourceOperationMaskForLocal:(BOOL)isLocal
{
	return  isLocal?NSDragOperationNone:NSDragOperationCopy;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	//NSLog(@"draggingEntered = %@", sender);
	NSPasteboard *pboard = [sender draggingPasteboard];
	unsigned int sourceDragMask = [sender draggingSourceOperationMask];

    if ([NSImage canInitWithPasteboard:pboard]) {
		if (sourceDragMask & NSDragOperationGeneric) {
			return NSDragOperationNone;
		}
	}
	return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	//NSLog(@"performDragOperation = %@", sender);
	return NO;
}

- (void)concludeDragOperation:(id )sender
{
	//NSLog(@"concludeDragOperation = %@", sender);
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSImage* image = [[NSImage allocWithZone:[self zone]]
				initWithPasteboard:pboard];
	[self setImage:image];
	[self setNeedsDisplay:YES];
}

- (void)draggingUpdated:(id <NSDraggingInfo>)sender
{
	//NSLog(@"draggingUpdated = %@", sender);
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
//	NSLog(@"draggingEnded = %@", sender);
//	NSWindow* targetwindow=[sender draggingDestinationWindow];
//	NSLog(@"Target window=%@", [targetwindow title] );
//	NSLog([[sender draggingDestinationWindow] className]); 
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
	//NSLog(@"draggingExited = %@", sender);
	
}


- (void)setTempPdfpath:(NSString*)path
{
	[m_pdfTempURL release];
	m_pdfTempURL=[[NSURL alloc] initFileURLWithPath:path];
}

-(void)mouseDown:(NSEvent*)event
{
//    NSURL* pdfURL=[NSURL fileURLWithPath:m_pdfTempfilePath];
//    NSImage* dragimage=[[NSImage alloc] initWithContentsOfURL:pdfURL];
    NSImage* dragimage=[[NSImage alloc] initWithContentsOfURL:m_pdfTempURL];
    [dragimage autorelease];
    
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    point.x -= [dragimage size].width/2;
    point.y -= [dragimage size].height/2;
	  
    NSData * pdfData = [NSData dataWithContentsOfURL : m_pdfTempURL];

	NSPasteboard* pasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
    /*
    [pasteboard declareTypes:[NSArray arrayWithObjects:NSPDFPboardType, NSTIFFPboardType,nil] owner:self];
    [pasteboard setData:pdfData forType:NSPDFPboardType ];
    [pasteboard setData:[dragimage TIFFRepresentation] forType:NSTIFFPboardType ];
    */
	NSString* filepath=[m_pdfTempURL absoluteString];
    NSArray *fileList = [NSArray arrayWithObjects:filepath, nil];

	[pasteboard declareTypes:[NSArray arrayWithObjects:NSPDFPboardType, NSFilenamesPboardType, nil] owner:nil];
    [pasteboard setData:pdfData forType:NSPDFPboardType ];
	[pasteboard setPropertyList:fileList forType:NSFilenamesPboardType];
	[pasteboard setData:[dragimage TIFFRepresentation] forType:NSTIFFPboardType ];

	
 
	[self dragImage:dragimage
                 at:point
             offset:NSZeroSize
              event:event
         pasteboard:pasteboard
             source:nil
          slideBack:YES];
	//NSLog(@"mouseDown dragImage ended.");
}


@end
