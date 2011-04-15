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


/*
 Slide in (from, to)
 zoom in
 
 
 */

@interface KSPopup ()

- (void) runNextActionAnimated:(bool) animated;

- (void) onActionComplete:(NSString*) animationID
				 finished:(NSNumber*) finished
				  context:(void*) context;

@end

@implementation KSPopup

- (id) initWithViewController:(UIViewController*) controllerIn
{
	if(nil != (self = [super init]))
	{
		controller_ = [controllerIn retain];
		initialStateActions_ = [[NSMutableArray arrayWithCapacity:10] retain];
		popupActions_ = [[NSMutableArray arrayWithCapacity:10] retain];
		dismissActions_ = [[NSMutableArray arrayWithCapacity:10] retain];
		currentActions_ = [[NSMutableArray arrayWithCapacity:10] retain];
	}
	return self;
}

- (void) dealloc
{
	[controller_ release];
	[initialStateActions_ release];
	[popupActions_ release];
	[dismissActions_ release];
	[currentActions_ release];
	[modalBackView_ release];
	[super dealloc];
}

@synthesize modal = modal_;
@synthesize initialStateActions = initialStateActions_;
@synthesize popupActions = popupActions_;
@synthesize dismissActions = dismissActions_;
@synthesize controller = controller_;

- (void) popupController:(UIViewController*) controller :(bool) animated
{
	controller_ = [controller retain];
	NSLog(@"Popping up controller %@", controller_);

	UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
	if(modal_)
	{
		NSLog(@"Is modal");
		modalBackView_ = [[UIView alloc] initWithFrame:[keyWindow frame]];
		modalBackView_.backgroundColor = [UIColor clearColor];
		[keyWindow addSubview:modalBackView_];
		[modalBackView_ addSubview:controller_.view];
	}
	else
	{
		NSLog(@"Is not modal");
		[keyWindow addSubview:controller_.view];
	}

	dismissing_ = NO;
	[currentActions_ removeAllObjects];
	[currentActions_ addObjectsFromArray:popupActions_];
	currentIndex_ = 0;
	[self runNextActionAnimated:animated];
}

- (void) dismissAnimated:(bool) animated
{
	dismissing_ = YES;
	[currentActions_ removeAllObjects];
	// TODO: Make default dismiss actions.
	[currentActions_ addObjectsFromArray:dismissActions_];
	currentIndex_ = 0;
	[self runNextActionAnimated:animated];
}


- (void) runNextActionAnimated:(bool) animated
{
	KSPopupAction* currentAction = [currentActions_ objectAtIndex:currentIndex_];
	NSLog(@"Run action %@, animated = %d", currentAction, animated);
	
	if(animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:currentAction.duration];
	}
	
	[currentAction applyTo:controller_];
	
	if(animated)
	{
		[UIView setAnimationDelegate:self];
		[UIView setAnimationWillStartSelector:NULL];
		[UIView setAnimationDidStopSelector:@selector(onActionComplete:finished:context:)];
		[UIView commitAnimations];
	}
}

- (void) onActionComplete:(NSString*) animationID
				 finished:(NSNumber*) finished
				  context:(void*) context
{
	NSLog(@"Action complete.");
	currentIndex_++;
	if(currentIndex_ < [currentActions_ count])
	{
		[self runNextActionAnimated:YES];
	}
	else if(dismissing_)
	{
		[modalBackView_ removeFromSuperview];
		[modalBackView_ release];
		modalBackView_ = nil;
		[controller_.view removeFromSuperview];
		[controller_ release];
		controller_ = nil;
	}
}


+ (KSPopup*) popupSlideController:(UIViewController*) controller
						   from:(KSPopupPosition) startPos
							 to:(KSPopupPosition) endPos
					   duration:(NSTimeInterval) duration
{
	KSPopup* popup = [[[self alloc] init] autorelease];
	
//	float startX = 0;
//	float startY = 0;
	switch(startPos)
	{
		case PopupPositionLeft:
			break;
		case PopupPositionTopLeft:
			break;
		case PopupPositionTop:
			break;
		case PopupPositionTopRight:
			break;
		case PopupPositionRight:
			break;
		case PopupPositionBottomRight:
			break;
		case PopupPositionBottom:
			break;
		case PopupPositionBottomLeft:
			break;
		case PopupPositionCenter:
			break;
	}
	
	[popup.popupActions addObject:[KSTransformPopupAction translateByX:320 y:0 duration:0.5]];
	
	return popup;
}

- (void) popup
{
    // TODO
}

- (void) dismiss
{
    // TODO
}

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

- (void) applyTo:(UIViewController*) controller
{
	// Do nothing
}

- (KSPopupAction*) inverseAction
{
	NSAssert(false, @"Subclasses must override inverseAction");
	return nil;
}

@end



@implementation KSTransformPopupAction

+ (KSTransformPopupAction*) actionWithDuration:(NSTimeInterval) duration
								   transform:(CGAffineTransform) transform
{
	return [[[self alloc] initWithDuration:duration transform:transform] autorelease];
}

+ (KSTransformPopupAction*) translateByX:(float) x y:(float) y duration:(NSTimeInterval) duration
{
	return [self actionWithDuration:duration transform:CGAffineTransformMakeTranslation(x, y)];
}

+ (KSTransformPopupAction*) rotateBy:(float) radians duration:(NSTimeInterval) duration
{
	return [self actionWithDuration:duration transform:CGAffineTransformMakeRotation(radians)];
}

+ (KSTransformPopupAction*) scaleByX:(float) x y:(float) y duration:(NSTimeInterval) duration
{
	return [self actionWithDuration:duration transform:CGAffineTransformMakeScale(x, y)];
}

- (id) initWithDuration:(NSTimeInterval)duration
			  transform:(CGAffineTransform)transform
{
	if(nil != (self = [super initWithDuration:duration]))
	{
		transform_ = transform;
	}
	return self;
}

@synthesize transform = transform_;

- (KSPopupAction*) inverseAction
{
	return [[self class] actionWithDuration:duration_ transform:CGAffineTransformInvert(transform_)];
}

- (void) applyTo:(UIViewController*) controller
{
	controller.view.transform = CGAffineTransformConcat(controller.view.transform, transform_);
}

@end



@implementation KSFramePopupAction

@end



@implementation KSBoundsPopupAction

@end



@implementation KSCenterPopupAction

@end



@implementation KSAlphaPopupAction

@end



@implementation KSBackgroundcolorPopupAction

@end
