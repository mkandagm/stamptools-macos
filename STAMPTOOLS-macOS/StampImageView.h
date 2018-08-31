#import <Cocoa/Cocoa.h>

@interface StampImageView : NSImageView {
	NSURL*		m_pdfTempURL;
}

- (void)setTempPdfpath:(NSString*)path;
- (void)mouseDown:(NSEvent*)event;
- (void)draggingUpdated:(id <NSDraggingInfo>)sender;
- (void)draggingExited:(id <NSDraggingInfo>)sender;
- (void)draggingEnded:(id <NSDraggingInfo>)sender;
- (unsigned int)draggingSourceOperationMaskForLocal:(BOOL)isLocal;
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender;
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender;
- (void)concludeDragOperation:(id )sender;
@end
