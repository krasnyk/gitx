//
//  PBAddSubmoduleSheet.m
//  GitX
//
//  Created by Tomasz Krasnyk on 11-01-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PBResetSheet.h"

@interface PBResetSheet()
@property (nonatomic, retain) PBGitRepository *repository;

+ (void) beginResetSheetForRepository:(PBGitRepository *)repo withCommitDestination:(NSString *) commit;
- (void) updateResetButton;
@end


@implementation PBResetSheet
@synthesize repository;

#pragma mark -

- (id) initWithWindowNibName:(NSString *)windowNibName {
	if (self = [super initWithWindowNibName:windowNibName]) {
		resetNames = [[NSArray alloc] initWithObjects:@"soft", @"hard", @"mixed", @"merge", @"keep", nil];
		resetTooltips = [NSDictionary dictionaryWithObjectsAndKeys:
						 @"Does not touch the index file nor the working tree at all, but requires them to be in a good order. This leaves all your changed files \"Changes to be committed\", as git status would put it.", @"soft",
						 @"Matches the working tree and index to that of the tree being switched to.\nAny changes to tracked files in the working tree since destination commit are lost.", @"hard",
						 @"Resets the index but not the working tree (i.e., the changed files are preserved but not marked for commit) and reports what has not been updated.", @"mixed",
						 @"Resets the index to match the tree recorded by the named commit, and updates the files that are different between the named commit and the current commit in the working tree.", @"merge",
						 @"Reset the index to the given commit, keeping local changes in the working tree since the current commit, while updating working tree files without local changes to what appears in the given commit. If a file that is different between the current commit and the given commit has local changes, reset is aborted.", @"keep", nil];
							 
	}
	return self;
}

- (void) beginResetSheetForRepository:(PBGitRepository *)repo withCommitDestination:(NSString *) commit {
	self.repository = repo;
	
	[self window];
	
	if (commit) {
		[resetDestinationCommit setStringValue:commit];
	}
	[resetTypes addItemsWithTitles:resetNames];
	[resetTypes selectItemAtIndex:0];
	[self comboBoxChanged:resetDestinationCommit]; // fill tooltip
	[self updateResetButton];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:NSControlTextDidChangeNotification object:resetDestinationCommit];
	[NSApp beginSheet:[self window] modalForWindow:[self.repository.windowController window] modalDelegate:self didEndSelector:nil contextInfo:NULL];
}

+ (void) beginResetSheetForRepository:(PBGitRepository *)repo withCommitDestination:(NSString *) commit {
	PBResetSheet *sheet = [[self alloc] initWithWindowNibName:@"PBResetSheet"];
	[sheet beginResetSheetForRepository:repo withCommitDestination:commit];
}

#pragma mark -
#pragma mark actions

- (IBAction) resetClicked:(id) sender {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[NSApp endSheet:[self window]];
	[[self window] orderOut:self];
	
	[self.repository.resetController resetToCommit:[resetDestinationCommit stringValue] withType:[resetTypes titleOfSelectedItem]];
}

- (IBAction) cancelClicked:(id) sender {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[NSApp endSheet:[self window]];
	[[self window] orderOut:self];
}

- (IBAction) comboBoxChanged:(id) sender {
	NSString *selectedItem = [resetTypes titleOfSelectedItem];
	
	[resetTypes setToolTip:[resetTooltips objectForKey:selectedItem]];
}

- (IBAction) textChanged:(id) sender {
	[self updateResetButton];
}

- (void) updateResetButton {
	[resetButton setEnabled:[[resetDestinationCommit stringValue] length] > 0];
}

@end
