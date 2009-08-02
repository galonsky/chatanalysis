//
//  ChatAppController.h
//  ChatAnalysis
//
//  Created by Alex Galonsky on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ChatAppController : NSObject {
	IBOutlet NSLevelIndicator *completion;
	IBOutlet NSTableView *wordView;
	IBOutlet NSTableView *buddyView;
	NSArray *chatContents;
	NSArray *instantMessages;
	NSArray *sortedWords;
	NSArray *sortedBuddies;
	NSMutableDictionary *freqs;
	NSMutableDictionary *buddyFreqs;

}
- (IBAction)pushButton:(id)sender;
- (void)loadFile:(NSString *)myPath;
- (void)getFiles;
- (void)sort;

@end
