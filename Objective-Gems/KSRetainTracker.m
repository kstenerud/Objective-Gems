//
//  KSRetainTracker.m
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

#import "KSRetainTracker.h"
#import <objc/runtime.h>
#include <execinfo.h>

#define kRTAllocSkipFrames 4
#define kRTDeallocSkipFrames 5
#define kRTRetainSkipFrames 3
#define kRTReleaseSkipFrames 3
#define kRTAutoreleaseSkipFrames 3

static NSString* rt_condensedCallTrace(unsigned int numEntries, unsigned int skipFrames)
{
    void* callstack[numEntries+skipFrames];
	int numFrames = backtrace(callstack, numEntries+skipFrames);
	char** symbols = backtrace_symbols(callstack, numFrames);
    
	NSMutableString* string = [NSMutableString stringWithString:@"("];
	for(int i = skipFrames; i < numFrames; i++)
	{
        char* startOffset = strstr(symbols[i], "0x") + 11;
        *strstr(startOffset, " + ") = '\0';
        NSString* fmt = (i < numFrames-1) ? @"%s, " : @"%s)";
        [string appendFormat:fmt, startOffset];
	}
	
	// symbols was malloc'd by backtrace_symbols() and so we must free it.
	free(symbols);
    
    return [string length] > 2 ? string : @"";
}


@interface KSRetainTracker ()

- (void) notifyAlloc:(id) object;
- (void) notifyDealloc:(id) object;
- (void) notifyRetain:(id) object;
- (void) notifyRelease:(id) object;
- (void) notifyAutorelease:(id) object;

@end


@implementation NSObject (KSRetainTracker)

+ (id) allocWithZone_RTOriginal:(NSZone*) zone
{
    id allocedObject = [self allocWithZone_RTOriginal:zone];
    [[KSRetainTracker sharedInstance] notifyAlloc:allocedObject];
    return allocedObject;
}

- (void) dealloc_RTOriginal
{
    [[KSRetainTracker sharedInstance] notifyDealloc:self];
    [self dealloc_RTOriginal];
}

- (id) retain_RTOriginal
{
    [[KSRetainTracker sharedInstance] notifyRetain:self];
    return [self retain_RTOriginal];
}

- (void) release_RTOriginal
{
    [[KSRetainTracker sharedInstance] notifyRelease:self];
    [self release_RTOriginal];
} 

- (id) autorelease_RTOriginal
{
    [[KSRetainTracker sharedInstance] notifyAutorelease:self];
    return [self autorelease_RTOriginal];
}

@end


@interface KSRTObjectTracker: NSObject
{
    int objectRetainCount_;
    int objectAutoreleaseCount_;
}
@property(readonly) int currentRetainCount;
@property(readonly) int effectiveRetainCount;

- (void) notifyRetain;
- (void) notifyRelease;
- (void) notifyAutorelease;

+ (KSRTObjectTracker*) tracker;

@end


@implementation KSRTObjectTracker

+ (KSRTObjectTracker*) tracker
{
    return [[[self alloc] init] autorelease];
}

- (id) init
{
    if(nil != (self = [super init]))
    {
        objectRetainCount_ = 1;
    }
    return self;
}

@synthesize currentRetainCount = objectRetainCount_;

- (int) effectiveRetainCount
{
    return objectRetainCount_ - objectAutoreleaseCount_;
}

- (void) notifyRetain
{
    objectRetainCount_++;
}

- (void) notifyRelease
{
    objectRetainCount_--;
    if(objectAutoreleaseCount_ > 0)
    {
        objectAutoreleaseCount_--;
    }
}

- (void) notifyAutorelease
{
    objectAutoreleaseCount_++;
}

@end


@interface KSRTWeakReference : NSObject
{
    id reference_;
}
@property(readonly) id reference;

+ (KSRTWeakReference*) reference:(id) reference;
- (id) initWithReference:(id) reference;

@end


@implementation KSRTWeakReference

+ (KSRTWeakReference*) reference:(id) reference
{
    return [[[self alloc] initWithReference:reference] autorelease];
}

- (id) initWithReference:(id) reference
{
    if(nil != (self = [super init]))
    {
        reference_ = reference;
    }
    return self;
}

@synthesize reference = reference_;

- (BOOL) isEqual:(id)object
{
    if(![object isKindOfClass:[KSRTWeakReference class]])
    {
        return NO;
    }
    
    return reference_ == ((KSRTWeakReference*)object)->reference_;
}

- (NSUInteger) hash
{
    return (NSUInteger)reference_;
}

- (id) copyWithZone:(NSZone*) zone
{
    return [[[self class] allocWithZone:zone] initWithReference:reference_];
}

@end


SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KSRetainTracker);


@implementation KSRetainTracker

SYNTHESIZE_SINGLETON_FOR_CLASS(KSRetainTracker);

