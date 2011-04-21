//
//  KSPopup.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 10-11-14.
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

#import "KSPopup.h"
#import "KSProxyAndReference.h"


#define kDefaultPopupDuration 0.3f



#pragma mark UIView Category

@implementation UIView (KSPopup)

- (void) dismissPopup
{
    [[KSPopupManager sharedInstance] dismissPopupView:self];
}

@end



#pragma mark -
#pragma mark KSPopupManager

@interface KSPopupManager ()

/** Calculate the effective frame for a subview.
 * This handles any overlapping views such as the status bar.
 *
 * @param superview the superview to calculate a frame from.
 * @return the effective frame for a subview.
 */
- (CGRect) effectiveFrame:(UIView*) superview;

/** Calculate the effective center of a superview.
 * This handles any overlapping views such as the status bar.
 *
 * @param superview the superview to calculate the center of.
 * @return the effective center.
 */
- (CGPoint) effectiveCenter:(UIView*) superview;

- (CGPoint) startPositionFromPosition:(KSPopupPosition) fromPosition
                                 view:(UIView*) view
                            superview:(UIView*) superview;

- (CGPoint) endPositionFromPosition:(KSPopupPosition) fromPosition
                               view:(UIView*) view
                          superview:(UIView*) superview;

/** (INTERNAL USE) Notify that a view has finished being dismissed.
 *
 * @param view The view that has been dismissed.
 */
- (void) notifyPopupDismissed:(UIView*) view;

@end


SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KSPopupManager);

@implementation KSPopupManager

SYNTHESIZE_SINGLETON_FOR_CLASS(KSPopupManager);

- (id) init
{
    if(nil != (self = [super init]))
    {
        activePopups_ = [NSMutableDictionary new];
    }
    return self;
}

- (void) dealloc
{
    [activePopups_ release];
    
    [super dealloc];
}

- (void) dismissPopupView:(UIView*) view
{
    [[activePopups_ objectForKey:[KSReference referenceTo:view]] dismiss];
}

- (void) notifyPopupDismissed:(UIView*) view
{
    [activePopups_ removeObjectForKey:[KSReference referenceTo:view]];
}

- (void) popupController:(UIViewController*) controller
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
    KSPopupProcess* process = [KSPopupProcess processWithController:controller
                                                        popupAction:popupAction
                                                      dismissAction:dismissAction
                                                   initialTransform:initialTransform
                                                      initialCenter:initialCenter
                                                       initialAlpha:initialAlpha
                                                          superview:superview
                                                              modal:modal
                                                             target:target
                                                           selector:selector];
    [activePopups_ setObject:process
                      forKey:[KSReference referenceTo:controller.view]];
    [process popup];
}

- (CGRect) effectiveFrame:(UIView*) superview
{
    if(superview != [UIApplication sharedApplication].keyWindow)
    {
        return superview.bounds;
    }
    
    CGRect keyWindowBounds = [UIApplication sharedApplication].keyWindow.bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    return CGRectMake(keyWindowBounds.origin.x,
                      keyWindowBounds.origin.y + statusBarFrame.size.height,
                      keyWindowBounds.size.width,
                      keyWindowBounds.size.height - statusBarFrame.size.height);
}

- (CGPoint) effectiveCenter:(UIView*) superview
{
    CGRect effectiveBounds = [self effectiveFrame:superview];
    return CGPointMake(effectiveBounds.size.width/2 + effectiveBounds.origin.x,
                       effectiveBounds.size.height/2 + effectiveBounds.origin.y);
}

- (CGPoint) startPositionFromPosition:(KSPopupPosition) fromPosition
                                 view:(UIView*) view
                            superview:(UIView*) superview
{
    CGRect superFrame = [self effectiveFrame:superview];
    CGSize viewSize = view.frame.size;
    
    CGPoint position = [self effectiveCenter:superview];
    
    
    if(fromPosition & KSPopupPositionLeft)
    {
        position.x = superFrame.origin.x - viewSize.width / 2;
    }
    else if(fromPosition & KSPopupPositionRight)
    {
        position.x = superFrame.origin.x + superFrame.size.width + viewSize.width / 2;
    }
    
    if(fromPosition & KSPopupPositionTop)
    {
        position.y = superFrame.origin.y - viewSize.height / 2;
    }
    else if(fromPosition & KSPopupPositionBottom)
    {
        position.y = superFrame.origin.y + superFrame.size.height + viewSize.height / 2;
    }
    
    return position;
}

