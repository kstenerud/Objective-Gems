//
//  RNG.m
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

#import "RNG.h"
#import "SFMT.h"
#import "NSMutableArray+Shuffle.h"

@implementation RNG

SYNTHESIZE_LESSER_SINGLETON_FOR_CLASS(RNG);

- (id) init
{
	return [self initWithSeed:(unsigned int)time(NULL)];
}

- (id) initWithSeed:(unsigned int) seedValueIn
{
	if(nil != (self = [super init]))
	{
		self.seedValue = seedValueIn;
	}
	return self;
}

@synthesize seedValue;

- (void) setSeedValue:(unsigned int) value
{
	seedValue = value;
	init_gen_rand(seedValue);
}

- (unsigned int) randomUnsignedInt
{
	return gen_rand32();
}

- (double) randomProbability
{
	return genrand_real1();
}

- (double) random53BitProbability
{
	return genrand_res53_mix();
}

- (int) randomNumberFrom: (int) minValue to: (int) maxValue
{
	double probability = gen_rand32() / 4294967296.0;
	double range = maxValue - minValue + 1;
	return (int)(range * probability + minValue);
}

- (int) randomNumberFrom: (int) minValue to: (int) maxValue except:(int) exceptValue
{
	if(minValue == maxValue)
	{
		return minValue;
	}
	int result;
	while(exceptValue == (result = [self randomNumberFrom:minValue to:maxValue]))
	{
	}
	return result;
}

- (NSMutableArray*) randomlyOrderedNumbersFrom:(int) startValue to:(int) endValue
{
	int numValues = endValue - startValue;
    if(numValues < 0)
    {
        endValue ^= startValue;
        startValue ^= endValue;
        endValue ^= startValue;
        numValues = endValue - startValue;
    }
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:(NSUInteger)numValues];
	for(int i = startValue; i <= endValue; i++)
	{
		[array addObject:[NSNumber numberWithInt:i]];
	}
	[array shuffle];
	return array;
}

- (NSMutableArray*) randomNumberArrayWith: (NSUInteger) n elementsFrom: (int) minValue to: (int) maxValue
{
	NSMutableArray* list = [NSMutableArray arrayWithCapacity:n];
	
	while(n > 0)
	{
		int numToAdd;
		
		do
			numToAdd = [self randomNumberFrom:minValue to:maxValue];
		while([list containsObject:[NSNumber numberWithInt:numToAdd]]);
		
		[list addObject:[NSNumber numberWithInt:numToAdd]];
		n--;
	}
	
	return list;
}

- (float) randomFloatFrom: (float) minValue to: (float) maxValue
{
	double probability = genrand_real1();
	double range = maxValue - minValue;
	return (float)(range * probability + minValue);
}

- (bool) randomBool
{
	return gen_rand32() & 1;
}

@end
