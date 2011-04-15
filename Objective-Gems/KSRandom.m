//
//  KSRandom.m
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

#import "KSRandom.h"


#if RNG_USE_SFMT


#import "SFMT.h"

#define RNG_SEED(A) init_gen_rand(A)
#define RNG_GEN_UINT() gen_rand32()
#define RNG_GEN_PROBABILITY() genrand_real2()


#else /* RNG_USE_SFMT */


#define RNG_SEED(A) srand(A)
#define RNG_GEN_UINT() rand()
#define RNG_GEN_PROBABILITY() (rand() / 2147483648.0)


#endif /* RNG_USE_SFMT */



SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KSRandom);

@implementation KSRandom

SYNTHESIZE_SINGLETON_FOR_CLASS(KSRandom);

- (id) init
{
	if(nil != (self = [super init]))
	{
		self.seedValue = time(NULL);
	}
	return self;
}

@synthesize seedValue = seedValue_;

- (void) setSeedValue:(unsigned int) value
{
	seedValue_ = value;
	RNG_SEED(seedValue_);
}

- (unsigned int) randomUnsignedInt
{
	return RNG_GEN_UINT();
}

- (double) randomProbability
{
	return RNG_GEN_PROBABILITY();
}

- (double) randomDoubleFrom: (double) minValue to: (double) maxValue
{
    return minValue + (maxValue - minValue) * RNG_GEN_PROBABILITY();
}

- (int) randomIntegerFrom: (int) minValue to: (int) maxValue
{
	double probability = RNG_GEN_PROBABILITY();
	double range = maxValue - minValue + 1;
	return (int)(range * probability + minValue);
}

- (int) randomIntegerFrom: (int) minValue to: (int) maxValue except:(int) exceptValue
{
	int result = [self randomIntegerFrom:minValue to:maxValue-1];
	return result < exceptValue ? result : result + 1;
}

- (BOOL) randomBool
{
	return RNG_GEN_UINT() & 1;
}

@end
