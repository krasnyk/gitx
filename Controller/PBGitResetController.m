//
//  PBGitResetController.m
//  GitX
//
//  Created by Tomasz Krasnyk on 10-11-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PBGitResetController.h"
#import "PBGitRepository.h"
#import "PBCommand.h"

#import "PBResetSheet.h"
#import "PBRevertSheet.h"

static NSString * const kCommandKey = @"command";

@implementation PBGitResetController

- (id) initWithRepository:(PBGitRepository *) repo {
	if (self = [super init]){
        repository = [repo retain];
    }
    return self;
}

- (void) resetHardToHead {
	NSAlert *alert = [NSAlert alertWithMessageText:@"Reseting working copy and index"
									 defaultButton:@"Reset"
								   alternateButton:nil
									   otherButton:@"Cancel"
						 informativeTextWithFormat:@"Are you sure you want to reset your working copy and index? All changes to them will be gone!"];
	
	NSArray *arguments = [NSArray arrayWithObjects:@"reset", @"--hard", @"HEAD", nil];
	PBCommand *cmd = [[PBCommand alloc] initWithDisplayName:@"Reset hard to HEAD" parameters:arguments repository:repository];
	cmd.commandTitle = cmd.displayName;
	cmd.commandDescription = @"Reseting head";
	
	NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObject:cmd forKey:kCommandKey];
	
	[alert beginSheetModalForWindow:[repository.windowController window]
					  modalDelegate:self
					 didEndSelector:@selector(confirmResetSheetDidEnd:returnCode:contextInfo:)
						contextInfo:info];
}

- (void) resetToCommit:(NSString *) commit withType:(NSString *) resetType {
	NSArray *arguments = [NSArray arrayWithObjects:@"reset", [NSString stringWithFormat:@"--%@", resetType], commit, nil];
	PBCommand *cmd = [[PBCommand alloc] initWithDisplayName:@"Reset..." parameters:arguments repository:repository];
	cmd.commandTitle = cmd.displayName;
	cmd.commandDescription = @"Resetting repository";
	[cmd invoke];
}

- (void) reset {
	[self resetToDestinationCommit:nil];
}

- (void) resetToDestinationCommit:(NSString *) destinationCommit {
	[PBResetSheet beginResetSheetForRepository:repository withCommitDestination:destinationCommit];
}

- (void) showRevertSheetWithPrefilledCommit:(NSString *) prefilledCommit {
	[PBRevertSheet beginRevertSheetForRepository:repository withPrefilledCommit:prefilledCommit];
}

- (void) showRevertSheet {
	[PBRevertSheet beginRevertSheetForRepository:repository withPrefilledCommit:nil];
}

- (void) revertCommit:(NSString *) commitToRevert noCommit:(BOOL) noCommitOn {
	NSMutableArray *arguments = [NSMutableArray arrayWithObjects:@"revert", @"--no-edit", nil];
	if (noCommitOn) {
		[arguments addObject:@"-n"];
	}
	[arguments addObject:commitToRevert];
	
	PBCommand *cmd = [[PBCommand alloc] initWithDisplayName:@"Revert..." parameters:arguments repository:repository];
	cmd.commandTitle = cmd.displayName;
	cmd.commandDescription = @"Reverting repository";
	[cmd invoke];
}

- (NSArray *) menuItems {
	NSMenuItem *resetHeadHardly = [[NSMenuItem alloc] initWithTitle:@"Reset hard to HEAD" action:@selector(resetHardToHead) keyEquivalent:@""];
	[resetHeadHardly setTarget:self];
	
	NSMenuItem *reset = [[NSMenuItem alloc] initWithTitle:@"Reset..." action:@selector(reset) keyEquivalent:@""];
	[reset setTarget:self];
	
	NSMenuItem *revert = [[NSMenuItem alloc] initWithTitle:@"Revert..." action:@selector(showRevertSheet) keyEquivalent:@""];
	[revert setTarget:self];
	
	return [NSArray arrayWithObjects:resetHeadHardly, reset, revert, nil];
}

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem {
	BOOL shouldBeEnabled = YES;
	SEL action = [menuItem action];
	if (action == @selector(reset)) {
		shouldBeEnabled = YES;
		//TODO missing implementation
	}
	return shouldBeEnabled;
}

- (void) dealloc {
	[repository release];
	[super dealloc];
}

#pragma mark -
#pragma mark Confirm Window

- (void) confirmResetSheetDidEnd:(NSAlert *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    [[sheet window] orderOut:nil];
	
	if (returnCode == NSAlertDefaultReturn) {
		PBCommand *cmd = [(NSDictionary *)contextInfo objectForKey:kCommandKey];
		[cmd invoke];
	}
}


@end
