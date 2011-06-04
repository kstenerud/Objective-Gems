//
//  NSMutableArray+Stack+Queue.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 1/18/11.
//
// Copyright 2011 Karl Stenerud
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

#import "NSMutableArray+Stack+Queue.h"
#import "LoadableCategory.h"

MAKE_CATEGORIES_LOADABLE(ObjectiveGems_NSMutableArray_StackQueue);


@implementation NSMutableArray (Stack_Queue)

- (void) push:(id) object
{
	[self addObject:object];
}

- (id) pop
{
	if([self count] == 0)
	{
		return nil;
	}
	NSUInteger idx = [self count] - 1;
	id object = [[[self objectAtIndex:idx] retain] autorelease];
	[self removeObjectAtIndex:idx];
	return object;
}

- (id) peek
{
    return [self objectAtIndex:[self count]-1];
}

- (void) enqueue:(id) object
{
	[self addObject:object];
}

- (id) dequeue
{
	if([self count] == 0)
	{
		return nil;
	}
	id object = [[[self objectAtIndex:0] retain] autorelease];
	[self removeObjectAtIndex:0];
	return object;
}

@end
