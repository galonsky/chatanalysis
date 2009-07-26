//
//  ChatAppController.m
//  ChatAnalysis
//
//  Created by Alex Galonsky on 7/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ChatAppController.h"
#import "InstantMessage.h"
#import "Presentity.h"



@implementation ChatAppController
- (IBAction)pushButton:(id)sender
{
	myPath = @"/Users/Alex/Desktop/test.ichat";
	freqs = [[NSMutableDictionary alloc] init];
	[self loadContents];
}

//From Logorrhea/Logtastic
- (void)loadContents
{
	if (chatContents == nil)
	{
		NSData *chatLog = [[NSData alloc] initWithContentsOfMappedFile:myPath];
		if ([myPath hasSuffix:@".ichat"]) // check for tiger-style chat transcript
		{
			NS_DURING
			chatContents = [[NSKeyedUnarchiver unarchiveObjectWithData:chatLog] retain];
			NS_HANDLER
			NSLog(@"Caught exception from NSKeyedUnarchiver - %@", [localException reason]);
			chatContents = nil;
			NS_ENDHANDLER
			[chatLog release];
		}
		else
		{
			NS_DURING
			chatContents = [[NSUnarchiver unarchiveObjectWithData:chatLog] retain];
			NS_HANDLER
			NSLog(@"Caught exception from NSUnarchiver - %@", [localException reason]);
			chatContents = nil;
			NS_ENDHANDLER
			[chatLog release];
		}
		
		if (![chatContents isKindOfClass:[NSArray class]])
		{
			[chatContents release];
			chatContents = nil;
		}
		
		if (chatContents != nil)
		{
			for (unsigned int i=0; i < [chatContents count]; i++)
			{
				id obj = [chatContents objectAtIndex:i];
				if ([obj isKindOfClass:[NSArray class]])
				{
					instantMessages = [obj retain];
					break;
				}
			}
		}
	}
	for(int i = 0; i < [instantMessages count]; i++)
	{
		NSString *message = [[[instantMessages objectAtIndex:i] text] string];
		NSArray *words = [message componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",.!?/()\"* "]];
		
		for(NSString *word in words)
		{
			word = [word lowercaseString];
			if([word isEqual:@""]) continue;
			if([freqs objectForKey:word] == nil)
			{
				[freqs setObject:[NSNumber numberWithInt:1] forKey:word];
			}
			else
			{
				NSNumber *current = [freqs objectForKey:word];
				NSNumber *new = [NSNumber numberWithInt: ([current intValue] + 1)];
				[freqs setObject:new forKey:word];
			}
		}
	}
	for(NSString *key in freqs)
	{
		NSLog(@"%@, %@", key, [freqs objectForKey:key]);
	}
}
@end