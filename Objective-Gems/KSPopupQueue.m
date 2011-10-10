//
//  KSPopupQueue.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 4/21/11.
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

#import "KSPopupQueue.h"
#import "NSMutableArray+Stack+Queue.h"
#import "NSInvocation+Simple.h"
#import "KSNil.h"


SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KSPopupQueue);

@implementation KSPopupQueue

SYNTHESIZE_SINGLETON_FOR_CLASS(KSPopupQueue);

- (id) init
{
    if(nil != (self = [super init]))
    {
        queuedPopups_ = [NSMutableArray new];
        queuedPopupCallbacks_ = [NSMutableArray new];
    }
    return self;
}

- (void) dealloc
{
    [queuedPopupCallbacks_ release];
    [queuedPopups_ release];
    
    [super dealloc];
}

- (void) dismissPopupView:(UIView*) view
{
    [[KSPopupManager sharedInstance] dismissPopupView:view];
}

- (void) onPopupProcessComplete:(KSPopupProcess*) process
{
    [queuedPopups_ pop];
    NSInvocation* invocation = [queuedPopupCallbacks_ pop];
    [invocation invoke];
}
/*
- (KSPopupProcess*) popupController:(UIViewController*) controller
                        popupAction:(KSPopupAction*) popupAction
                      dismissAction:(KSPopupAction*) dismissAction
                   initialTransform:(CGAffineTransform) initialTransform
                      initialCenter:(CGPoint) initialCenter
                       initialAlpha:(float) initialAlpha
                          superview:(UIView*) superview
                              modal:(BOOL) modal
                      onDismissCall:(id) target
                           selector:(SEL) selector
{
    @synchronized(self)
    {
        [queuedPopupCallbacks_ push:[NSInvocation invocationWithTarget:target
                                                              selector:selector]];
        
        KSPopupProcess* process = [[KSPopupManager sharedInstance] popupController:controller
                                                                       popupAction:popupAction
                                                                     dismissAction:dismissAction
                                                                  initialTransform:initialTransform
                                                                     initialCenter:initialCenter
                                                                      initialAlpha:initialAlpha
                                                                         superview:superview
                                                                             modal:modal
                                                                     onDismissCall:self
                                                                          selector:@selector(onPopupProcessComplete:)];
        [queuedPopups_ push:process];
        return process;
    }
}

- (KSPopupProcess*) slideInController:(UIViewController*) controller
                                 from:(KSPopupPosition) sourcePosition
                             toCenter:(BOOL) toCenter
{
    @synchronized(self)
    {
        [queuedPopupCallbacks_ push:[KSNil null]];
        
        KSPopupProcess* process = [[KSPopupManager sharedInstance] slideInController:controller
                                                                                from:sourcePosition
                                                                            toCenter:toCenter];
        [queuedPopups_ push:process];
        return process;
    }
}

- (KSPopupProcess*) slideInController:(UIViewController*) controller
                                 from:(KSPopupPosition) sourcePosition
                             toCenter:(BOOL) toCenter
                             duration:(NSTimeInterval) duration
                            superview:(UIView*) superview
                                modal:(BOOL) modal
                        onDismissCall:(id) target
                             selector:(SEL) selector
{
    @synchronized(self)
    {
        [queuedPopupCallbacks_ push:[NSInvocation invocationWithTarget:target
                                                              selector:selector]];
        KSPopupProcess* process = [[KSPopupManager sharedInstance] slideInController:controller
                                                                                from:sourcePosition
                                                                            toCenter:toCenter
                                                                            duration:duration
                                                                           superview:superview
                                                                               modal:modal
                                                                       onDismissCall:target
                                                                            selector:selector];
        [queuedPopups_ push:process];
        return process;
    }
}

- (KSPopupProcess*) zoomInWithController:(UIViewController*) controller
{
    @synchronized(self)
    {
        [queuedPopupCallbacks_ push:[KSNil null]];
        
        KSPopupProcess* process = [[KSPopupManager sharedInstance] zoomInWithController:controller];
        [queuedPopups_ push:process];
        return process;
    }
}

- (KSPopupProcess*) zoomInWithController:(UIViewController*) controller
                                duration:(NSTimeInterval) duration
                               superview:(UIView*) superview
                                   modal:(BOOL) modal
                           onDismissCall:(id) target
                                selector:(SEL) selector
{
    @synchronized(self)
    {
        [queuedPopupCallbacks_ push:[NSInvocation invocationWithTarget:target
                                                              selector:selector]];
        KSPopupProcess* process = [[KSPopupManager sharedInstance] zoomInWithController:controller
                                                                               duration:duration
                                                                              superview:superview
                                                                                  modal:modal
                                                                          onDismissCall:target
                                                                               selector:selector];
        [queuedPopups_ push:process];
        return process;
    }
}

- (KSPopupProcess*) bumpZoomInWithController:(UIViewController*) controller
{
    @synchronized(self)
    {
        [queuedPopupCallbacks_ push:[KSNil null]];
        
        KSPopupProcess* process = [[KSPopupManager sharedInstance] bumpZoomInWithController:controller];
        [queuedPopups_ push:process];
        return process;
    }
}

- (KSPopupProcess*) bumpZoomInWithController:(UIViewController*) controller
                                    duration:(NSTimeInterval) duration
                                   superview:(UIView*) superview
                                       modal:(BOOL) modal
                               onDismissCall:(id) target
                                    selector:(SEL) selector
{
    @synchronized(self)
    {
        [queuedPopupCallbacks_ push:[NSInvocation invocationWithTarget:target
                                                              selector:selector]];
        KSPopupProcess* process = [[KSPopupManager sharedInstance] bumpZoomInWithController:controller
                                                                                   duration:duration
                                                                                  superview:superview
                                                                                      modal:modal
                                                                              onDismissCall:target
                                                                                   selector:selector];
        [queuedPopups_ push:process];
        return process;
    }
}

- (KSPopupProcess*) fadeInController:(UIViewController*) controller
{
    @synchronized(self)
    {
        [queuedPopupCallbacks_ push:[KSNil null]];
        
        KSPopupProcess* process = [[KSPopupManager sharedInstance] fadeInController:controller];
        [queuedPopups_ push:process];
        return process;
    }
}

- (KSPopupProcess*) fadeInController:(UIViewController*) controller
                            duration:(NSTimeInterval) duration
                           superview:(UIView*) superview
                               modal:(BOOL) modal
                       onDismissCall:(id) target
                            selector:(SEL) selector
{
    @synchronized(self)
    {
        [queuedPopupCallbacks_ push:[NSInvocation invocationWithTarget:target
                                                              selector:selector]];
        KSPopupProcess* process = [[KSPopupManager sharedInstance] fadeInController:controller
                                                                           duration:duration
                                                                          superview:superview
                                                                              modal:modal
                                                                      onDismissCall:target
                                                                           selector:selector];
        [queuedPopups_ push:process];
        return process;
    }
}
*/
@end
