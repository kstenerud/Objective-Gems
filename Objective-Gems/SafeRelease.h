//
//  SafeRelease.h
//  Objective-Gems
//
//  Created by Karl Stenerud.
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
