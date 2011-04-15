//
//  RetainNoNill_Tests.m
//  Objective-Gems
//

#import "RetainNoNil.h"

@interface RetainNoNil_Tests : SenTestCase {}
@end

@implementation RetainNoNil_Tests

- (void) testNil
{
    STAssertThrows(RETAIN_NO_NIL(nil), @"Should have thrown");
}

- (void) testNotNil
{
    id object = [[NSObject new] autorelease];
    STAssertNoThrow(RETAIN_NO_NIL(object), @"Should have thrown");
}

@end
