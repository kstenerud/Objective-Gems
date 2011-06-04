//
//  KSPopupQueue.h
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

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "KSPopup.h"


@interface KSPopupQueue : NSObject
{
    NSMutableArray* queuedPopups_;
    NSMutableArray* queuedPopupCallbacks_;
}

/** Make this class a singleton, accessible using "sharedInstance"
 */
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KSPopupQueue);

/** Slide in a view.
 *
 * @param controller The controller containing the view to pop up.
 * @param sourcePosition The position to slide in from.
 * @param toCenter If NO, slide in only to the edge of the screen.
 *                 If YES, slide in all the way to the center.
 * @return The process handling this popup.
 */
- (KSPopupProcess*) slideInController:(UIViewController*) controller
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
 * @return The process handling this popup.
 */
- (KSPopupProcess*) slideInController:(UIViewController*) controller
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
 * @return The process handling this popup.
 */
- (KSPopupProcess*) zoomInWithController:(UIViewController*) controller;

/** Zoom in a view.
 *
 * @param controller The controller containing the view to pop up.
 * @param duration The duration of the transition.
 * @param superview The superview to attach the popup to (nil = key window)
 * @param modal If YES, pop up as "modal" (all other input disabled)
 * @param target The target to call when the popup is dismissed (nil = ignore)
 * @param selector The selector to invoke when the popup is dismissed.
 * @return The process handling this popup.
 */
- (KSPopupProcess*) zoomInWithController:(UIViewController*) controller
                                duration:(NSTimeInterval) duration
                               superview:(UIView*) superview
                                   modal:(BOOL) modal
                           onDismissCall:(id) target
                                selector:(SEL) selector;

/** Bump-zoom in a view.
 *
 * @param controller The controller containing the view to pop up.
 * @return The process handling this popup.
 */
- (KSPopupProcess*) bumpZoomInWithController:(UIViewController*) controller;

/** Bump-zoom in a view.
 *
 * @param controller The controller containing the view to pop up.
 * @param duration The duration of the transition.
 * @param superview The superview to attach the popup to (nil = key window)
 * @param modal If YES, pop up as "modal" (all other input disabled)
 * @param target The target to call when the popup is dismissed (nil = ignore)
 * @param selector The selector to invoke when the popup is dismissed.
 * @return The process handling this popup.
 */
- (KSPopupProcess*) bumpZoomInWithController:(UIViewController*) controller
                                    duration:(NSTimeInterval) duration
                                   superview:(UIView*) superview
                                       modal:(BOOL) modal
                               onDismissCall:(id) target
                                    selector:(SEL) selector;

/** Fade in a view.
 *
 * @param controller The controller containing the view to pop up.
 * @return The process handling this popup.
 */
- (KSPopupProcess*) fadeInController:(UIViewController*) controller;

/** Fade in a view.
 *
 * @param controller The controller containing the view to pop up.
 * @param duration The duration of the transition.
 * @param superview The superview to attach the popup to (nil = key window)
 * @param modal If YES, pop up as "modal" (all other input disabled)
 * @param target The target to call when the popup is dismissed (nil = ignore)
 * @param selector The selector to invoke when the popup is dismissed.
 * @return The process handling this popup.
 */
- (KSPopupProcess*) fadeInController:(UIViewController*) controller
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
 * @return The process handling this popup.
 */
- (KSPopupProcess*) popupController:(UIViewController*) controller
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
