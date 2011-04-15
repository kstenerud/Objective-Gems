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


typedef enum
{
	PopupPositionCenter,
	PopupPositionLeft,
	PopupPositionTopLeft,
	PopupPositionTop,
	PopupPositionTopRight,
	PopupPositionRight,
	PopupPositionBottomRight,
	PopupPositionBottom,
	PopupPositionBottomLeft,
} KSPopupPosition;


@interface KSPopupAction: NSObject
{
	NSTimeInterval duration_;
}
@property(readwrite,assign) NSTimeInterval duration;

- (id) initWithDuration:(NSTimeInterval) duration;

- (KSPopupAction*) inverseAction;

- (void) applyTo:(UIViewController*) controller;

@end


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



@interface KSPopupFactory: NSObject
{
}

+ (KSPopup*) popupSlideFrom:(KSPopupPosition) startPos
                         to:(KSPopupPosition) endPos
                   duration:(NSTimeInterval) duration;

@end



// No need for sequential.  Popup will manage sequential actions

@interface KSConcurrentPopupAction: KSPopupAction
{
	NSMutableArray* actions_;
}
@property(readonly) NSMutableArray* actions;

@end

@interface KSTransformPopupAction: KSPopupAction
{
	CGAffineTransform transform_;
}
@property(readonly) CGAffineTransform transform;

+ (KSTransformPopupAction*) actionWithDuration:(NSTimeInterval)duration
                                     transform:(CGAffineTransform)transform;

+ (KSTransformPopupAction*) translateByX:(float) x y:(float) y duration:(NSTimeInterval) duration;

+ (KSTransformPopupAction*) rotateBy:(float) radians duration:(NSTimeInterval) duration;

+ (KSTransformPopupAction*) scaleByX:(float) x y:(float) y duration:(NSTimeInterval) duration;

- (id) initWithDuration:(NSTimeInterval)duration
			  transform:(CGAffineTransform)transform;

- (KSTransformPopupAction*) inverseAction;

@end


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

@interface KSAlphaPopupAction: KSPopupAction
{
	CGFloat alpha_;
}

@end

@interface KSBackgroundcolorPopupAction: KSPopupAction
{
	UIColor* backgroundColor_;
}

@end



/*
 frame
 bounds
 center
 transform
 alpha
 backgroundColor
 */
