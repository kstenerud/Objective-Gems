//
//  KSStackTracer.h
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

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"


/** Generates and formats stack traces.
 */
@interface KSStackTracer : NSObject
{
	/** The current application process's name. */
	NSString* processName_;
}

/** Make this class into a singleton. */
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KSStackTracer);

/**
 * Generate a stack trace with the default maximum entries (currently 40).
 *
 * @return an array of StackTraceEntry.
 */
- (NSArray*) generateTrace;

/**
 * Generate a stack trace with the specified maximum entries.
 *
 * @param maxEntries The maximum number of lines to trace.
 * @return an array of StackTraceEntry.
 */
- (NSArray*) generateTraceWithMaxEntries:(unsigned int) maxEntries;

/**
 * Create an "intelligent" trace from the specified trace.
 * This is designed primarily for stripping out useless trace lines from
 * an exception or signal trace.
 *
 * @param stackTrace The trace to convert (NSArray containing StackTraceEntry).
 * @return An intelligent trace with the useless info stripped.
 */
- (NSArray*) intelligentTrace:(NSArray*) stackTrace;

/**
 * Turn the specified stack trace into a printabe string.
 *
 * @param stackTrace The stack trace to convert (NSArray containing StackTraceEntry).
 * @retun A string representation of the stack trace.
 */
- (NSString*) printableTrace:(NSArray*) stackTrace;

/**
 * Turn the specified stack trace into a condensed printable string.
 * The condensed entries are space separated, and only contain the object class
 * (if any) and the selector call.
 *
 * @param stackTrace The stack trace to convert (NSArray containing StackTraceEntry).
 * @return A condensed string representation of the stack trace.
 */
- (NSString*) condensedPrintableTrace:(NSArray*) stackTrace;

@end



/** A single stack trace entry, recording all information about a stack trace line.
 */
@interface KSStackTraceEntry: NSObject
{
	unsigned int traceEntryNumber_;
	NSString* library_;
	unsigned int address_;
	NSString* objectClass_;
	bool isClassLevelSelector_;
	NSString* selectorName_;
	int offset_;
	NSString* rawEntry_;
}
/** This entry's position in the original stack trace. */
@property(readonly,nonatomic) unsigned int traceEntryNumber;

/** Which library, framework, or process the entry is from. */
@property(readonly,nonatomic) NSString* library;

/** The address in memory. */
@property(readonly,nonatomic) unsigned int address;

/** The class of object that made the call. */
@property(readonly,nonatomic) NSString* objectClass;

/** If true, this is a class level selector being called. */
@property(readonly,nonatomic) bool isClassLevelSelector;

/** The selector (or function if it's C) being called. */
@property(readonly,nonatomic) NSString* selectorName;

/** The offset within the function or method. */
@property(readonly,nonatomic) int offset;

/** Create a new stack trace entry from the specified trace line.
 * This line is expected to conform to what backtrace_symbols() returns.
 */
+ (id) entryWithTraceLine:(NSString*) traceLine;

/** Initialize a stack trace entry from the specified trace line.
 * This line is expected to conform to what backtrace_symbols() returns.
 */
- (id) initWithTraceLine:(NSString*) traceLine;

@end
