//
//  NSMutableArray+Stack+Queue.h
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

#import <Foundation/Foundation.h>


/** Enhancmeent that adds stack and queue operations to an array.
 */
@interface NSMutableArray (Stack_Queue)

/** Push an object onto the end of this array (like a LIFO stack).
 *
 * @param object the object to push onto the stack.
 */
- (void) push:(id) object;

/** Pop the last object off the array (like a LIFO stack).
 *
 * @return the object that was removed.
 */
- (id) pop;

/** Peek at the top of the stack without removing the object.
 *
 * @return the object at the top of the stack.
 */
- (id) peek;

/** Add an object to the beginning of a queue.
 *
 * @param the object to add.
 */
- (void) enqueue:(id) object;

/** Remove an object from the end of a queue.
 *
 * @return the object that was removed.
 */
- (id) dequeue;

@end
