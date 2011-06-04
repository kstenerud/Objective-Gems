//
//  KSNil.h
//  Objective-Gems
//
//  Created by Karl Stenerud on 4/22/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * Class that behaves as close to nil as possible.
 *
 * Unlike nil, KSNil can be added to collections.
 * Unlike NSNull, KSNil responds with 0 to any method call.
 *
 * The only exceptions are:
 * - isEqual (returns YES when compared to a KSNil instance)
 * - isProxy (returns YES)
 * - class (returns KSNil)
 * - methodSignatureForSelector (returns a roughly matching signature)
 * - allocWithZone, init, self, retain, autorelease, copy, copyWithZone,
 *   initWithCoder, replacementObjectForCoder (returns a KSNil instance)
 *
 * It is implemented as a singleton and does not honor retain/release.
 */
@interface KSNil
{
}

/** Create an NSNil object
 *
 * @return a KSNil object.
 */
+ (id) null;

@end
