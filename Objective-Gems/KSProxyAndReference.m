//
//  KSProxyAndReference.m
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

#import "KSProxyAndReference.h"


@implementation KSProxy

+ (KSProxy*) proxyTo:(id) reference
{
    return [[[self alloc] initWithReference:reference
                              weakReference:NO
                                   deepCopy:NO] autorelease];
}

+ (KSProxy*) weakProxyTo:(id) reference
{
    return [[[self alloc] initWithReference:reference
                              weakReference:YES
                                   deepCopy:NO] autorelease];
}


- (id) initWithReference:(id)reference
           weakReference:(BOOL) weakReference
                deepCopy:(BOOL) deepCopy
{
    reference_ = reference;
    weakReference_ = weakReference;
    deepCopy_ = deepCopy;

    if(deepCopy_ && ![reference_ respondsToSelector:@selector(copyWithZone:)])
    {
        NSAssert1(1 == 0,
                  @"Specified deepCopy, but class %@ does not respond to copyWithZone:",
                  [reference class]);
        [self release];
        return nil;
    }

    if(!weakReference_)
    {
        [reference_ retain];
    }

    return self;
}

- (void) dealloc
{
    if(!weakReference_)
    {
        [reference_ release];
    }
    
    [super dealloc];
}

- (id) copyWithZone:(NSZone*) zone
{
    id newReference = reference_;
    if(deepCopy_)
    {
        newReference = [newReference copyWithZone:zone];
    }
    return [[[self class] allocWithZone:zone] initWithReference:newReference
                                                  weakReference:weakReference_
                                                       deepCopy:deepCopy_];
}

- (BOOL) isKindOfClass:(Class) aClass
{
    return [super isKindOfClass:aClass] || [reference_ isKindOfClass:aClass];
}

- (void) forwardInvocation:(NSInvocation*) anInvocation
{
    [anInvocation setTarget:reference_];
    [anInvocation invoke];
}

- (NSMethodSignature*) methodSignatureForSelector:(SEL) aSelector
{
    return [reference_ methodSignatureForSelector:aSelector];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@, proxying: %@", [super description], reference_];
}

@end



@implementation KSReference

+ (KSReference*) referenceTo:(id) reference
{
    return [[[self alloc] initWithReference:reference weakReference:NO] autorelease];
}

+ (KSReference*) weakReferenceTo:(id) reference
{
    return [[[self alloc] initWithReference:reference weakReference:YES] autorelease];
}

- (id) initWithReference:(id)reference
           weakReference:(BOOL) weakReference
{
    if(nil != (self = [super init]))
    {
        reference_ = reference;
        weakReference_ = weakReference;
        if(!weakReference_)
        {
            [reference_ retain];
        }
    }
    return self;
}

- (void) dealloc
{
    if(!weakReference_)
    {
        [reference_ release];
    }
    
    [super dealloc];
}

@synthesize reference = reference_;

- (id) copyWithZone:(NSZone*) zone
{
    return [[[self class] allocWithZone:zone] initWithReference:reference_
                                                  weakReference:weakReference_];
}

- (NSUInteger) hash
{
    return (NSUInteger)reference_;
}

- (BOOL) isEqual:(id) anObject
{
    if(![anObject isKindOfClass:[self class]])
    {
        return NO;
    }
    return ((KSReference*)anObject).reference == self.reference;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@, referencing: %@", [super description], reference_];
}

@end
