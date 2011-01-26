//
//  PBGitResetController.h
//  GitX
//
//  Created by Tomasz Krasnyk on 10-11-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PBGitRepository;

@interface PBGitResetController : NSObject {
	PBGitRepository *repository;
}
- (id) initWithRepository:(PBGitRepository *) repo;

- (NSArray *) menuItems;

// showing sheet
- (void) resetToDestinationCommit:(NSString *) destinationCommit;
- (void) reset;

- (void) showRevertSheetWithPrefilledCommit:(NSString *) prefilledCommit;
- (void) showRevertSheet;

// actions
- (void) resetHardToHead;
- (void) resetToCommit:(NSString *) commit withType:(NSString *) resetType;

- (void) revertCommit:(NSString *) commitToRevert noCommit:(BOOL) noCommitOn;

@end
