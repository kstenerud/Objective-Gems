//
//  KSRetainTracker.h
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


#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"


/**
 * A debugging tool for tracking where allocs, deallocs, retains, releases, and
 * autoreleases are happening.
 *
 * Once you register a class with the tracker, it will start logging all calls
 * to memory management related methods, printing out the object class, pointer,
 * method, current retain count, effective retain count (retains - autoreleases),
 * and an optional mini call trace (use callTraceLevel 0 to disable).
 *
 *
 * Usage Example (inside a UIViewController):
 *
 *    [[KSRetainTracker sharedInstance] registerClass:[TestView class] callTraceLevel:2];
 *    [KSRetainTracker sharedInstance].enabled = YES;
 *    ...
 *    TestView* view = [[[TestView alloc] init] autorelease];
 *    [self.view addSubview:view];
 *    [view removeFromSuperview];
 *
 *
 * Output:
 *
 *    <TestView: 0x5c201f0> ALLOC  :  1      (-[TestMessageSenderViewController onShow], -[UIApplication sendAction:to:from:forEvent:])
 *    <TestView: 0x5c201f0> AUTOREL:  1 ( 0) (-[TestMessageSenderViewController onShow], -[UIApplication sendAction:to:from:forEvent:])
 *    <TestView: 0x5c201f0> RETAIN :  2 ( 1) (-[UIView(Internal) _addSubview:positioned:relativeTo:], -[UIView(Hierarchy) addSubview:])
 *    <TestView: 0x5c201f0> RELEASE:  1 ( 1) (-[TestMessageSenderViewController onShow], -[UIApplication sendAction:to:from:forEvent:])
 *    <TestView: 0x5c201f0> RELEASE:  0 ( 0) (CFRelease, _CFAutoreleasePoolPop)
 *    <TestView: 0x5c201f0> DEALLOC:         (CFRelease, _CFAutoreleasePoolPop)
 *
 * Note: Apple sometimes uses internal magic to bypass the alloc method.
 *       In such a case your output would be missing the initial ALLOC trace:
 *
 *    <UIView: 0x7119120> RETAIN :  2 ( 2) (-[UIViewController view], -[UIWindow addRootViewControllerViewIfPossible])
 *    <UIView: 0x7119120> AUTOREL:  2 ( 1) (-[UIWindow addRootViewControllerViewIfPossible], -[TestMessageSenderAppDelegate application:didFinishLaunchingWithOptions:])
 *    <UIView: 0x7119120> RETAIN :  3 ( 2) (-[CALayer layoutSublayers], CALayerLayoutIfNeeded)
 *    <UIView: 0x7119120> RELEASE:  2 ( 2) (CALayerLayoutIfNeeded, _ZN2CA7Context18commit_transactionEPNS_11TransactionE)
 *    <UIView: 0x7119120> RELEASE:  1 ( 1) (CFRelease, -[__NSArrayM dealloc])
 *    <UIView: 0x7119120> RELEASE:  0 ( 0) (CFRelease, _CFAutoreleasePoolPop)
 *    <UIView: 0x7105c70> DEALLOC:         (CFRelease, _CFAutoreleasePoolPop)
 *
 *
 * When tracing common classes, it's easy for the instance you're interested in
 * to be lost in the flood. The SYNTHESIZE_EMPTY_SUBCLASS macro is a convenient
 * way to make a temporary empty subclass to help with tracing. e.g:
 *
 *    SYNTHESIZE_EMPTY_SUBCLASS(TestView, UIView);
 *
 * Then alloc a TestView instead of UIView where you want to trace its lifetime.
 */
@interface KSRetainTracker : NSObject
{
    NSMutableDictionary* trackedObjects_;
    NSMutableDictionary* registeredClasses_;
    BOOL enabled_;
}

/** When YES, RetainTracker will log memory management method calls. */
@property(readwrite,assign) BOOL enabled;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KSRetainTracker);

/** Register a class to have memory management methods monitored.
 *
 * @param cls The class to monitor.
 * @param callTraceLevel How far down the call stack to trace when logging.
 */
- (void) registerClass:(Class) cls callTraceLevel:(int) callTraceLevel;

/** Unregister a class so that it is no longer monitored.
 */
- (void) unregisterClass:(Class) cls;

@end


/** Synthesize an empty subclass (different in name only) to make it easier
 * to track via RetainTracker.
 *
 * @param SUBCASS What you want to name your subclass
 * @param SUPERCLASS The class to inherit from.
 */
#define SYNTHESIZE_EMPTY_SUBCLASS(SUBCLASS, SUPERCLASS) \
@interface SUBCLASS : SUPERCLASS {} \
@end \
@implementation SUBCLASS \
@end


