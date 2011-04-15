//
//  KSRandom.h
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

#import "SynthesizeSingleton.h"


/** If 1, use Simd-Oriented Fast Mersenne Twister algorithm
 * (see SFMT under Support). Othwerwise use rand().
 */
#define KSRandom_USE_SFMT 1


/**
 * Random number generator interface
 */
@interface KSRandom : NSObject
{
	unsigned int seedValue_;
}

/** The current seed value being used */
@property(nonatomic,readwrite,assign) unsigned int seedValue;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KSRandom);

/** Generate a random unsigned integer.
 *
 * @return A random unsigned int from 0 to 0xffffffff
 */
- (unsigned int) randomUnsignedInt;

/** Generate a random probability.
 *
 * @return A random probability value from 0.0 to 1.0
 */
- (double) randomProbability;

/** Generate a random double value.
 *
 * @param minValue The minimum value to generate.
 * @param maxValue The maximum value to generate.
 * @return A random value within the specified range.
 */
- (double) randomDoubleFrom: (double) minValue to: (double) maxValue;

/** Generate a random integer value.
 *
 * @param minValue The minimum value to generate.
 * @param maxValue The maximum value to generate.
 * @return A random value within the specified range.
 */
- (int) randomIntegerFrom: (int) minValue to: (int) maxValue;

/** Generate a random integer value but not the excepted value.
 *
 * @param minValue The minimum value to generate.
 * @param maxValue The maximum value to generate.
 * @param exceptValue The value that must NOT be returned.
 * @return A random value within the specified range.
 */
- (int) randomIntegerFrom: (int) minValue to: (int) maxValue except:(int) exceptValue;

/** Generate a random boolean value.
 *
 * @return YES or NO
 */
- (BOOL) randomBool;

@end
