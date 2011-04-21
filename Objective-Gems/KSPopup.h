//
//  KSPopup.h
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

#import <UIKit/UIKit.h>
#import "SynthesizeSingleton.h"



/* "Ignore" values. Use these to tell the popup manager not to set an initial
 * value for the specified property.
 */
#define kKSIgnoreAlpha NAN
#define kKSIgnorePosition CGPointMake(NAN, NAN)
#define kKSIgnoreTransform CGAffineTransformMake(NAN, NAN, NAN, NAN, NAN, NAN)

/** Position values used in certain actions.
 */
typedef enum
{
    KSPopupPositionCenter = 0,
	KSPopupPositionLeft = 1,
	KSPopupPositionRight = 2,
	KSPopupPositionTop = 4,
	KSPopupPositionBottom = 8,
	KSPopupPositionTopLeft = 5,
	KSPopupPositionTopRight = 6,
	KSPopupPositionBottomLeft = 9,
	KSPopupPositionBottomRight = 10,
} KSPopupPosition;

@class KSPopupAction;



#pragma mark -
#pragma mark UIView Category

/**
 * Category adding the ability to dismiss a popup from within the popped-up
 * view itself.
 */
@interface UIView (KSPopup)

/** Dismiss this view (if it's a popup)
 */
- (void) dismissPopup;

@end



#pragma mark -
#pragma mark KSPopupManager

/**
 * Launches and manages popup views.
 */
@interface KSPopupManager: NSObject
{
    /** All currently active popup processes. */
    NSMutableDictionary* activePopups_;
}

/** Make this class a singleton, accessible using "sharedInstance"
 */
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KSPopupManager);

/** Slide in a view.
 *
 * @param controller The controller containing the view to pop up.
 * @param sourcePosition The position to slide in from.
 * @param toCenter If NO, slide in only to the edge of the screen.
 *                 If YES, slide in all the way to the center.
 */
- (void) slideInController:(UIViewController*) controller
                      from:(KSPopupPosition) sourcePosition
                  toCenter:(BOOL) toCenter;

/** Slide in a view.
 *
 * @param controller The controller containing the view to pop up.
 * @param sourcePosition The position to slide in from.
 * @param toCenter If NO, slide in only to the edge of the screen.
 *                 If YES, slide in all the way to the center.
 * @param duration The duration of the transition.
 * @param superview The superview to attach the popup to (nil = key window)
 * @param modal If YES, pop up as "modal" (all other input disabled)
 * @param target The target to call when the popup is dismissed (nil = ignore)
 * @param selector The selector to invoke when the popup is dismissed.
 */
- (void) slideInController:(UIViewController*) controller
                      from:(KSPopupPosition) sourcePosition
                  toCenter:(BOOL) toCenter
                  duration:(NSTimeInterval) duration
                 superview:(UIView*) superview
                     modal:(BOOL) modal
             onDismissCall:(id) target
                  selector:(SEL) selector;

/** Zoom in a view.
 *
 * @param controller The controller containing the view to pop up.
 */
- (void) zoomInWithController:(UIViewController*) controller;

/** Zoom in a view.
 *
 * @param controller The controller containing the view to pop up.
 * @param duration The duration of the transition.
 * @param superview The superview to attach the popup to (nil = key window)
 * @param modal If YES, pop up as "modal" (all other input disabled)
 * @param target The target to call when the popup is dismissed (nil = ignore)
 * @param selector The selector to invoke when the popup is dismissed.
 */
- (void) zoomInWithController:(UIViewController*) controller
                     duration:(NSTimeInterval) duration
                    superview:(UIView*) superview
                        modal:(BOOL) modal
                onDismissCall:(id) target
                     selector:(SEL) selector;

/** Bump-zoom in a view.
 *
 * @param controller The controller containing the view to pop up.
 */
- (void) bumpZoomInWithController:(UIViewController*) controller;

