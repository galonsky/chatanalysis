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
#import "Word.h"
#import "AGRegex.h"



@implementation ChatAppController
- (IBAction)pushButton:(id)sender
{
	freqs = [[NSMutableDictionary alloc] init];
	buddyFreqs = [[NSMutableDictionary alloc] init];
	[self getFiles];
}

//From Logorrhea/Logtastic
- (void)loadFile:(NSString *)myPath
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
	
	for(int i = 0; i < [instantMessages count]; i++)
	{
		Presentity *sender = [[instantMessages objectAtIndex:i] sender];
		
		//NSLog(@"%@", [sender senderID]);
		if([sender senderID] == nil) continue;
		
		if(![[sender senderID] isEqual:@"bhound89"])
		{
			if([buddyFreqs objectForKey:[sender senderID]] == nil)
			{
				Word *newName = [[Word alloc] initWithWord:[sender senderID]];
				[buddyFreqs setObject:newName forKey:[sender senderID]];
			}
			else
			{
				Word *current = [buddyFreqs objectForKey:[sender senderID]];
				[current increment];
			}
		}
		
		NSString *message = [[[instantMessages objectAtIndex:i] text] string];
		NSArray *words = [message componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",.!?/()\"*: "]];
		
		for(NSString *word in words)
		{
			word = [word lowercaseString];
			if([word isEqual:@""]) continue;
			if([freqs objectForKey:word] == nil)
			{
				Word *newWord = [[Word alloc] initWithWord:word];
				[freqs setObject:newWord forKey:word];
			}
			else
			{
				Word *current = [freqs objectForKey:word];
				[current increment];
			}
		}
	}
}
//From Logorrhea
- (void)getFiles
{
	//Grab path to iChats folder
    NSString *pathToChats = @"~/Documents/iChats";
	
	pathToChats = [pathToChats stringByExpandingTildeInPath];
	NSFileManager *manager = [NSFileManager defaultManager];
	NSString *pathToChatsWithSlash = [pathToChats stringByAppendingString:@"/"];
	NSArray *contents = [manager subpathsAtPath:pathToChats];
	
    for (unsigned int i=0; i < [contents count]; i++)
	{
		NSString *pathName = [contents objectAtIndex:i];
		NSString *fileName = [pathName lastPathComponent];
		NSString *pathExtension = [fileName pathExtension];
		if([pathExtension isEqual:@"ichat"] || [pathExtension isEqual:@"chat"])
		{
			//NSLog(@"%@", [pathToChatsWithSlash stringByAppendingString:pathName]);
			[self loadFile:[pathToChatsWithSlash stringByAppendingString:pathName]];
		}
    }
    [self sort];
}

- (void)sort
{
	NSArray *wordList = [freqs allValues];
	NSArray *buddyList = [buddyFreqs allValues];
	
	NSSortDescriptor *sortDescriptor;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"count" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	NSArray *sortedWords = [wordList sortedArrayUsingDescriptors:sortDescriptors];
	NSArray *sortedBuddies = [buddyList sortedArrayUsingDescriptors:sortDescriptors];
	
//	for(Word *buddy in sortedBuddies)
//	{
//		NSLog(@"%@, %@", [buddy valueForKey:@"word"], [buddy valueForKey:@"count"]);
//	}
	
//	for(Word *currentWord in sortedWords)
//	{
//		NSLog(@"%@, %@", [currentWord valueForKey:@"word"], [currentWord valueForKey:@"count"]);
//	}
}
@end