- (CGPoint) endPositionFromPosition:(KSPopupPosition) fromPosition
                               view:(UIView*) view
                          superview:(UIView*) superview
{
    CGRect superFrame = [self effectiveFrame:superview];
    CGSize viewSize = view.frame.size;
    
    CGPoint position = [self effectiveCenter:superview];
    
    
    if(fromPosition & KSPopupPositionLeft)
    {
        position.x = superFrame.origin.x + viewSize.width / 2;
    }
    else if(fromPosition & KSPopupPositionRight)
    {
        position.x = superFrame.origin.x + superFrame.size.width - viewSize.width / 2;
    }
    
    if(fromPosition & KSPopupPositionTop)
    {
        position.y = superFrame.origin.y + viewSize.height / 2;
    }
    else if(fromPosition & KSPopupPositionBottom)
    {
        position.y = superFrame.origin.y + superFrame.size.height - viewSize.height / 2;
    }
    
    return position;
}

- (void) slideInController:(UIViewController*) controller
                      from:(KSPopupPosition) sourcePosition
                  toCenter:(BOOL) toCenter
{
    [self slideInController:controller
                       from:sourcePosition
                   toCenter:toCenter
                   duration:kDefaultPopupDuration
                  superview:nil
                      modal:YES
              onDismissCall:nil
                   selector:nil];
}

- (void) slideInController:(UIViewController*) controller
                      from:(KSPopupPosition) sourcePosition
                  toCenter:(BOOL) toCenter
                  duration:(NSTimeInterval) duration
                 superview:(UIView*) superview
                     modal:(BOOL) modal
             onDismissCall:(id) target
                  selector:(SEL) selector
{
    if(nil == superview)
    {
        superview = [[UIApplication sharedApplication] keyWindow];
    }
    
    CGPoint startPosition = [self startPositionFromPosition:sourcePosition
                                                       view:controller.view
                                                  superview:superview];
    
    CGPoint endPosition;
    if(toCenter)
    {
        endPosition = [self effectiveCenter:superview];
    }
    else
    {
        endPosition = [self endPositionFromPosition:sourcePosition
                                               view:controller.view
                                          superview:superview];
    }
    
    [self popupController:controller
              popupAction:[KSMovePopupAction actionWithPosition:endPosition duration:duration]
            dismissAction:[KSMovePopupAction actionWithPosition:startPosition duration:duration]
         initialTransform:CGAffineTransformIdentity
            initialCenter:startPosition
             initialAlpha:kKSIgnoreAlpha
                superview:superview
                    modal:modal
            onDismissCall:target
                 selector:selector];
}

- (void) zoomInWithController:(UIViewController*) controller
{
    [self zoomInWithController:controller
                      duration:kDefaultPopupDuration
                     superview:nil
                         modal:YES
                 onDismissCall:nil
                      selector:nil];
}

- (void) zoomInWithController:(UIViewController*) controller
                     duration:(NSTimeInterval) duration
                    superview:(UIView*) superview
                        modal:(BOOL) modal
                onDismissCall:(id) target
                     selector:(SEL) selector
{
    if(nil == superview)
    {
        superview = [[UIApplication sharedApplication] keyWindow];
    }
    
    [self popupController:controller
              popupAction:[KSTransformPopupAction scaleToX:1.0f y:1.0f duration:duration]
            dismissAction:[KSTransformPopupAction scaleToX:0.001f y:0.001f duration:duration]
         initialTransform:CGAffineTransformMakeScale(0.001f, 0.001f)
            initialCenter:[self effectiveCenter:superview]
             initialAlpha:kKSIgnoreAlpha
                superview:superview
                    modal:modal
            onDismissCall:target
                 selector:selector];
}

- (void) bumpZoomInWithController:(UIViewController*) controller
{
    [self bumpZoomInWithController:controller
                          duration:kDefaultPopupDuration
                         superview:nil
                             modal:YES
                     onDismissCall:nil
                          selector:nil];
}