/** Bump-zoom in a view.
 *
 * @param controller The controller containing the view to pop up.
 * @param duration The duration of the transition.
 * @param superview The superview to attach the popup to (nil = key window)
 * @param modal If YES, pop up as "modal" (all other input disabled)
 * @param target The target to call when the popup is dismissed (nil = ignore)
 * @param selector The selector to invoke when the popup is dismissed.
 */
- (void) bumpZoomInWithController:(UIViewController*) controller
                         duration:(NSTimeInterval) duration
                        superview:(UIView*) superview
                            modal:(BOOL) modal
                    onDismissCall:(id) target
                         selector:(SEL) selector;

/** Fade in a view.
 *
 * @param controller The controller containing the view to pop up.
 */
- (void) fadeInController:(UIViewController*) controller;

/** Fade in a view.
 *
 * @param controller The controller containing the view to pop up.
 * @param duration The duration of the transition.
 * @param superview The superview to attach the popup to (nil = key window)
 * @param modal If YES, pop up as "modal" (all other input disabled)
 * @param target The target to call when the popup is dismissed (nil = ignore)
 * @param selector The selector to invoke when the popup is dismissed.
 */
- (void) fadeInController:(UIViewController*) controller
                 duration:(NSTimeInterval) duration
                superview:(UIView*) superview
                    modal:(BOOL) modal
            onDismissCall:(id) target
                 selector:(SEL) selector;

/** Dismiss a popped up view.
 *
 * @param view The view to dismiss.
 */
- (void) dismissPopupView:(UIView*) view;


/** Popup a view.
 *
 * @param controller The controller containing the view to pop up.
 * @param popupAction The action that will animate the popup.
 * @param dismissAction The action that will animate the dismiss.
 * @param initialTransform The initial transform to set on the view.
 *                         (Use kKSIgnoreTransform to leave it as-is)
 * @param initialCenter The initial center to set on the view
 *                      (Use kKSIgnorePosition to leave it as-is)
 * @param initialAlpha The initial alpha to set on the view
 *                     (Use kKSIgnoreAlpha to leave it as-is)
 * @param superview The superview to attach the popup to (nil = key window)
 * @param modal If YES, pop up as "modal" (all other input disabled)
 * @param target The target to call when the popup is dismissed (nil = ignore)
 * @param selector The selector to invoke when the popup is dismissed.
 */
- (void) popupController:(UIViewController*) controller
             popupAction:(KSPopupAction*) popupAction
           dismissAction:(KSPopupAction*) dismissAction
        initialTransform:(CGAffineTransform) initialTransform
           initialCenter:(CGPoint) initialCenter
            initialAlpha:(float) initialAlpha
               superview:(UIView*) superview
                   modal:(BOOL) modal
           onDismissCall:(id) target
                selector:(SEL) selector;

@end



#pragma mark -
#pragma mark KSPopupProcess

/**
 * Manages the lifetime of a popup, initiating both popup and dismiss actions.
 */
@interface KSPopupProcess: NSObject
{
    /** The initial transform to apply before popping up the view */
    CGAffineTransform initialTransform_;
    /** The initial center position of the popup view */
    CGPoint initialCenter_;
    /** The initial transparency of the popup view */
    float initialAlpha_;
    /** The action that will pop up the view */
    KSPopupAction* popupAction_;
    /** The action that will dismiss the view */
    KSPopupAction* dismissAction_;
    /** The controller holding the popup view */
    UIViewController* controller_;
    /** The view to attach the popup to */
    UIView* superview_;
    /** If not nil, the view that will render this popup modal */
    UIView* modalView_;
    /** Target to call when the popup is dismissed */
    id target_;
    /** Selector to invoke when the popup is dismissed */
    SEL selector_;
}
/** The controller holding the popup view */
@property(readonly) UIViewController* controller;

