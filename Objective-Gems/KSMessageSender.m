//
//  KSMessageSender.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 10-01-19.
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

#import "KSMessageSender.h"
#import "KSPopup.h"
#import <objc/message.h>


@class KSMSMessageViewPresenter;

@interface KSMessageSender ()

/** Remove a presenter from the presenters list. */
- (void) removePresenter:(KSMSMessageViewPresenter*) presenter;

@end


#pragma mark -
#pragma mark KSMSMessageViewPresenter

/**
 * Presents a message compose view.
 */
@interface KSMSMessageViewPresenter : NSObject <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    KSMessageSender* sender_;
    UIViewController* controller_;
    id target_;
    SEL selector_;
    BOOL animated_;
}

/** Create a new message presenter.
 *
 * @param sender The sender that holds a retain on this object.
 * @param controller The message view controller to present.
 * @param target The target to inform when the message operation completes.
 * @param selector The selector to call on the target.
 * @param animated If true, present and dismiss the controller with a slide animation.
 * @return A new message view presenter.
 */
+ (KSMSMessageViewPresenter*) presenterWithSender:(KSMessageSender*) sender
                                   controller:(UIViewController*) controller
                                       target:(id) target
                                     selector:(SEL) selector
                                     animated:(BOOL) animated;

/** Initialize a message presenter.
 *
 * @param sender The sender that holds a retain on this object.
 * @param controller The message view controller to present.
 * @param target The target to inform when the message operation completes.
 * @param selector The selector to call on the target.
 * @param animated If true, present and dismiss the controller with a slide animation.
 * @return The initialized message view presenter.
 */
- (id) initWithSender:(KSMessageSender*) sender
           controller:(UIViewController*) controller
               target:(id) target
             selector:(SEL) selector
             animated:(BOOL) animated;

/** Present the view.
 */
- (void) presentView;

/** Dismiss the view.
 */
- (void) dismissView;

@end

@interface KSMSMessageViewPresenter ()

/** Inform the target of the result of the message operation.
 *
 * @param result The operation result.
 * @paran error The error, if any.
 */
- (void) informTarget:(NSUInteger) result error:(NSError*) error;

@end



@implementation KSMSMessageViewPresenter

+ (KSMSMessageViewPresenter*) presenterWithSender:(KSMessageSender*) sender
                                   controller:(UIViewController*) controller
                                       target:(id) target
                                     selector:(SEL) selector
                                     animated:(BOOL) animated
{
    return [[[self alloc] initWithSender:sender
                              controller:controller
                                  target:target
                                selector:selector
                                animated:animated] autorelease];
}

- (id) initWithSender:(KSMessageSender*) sender
           controller:(UIViewController*) controller
               target:(id) target
             selector:(SEL) selector
             animated:(BOOL) animated
{
    if(nil != (self = [super init]))
    {
        sender_ = sender;
        controller_ = [controller retain];
        target_ = [target retain];
        selector_ = selector;
        animated_ = animated;

        if([controller respondsToSelector:@selector(setMailComposeDelegate:)])
        {
            [(id)controller setMailComposeDelegate:self];
        }
        else if([controller respondsToSelector:@selector(setMessageComposeDelegate:)])
        {
            [(id)controller setMessageComposeDelegate:self];
        }
        else
        {
            [self dealloc];
            self = nil;
            [NSException raise:@"Invalid view controller type" format:@"Controller %@ does not respond to setMailComposeDelegate: or setMessageComposeDelegate:", [controller class]];
        }
    }
    return self;
}

- (void) dealloc
{
    [controller_ release];
    [target_ release];
    
    [super dealloc];
}

- (void) presentView
{
    [[KSPopupManager sharedInstance] slideInController:controller_ from:KSPopupPositionBottom toCenter:NO];
}

- (void) dismissView
{
    [[KSPopupManager sharedInstance] dismissPopupView:controller_.view];
}

