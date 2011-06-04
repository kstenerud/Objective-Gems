//
//  NSMutableArray+InsertArray.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 10-02-15.
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

#import "NSMutableArray+InsertArray.h"
#import "LoadableCategory.h"

MAKE_CATEGORIES_LOADABLE(ObjectiveGems_NSMutableArray_InsertArray);


@implementation NSMutableArray (InsertArray)

- (void) insertArray:(NSArray*) array atIndex:(NSUInteger) insertIndex
{
	NSIndexSet* indices = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(insertIndex, [array count])];
	[self insertObjects:array atIndexes:indices];
}

@end
