//
//  NSMutableArray+WeakReferences.h
//  Objective-Gems
//
//  Created by Karl Stenerud on 05/12/09.
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


/**
 * Adds to NSMutableArray the ability to create an array that keeps weak
 * references.
 */
@interface NSMutableArray (WeakReferences)

/** Create an NSMutableArray that uses weak references.
 */
+ (NSMutableArray*) mutableArrayUsingWeakReferences;

/** Create an NSMutableArray that uses weak references.
 *
 * @param capacity The initial capacity of the array.
 */
+ (NSMutableArray*) mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger) capacity;

/** Create an NSMutableArray that uses weak references (no pending autorelease).
 */
+ (NSMutableArray*) newMutableArrayUsingWeakReferences;

/** Create an NSMutableArray that uses weak references (no pending autorelease).
 *
 * @param capacity The initial capacity of the array.
 */
+ (NSMutableArray*) newMutableArrayUsingWeakReferencesWithCapacity:(NSUInteger) capacity;

@end
