//
//  NSData+Aes256.m
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

#import "NSData+AES256.h"
#import <CommonCrypto/CommonCryptor.h>

// Key size is 32 bytes for AES256
#define kKeySize kCCKeySizeAES256

@implementation NSData (Aes256)

/** Generic encrypt/decrypt method.
 *
 * @param keyData The encryption key.
 * @param keyLength The length of the encryption key (max 32). If it's less than 32 the key will be padded with 0s.
 * @param decrypt If YES, decrypt the data. Otherwise encrypt the data.
 * @return The encrypted or decrypted data.
 */
- (NSData*) makeCryptedVersionWithKeyData:(const void*) keyData ofLength:(int) keyLength decrypt:(bool) decrypt
{
	// Copy the key data, padding with zeroes if needed
	char key[kKeySize];
	bzero(key, sizeof(key));
	memcpy(key, keyData, keyLength > kKeySize ? kKeySize : keyLength);
	
	size_t bufferSize = [self length] + kCCBlockSizeAES128;
	void* buffer = malloc(bufferSize);
	
	size_t dataUsed;
	
	CCCryptorStatus status = CCCrypt(decrypt ? kCCDecrypt : kCCEncrypt,
									 kCCAlgorithmAES128,
									 kCCOptionPKCS7Padding | kCCOptionECBMode,
									 key, kKeySize,
									 NULL,
									 [self bytes], [self length],
									 buffer, bufferSize,
									 &dataUsed);

	switch(status)
	{
		case kCCSuccess:
			return [NSData dataWithBytesNoCopy:buffer length:dataUsed];
		case kCCParamError:
			NSLog(@"Error: NSData+Aes256: Could not %s data: Param error", decrypt ? "decrypt" : "encrypt");
			break;
		case kCCBufferTooSmall:
			NSLog(@"Error: NSData+Aes256: Could not %s data: Buffer too small", decrypt ? "decrypt" : "encrypt");
			break;
		case kCCMemoryFailure:
			NSLog(@"Error: NSData+Aes256: Could not %s data: Memory failure", decrypt ? "decrypt" : "encrypt");
			break;
		case kCCAlignmentError:
			NSLog(@"Error: NSData+Aes256: Could not %s data: Alignment error", decrypt ? "decrypt" : "encrypt");
			break;
		case kCCDecodeError:
			NSLog(@"Error: NSData+Aes256: Could not %s data: Decode error", decrypt ? "decrypt" : "encrypt");
			break;
		case kCCUnimplemented:
			NSLog(@"Error: NSData+Aes256: Could not %s data: Unimplemented", decrypt ? "decrypt" : "encrypt");
			break;
		default:
			NSLog(@"Error: NSData+Aes256: Could not %s data: Unknown error", decrypt ? "decrypt" : "encrypt");
	}

	free(buffer);
	return nil;
}


- (NSData*) encryptedWithKey:(NSData*) key
{
	return [self makeCryptedVersionWithKeyData:[key bytes] ofLength:[key length] decrypt:NO];
}

- (NSData*) decryptedWithKey:(NSData*) key
{
	return [self makeCryptedVersionWithKeyData:[key bytes] ofLength:[key length] decrypt:YES];
}

@end
