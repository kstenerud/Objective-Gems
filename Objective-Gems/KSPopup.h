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

#define kKSUndefinedAlpha NAN
#define kKSUndefinedCenter CGPointMake(NAN, NAN)
#define kKSUndefinedTransform CGAffineTransformMake(NAN, NAN, NAN, NAN, NAN, NAN)

/*
 Initial state:
 - center
 - transform
 - alpha
 */

typedef enum
{
	KSPopupDirectionLeft,
	KSPopupDirectionTopLeft,
	KSPopupDirectionTop,
	KSPopupDirectionTopRight,
	KSPopupDirectionRight,
	KSPopupDirectionBottomRight,
	KSPopupDirectionBottom,
	KSPopupDirectionBottomLeft,
} KSPopupDirection;


@interface UIView (KSPopup)

- (void) dismissPopup;

@end


@interface KSPopupAction: NSObject
{
	NSTimeInterval duration_;
    id target_;
    SEL selector_;
}

- (id) initWithDuration:(NSTimeInterval) duration;

@property(readonly) NSTimeInterval duration;

- (void) applyToView:(UIView*) view
    onCompletionCall:(id) target
            selector:(SEL) selector;

@end


@interface KSPopupProcess: NSObject
{
    CGAffineTransform initialTransform_;
    CGPoint initialCenter_;
    float initialAlpha_;
    KSPopupAction* popupAction_;
    KSPopupAction* dismissAction_;
    UIViewController* controller_;
    UIView* modalView_;
}

+ (KSPopupProcess*) processWithController:(UIViewController*) controller
                              popupAction:(KSPopupAction*) popupAction
                            dismissAction:(KSPopupAction*) dismissAction
                                transform:(CGAffineTransform) initialTransform
                                   center:(CGPoint) initialCenter
                                    alpha:(float) initialAlpha
                                    modal:(BOOL) modal;

- (id) initWithController:(UIViewController*) controller
              popupAction:(KSPopupAction*) popupAction
            dismissAction:(KSPopupAction*) dismissAction
                transform:(CGAffineTransform) initialTransform
                   center:(CGPoint) initialCenter
                    alpha:(float) initialAlpha
                    modal:(BOOL) modal;
- (void) popup;
- (void) dismiss;

// callback?

@end


@interface KSPopupManager: NSObject
{
    NSMutableDictionary* activePopups_;
    CGPoint screenCenter_;
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KSPopupManager);

- (void) dismissPopupView:(UIView*) view;

- (void) notifyPopupDismissed:(UIView*) view;

- (void) popupController:(UIViewController*) controller
             popupAction:(KSPopupAction*) popupAction
           dismissAction:(KSPopupAction*) dismissAction
               transform:(CGAffineTransform) initialTransform
                  center:(CGPoint) initialCenter
                   alpha:(float) initialAlpha
                   modal:(BOOL) modal;


- (void) popupZoomWithController:(UIViewController*) controller
                           modal:(BOOL) modal;

- (void) popupSlide:(KSPopupDirection) direction
         controller:(UIViewController*) controller
              modal:(BOOL) modal;

@end



/*
@interface KSPopup : NSObject
{
	bool modal_;
	NSMutableArray* initialStateActions_;
	NSMutableArray* popupActions_;
	NSMutableArray* dismissActions_;
	UIViewController* controller_;
	
	UIView* modalBackView_;
	NSMutableArray* currentActions_;
	unsigned int currentIndex_;
	bool dismissing_;
}

@property(readwrite,assign) bool modal;
@property(readonly) NSMutableArray* initialStateActions;
@property(readonly) NSMutableArray* popupActions;
@property(readonly) NSMutableArray* dismissActions;
@property(readonly) UIViewController* controller;

- (id) initWithViewController:(UIViewController*) controller;

- (void) popup;
- (void) dismiss;

@end
*/



@interface KSConcurrentPopupActions: KSPopupAction
{
	NSMutableArray* actions_;
}

+ (KSConcurrentPopupActions*) actions:(KSPopupAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;

- (id) initWithActions:(KSPopupAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;

- (id) initWithActionsArray:(NSArray*) actions;


@end

@interface KSSequentialPopupActions: KSPopupAction
{
	NSMutableArray* actions_;
    NSInteger currentActionIndex_;
    UIView* view_;
}

+ (KSSequentialPopupActions*) actions:(KSPopupAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;

- (id) initWithActions:(KSPopupAction*) action1, ... NS_REQUIRES_NIL_TERMINATION;

- (id) initWithActionsArray:(NSArray*) actions;

@end


@interface KSTransformPopupAction: KSPopupAction
{
	CGAffineTransform transform_;
}

+ (KSTransformPopupAction*) affineTransform:(CGAffineTransform) transform duration:(NSTimeInterval) duration;

+ (KSTransformPopupAction*) translateToX:(float) x y:(float) y duration:(NSTimeInterval) duration;

+ (KSTransformPopupAction*) rotateTo:(float) radians duration:(NSTimeInterval) duration;

+ (KSTransformPopupAction*) scaleToX:(float) x y:(float) y duration:(NSTimeInterval) duration;

- (id) initWithDuration:(NSTimeInterval)duration
			  transform:(CGAffineTransform)transform;

@end

@interface KSAlphaPopupAction: KSPopupAction
{
	CGFloat alpha_;
}

+ (KSAlphaPopupAction*) actionWithAlpha:(float) alpha duration:(NSTimeInterval) duration;

- (id) initWithAlpha:(float) alpha duration:(NSTimeInterval) duration;

@end





/*
@interface KSFramePopupAction: KSPopupAction
{
	CGRect frame_;
}

@end

@interface KSBoundsPopupAction: KSPopupAction
{
	CGRect bounds_;
}

@end

@interface KSCenterPopupAction: KSPopupAction
{
	CGPoint center_;
}

@end

@interface KSBackgroundcolorPopupAction: KSPopupAction
{
	UIColor* backgroundColor_;
}

@end
*/


/*
 frame
 bounds
 center
 transform
 alpha
 backgroundColor
 */
