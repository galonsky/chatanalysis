//
//  Word.m
//  ChatAnalysis
//
//  Created by Alex Galonsky on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Word.h"


@implementation Word

- (id)initWithWord:(NSString *)w
{
	[super init];
	word = w;
	count = 1;
	return self;
}
- (void)increment
{
	count++;
}


@synthesize count;
@synthesize word;

@end
