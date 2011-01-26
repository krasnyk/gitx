//
//  PBRevertSheet.h
//  GitX
//
//  Created by Tomasz Krasnyk on 11-01-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBGitRepository.h"


@interface PBRevertSheet : NSWindowController {
	// view
	IBOutlet NSTextField *revertCommitTextField;
	IBOutlet NSButton *revertButton;
	IBOutlet NSButton *noCommmitButton;
	
	PBGitRepository *repository;
}

+ (void) beginRevertSheetForRepository:(PBGitRepository *)repo withPrefilledCommit:(NSString *) commit;

- (IBAction) revertClicked:(id) sender;
- (IBAction) cancelClicked:(id) sender;
- (IBAction) textChanged:(id) sender;

@end
