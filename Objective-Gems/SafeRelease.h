//
//  SafeRelease.h
//  Objective-Gems
//
//  Created by Karl Stenerud.
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


/* Safe release mechanisms, which set the object pointer to -1 after
 * releasing so that there's virtually no chance of accidentally
 * accessing a valid object that got allocated at the same address.
 *
 * Attempting to send a message to an object address of -1 will cause
 * the application to crash, unlike 0 which would give a standard nil
 * response, potentially covering up a bug.
 */

/** Size-safe pointer to -1 */
#define INVALID_OBJECT_ ((void*)(((char*)((void*)0))-1))

/** Release an object and set its pointer to an invalid location (-1).
 *
 * @param OBJ The object to release.
 */
#define SAFE_RELEASE(OBJ) \
{ \
	[OBJ release]; \
	OBJ = INVALID_OBJECT_; \
}

/** Release a core foundation object and set its pointer to an invalid
 * location (-1).
 *
 * @param OBJ The object to release.  If OBJ is NULL, it won't release,
 *            but will still set the pointer to -1.
 */
#define SAFE_CFRELEASE(OBJ) \
{ \
	if(nil != OBJ) \
	{ \
		CFRelease(OBJ); \
	} \
	OBJ = INVALID_OBJECT_; \
}

/** Invalidate an NSTimer and set its pointer to an invalid location (-1).
 *
 * @param OBJ The timer to invalidate.
 */
#define SAFE_INVALIDATE(OBJ) \
{ \
	[OBJ invalidate]; \
	OBJ = INVALID_OBJECT_; \
}
