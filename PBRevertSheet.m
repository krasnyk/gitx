//
//  PBRevertSheet.m
//  GitX
//
//  Created by Tomasz Krasnyk on 11-01-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PBRevertSheet.h"

@interface PBRevertSheet()
@property (nonatomic, retain) PBGitRepository *repository;

+ (void) beginRevertSheetForRepository:(PBGitRepository *)repo withPrefilledCommit:(NSString *) commit;
- (void) updateRevertButton;
@end


@implementation PBRevertSheet
@synthesize repository;

#pragma mark -

- (id) initWithWindowNibName:(NSString *)windowNibName {
	if (self = [super initWithWindowNibName:windowNibName]) {
		
	}
	return self;
}

- (void) beginRevertSheetForRepository:(PBGitRepository *)repo withPrefilledCommit:(NSString *) commit {
	self.repository = repo;
	
	[self window];
	
	if (commit) {
		[revertCommitTextField setStringValue:commit];
	}
	[self updateRevertButton];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:NSControlTextDidChangeNotification object:revertCommitTextField];
	[NSApp beginSheet:[self window] modalForWindow:[self.repository.windowController window] modalDelegate:self didEndSelector:nil contextInfo:NULL];
}

+ (void) beginRevertSheetForRepository:(PBGitRepository *)repo withPrefilledCommit:(NSString *) commit {
	PBRevertSheet *sheet = [[self alloc] initWithWindowNibName:@"PBRevertSheet"];
	[sheet beginRevertSheetForRepository:repo withPrefilledCommit:commit];
}

#pragma mark -
#pragma mark actions

- (IBAction) revertClicked:(id) sender {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[NSApp endSheet:[self window]];
	[[self window] orderOut:self];
	
	[self.repository.resetController revertCommit:[revertCommitTextField stringValue] noCommit:[noCommmitButton state] == NSOnState];
}

- (IBAction) cancelClicked:(id) sender {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[NSApp endSheet:[self window]];
	[[self window] orderOut:self];
}

- (IBAction) textChanged:(id) sender {
	[self updateRevertButton];
}

- (void) updateRevertButton {
	[revertButton setEnabled:[[revertCommitTextField stringValue] length] > 0];
}

@end
