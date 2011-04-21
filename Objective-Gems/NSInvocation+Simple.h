//
//  NSInvocation+Simple.h
//  Objective-Gems
//
//  Created by Karl Stenerud on 4/20/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * A simpler interface to building and invoking NSInvocation objects.
 */
@interface NSInvocation (Simple)

/** Builds an NSInvocation object pre-initialized to call the specified
 * selector on the specified target.
 *
 * @param target The target to call.
 * @param selector The selector to invoke on the target.
 * @return A new NSInvocation.
 */
+ (NSInvocation*) invocationWithTarget:(id) target selector:(SEL) selector;

/** Invoke and return whatever the invocation returned. Returns nil if
 * the selector returns void or a struct. Returns NSNumber if the selector
 * returns a primitive numeric type.
 *
 * @return The selector's return or nil if it's void or a struct.
 */
- (id) invokeAndReturn;

/** Invoke with the specified argument and return whatever the invocation
 * returned. Returns nil if the selector returns void or a struct. Returns
 * NSNumber if the selector returns a primitive numeric type.
 *
 * @param object The argument to the call.
 * @return The selector's return or nil if it's void or a struct.
 */
- (id) invokeWithObject:(id) object;

/** Invoke with the specified arguments and return whatever the invocation
 * returned. Returns nil if the selector returns void or a struct. Returns
 * NSNumber if the selector returns a primitive numeric type.
 *
 * @param object The first argument to the call.
 * @param object2 The second argument to the call.
 * @return The selector's return or nil if it's void or a struct.
 */
- (id) invokeWithObject:(id) object withObject:(id) object2;

@end