- (void) bumpZoomInWithController:(UIViewController*) controller
                         duration:(NSTimeInterval) duration
                        superview:(UIView*) superview
                            modal:(BOOL) modal
                    onDismissCall:(id) target
                         selector:(SEL) selector
{
    if(nil == superview)
    {
        superview = [[UIApplication sharedApplication] keyWindow];
    }
    
    
    [self popupController:controller
              popupAction:[KSSequentialPopupActions actions:
                           [KSTransformPopupAction scaleToX:1.1f y:1.1f duration:duration*0.8f],
                           [KSTransformPopupAction scaleToX:1.0f y:1.0f duration:duration*0.2f],
                           nil]
            dismissAction:[KSTransformPopupAction scaleToX:0.001f y:0.001f duration:duration]
         initialTransform:CGAffineTransformMakeScale(0.001f, 0.001f)
            initialCenter:[self effectiveCenter:superview]
             initialAlpha:kKSIgnoreAlpha
                superview:superview
                    modal:modal
            onDismissCall:target
                 selector:selector];
}

- (void) fadeInController:(UIViewController*) controller
{
    [self fadeInController:controller
                  duration:kDefaultPopupDuration
                 superview:nil
                     modal:YES
             onDismissCall:nil
                  selector:nil];
}

- (void) fadeInController:(UIViewController*) controller
                 duration:(NSTimeInterval) duration
                superview:(UIView*) superview
                    modal:(BOOL) modal
            onDismissCall:(id) target
                 selector:(SEL) selector
{
    if(nil == superview)
    {
        superview = [[UIApplication sharedApplication] keyWindow];
    }
    
    [self popupController:controller
              popupAction:[KSAlphaPopupAction actionWithAlpha:1.0f duration:duration]
            dismissAction:[KSAlphaPopupAction actionWithAlpha:0.0f duration:duration]
         initialTransform:CGAffineTransformIdentity
            initialCenter:[self effectiveCenter:superview]
             initialAlpha:0
                superview:superview
                    modal:modal
            onDismissCall:target
                 selector:selector];
}

@end



#pragma mark -
#pragma mark KSPopupProcess

@interface KSPopupProcess ()

/** Called when a dismiss animation completes
 */
- (void) onDismissComplete;

@end


@implementation KSPopupProcess

+ (KSPopupProcess*) processWithController:(UIViewController*) controller
                              popupAction:(KSPopupAction*) popupAction
                            dismissAction:(KSPopupAction*) dismissAction
                         initialTransform:(CGAffineTransform) initialTransform
                            initialCenter:(CGPoint) initialCenter
                             initialAlpha:(float) initialAlpha
                                superview:(UIView*) superview
                                    modal:(BOOL) modal
                                   target:(id) target
                                 selector:(SEL) selector
{
    return [[[self alloc] initWithController:controller
                                 popupAction:popupAction
                               dismissAction:dismissAction
                            initialTransform:initialTransform
                               initialCenter:initialCenter
                                initialAlpha:initialAlpha
                                   superview:superview
                                       modal:modal
                                      target:target
                                    selector:selector] autorelease];
}

- (id) initWithController:(UIViewController*) controller
              popupAction:(KSPopupAction*) popupAction
            dismissAction:(KSPopupAction*) dismissAction
         initialTransform:(CGAffineTransform) initialTransform
            initialCenter:(CGPoint) initialCenter
             initialAlpha:(float) initialAlpha
                superview:(UIView*) superview
                    modal:(BOOL) modal
                   target:(id) target
                 selector:(SEL) selector
{
    if(nil != (self = [super init]))
    {
        target_ = target;
        selector_ = selector;
        controller_ = [controller retain];
        popupAction_ = [popupAction retain];
        dismissAction_ = [dismissAction retain];
        initialTransform_ = initialTransform;
        initialCenter_ = initialCenter;
        initialAlpha_ = initialAlpha;
        superview_ = superview;
        if(nil == superview_)
        {
            superview_ = [[UIApplication sharedApplication] keyWindow];
        }
        [superview_ retain];
        if(modal)
        {
            modalView_ = [UIView new];
            [modalView_ setFrame:superview_.bounds];
        }
    }
    return self;
}

- (void) dealloc
{
    [popupAction_ release];
    [dismissAction_ release];
    [controller_ release];
    [modalView_ release];
    [superview_ release];
    [super dealloc];
}

@synthesize controller = controller_;

- (void) popup
{
    UIView* parentView = superview_;
    if(nil != modalView_)
    {
        [superview_ addSubview:modalView_];
        parentView = modalView_;
    }
    
    if(!isnan(initialCenter_.x))
    {
        controller_.view.center = initialCenter_;
    }
    if(!isnan(initialAlpha_))
    {
        controller_.view.alpha = initialAlpha_;
    }
    if(!isnan(controller_.view.transform.a))
    {
        controller_.view.transform = initialTransform_;
    }
    [parentView addSubview:controller_.view];
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:popupAction_.duration];
    [popupAction_ applyToView:controller_.view
             onCompletionCall:nil
                     selector:nil];
	[UIView commitAnimations];
}

