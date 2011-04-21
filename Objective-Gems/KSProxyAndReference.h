//
//  KSProxyAndReference.h
//  Objective-Gems
//
//  Created by Karl Stenerud on 4/20/11.
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

/**
 * A proxy that passes most messages to its reference.
 *
 * Messages not forwarded:
 * - autorelease
 * - class
 * - description (forwarded, but result is modified with proxy info)
 * - isProxy
 * - release
 * - retain
 * - retainCount
 * - self
 * - superclass
 * - zone
 */
@interface KSProxy : NSProxy<NSCopying>
{
    /** The object this proxy references */
    id reference_;
    /** If YES, this is a weak reference */
    BOOL weakReference_;
    /** If YES, copying this proxy will also copy the object it references */
    BOOL deepCopy_;
}

/** Create a proxy referencing the specified object.
 *
 * @param reference The object to reference.
 * @return A new proxy.
 */
+ (KSProxy*) proxyTo:(id) reference;

/** Create a proxy weakly referencing the specified object.
 *
 * @param reference The object to reference.
 * @return A new proxy.
 */
+ (KSProxy*) weakProxyTo:(id) reference;

/** Initialize a proxy to reference the specified object.
 *
 * @param reference The object to reference.
 * @param weakReferences If YES, do not retain the reference.
 * @param deepCopy If YES, copying this proxy will also copy the reference.
 * @return The initialized proxy.
 */
- (id) initWithReference:(id) reference
           weakReference:(BOOL) weakReference
                deepCopy:(BOOL) deepCopy;

@end


/**
 * A reference to another object.
 * Also supports being used as a key in a dictionary.
 */
@interface KSReference : NSObject<NSCopying>
{
    /** The object being referenced */
    id reference_;
    /** If YES, this is a weak reference */
    BOOL weakReference_;
}
/** The object being referenced */
@property(readonly) id reference;

/** Create a reference to the specified object.
 *
 * @param reference The object to reference.
 * @return A new reference.
 */
+ (KSReference*) referenceTo:(id) reference;

/** Create a weak reference to the specified object.
 *
 * @param reference The object to reference.
 * @return A new reference.
 */
+ (KSReference*) weakReferenceTo:(id) reference;

/** Initialize a reference to an object.
 *
 * @param reference The object to reference.
 * @param weakReferences If YES, do not retain the reference.
 * @return The initialized reference.
 */
- (id) initWithReference:(id)reference
           weakReference:(BOOL) weakReference;

@end
