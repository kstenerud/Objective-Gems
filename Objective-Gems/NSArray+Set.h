//
//  NSArray+Set.h
//  Objective-Gems
//
//  Created by Karl Stenerud.
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
 * Enhancement to allow populating an array from a set.
 */
@interface NSArray (ArrayWithSet)

/** Create an array from a set.
 *
 * @param set The set whose contents to create an array from.
 * @return A new array with the same contents as the set.
 */
+ (id) arrayWithSet:(NSSet*) set;

@end



/**
 * Enhancement to allow populating an array from a set.
 */
@interface NSMutableArray (Set)

/** Create an array from a set.
 *
 * @param set The set whose contents to create an array from.
 * @return A new array with the same contents as the set.
 */
+ (id) arrayWithSet:(NSSet*) set;

@end