- (id) init
{
    if(nil != (self = [super init]))
    {
        registeredClasses_ = [[NSMutableDictionary dictionaryWithCapacity:64] retain];
        trackedObjects_ = [[NSMutableDictionary dictionaryWithCapacity:1024] retain];
        Class cls = [NSObject class];
        
        method_exchangeImplementations(class_getClassMethod(cls, @selector(allocWithZone:)),
                                       class_getClassMethod(cls, @selector(allocWithZone_RTOriginal:)));
        method_exchangeImplementations(class_getInstanceMethod(cls, @selector(dealloc)),
                                       class_getClassMethod(cls, @selector(dealloc_RTOriginal)));
        method_exchangeImplementations(class_getInstanceMethod(cls, @selector(retain)),
                                       class_getClassMethod(cls, @selector(retain_RTOriginal)));
        method_exchangeImplementations(class_getInstanceMethod(cls, @selector(release)),
                                       class_getClassMethod(cls, @selector(release_RTOriginal)));
        method_exchangeImplementations(class_getInstanceMethod(cls, @selector(autorelease)),
                                       class_getClassMethod(cls, @selector(autorelease_RTOriginal)));
    }
    return self;
}

- (void) dealloc
{
    [registeredClasses_ release];
    [trackedObjects_ release];
    
    [super dealloc];
}

@synthesize enabled = enabled_;

- (void) registerClass:(Class) cls callTraceLevel:(int) callTraceLevel
{
	@synchronized(self)
	{
        [registeredClasses_ setObject:[NSNumber numberWithInt:callTraceLevel] forKey:cls];
	}
}

- (void) unregisterClass:(Class) cls
{
	@synchronized(self)
	{
        [registeredClasses_ removeObjectForKey:cls];
	}
}

- (void) notifyAlloc:(id) object
{
    if(enabled_)
    {
        @synchronized(self)
        {
            NSNumber* callTraceLevel = [registeredClasses_ objectForKey:[object class]];
            if(nil != callTraceLevel)
            {
                [trackedObjects_ setObject:[KSRTObjectTracker tracker] forKey:[KSRTWeakReference reference:object]];
                NSLog(@"<%@: %p> ALLOC  :  1      %@",
                      [object class],
                      object,
                      rt_condensedCallTrace([callTraceLevel intValue], kRTAllocSkipFrames));
            }
        }
    }
}

- (void) notifyDealloc:(id) object
{
    if(enabled_)
    {
        @synchronized(self)
        {
            NSNumber* callTraceLevel = [registeredClasses_ objectForKey:[object class]];
            if(nil != callTraceLevel)
            {
                [trackedObjects_ removeObjectForKey:[KSRTWeakReference reference:object]];
                NSLog(@"<%@: %p> DEALLOC:         %@",
                      [object class],
                      object,
                      rt_condensedCallTrace([callTraceLevel intValue], kRTDeallocSkipFrames));
            }
        }
    }
}

- (void) notifyRetain:(id) object
{
    if(enabled_)
    {
        @synchronized(self)
        {
            NSNumber* callTraceLevel = [registeredClasses_ objectForKey:[object class]];
            if(nil != callTraceLevel)
            {
                KSRTObjectTracker* tracker = [trackedObjects_ objectForKey:[KSRTWeakReference reference:object]];
                if(nil == tracker)
                {
                    // Alloc method was bypassed. Assume current retain count of 1
                    tracker = [KSRTObjectTracker tracker];
                    [trackedObjects_ setObject:tracker forKey:[KSRTWeakReference reference:object]];
                }
                [tracker notifyRetain];
                NSLog(@"<%@: %p> RETAIN : %2d (%2d) %@",
                      [object class],
                      object,
                      tracker.currentRetainCount,
                      tracker.effectiveRetainCount,
                      rt_condensedCallTrace([callTraceLevel intValue], kRTRetainSkipFrames));
            }
        }
    }
}

- (void) notifyRelease:(id) object
{
    if(enabled_)
    {
        @synchronized(self)
        {
            NSNumber* callTraceLevel = [registeredClasses_ objectForKey:[object class]];
            if(nil != callTraceLevel)
            {
                KSRTObjectTracker* tracker = [trackedObjects_ objectForKey:[KSRTWeakReference reference:object]];
                if(nil == tracker)
                {
                    // Alloc method was bypassed. Assume current retain count of 1
                    tracker = [KSRTObjectTracker tracker];
                    [trackedObjects_ setObject:tracker forKey:[KSRTWeakReference reference:object]];
                }
                [tracker notifyRelease];
                NSLog(@"<%@: %p> RELEASE: %2d (%2d) %@",
                      [object class],
                      object,
                      tracker.currentRetainCount,
                      tracker.effectiveRetainCount,
                      rt_condensedCallTrace([callTraceLevel intValue], kRTReleaseSkipFrames));
            }
        }
    }
}

- (void) notifyAutorelease:(id) object
{
    if(enabled_)
    {
        @synchronized(self)
        {
            NSNumber* callTraceLevel = [registeredClasses_ objectForKey:[object class]];
            if(nil != callTraceLevel)
            {
                KSRTObjectTracker* tracker = [trackedObjects_ objectForKey:[KSRTWeakReference reference:object]];
                if(nil == tracker)
                {
                    // Alloc method was bypassed. Assume current retain count of 1
                    tracker = [KSRTObjectTracker tracker];
                    [trackedObjects_ setObject:tracker forKey:[KSRTWeakReference reference:object]];
                }
                [tracker notifyAutorelease];
                NSLog(@"<%@: %p> AUTOREL: %2d (%2d) %@",
                      [object class],
                      object,
                      tracker.currentRetainCount,
                      tracker.effectiveRetainCount,
                      rt_condensedCallTrace([callTraceLevel intValue], kRTAutoreleaseSkipFrames));
            }
        }
    }
}

@end
