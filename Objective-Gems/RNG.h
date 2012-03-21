//
//  RNG.h
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

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"

/** Random number generator interface */
@interface RNG : NSObject
{
	unsigned int seedValue;
}
/** The current seed value being used */
@property(nonatomic,readwrite,assign) unsigned int seedValue;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(RNG);

/** Initialize with the specified seed value.
 * This must ONLY be called BEFORE accessing sharedInstance.
 */
- (id) initWithSeed:(unsigned int) seed;

/** Returns a random unsigned int from 0 to 0xffffffff */
- (unsigned int) randomUnsignedInt;

/** Returns a random probability value from 0.0 to 1.0 */
- (double) randomProbability;

/** Returns a 53-bit precision probability value from 0.0 to 1.0 */
- (double) random53BitProbability;

/** Returns a random integer from minValue to maxValue */
- (int) randomNumberFrom: (int) minValue to: (int) maxValue;

/** Returns a random integer from minValue to maxValue, but does not return exceptValue */
- (int) randomNumberFrom: (int) minValue to: (int) maxValue except:(int) exceptValue;

/** Returns an array of n unique random integers from minValue to maxValue */
- (NSMutableArray*) randomNumberArrayWith: (NSUInteger) n elementsFrom: (int) minValue to: (int) maxValue;

/** Returns a mutable array containing all numbers from startValue to endValue, in random order. */
- (NSMutableArray*) randomlyOrderedNumbersFrom:(int) startValue to:(int) endValue;

/** Returns a random float from minValue to maxValue */
- (float) randomFloatFrom: (float) minValue to: (float) maxValue;

/** Randomly returns YES or NO */
- (bool) randomBool;

@end
