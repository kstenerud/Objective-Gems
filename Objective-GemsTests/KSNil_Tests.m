//
//  KSNil_Tests.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 4/22/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import "KSNil.h"

@interface KSNil_Tests : SenTestCase {}
@end

@interface KSNil_FakeClass: NSObject
{
}

- (void) doTheLongLong:(long long) value;

@end

@implementation KSNil_FakeClass

- (void) doTheLongLong:(long long) value
{
    // Actually, do nothing.
}

@end


@implementation KSNil_Tests

- (void) testRetainRelease
{
    id object = [KSNil null];
    
    STAssertTrue([object retainCount] == 0, @"Retain count should be 0 but was %d", [object retainCount]);
    [object retain];
    STAssertTrue([object retainCount] == 0, @"Retain count should be 0 but was %d", [object retainCount]);
    [object release];
    STAssertTrue([object retainCount] == 0, @"Retain count should be 0 but was %d", [object retainCount]);
}

- (void) testMethod
{
    id object = [KSNil null];
    id result = [object subpathsOfDirectoryAtPath:@"/" error:nil];
    STAssertEqualObjects(result, nil, @"Should be nil");
}

- (void) testPrimitiveMethod
{
    id object = [KSNil null];
    unsigned int result = [object processorCount];
    STAssertTrue(result == 0, @"Should be 0 but was %d", result);
}

- (void) testStructMethod
{
    id object = [KSNil null];
    id result = [object indexPathForRowAtPoint:CGPointMake(100, 100)];
    STAssertEqualObjects(result, nil, @"Should be nil");
    
    // cannot coerce a return struct
    /*
    id object = [KSNil null];
    CGRect result = [object printRect];
    STAssertTrue(result.origin.x == 0 &&
                 result.origin.y == 0 &&
                 result.size.width == 0 &&
                 result.size.height == 0,
                 @"Should be 0,0,0,0 but was %d,%d,%d,%d",
                 result.origin.x,
                 result.origin.y,
                 result.size.width,
                 result.size.height);
     */
}

- (void) testEquals
{
    id object1 = [KSNil null];
    id object2 = [KSNil null];
    
    STAssertEqualObjects(object1, object2, @"Should be equal");
    STAssertFalse([object1 isEqual:nil], @"Should not be equal to nil");
}

- (void) testLongLong
{
    // Make sure we're not clobbering memory
    id object = [KSNil null];
    long long value = 100;
    [object doTheLongLong:value];
}

@end
