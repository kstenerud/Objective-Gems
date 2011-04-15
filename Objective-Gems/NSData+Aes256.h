//
//  NSData+Aes256.h
//  Objective-Gems
//
//  Created by Karl Stenerud on 10-01-23.
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

#import <Foundation/Foundation.h>

/**
 * Enhancement to add AES 256-bit encryption capabilities.
 */
@interface NSData (Aes256)

/** Make an encrypted copy of the data.
 *
 * @param key The 32 byte encryption key. If it's less than 32, it will be padded with 0s.
 * @return An encrypted version of the data.
 */
- (NSData*) encryptedWithKey:(NSData*) key;

/** Make an encrypted copy of the data.
 *
 * @param key The 32 byte encryption key. If it's less than 32, it will be padded with 0s.
 * @return A decrypted version of the data.
 */
- (NSData*) decryptedWithKey:(NSData*) key;

@end
