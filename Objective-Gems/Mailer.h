//
//  Mailer.h
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

#import <MessageUI/MessageUI.h>
#import "SynthesizeSingleton.h"

/** Opens the iPhone's built-in mailer to send an email message.
 * The developer may optionally specify a delegate to inform of the result
 * of the mailing operation (successful or not, the user cancelled, etc).
 */
@interface Mailer : NSObject <MFMailComposeViewControllerDelegate>
{
	/** The target to inform when mailing is complete (or not). */
	id mailResultTarget;

	/** The selector to invoke on the target. */
	SEL mailResultSelector;

	// Generic controller to present our MFMailComposeViewController.
	UIViewController* dummyViewController;
    
    // Dummy view for the controller
    UIView* dummyView;
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(Mailer);

/** Open the mailer with the specified information.
 *
 * @param recipient The recipient's email address (can be nil).
 * @param subject The subject of the message (can be nil).
 * @param message The message body (can be nil).
 * @param isHtml If YES, the message body is to be interpreted as HTML.
 */
- (void) sendMailTo:(NSString*) recipient
			subject:(NSString*) subject
			message:(NSString*) message
			 isHtml:(bool) isHtml;

/** Open the mailer with the specified information.
 *
 * @param recipient The recipient's email address (can be nil).
 * @param subject The subject of the message (can be nil).
 * @param message The message body (can be nil).
 * @param isHtml If YES, the message body is to be interpreted as HTML.
 * @param attachments A dictionary of filename keys and NSData values.
 * @param target The target to inform if the result (can be nil).
 * @param selector The selector to invoke on the target (can be nil if target is nil).
 */
- (void) sendMailTo:(NSString*) recipient
			subject:(NSString*) subject
			message:(NSString*) message
			 isHtml:(bool) isHtml
		attachments:(NSDictionary*) attachments
	   resultTarget:(id) target
		   selector:(SEL) selector;

/** Open the mailer with the specified information.
 *
 * @param recipients The recipients' email addresses (can be nil).
 * @param subject The subject of the message (can be nil).
 * @param message The message body (can be nil).
 * @param isHtml If YES, the message body is to be interpreted as HTML.
 */
- (void) sendMailToRecipients:(NSArray*) recipients
					  subject:(NSString*) subject
					  message:(NSString*) message
					   isHtml:(bool) isHtml;

/** Open the mailer with the specified information.
 *
 * @param recipients The recipients' email addresses (can be nil).
 * @param subject The subject of the message (can be nil).
 * @param message The message body (can be nil).
 * @param isHtml If YES, the message body is to be interpreted as HTML.
 * @param attachments A dictionary of filename keys and NSData values.
 * @param target The target to inform if the result (can be nil).
 * @param selector The selector to invoke on the target (can be nil if target is nil).
 */
- (void) sendMailToRecipients:(NSArray*) recipients
					  subject:(NSString*) subject
					  message:(NSString*) message
					   isHtml:(bool) isHtml
				  attachments:(NSDictionary*) attachments
				 resultTarget:(id) target
					 selector:(SEL) selector;

- (void) presentMailController:(MFMailComposeViewController*) controller
				  resultTarget:(id) target
					  selector:(SEL) selector;

@end


/** Contains information about the result of a mail operation.
 */
@interface MailComposeResult : NSObject
{
	MFMailComposeResult result;
	NSError* error;
}
/** The result of the mailing operation. @see MFMailComposeResult */
@property(readonly,nonatomic) MFMailComposeResult result;

/** The error that occurred, if any (will be nil if no error occurred). */
@property(readonly,nonatomic) NSError* error;

/**
 * Create a mail result.
 *
 * @param result The mail compose result.
 * @param error: The error that occurred, if any.
 */
+ (id) resultWithResult:(MFMailComposeResult) result error:(NSError*) error;

/**
 * Initialize a mail result.
 *
 * @param result The mail compose result.
 * @param error: The error that occurred, if any.
 */
- (id) initWithResult:(MFMailComposeResult) result error:(NSError*) error;

@end
