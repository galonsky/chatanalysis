//
//  ChatAppController.h
//  ChatAnalysis
//
//  Created by Alex Galonsky on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ChatAppController : NSObject {
	NSString *myPath;
	NSArray *chatContents;
	NSArray *instantMessages;
}
- (IBAction)pushButton:(id)sender;
- (void)loadContents;

@end
