//
//  NSData+Aes256_Tests.m
//  Objective-Gems
//

#import "NSData+Aes256.h"

@interface NSData_Aes256_Tests : SenTestCase {}
@end


@implementation NSData_Aes256_Tests

- (void) testEncryptDecrypt
{
    NSData* key = [@"This is a key" dataUsingEncoding:NSUTF8StringEncoding];
    NSData* expectedResult = [@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." dataUsingEncoding:NSUTF8StringEncoding];
    NSData* encryptedResult = [expectedResult encryptedWithKey:key];
    NSData* actualResult = [encryptedResult decryptedWithKey:key];
    
    
    STAssertFalse([expectedResult isEqualToData:encryptedResult], @"Encrypted should not be the same as decrypted");
    STAssertEqualObjects(actualResult, expectedResult, @"Decrypted data was different");
}

@end