/** Create a new popup process.
 *
 * @param controller The controller holding the popup view.
 * @param popupAction The action that will pop up the view.
 * @param dismissAction The action that will dismiss the view.
 * @param initialTransform The initial transform to apply before popping the view.
 * @param initialCenter The initial center position of the popup view.
 * @param initialAlpha The initial transparency of the popup view.
 * @param superview The view to attach the popup to (nil = key window)
 * @param modal If YES, make the popup modal.
 * @param target The target to call when the popup is dismissed.
 * @param selector The selector to invoke when the popup is dismissed.
 * @return a new popup process.
 */
+ (KSPopupProcess*) processWithController:(UIViewController*) controller
                              popupAction:(KSPopupAction*) popupAction
                            dismissAction:(KSPopupAction*) dismissAction
                         initialTransform:(CGAffineTransform) initialTransform
                            initialCenter:(CGPoint) initialCenter
                             initialAlpha:(float) initialAlpha
                                superview:(UIView*) superview
                                    modal:(BOOL) modal
                                   target:(id) target
                                 selector:(SEL) selector;

/** Initialize a popup process.
 *
 * @param controller The controller holding the popup view.
 * @param popupAction The action that will pop up the view.
 * @param dismissAction The action that will dismiss the view.
 * @param initialTransform The initial transform to apply before popping the view.
 * @param initialCenter The initial center position of the popup view.
 * @param initialAlpha The initial transparency of the popup view.
 * @param superview The view to attach the popup to (nil = key window)
 * @param modal If YES, make the popup modal.
 * @param target The target to call when the popup is dismissed.
 * @param selector The selector to invoke when the popup is dismissed.
 * @return The initialized popup process.
 */
- (id) initWithController:(UIViewController*) controller
              popupAction:(KSPopupAction*) popupAction
            dismissAction:(KSPopupAction*) dismissAction
         initialTransform:(CGAffineTransform) initialTransform
            initialCenter:(CGPoint) initialCenter
             initialAlpha:(float) initialAlpha
                superview:(UIView*) superview
                    modal:(BOOL) modal
                   target:(id) target
                 selector:(SEL) selector;

/** Popup the view.
 */
- (void) popup;

/* Dismiss the view.
 */
- (void) dismiss;

@end



#pragma mark -
#pragma mark KSPopupAction

/**
 * Instructs the UIView animation system to modify a view during animation.
 */
@interface KSPopupAction: NSObject
{
    /** The duration of the action */
	NSTimeInterval duration_;
    /** The target to inform when the action completes */
    id target_;
    /** The selector to call when the action completes */
    SEL selector_;
}

/** Initialize an action.
 *
 * @param duration The duration of the action.
 * @return the initialized action.
 */
- (id) initWithDuration:(NSTimeInterval) duration;

/** The duration of the action. */
@property(readonly) NSTimeInterval duration;

/** Apply this action to a view.
 *
 * @param view the view to apply the action to.
 * @param target The target to inform when this action completes.
 * @param selector the selector to call when this action completes.
 */
- (void) applyToView:(UIView*) view
    onCompletionCall:(id) target
            selector:(SEL) selector;

@end



#pragma mark -
#pragma mark KSConcurrentPopupActions

/**
 * Action that executes multiple actions concurrently.
 */
@interface KSConcurrentPopupActions: KSPopupAction
{
    /** Actions to execute. */
	NSMutableArray* actions_;
}

/** Create a new set of concurrent actions.
 *
 * @param action1 The first action in a nil terminated list of actions.
 * @return A new concurrent action.
 */
