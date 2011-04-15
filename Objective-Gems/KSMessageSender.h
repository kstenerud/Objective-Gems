//
//  KSMessageSender.h
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

// Requires:
// - MessageUI.framework


/**
 * Opens the iPhone's built-in mailer to send an email message.
 *
 * The developer may optionally specify a delegate to inform of the result
 * of the mailing operation (successful or not, the user cancelled, etc).
 */
@interface KSMessageSender : NSObject
{
	/** TRUE only if the current device has iOS 4.0 or higher. */
	bool supportsSms_;

    /** List of presenters that are currently active. */
    NSMutableArray* presenters_;
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(KSMessageSender);

/** Returns YES if the operating system supports sending SMS messages
 * via MFMessageComposeViewController (iOS 4.0+).
 *
 * @return YES if the OS supports sending SMS.
 */
@property(readonly) bool supportsSms;

/** Returns YES if the current device is capable of sending text messages.
 *
 * A device may be unable to send messages if it does not support text messaging
 * or if it is not currently configured to send messages.
 */
@property(readonly) bool canSendSMS;

/** Open an SMS send view with the specified information.
 * Upon completion, the target will have the specified selector invoked with
 * a MessageResult object.
 *
 * @param recipient The recipient's phone number (can be nil).
 * @param message The message body (can be nil).
 */
- (void) sendSMSTo:(NSString*) number
		   message:(NSString*) message;

/** Open an SMS send view with the specified information.
 * Upon completion, the target will have the specified selector invoked.
 * The selector must have the format:
 * - (void) onSmsSendComplete:(MessageComposeResult) result
 *
 * @param recipient The recipient's phone number (can be nil).
 * @param message The message body (can be nil).
 * @param resultTarget The target to inform if the result (can be nil).
 * @param selector The selector to invoke on the target (can be nil if target is nil).
 */
- (void) sendSMSTo:(NSString*) number
		   message:(NSString*) message
	  resultTarget:(id) target
		  selector:(SEL) selector;

/** Open an email send view with the specified information.
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

/** Open an email send view with the specified information.
 * Upon completion, the target will have the specified selector invoked.
 * The selector must have the format:
 * - (void) onMailSendComplete:(MFMailComposeResult) result error:(NSError*) error
 *
 * @param recipient The recipient's email address (can be nil).
 * @param subject The subject of the message (can be nil).
 * @param message The message body (can be nil).
 * @param isHtml If YES, the message body is to be interpreted as HTML.
 * @param resultTarget The target to inform if the result (can be nil).
 * @param selector The selector to invoke on the target (can be nil if target is nil).
 */
- (void) sendMailTo:(NSString*) recipient
			subject:(NSString*) subject
			message:(NSString*) message
			 isHtml:(bool) isHtml
	   resultTarget:(id) target
		   selector:(SEL) selector;

/** Open an email send view with the specified information.
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

/** Open an email send view with the specified information.
 * Upon completion, the target will have the specified selector invoked.
 * The selector must have the format:
 * - (void) onMailSendComplete:(MFMailComposeResult) result error:(NSError*) error
 *
 * @param recipients The recipients' email addresses (can be nil).
 * @param subject The subject of the message (can be nil).
 * @param message The message body (can be nil).
 * @param isHtml If YES, the message body is to be interpreted as HTML.
 * @param resultTarget The target to inform if the result (can be nil).
 * @param selector The selector to invoke on the target (can be nil if target is nil).
 */
- (void) sendMailToRecipients:(NSArray*) recipients
					  subject:(NSString*) subject
					  message:(NSString*) message
					   isHtml:(bool) isHtml
				 resultTarget:(id) target
					 selector:(SEL) selector;

@end
