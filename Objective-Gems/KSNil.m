//
//  KSNil.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 4/22/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import "KSNil.h"
#import <objc/runtime.h>


@implementation KSNil

static KSNil* ksnil_instance = nil;

+ (void) initialize
{
    @synchronized(self)
    {
        if(nil == ksnil_instance)
        {
            ksnil_instance = (KSNil*)NSAllocateObject(self, 0, NSDefaultMallocZone());
        }
    }
}

+ (Class) class
{
    return self;
}

- (Class) class
{
    return object_getClass(self);
}

- (BOOL) isProxy
{
    return YES;
}

+ (id) null
{
    return ksnil_instance;
}

+ (id)allocWithZone:(NSZone*) zone
{
    return ksnil_instance;
}

- (id) init
{
    return ksnil_instance;
}

- (id) self
{
    return ksnil_instance;
}

- (id) retain
{
    return ksnil_instance;
}

- (id) autorelease
{
    return ksnil_instance;
}

- (id) copy
{
    return ksnil_instance;
}

- (id) copyWithZone:(NSZone*) zone
{
    return ksnil_instance;
}

- (id)initWithCoder:(NSCoder*) aDecoder
{
    return ksnil_instance;
}

- (id)replacementObjectForCoder:(NSCoder*) aCoder
{
    return ksnil_instance;
}

- (BOOL) isEqual:(id) object
{
    return [object class] == [KSNil class];
}

- (void) forwardInvocation:(NSInvocation*) anInvocation
{
    // Assume the return value was an object pointer to nil.
    // This doesn't work for struct return types.
    id result = nil;
    [anInvocation setReturnValue:&result];
}

- (NSMethodSignature*) methodSignatureForSelector:(SEL) aSelector
{
    // Count the number of arguments in the selector.
    // A selector is basically a string at the core so we can
    // get away with this.
    unsigned int numArguments = 0;
    for(char* pChar = (char*)aSelector; *pChar != 0; pChar++)
    {
        if(':' == *pChar)
        {
            numArguments++;
        }
    }

    // Now build up a fake argument signature list, assuming every argument
    // is an object (works fine for different sized actual args).
    char types[32] = {*@encode(id), *@encode(SEL)};
    for(unsigned int i = 0; i < numArguments; i++)
    {
        types[i+2] = *@encode(id);
    }
    types[numArguments+2] = 0;
    
    return [NSMethodSignature signatureWithObjCTypes:types];
}

@end
