//
//  KSStackTracer.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 10-02-16.
//
// Copyright 2010 Karl Stenerud
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall remain in place
// in this source code.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "KSStackTracer.h"
#include <execinfo.h>
#include <unistd.h>


/** The maximum number of stack trace lines to use if none is specified. */
#define kDefaultMaxEntries 40

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KSStackTracer);


@implementation KSStackTracer

SYNTHESIZE_SINGLETON_FOR_CLASS(KSStackTracer);

- (id) init
{
	if(nil != (self = [super init]))
	{
		processName_ = [[[NSProcessInfo processInfo] processName] retain];
	}
	return self;
}

- (void) dealloc
{
	[processName_ release];
	[super dealloc];
}

- (NSArray*) generateTrace
{
	return [self generateTraceWithMaxEntries:kDefaultMaxEntries];
}

- (NSArray*) generateTraceWithMaxEntries:(unsigned int) maxEntries
{
	// Get the stack trace from the OS.
	void* callstack[maxEntries];
	int numFrames = backtrace(callstack, maxEntries);
	char** symbols = backtrace_symbols(callstack, numFrames);
	
	// Create StackTraceEntries.
	NSMutableArray* stackTrace = [NSMutableArray arrayWithCapacity:numFrames];
	for(int i = 0; i < numFrames; i++)
	{
		[stackTrace addObject:[KSStackTraceEntry entryWithTraceLine:[NSString stringWithUTF8String:symbols[i]]]];
	}
	
	// symbols was malloc'd by backtrace_symbols() and so we must free it.
	free(symbols);
	
	return stackTrace;
}

- (NSArray*) intelligentTrace:(NSArray*) stackTrace
{	
	unsigned int startOffset = 0;

	// Anything with this process name at the start is going to be part of the
	// exception/signal catching.  We skip that.
	for(unsigned int i = startOffset; i < [stackTrace count]; i++)
	{
		KSStackTraceEntry* entry = [stackTrace objectAtIndex:i];

		if(![processName_ isEqualToString:entry.library])
		{
			startOffset = i;
			break;
		}
	}

	// Beneath that is a bunch of runtime error handling stuff.  We skip this as well.
	for(unsigned int i = startOffset; i < [stackTrace count]; i++)
	{
		KSStackTraceEntry* entry = [stackTrace objectAtIndex:i];
		
		if(0xffffffff == entry.address)
		{
			// Signal handler stack trace is useless up to "0xffffffff 0x0 + 4294967295"
			startOffset = i + 1;
			break;
		}
		if([@"__objc_personality_v0" isEqualToString:entry.selectorName])
		{
			// Exception handler stack trace is useless up to "__objc_personality_v0 + 0"
			startOffset = i + 1;
			break;
		}
	}
	
	// Look for the last point where it was still in our code.
	// If we don't find anything, we'll just use everything past the exception/signal stuff.
	for(unsigned int i = startOffset; i < [stackTrace count]; i++)
	{
		KSStackTraceEntry* entry = [stackTrace objectAtIndex:i];
		
		// If we reach the "main" function, we've exhausted the stack trace.
		// Since we couldn't find anything, start from the previously calculated starting point.
		if([@"main" isEqualToString:entry.selectorName])
		{
			break;
		}
		
		// If we find something from our own code, use one level higher as the starting point.
		if([processName_ isEqualToString:entry.library])
		{
			startOffset = i - 1;
		}
	}

	NSMutableArray* result = [NSMutableArray arrayWithCapacity:[stackTrace count] - startOffset];
	for(unsigned int i = startOffset; i < [stackTrace count]; i++)
	{
		[result addObject:[stackTrace objectAtIndex:i]];
	}
	
	return result;
}


- (NSString*) printableTrace:(NSArray*) stackTrace
{
	NSMutableString* string = [NSMutableString stringWithCapacity:[stackTrace count] * 100];
	for(KSStackTraceEntry* entry in stackTrace)
	{
		[string appendString:[entry description]];
		[string appendString:@"\n"];
	}
	return string;
}

- (NSString*) condensedPrintableTrace:(NSArray*) stackTrace
{
	NSMutableString* string = [NSMutableString stringWithCapacity:[stackTrace count] * 50];
	bool firstRound = YES;
	for(KSStackTraceEntry* entry in stackTrace)
	{
		if(firstRound)
		{
			firstRound = NO;
		}
		else
		{
			// Space separated.
			[string appendString:@" "];
		}

		if(nil != entry.objectClass)
		{
			// -[MyClass myMethod:anExtraParameter] or
			// +[MyClass myClassMethod:anExtraParameter]
			NSString* levelPrefix = entry.isClassLevelSelector ? @"+" : @"-";
			[string appendFormat:@"%@[%@ %@]", levelPrefix, entry.objectClass, entry.selectorName];
		}
		else
		{
			// my_c_function
			[string appendFormat:@"%@", entry.selectorName];
		}
	}
	return string;
}

@end



@implementation KSStackTraceEntry

static NSMutableCharacterSet* objcSymbolSet;

+ (id) entryWithTraceLine:(NSString*) traceLine
{
	return [[[self alloc] initWithTraceLine:traceLine] autorelease];
}

- (id) initWithTraceLine:(NSString*) traceLine
{
	if(nil == objcSymbolSet)
	{
		objcSymbolSet = [[NSMutableCharacterSet alloc] init];
		[objcSymbolSet formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
		[objcSymbolSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithRange:NSMakeRange('!', '~' - '!')]];
	}
	
	if(nil != (self = [super init]))
	{
		rawEntry_ = [traceLine retain];
		
		NSScanner* scanner = [NSScanner scannerWithString:rawEntry_];
		
		if(![scanner scanInt:(int*)&traceEntryNumber_]) goto done;
		
		if(![scanner scanCharactersFromSet:objcSymbolSet intoString:&library_]) goto done;
		
		if(![scanner scanHexInt:&address_]) goto done;
		
		if(![scanner scanCharactersFromSet:objcSymbolSet intoString:&selectorName_]) goto done;
		if([selectorName_ length] > 2 && [selectorName_ characterAtIndex:1] == '[')
		{
			isClassLevelSelector_ = [selectorName_ characterAtIndex:0] == '+';
			objectClass_ = [[selectorName_ substringFromIndex:2] retain];
			if(![scanner scanUpToString:@"]" intoString:&selectorName_]) goto done;
			if(![scanner scanString:@"]" intoString:nil]) goto done;
		}
		
		if(![scanner scanString:@"+" intoString:nil]) goto done;
		
		if(![scanner scanInt:&offset_]) goto done;
		
	done:
		if(nil == library_)
		{
			library_ = @"???";
		}
		if(nil == selectorName_)
		{
			selectorName_ = @"???";
		}
		[library_ retain];
		[objectClass_ retain];
		[selectorName_ retain];
	}
	return self;
}

- (void) dealloc
{
	[rawEntry_ release];
	[library_ release];
	[objectClass_ release];
	[selectorName_ release];
	[super dealloc];
}

@synthesize traceEntryNumber = traceEntryNumber_;
@synthesize library = library_;
@synthesize address = address_;
@synthesize objectClass = objectClass_;
@synthesize isClassLevelSelector = isClassLevelSelector_;
@synthesize selectorName = selectorName_;
@synthesize offset = offset_;

- (NSString*) description
{
	return rawEntry_;
}

@end
