#import <Cocoa/Cocoa.h>
#import "StampImageView.h"


@interface StampController : NSObject<NSDrawerDelegate>
{
    IBOutlet id					MainWindow;
	IBOutlet StampImageView*	m_stampImageView;
	IBOutlet NSSlider*			m_sliderStampsize;
	IBOutlet NSSlider*			m_sliderThickness;
	IBOutlet NSSlider*			m_sliderRotation;
	IBOutlet NSTextField*		m_sliderRotationValue;
	IBOutlet NSButton*			m_checkboxIsdoublecircle;
	IBOutlet NSTextField*		m_stampstrTOP;
	IBOutlet NSTextField*		m_stampstrBOT;
	IBOutlet NSButton*			m_checkboxIsnowdate;
	IBOutlet NSDatePicker*		m_stampDate;

	IBOutlet NSButton*			m_togglebutton;
	IBOutlet NSDrawer*			m_drawer;
	IBOutlet NSPopUpButton*		m_combo_dateFormat;
	IBOutlet NSColorWell*		m_stampColorWell;

    float       m_thickness;
	NSInteger	m_size;				// size of stamp
	NSInteger	m_isDoubleCircle;	// 
	NSInteger	m_isStampNowdate;	// 
	NSString*	m_strTitle;
	NSString*	m_strName;
	int			m_fontButtonTag;
	NSInteger	m_fontSizeTOP; 
	NSString*	m_fontNameTOP;
	NSInteger	m_fontSizeMID; 
	NSString*	m_fontNameMID;
	NSInteger	m_fontSizeBOT; 
	NSString*	m_fontNameBOT;
	
	NSInteger	m_dateFormat;
	BOOL		m_useCustomDateFormat;
    NSColor*    m_stampcolor;
	NSInteger	m_rotation;

}

- (void)OnTimer:(NSTimer*)aTimer;
- (IBAction)copyToClipboard:(id)sender;
- (IBAction)changeStampSize:(id)sender;
- (IBAction)changeThicness:(id)sender;
- (IBAction)changeStampRing:(id)sender;
- (IBAction)changeStampDate:(id)sender;
- (IBAction)changeStampDatePicker:(id)sender;
- (IBAction)changeStampStrTOP:(id)sender;
- (IBAction)changeStampStrBOT:(id)sender;
- (IBAction)changeStampFont:(id)sender;

- (IBAction)changeDateFormat:(id)sender;
- (IBAction)changeStampColor:(id)sender;

- (IBAction)copyIntoClipboard:(id)sender;
- (IBAction)toogledrawer:(id)sender;

- (IBAction)changeStampRotationField:(id)sender;
- (IBAction)changeStampRotation:(id)sender;


@end