- (void) dismiss
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:dismissAction_.duration];
    [dismissAction_ applyToView:controller_.view
               onCompletionCall:self
                       selector:@selector(onDismissComplete)];
	[UIView commitAnimations];
}

- (void) onDismissComplete
{
    [controller_.view removeFromSuperview];
    [modalView_ removeFromSuperview];
    [[KSPopupManager sharedInstance] notifyPopupDismissed:controller_.view];
    [target_ performSelector:selector_ withObject:self];
}

@end



#pragma mark -
#pragma mark KSPopupAction

@interface KSPopupAction ()

/** Called when the currently running animation completes.
 *
 * @param animationID The application-supplied animation ID (if any)
 * @param finished An NSNumber representation of a BOOL, that the animation
 *                 completed fully.
 * @param context An optional application-supplied context.
 */
- (void) onAnimationComplete:(NSString*) animationID
                    finished:(NSNumber*) finished
                     context:(void*) context;

@end

@implementation KSPopupAction

- (id) initWithDuration:(NSTimeInterval) duration
{
    if(nil != (self = [super init]))
    {
        duration_ = duration;
    }
    return self;
}

@synthesize duration = duration_;

- (void) applyToView:(UIView*) view
    onCompletionCall:(id) target
            selector:(SEL) selector
{
    target_ = target;
    selector_ = selector;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
}

- (void) onAnimationComplete:(NSString*) animationID
                    finished:(NSNumber*) finished
                     context:(void*) context
{
    [target_ performSelector:selector_ withObject:self];
}

@end



#pragma mark -
#pragma mark KSConcurrentPopupActions

@implementation KSConcurrentPopupActions

+ (KSConcurrentPopupActions*) actions:(KSPopupAction*) action1, ...
{
    NSMutableArray* actions = [NSMutableArray array];
    va_list params;
    va_start(params,action1);
    KSPopupAction* action = action1;
    while(nil != action)
    {
        [actions addObject:action];
        action = va_arg(params, KSPopupAction*);
    }
    va_end(params);
    return [[[self alloc] initWithActionsArray:actions] autorelease];
}

- (id) initWithActions:(KSPopupAction*) action1, ...
{
    NSMutableArray* actions = [NSMutableArray array];
    va_list params;
    va_start(params,action1);
    KSPopupAction* action = action1;
    while(nil != action)
    {
        [actions addObject:action];
        action = va_arg(params, KSPopupAction*);
    }
    va_end(params);
    
    return [self initWithActionsArray:actions];
}

- (id) initWithActionsArray:(NSArray*) actions;
{
    if(nil != (self = [super initWithDuration:[[actions objectAtIndex:0] duration]]))
    {
        actions_ = [actions retain];
    }
    return self;
}

- (void) dealloc
{
    [actions_ release];
    
    [super dealloc];
}

- (void) applyToView:(UIView*) view
    onCompletionCall:(id) target
            selector:(SEL) selector
{
    for(KSPopupAction* action in actions_)
    {
        [action applyToView:view
           onCompletionCall:nil
                   selector:nil];
    }
    
    [super applyToView:view onCompletionCall:target selector:selector];
}

@end



#pragma mark -
#pragma mark KSSequentialPopupActions

@interface KSSequentialPopupActions ()

/** Run the next action in the sequence.
 */
- (void) runNextAction;

@end

@implementation KSSequentialPopupActions

+ (KSSequentialPopupActions*) actions:(KSPopupAction*) action1, ...
{
    NSMutableArray* actions = [NSMutableArray array];
    va_list params;
    va_start(params,action1);
    KSPopupAction* action = action1;
    while(nil != action)
    {
        [actions addObject:action];
        action = va_arg(params, KSPopupAction*);
    }
    va_end(params);
    return [[[self alloc] initWithActionsArray:actions] autorelease];
}

- (id) initWithActions:(KSPopupAction*) action1, ...
{
    NSMutableArray* actions = [NSMutableArray array];
    va_list params;
    va_start(params,action1);
    KSPopupAction* action = action1;
    while(nil != action)
    {
        [actions addObject:action];
        action = va_arg(params, KSPopupAction*);
    }
    va_end(params);
    
    return [self initWithActionsArray:actions];
}