- (void) informTarget:(NSUInteger) result error:(NSError*) error
{
    if(nil != target_)
    {
		objc_msgSend(target_, selector_, result, error);
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
				 didFinishWithResult:(MessageComposeResult)result
{
    [self dismissView];
    [self informTarget:result error:nil];
    [sender_ removePresenter:self];
}

- (void) mailComposeController:(MFMailComposeViewController*)mailController
		   didFinishWithResult:(MFMailComposeResult)result
						 error:(NSError*)error
{
    [self dismissView];
    [self informTarget:result error:error];
    [sender_ removePresenter:self];
}

@end


#pragma mark -
#pragma mark MessageSender

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(KSMessageSender);


@interface KSMessageSender ()

- (void) presentController:(UIViewController*) controller
                    target:(id) target
                  selector:(SEL) selector
                  animated:(BOOL) animated;

@end

@implementation KSMessageSender

SYNTHESIZE_SINGLETON_FOR_CLASS(KSMessageSender);

- (id) init
{
	if(nil != (self = [super init]))
	{
        presenters_ = [[NSMutableArray alloc] init];
		supportsSms_ = nil != NSClassFromString(@"MFMessageComposeViewController");
	}
	return self;
}

- (void) dealloc
{
    [presenters_ release];
    
    [super dealloc];
}

@synthesize supportsSms = supportsSms_;

- (bool) canSendSMS
{
	return supportsSms_ && [MFMessageComposeViewController canSendText];
}

- (void) sendSMSTo:(NSString*) number
		   message:(NSString*) message
{
	[self sendSMSTo:number
			message:message
	   resultTarget:nil
		   selector:nil];
}

- (void) sendSMSTo:(NSString*) number
		   message:(NSString*) message
	  resultTarget:(id) target
		  selector:(SEL) selector
{
	if(self.canSendSMS)
	{
		MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
		
		if(nil != number)
		{
			controller.recipients = [NSArray arrayWithObject:number];
		}
		if(nil != message)
		{
			controller.body = message;
		}
		
        [self presentController:controller target:target selector:selector animated:YES];
	}
}

- (void) sendMailTo:(NSString*) recipient
			subject:(NSString*) subject
			message:(NSString*) message
			 isHtml:(bool) isHtml
{
	NSArray* recipients = nil == recipient ? nil : [NSArray arrayWithObject:recipient];
	[self sendMailToRecipients:recipients
					   subject:subject
					   message:message
						isHtml:isHtml
				  resultTarget:nil
					  selector:nil];
}

- (void) sendMailTo:(NSString*) recipient
			subject:(NSString*) subject
			message:(NSString*) message
			 isHtml:(bool) isHtml
	   resultTarget:(id) target
		   selector:(SEL) selector
{
	NSArray* recipients = nil == recipient ? nil : [NSArray arrayWithObject:recipient];
	[self sendMailToRecipients:recipients
					   subject:subject
					   message:message
						isHtml:isHtml
				  resultTarget:target
					  selector:selector];
}

- (void) sendMailToRecipients:(NSArray*) recipients
					  subject:(NSString*) subject
					  message:(NSString*) message
					   isHtml:(bool) isHtml
{
	[self sendMailToRecipients:recipients
					   subject:subject
					   message:message
						isHtml:isHtml
				  resultTarget:nil
					  selector:nil];
}

- (void) sendMailToRecipients:(NSArray*) recipients
					  subject:(NSString*) subject
					  message:(NSString*) message
					   isHtml:(bool) isHtml
				 resultTarget:(id) target
					 selector:(SEL) selector
{
	MFMailComposeViewController* mailController = [[[MFMailComposeViewController alloc] init] autorelease];
	
	if(nil != recipients)
	{
		[mailController setToRecipients:recipients];
	}
	if(nil != subject)
	{
		[mailController setSubject:subject];
	}
	if(nil != message)
	{
		[mailController setMessageBody:message isHTML:isHtml];
	}
	
    [self presentController:mailController target:target selector:selector animated:YES];
}

- (void) presentController:(UIViewController*) controller
                    target:(id) target
                  selector:(SEL) selector
                  animated:(BOOL) animated
{
    KSMSMessageViewPresenter* presenter = [KSMSMessageViewPresenter presenterWithSender:self
                                                                     controller:controller
                                                                         target:target
                                                                       selector:selector
                                                                       animated:animated];
    [presenter presentView];
    [presenters_ addObject:presenter];
}


- (void) removePresenter:(KSMSMessageViewPresenter*) presenter
{
    [presenters_ removeObject:presenter];
}

@end