+ (KSConcurrentPopupActions*) actions:(KSPopupAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;

/** Initialize a new set of concurrent actions.
 *
 * @param action1 The first action in a nil terminated list of actions.
 * @return The initialized concurrent action.
 */
- (id) initWithActions:(KSPopupAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;

/** Initialize a new set of concurrent actions.
 *
 * @param actions The list of actions to run.
 * @return The initialized concurrent action.
 */
- (id) initWithActionsArray:(NSArray*) actions;

@end



#pragma mark -
#pragma mark KSSequentialPopupActions

/**
 * Action that executes multiple actions sequentially.
 */
@interface KSSequentialPopupActions: KSPopupAction
{
    /** Actions to execute */
	NSMutableArray* actions_;
    /** The index of the currently running action */
    NSInteger currentActionIndex_;
    /** The view that is being animated */
    UIView* view_;
}

/** Create a new sequence of actions.
 *
 * @param action1 The first action in a nil terminated list of actions.
 * @return A new sequence of actions.
 */
+ (KSSequentialPopupActions*) actions:(KSPopupAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;

/** Initialize a new sequence of actions.
 *
 * @param action1 The first action in a nil terminated list of actions.
 * @return The initialized sequence of actions.
 */
- (id) initWithActions:(KSPopupAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;

/** Initialize a new sequence of actions.
 *
 * @param actions The list of actions.
 * @return The initialized sequence of actions.
 */
- (id) initWithActionsArray:(NSArray*) actions;

@end



#pragma mark -
#pragma mark KSTransformPopupAction

/**
 * Action that modifies the "transform" property of a view.
 */
@interface KSTransformPopupAction: KSPopupAction
{
    /** The transform to apply */
	CGAffineTransform transform_;
}

/** Create a generic affine transform action.
 *
 * @param transform The transform to apply.
 * @param duration The duration of the action.
 * @return A new transform action.
 */
+ (KSTransformPopupAction*) affineTransform:(CGAffineTransform) transform
                                   duration:(NSTimeInterval) duration;

/** Create a translation transform action.
 *
 * @param position The final position.
 * @param duration The duration of the action.
 * @return A new transform action.
 */
+ (KSTransformPopupAction*) translateTo:(CGPoint) position
                                duration:(NSTimeInterval) duration;

/** Create a rotation transform action.
 *
 * @param radians The final rotation value.
 * @param duration The duration of the action.
 * @return A new transform action.
 */
+ (KSTransformPopupAction*) rotateTo:(float) radians
                            duration:(NSTimeInterval) duration;

/** Create a scale transform action.
 *
 * @param x The final x scale value.
 * @param y The final y scale value.
 * @param duration The duration of the action.
 * @return A new transform action.
 */
+ (KSTransformPopupAction*) scaleToX:(float) x
                                   y:(float) y
                            duration:(NSTimeInterval) duration;

/** Initialize a transform action.
 *
 * @param transform The transform to apply.
 * @param duration The duration of the action.
 * @return The initialized transform action.
 */
- (id) initWithTransform:(CGAffineTransform)transform
                duration:(NSTimeInterval)duration;

@end



#pragma mark -
#pragma mark KSMovePopupAction

/**
 * Action that moves the center point of a view.
 */
@interface KSMovePopupAction: KSPopupAction
{
    /** The position to move the center point to. */
    CGPoint position_;
}

/** Create a new move action.
 *
 * @param position The position to move the view to.
 * @param duration The duration of the move.
 * @return A new move action.
 */
+ (KSMovePopupAction*) actionWithPosition:(CGPoint) position
                                 duration:(NSTimeInterval) duration;

/** Initialize a move action.
 *
 * @param position The position to move the view to.
 * @param duration The duration of the move.
 * @return The initialized move action.
 */
- (id) initWithPosition:(CGPoint) position
               duration:(NSTimeInterval) duration;

@end



#pragma mark -
#pragma mark KSAlphaPopupAction

/**
 * Action that modifies the alpha (transparency) of a view.
 */
@interface KSAlphaPopupAction: KSPopupAction
{
    /** The alpha value to set the view to. */
	CGFloat alpha_;
}

/** Create a new transparency action.
 *
 * @param alpha The alpha to set the view to.
 * @param duration The duration of the fade.
 * @return A new alpha action.
 */
+ (KSAlphaPopupAction*) actionWithAlpha:(float) alpha
                               duration:(NSTimeInterval) duration;

/** Initialize a transparency action.
 *
 * @param alpha The alpha to set the view to.
 * @param duration The duration of the fade.
 * @return The initialized alpha action.
 */
- (id) initWithAlpha:(float) alpha duration:(NSTimeInterval) duration;

@end