- (id) initWithActionsArray:(NSArray*) actions
{
    NSTimeInterval duration = 0;
    for(KSPopupAction* action in actions)
    {
        duration += action.duration;
    }
    
    if(nil != (self = [super initWithDuration:duration]))
    {
        actions_ = [actions retain];
    }
    return self;
}

- (void) dealloc
{
    [actions_ release];
    [view_ release];
    
    [super dealloc];
}

- (void) applyToView:(UIView*) view
    onCompletionCall:(id) target
            selector:(SEL) selector
{
    [super applyToView:view onCompletionCall:target selector:selector];
    currentActionIndex_ = -1;
    [view_ release];
    view_ = [view retain];
    [self runNextAction];
}

- (void) runNextAction
{
    currentActionIndex_++;
    if((NSUInteger)currentActionIndex_ < [actions_ count])
    {
        KSPopupAction* action = [actions_ objectAtIndex:currentActionIndex_];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:action.duration];
        [action applyToView:view_
           onCompletionCall:self
                   selector:@selector(runNextAction)];
        [UIView commitAnimations];
        
    }
    else
    {
        [target_ performSelector:selector_ withObject:self];
    }
}

@end



#pragma mark -
#pragma mark KSTransformPopupAction

@implementation KSTransformPopupAction

+ (KSTransformPopupAction*) affineTransform:(CGAffineTransform) transform
                                   duration:(NSTimeInterval) duration
{
    return [[[self alloc] initWithTransform:transform
                                   duration:duration] autorelease];
}

+ (KSTransformPopupAction*) translateTo:(CGPoint) pos
                                duration:(NSTimeInterval) duration
{
    return [[[self alloc] initWithTransform:CGAffineTransformMakeTranslation(pos.x, pos.y)
                                   duration:duration] autorelease];
}

+ (KSTransformPopupAction*) rotateTo:(float) radians
                            duration:(NSTimeInterval) duration
{
    return [[[self alloc] initWithTransform:CGAffineTransformMakeRotation(radians)
                                   duration:duration] autorelease];
}

+ (KSTransformPopupAction*) scaleToX:(float) x
                                   y:(float) y
                            duration:(NSTimeInterval) duration
{
    return [[[self alloc] initWithTransform:CGAffineTransformMakeScale(x, y)
                                    duration:duration] autorelease];
}

- (id) initWithTransform:(CGAffineTransform)transform
                duration:(NSTimeInterval)duration
{
    if(nil != (self = [super initWithDuration:duration]))
    {
        transform_ = transform;
    }
    return self;
}

- (void) applyToView:(UIView*) view
    onCompletionCall:(id) target
            selector:(SEL) selector
{
    [super applyToView:view onCompletionCall:target selector:selector];
    
    view.transform = transform_;
}

@end



#pragma mark -
#pragma mark KSMovePopupAction

@implementation KSMovePopupAction

+ (KSMovePopupAction*) actionWithPosition:(CGPoint) position
                                 duration:(NSTimeInterval) duration
{
    return [[[self alloc] initWithPosition:position duration:duration] autorelease];
}

- (id) initWithPosition:(CGPoint) position
               duration:(NSTimeInterval) duration
{
    if(nil != (self = [super initWithDuration:duration]))
    {
        position_ = position;
    }
    return self;
}

- (void) applyToView:(UIView*) view
    onCompletionCall:(id) target
            selector:(SEL) selector
{
    [super applyToView:view onCompletionCall:target selector:selector];
    
    view.center = position_;
}

@end



#pragma mark -
#pragma mark KSAlphaPopupAction

@implementation KSAlphaPopupAction

+ (KSAlphaPopupAction*) actionWithAlpha:(float) alpha
                               duration:(NSTimeInterval) duration
{
    return [[[self alloc] initWithAlpha:alpha duration:duration] autorelease];
}

- (id) initWithAlpha:(float) alpha duration:(NSTimeInterval) duration
{
    if(nil != (self = [super initWithDuration:duration]))
    {
        alpha_ = alpha;
    }
    return self;
}

- (void) applyToView:(UIView*) view
    onCompletionCall:(id) target
            selector:(SEL) selector
{
    [super applyToView:view onCompletionCall:target selector:selector];
    
    view.alpha = alpha_;
}

@end
