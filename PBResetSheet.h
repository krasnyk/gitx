//
//  PBAddSubmoduleSheet.h
//  GitX
//
//  Created by Tomasz Krasnyk on 11-01-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBGitRepository.h"

@interface PBResetSheet : NSWindowController {
	// view
	IBOutlet NSTextField *resetDestinationCommit;
	IBOutlet NSButton *resetButton;
	IBOutlet NSPopUpButton *resetTypes;
	
	// model
	PBGitRepository *repository;
	NSDictionary *resetTooltips;
	NSArray *resetNames;
}

+ (void) beginResetSheetForRepository:(PBGitRepository *)repo withCommitDestination:(NSString *) commit;

- (IBAction) resetClicked:(id) sender;
- (IBAction) cancelClicked:(id) sender;
- (IBAction) comboBoxChanged:(id) sender;
- (IBAction) textChanged:(id) sender;
@end
