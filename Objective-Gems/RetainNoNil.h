//
//  RetainNoNil.h
//  Objective-Gems
//
// Copyright 2010 Karl Stenerud
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Note: You are NOT required to make the license available from within your
// iOS application. Including it in your project is sufficient.
//
// Attribution is not required, but appreciated :)
//

#import <Foundation/Foundation.h>

/** Retain an object but throw an exception if it was nil.
 *
 * @param OBJECT The object to retain.
 * @return The retained object.
 */
#define RETAIN_NO_NIL(OBJECT) rnn_retainNoNil(OBJECT, @#OBJECT)

/** Implementation of retain-no-nil.
 *
 * @param object The object to retain.
 * @param name The name for the object (displayed in the exception).
 * @return The retained object.
 */
static inline id rnn_retainNoNil(id object, NSString* name)
{
	if(nil == object)
	{
		[NSException raise:@"nil object"
					format:@"%@ was nil", name];
	}
	return [object retain];
}
