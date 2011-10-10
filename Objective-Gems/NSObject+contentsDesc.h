//
//  NSObject+contentsDesc.h
//  Objective-Gems
//
//  Created by Karl Stenerud on 10-09-25.
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


/**
 * Adds the ability for all objects to print out a human-readable description of
 * their contents.
 */
@interface NSObject (ContentsDesc)

/** A description of this object's contents (except structs). */
@property(readonly) NSString* contentsDesc;

/** Get a description of this object's contents (except structs), indenting the
 * specified amount.
 *
 * @param spaces The number of spaces to indent.
 * @return The description.
 */
- (NSString*) contentsDescWithIndentation:(unsigned int) spaces;

/** (INTERNAL USE) Get a description of this object's contents (except structs),
 * indenting the specified amount.
 * This method also keeps a history of previously processed objects so as to avoid
 * an endless loop when it encounters a cyclical graph.
 *
 * @param spaces The number of spaces to indent.
 * @param context A mutable array containing objects that have already been processed.
 * @return The description.
 */
- (NSString*) contentsDescWithIndentation:(unsigned int) spaces context:(NSMutableArray*) processedObjects;

@end
