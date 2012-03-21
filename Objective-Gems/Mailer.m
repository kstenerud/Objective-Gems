//
//  Mailer.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 10-01-19.
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

#import "Mailer.h"

SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(Mailer);

@implementation Mailer

SYNTHESIZE_SINGLETON_FOR_CLASS(Mailer);

- (id) init
{
	if (nil != (self = [super init]))
	{
		dummyViewController = [[UIViewController alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[dummyViewController release];
    [dummyView release];
    
	[super dealloc];
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
				   attachments:nil
				  resultTarget:nil
					  selector:nil];
}

- (void) sendMailTo:(NSString*) recipient
			subject:(NSString*) subject
			message:(NSString*) message
			 isHtml:(bool) isHtml
		attachments:(NSDictionary*) attachments
	   resultTarget:(id) target
		   selector:(SEL) selector
{
	NSArray* recipients = nil == recipient ? nil : [NSArray arrayWithObject:recipient];
	[self sendMailToRecipients:recipients
					   subject:subject
					   message:message
						isHtml:isHtml
				   attachments:attachments
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
				   attachments:nil
				  resultTarget:nil
					  selector:nil];
}

- (void) sendMailToRecipients:(NSArray*) recipients
					  subject:(NSString*) subject
					  message:(NSString*) message
					   isHtml:(bool) isHtml
				  attachments:(NSDictionary*) attachments
				 resultTarget:(id) target
					 selector:(SEL) selector
{
	mailResultTarget = target;
	mailResultSelector = selector;
	MFMailComposeViewController* mailController = [[[MFMailComposeViewController alloc] init] autorelease];
	[mailController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
	if(nil == mailController)
	{
		[mailResultTarget performSelector:mailResultSelector
							   withObject:[MailComposeResult resultWithResult:MFMailComposeResultFailed error:nil]];
		return;
	}

	mailController.mailComposeDelegate = self;
	
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

	for(NSString* filename in attachments)
	{
		[mailController addAttachmentData:[attachments objectForKey:filename]
								 mimeType:@"application/octet-stream"
								 fileName:filename];
	}
	
    [self presentMailController:mailController resultTarget:target selector:selector];
}

- (void) presentMailController:(MFMailComposeViewController*) mailController
				  resultTarget:(id) target
					  selector:(SEL) selector
{
	mailResultTarget = target;
	mailResultSelector = selector;
	mailController.mailComposeDelegate = self;

	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if([[window subviews] count] == 0)
	{
		NSArray* windows = [UIApplication sharedApplication].windows;
		for(int i = (int)[windows count] - 1; i >= 0; i--)
		{
			window = [windows objectAtIndex:(NSUInteger)i];
			if([[window subviews] count] > 0)
			{
				break;
			}
		}
	}

    UIView* view;
	if([[window subviews] count] > 0)
	{
		view = [window.subviews objectAtIndex:[[window subviews] count]-1];
	}
	else
	{
		dummyView = [[UIView alloc] init];
		[[UIApplication sharedApplication].keyWindow addSubview:dummyView];
		view = dummyView;
	}
    
    
	// Create a dummy controller to present the controller.
	[dummyViewController release];
	dummyViewController = [[UIViewController alloc] init];
	[dummyViewController setView:view];
	[dummyViewController presentModalViewController:dummyViewController animated:YES];
}

- (void) mailComposeController:(MFMailComposeViewController*)mailController
		   didFinishWithResult:(MFMailComposeResult)result
						 error:(NSError*)error
{
	// Use the dummy controller to dismiss the controller.
	[dummyViewController becomeFirstResponder];
	[dummyViewController dismissModalViewControllerAnimated:YES];
	[dummyViewController release];
	dummyViewController = nil;
	
	[dummyView removeFromSuperview];
	[dummyView release];
	dummyView = nil;

	// Inform the delegate.
	[mailResultTarget performSelector:mailResultSelector
						   withObject:[MailComposeResult resultWithResult:result error:error]];
}


@end

@implementation MailComposeResult

+ (id) resultWithResult:(MFMailComposeResult) result error:(NSError*) error
{
	return [[[self alloc] initWithResult:result error:error] autorelease];
}

- (id) initWithResult:(MFMailComposeResult) resultIn error:(NSError*) errorIn
{
	if(nil != (self = [super init]))
	{
		result = resultIn;
		error = [errorIn retain];
	}
	return self;
}

- (void) dealloc
{
	[error release];
	[super dealloc];
}

@synthesize result;
@synthesize error;

@end

