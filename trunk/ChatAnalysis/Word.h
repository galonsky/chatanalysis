//
//  Word.h
//  ChatAnalysis
//
//  Created by Alex Galonsky on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Word : NSObject {
	NSString *word;
	int count;
}
- (id)initWithWord:(NSString *)w;
- (void)increment;
@property(readwrite, assign) int count;
@property(readwrite, assign) NSString *word;
@end
