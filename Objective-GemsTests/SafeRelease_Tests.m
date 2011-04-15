//
//  SafeRelease_Tests.m
//  Objective-Gems
//

#import "SafeRelease.h"

@interface SafeRelease_Tests : SenTestCase {}
@end


@implementation SafeRelease_Tests

- (void) testSafeRelease
{
    id object = [NSObject new];
    SAFE_RELEASE(object);
    
    STAssertTrue(object == INVALID_OBJECT_, @"Pointer was %p. Expected %p", object, INVALID_OBJECT_);
}

- (void) testSafeCFRelease
{
    CFArrayRef object = CFArrayCreate(NULL, NULL, 0, NULL);
    SAFE_CFRELEASE(object);
    
    STAssertTrue(object == INVALID_OBJECT_, @"Pointer was %p. Expected %p", object, INVALID_OBJECT_);
}

- (void) testSafeInvalidate
{
    id object = [NSTimer timerWithTimeInterval:1 target:self selector:nil userInfo:nil repeats:NO];
    SAFE_INVALIDATE(object);
    
    STAssertTrue(object == INVALID_OBJECT_, @"Pointer was %p. Expected %p", object, INVALID_OBJECT_);
}


@end
