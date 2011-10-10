//
//  NSDictionary+JSONSupport_Tests.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 6/25/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import "NSDictionary+JSONSupport.h"

@interface NSDictionary_JSONSupport_Tests : SenTestCase {} @end


@implementation NSDictionary_JSONSupport_Tests

- (void) testReadJSONBoolGoodValue
{
    BOOL expectedValue;
    BOOL actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"true" forKey:keyName];
    expectedValue = YES;
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"false" forKey:keyName];
    expectedValue = NO;
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
}

- (void) testReadJSONBoolBadValue
{
    BOOL actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"t" forKey:keyName];
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"f" forKey:keyName];
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"yes" forKey:keyName];
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"y" forKey:keyName];
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"no" forKey:keyName];
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"n" forKey:keyName];
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"null" forKey:keyName];
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONBoolMissing
{
    BOOL actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONBoolNull
{
    BOOL actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];

    [jsonDict setValue:[NSNull null] forKey:keyName];
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONBoolIncorrectType
{
    BOOL actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];

    [jsonDict setValue:[NSDate date] forKey:keyName];
    success = [jsonDict readJSONBool:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}


- (void) testReadJSONIntegerGoodValue
{
    int64_t expectedValue;
    int64_t actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"0" forKey:keyName];
    expectedValue = 0;
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"1" forKey:keyName];
    expectedValue = 1;
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"-1" forKey:keyName];
    expectedValue = -1;
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"1000000000000" forKey:keyName];
    expectedValue = 1000000000000;
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"-1000000000000" forKey:keyName];
    expectedValue = -1000000000000;
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    NSString* llongMin = [[NSString stringWithFormat:@"%lld", LLONG_MIN] retain];
    NSString* llongMax = [[NSString stringWithFormat:@"%lld", LLONG_MAX] retain];
    
    [jsonDict setValue:llongMin forKey:keyName];
    expectedValue = LLONG_MIN;
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:llongMax forKey:keyName];
    expectedValue = LLONG_MAX;
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
}

- (void) testReadJSONIntegerBadValue
{
    int64_t actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"true" forKey:keyName];
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"false" forKey:keyName];
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"f100" forKey:keyName];
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@".2" forKey:keyName];
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"[20]" forKey:keyName];
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"one" forKey:keyName];
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"" forKey:keyName];
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"10000000000000000000000000000000000000000000000000000000" forKey:keyName];
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"-10000000000000000000000000000000000000000000000000000000" forKey:keyName];
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONIntegerMissing
{
    int64_t actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONIntegerNull
{
    int64_t actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSNull null] forKey:keyName];
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONIntegerIncorrectType
{
    int64_t actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSNumber numberWithLongLong:1] forKey:keyName];
    success = [jsonDict readJSONInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}


- (void) testReadJSONUIntegerGoodValue
{
    uint64_t expectedValue;
    uint64_t actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"0" forKey:keyName];
    expectedValue = 0;
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"1" forKey:keyName];
    expectedValue = 1;
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"1000000000000" forKey:keyName];
    expectedValue = 1000000000000;
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    NSString* ullongMax = [[NSString stringWithFormat:@"%llu", ULLONG_MAX] retain];
    
    [jsonDict setValue:ullongMax forKey:keyName];
    expectedValue = ULLONG_MAX;
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
}

- (void) testReadJSONUIntegerBadValue
{
    uint64_t actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"-1" forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"-1000000000" forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"true" forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"false" forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"f100" forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@".2" forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"[20]" forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"one" forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"" forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"10000000000000000000000000000000000000000000000000000000" forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONUIntegerMissing
{
    uint64_t actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONUIntegerNull
{
    uint64_t actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSNull null] forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONUIntegerIncorrectType
{
    uint64_t actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSNumber numberWithLongLong:1] forKey:keyName];
    success = [jsonDict readJSONUInteger:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}


- (void) testReadJSONFloatGoodValue
{
    double expectedValue;
    double actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"0" forKey:keyName];
    expectedValue = 0;
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"1" forKey:keyName];
    expectedValue = 1;
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"-1" forKey:keyName];
    expectedValue = -1;
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"1000000000000" forKey:keyName];
    expectedValue = 1000000000000;
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"-1000000000000" forKey:keyName];
    expectedValue = -1000000000000;
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"1.1" forKey:keyName];
    expectedValue = 1.1;
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"-25647.99477343" forKey:keyName];
    expectedValue = -25647.99477343;
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@".1" forKey:keyName];
    expectedValue = .1;
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"0.00000000001" forKey:keyName];
    expectedValue = 0.00000000001;
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
}

- (void) testReadJSONFloatBadValue
{
    double actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"true" forKey:keyName];
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"false" forKey:keyName];
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"f100" forKey:keyName];
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"a.2" forKey:keyName];
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"[20]" forKey:keyName];
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"one" forKey:keyName];
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"" forKey:keyName];
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONFloatMissing
{
    double actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONFloatNull
{
    double actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSNull null] forKey:keyName];
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONFloatIncorrectType
{
    double actualValue;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSNumber numberWithLongLong:1] forKey:keyName];
    success = [jsonDict readJSONFloat:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}


- (void) testReadJSONNumberGoodValue
{
    NSNumber* expectedValue = nil;
    NSNumber* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"0" forKey:keyName];
    expectedValue = [NSNumber numberWithLongLong:0];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"1" forKey:keyName];
    expectedValue = [NSNumber numberWithLongLong:1];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"-1" forKey:keyName];
    expectedValue = [NSNumber numberWithLongLong:-1];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"1000000000000" forKey:keyName];
    expectedValue = [NSNumber numberWithLongLong:1000000000000];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"-1000000000000" forKey:keyName];
    expectedValue = [NSNumber numberWithLongLong:-1000000000000];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"1.1" forKey:keyName];
    expectedValue = [NSNumber numberWithDouble:1.1];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"-25647.99477343" forKey:keyName];
    expectedValue = [NSNumber numberWithDouble:-25647.99477343];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@".1" forKey:keyName];
    expectedValue = [NSNumber numberWithDouble:.1];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"0.000000000000000000000000000000000000000001" forKey:keyName];
    expectedValue = [NSNumber numberWithDouble:0.000000000000000000000000000000000000000001];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");

    NSString* llongMin = [[NSString stringWithFormat:@"%lld", LLONG_MIN] retain];
    NSString* llongMax = [[NSString stringWithFormat:@"%lld", LLONG_MAX] retain];
    
    [jsonDict setValue:llongMin forKey:keyName];
    expectedValue = [NSNumber numberWithLongLong:LLONG_MIN];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:llongMax forKey:keyName];
    expectedValue = [NSNumber numberWithLongLong:LLONG_MAX];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");

    NSString* ullongMax = [[NSString stringWithFormat:@"%llu", ULLONG_MAX] retain];
    
    [jsonDict setValue:ullongMax forKey:keyName];
    expectedValue = [NSNumber numberWithUnsignedLongLong:ULLONG_MAX];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");

    [jsonDict setValue:@"true" forKey:keyName];
    expectedValue = [NSNumber numberWithBool:YES];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"false" forKey:keyName];
    expectedValue = [NSNumber numberWithBool:NO];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEquals(actualValue, expectedValue, @"");
}

- (void) testReadJSONNumberBadValue
{
    NSNumber* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"f100" forKey:keyName];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"a.2" forKey:keyName];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"[20]" forKey:keyName];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"one" forKey:keyName];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"" forKey:keyName];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONNumberMissing
{
    NSNumber* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONNumberNull
{
    NSNumber* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSNull null] forKey:keyName];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONNumberIncorrectType
{
    NSNumber* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSNumber numberWithLongLong:1] forKey:keyName];
    success = [jsonDict readJSONNumber:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}


- (void) testReadJSONDateGoodValue
{
    NSDate* expectedValue = nil;
    NSDate* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    expectedValue = [NSDate date];
    unsigned long long timeInterval = [expectedValue timeIntervalSince1970];
    expectedValue = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    [jsonDict setValue:[NSString stringWithFormat:@"%llu", timeInterval] forKey:keyName];
    success = [jsonDict readJSONDateInSeconds:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
}

- (void) testReadJSONDateBadValue
{
    NSDate* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"f100" forKey:keyName];
    success = [jsonDict readJSONDateInSeconds:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"a.2" forKey:keyName];
    success = [jsonDict readJSONDateInSeconds:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"[20]" forKey:keyName];
    success = [jsonDict readJSONDateInSeconds:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"one" forKey:keyName];
    success = [jsonDict readJSONDateInSeconds:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
    
    [jsonDict setValue:@"" forKey:keyName];
    success = [jsonDict readJSONDateInSeconds:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONDateMissing
{
    NSDate* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    success = [jsonDict readJSONDateInSeconds:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONDateNull
{
    NSDate* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSNull null] forKey:keyName];
    success = [jsonDict readJSONDateInSeconds:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONDateIncorrectType
{
    NSDate* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSDate date] forKey:keyName];
    success = [jsonDict readJSONDateInSeconds:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}


- (void) testReadJSONString
{
    NSString* expectedValue = nil;
    NSString* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];

    expectedValue = @"a_string";
    [jsonDict setValue:expectedValue forKey:keyName];
    success = [jsonDict readJSONString:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
}

- (void) testReadJSONStringMissing
{
    NSString* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    success = [jsonDict readJSONString:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONStringNull
{
    NSString* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];

    [jsonDict setValue:[NSNull null] forKey:keyName];
    success = [jsonDict readJSONString:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONStringIncorrectType
{
    NSString* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];

    [jsonDict setValue:[NSDate date] forKey:keyName];
    success = [jsonDict readJSONString:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}


- (void) testReadJSONDictionary
{
    NSDictionary* expectedValue = nil;
    NSDictionary* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    expectedValue = [NSDictionary dictionary];
    [jsonDict setValue:expectedValue forKey:keyName];
    success = [jsonDict readJSONDictionary:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
}

- (void) testReadJSONDictionaryMissing
{
    NSDictionary* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    success = [jsonDict readJSONDictionary:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONDictionaryNull
{
    NSDictionary* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSNull null] forKey:keyName];
    success = [jsonDict readJSONDictionary:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONDictionaryIncorrectType
{
    NSDictionary* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"blah" forKey:keyName];
    success = [jsonDict readJSONDictionary:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}


- (void) testReadJSONArray
{
    NSArray* expectedValue = nil;
    NSArray* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    expectedValue = [NSArray array];
    [jsonDict setValue:expectedValue forKey:keyName];
    success = [jsonDict readJSONArray:&actualValue forKey:keyName];
    STAssertTrue(success, @"Conversion unsuccessful");
    STAssertEqualObjects(actualValue, expectedValue, @"");
}

- (void) testReadJSONArrayMissing
{
    NSArray* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    success = [jsonDict readJSONArray:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONArrayNull
{
    NSArray* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:[NSNull null] forKey:keyName];
    success = [jsonDict readJSONArray:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}

- (void) testReadJSONArrayIncorrectType
{
    NSArray* actualValue = nil;
    BOOL success;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"blah" forKey:keyName];
    success = [jsonDict readJSONArray:&actualValue forKey:keyName];
    STAssertFalse(success, @"Conversion successful when it shouldn't be");
}


- (void) testJSONBoolForKey
{
    BOOL actualValue;
    BOOL expectedValue;
    NSString* keyName = @"a_key";

    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"true" forKey:keyName];
    expectedValue = YES;
    actualValue = [jsonDict JSONBoolForKey:keyName defaultValue:NO];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"false" forKey:keyName];
    expectedValue = NO;
    actualValue = [jsonDict JSONBoolForKey:keyName defaultValue:YES];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"n" forKey:keyName];
    expectedValue = YES;
    actualValue = [jsonDict JSONBoolForKey:keyName defaultValue:YES];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"" forKey:keyName];
    expectedValue = NO;
    actualValue = [jsonDict JSONBoolForKey:keyName defaultValue:NO];
    STAssertEquals(actualValue, expectedValue, @"");
}


- (void) testJSONIntegerForKey
{
    int64_t actualValue;
    int64_t expectedValue;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"0" forKey:keyName];
    expectedValue = 0;
    actualValue = [jsonDict JSONIntegerForKey:keyName defaultValue:-1000];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"-50" forKey:keyName];
    expectedValue = -50;
    actualValue = [jsonDict JSONIntegerForKey:keyName defaultValue:0];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"n" forKey:keyName];
    expectedValue = 123456;
    actualValue = [jsonDict JSONIntegerForKey:keyName defaultValue:123456];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"" forKey:keyName];
    expectedValue = -1000;
    actualValue = [jsonDict JSONIntegerForKey:keyName defaultValue:-1000];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"e.0" forKey:keyName];
    expectedValue = 0;
    actualValue = [jsonDict JSONIntegerForKey:keyName defaultValue:0];
    STAssertEquals(actualValue, expectedValue, @"");
}


- (void) testJSONUIntegerForKey
{
    uint64_t actualValue;
    uint64_t expectedValue;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"0" forKey:keyName];
    expectedValue = 0;
    actualValue = [jsonDict JSONUIntegerForKey:keyName defaultValue:1000];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"-50" forKey:keyName];
    expectedValue = 1;
    actualValue = [jsonDict JSONUIntegerForKey:keyName defaultValue:1];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"n" forKey:keyName];
    expectedValue = 123456;
    actualValue = [jsonDict JSONUIntegerForKey:keyName defaultValue:123456];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"e.0" forKey:keyName];
    expectedValue = 0;
    actualValue = [jsonDict JSONUIntegerForKey:keyName defaultValue:0];
    STAssertEquals(actualValue, expectedValue, @"");
}


- (void) testJSONFloatForKey
{
    double actualValue;
    double expectedValue;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"0" forKey:keyName];
    expectedValue = 0;
    actualValue = [jsonDict JSONFloatForKey:keyName defaultValue:-1000];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"-50.001" forKey:keyName];
    expectedValue = -50.001;
    actualValue = [jsonDict JSONFloatForKey:keyName defaultValue:0];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"n" forKey:keyName];
    expectedValue = 0.123456;
    actualValue = [jsonDict JSONFloatForKey:keyName defaultValue:0.123456];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"" forKey:keyName];
    expectedValue = -1000;
    actualValue = [jsonDict JSONFloatForKey:keyName defaultValue:-1000];
    STAssertEquals(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"e.0" forKey:keyName];
    expectedValue = 0;
    actualValue = [jsonDict JSONFloatForKey:keyName defaultValue:0];
    STAssertEquals(actualValue, expectedValue, @"");
}


- (void) testJSONNumberForKey
{
    NSNumber* expectedValue = nil;
    NSNumber* actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"true" forKey:keyName];
    expectedValue = [NSNumber numberWithBool:YES];
    actualValue = [jsonDict JSONNumberForKey:keyName defaultValue:nil];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"0.104" forKey:keyName];
    expectedValue = [NSNumber numberWithDouble:0.104];
    actualValue = [jsonDict JSONNumberForKey:keyName defaultValue:[NSNumber numberWithBool:YES]];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"" forKey:keyName];
    expectedValue = nil;
    actualValue = [jsonDict JSONNumberForKey:keyName defaultValue:nil];
    STAssertEqualObjects(actualValue, expectedValue, @"");    
    
    [jsonDict setValue:@"" forKey:keyName];
    expectedValue = [NSNumber numberWithBool:YES];
    actualValue = [jsonDict JSONNumberForKey:keyName defaultValue:[NSNumber numberWithBool:YES]];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}


- (void) testJSONDateForKey
{
    NSDate* expectedValue = nil;
    NSDate* actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    expectedValue = [NSDate date];
    unsigned long long timeInterval = [expectedValue timeIntervalSince1970];
    expectedValue = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    [jsonDict setValue:[NSString stringWithFormat:@"%llu", timeInterval] forKey:keyName];
    actualValue = [jsonDict JSONDateInSecondsForKey:keyName defaultValue:nil];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}


- (void) testJSONStringForKey
{
    NSString* expectedValue = nil;
    NSString* actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setValue:@"a_string" forKey:keyName];
    expectedValue = @"a_string";
    actualValue = [jsonDict JSONStringForKey:keyName defaultValue:nil];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:@"a_string" forKey:keyName];
    expectedValue = @"a_string";
    actualValue = [jsonDict JSONStringForKey:keyName defaultValue:@"blah"];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:[NSNull null] forKey:keyName];
    expectedValue = @"blah";
    actualValue = [jsonDict JSONStringForKey:keyName defaultValue:@"blah"];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:[NSArray array] forKey:keyName];
    expectedValue = nil;
    actualValue = [jsonDict JSONStringForKey:keyName defaultValue:nil];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}


- (void) testJSONDictionaryForKey
{
    NSDictionary* expectedValue = nil;
    NSDictionary* actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    NSDictionary* dict1 = [NSDictionary dictionaryWithObject:@"one" forKey:@"one"];
    NSDictionary* dict2 = [NSDictionary dictionaryWithObject:@"two" forKey:@"two"];
    
    [jsonDict setValue:dict1 forKey:keyName];
    expectedValue = dict1;
    actualValue = [jsonDict JSONDictionaryForKey:keyName defaultValue:nil];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:dict1 forKey:keyName];
    expectedValue = dict1;
    actualValue = [jsonDict JSONDictionaryForKey:keyName defaultValue:dict2];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:[NSNull null] forKey:keyName];
    expectedValue = dict2;
    actualValue = [jsonDict JSONDictionaryForKey:keyName defaultValue:dict2];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:[NSArray array] forKey:keyName];
    expectedValue = nil;
    actualValue = [jsonDict JSONDictionaryForKey:keyName defaultValue:nil];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}


- (void) testJSONArrayForKey
{
    NSArray* expectedValue = nil;
    NSArray* actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    NSArray* array1 = [NSArray arrayWithObject:@"one"];
    NSArray* array2 = [NSArray arrayWithObject:@"two"];
    
    [jsonDict setValue:array1 forKey:keyName];
    expectedValue = array1;
    actualValue = [jsonDict JSONArrayForKey:keyName defaultValue:nil];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:array1 forKey:keyName];
    expectedValue = array1;
    actualValue = [jsonDict JSONArrayForKey:keyName defaultValue:array2];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:[NSNull null] forKey:keyName];
    expectedValue = array2;
    actualValue = [jsonDict JSONArrayForKey:keyName defaultValue:array2];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setValue:[NSDictionary dictionary] forKey:keyName];
    expectedValue = nil;
    actualValue = [jsonDict JSONArrayForKey:keyName defaultValue:nil];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}


- (void) testSetJSONBool
{
    NSString* expectedValue = nil;
    NSString* actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setJSONBool:YES forKey:keyName];
    expectedValue = @"true";
    actualValue = [jsonDict valueForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONBool:NO forKey:keyName];
    expectedValue = @"false";
    actualValue = [jsonDict valueForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}


- (void) testSetJSONInteger
{
    NSString* expectedValue = nil;
    NSString* actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setJSONInteger:0 forKey:keyName];
    expectedValue = @"0";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONInteger:1 forKey:keyName];
    expectedValue = @"1";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONInteger:-1 forKey:keyName];
    expectedValue = @"-1";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");

    [jsonDict setJSONInteger:5000000 forKey:keyName];
    expectedValue = @"5000000";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");

    NSString* llongMin = [[NSString stringWithFormat:@"%lld", LLONG_MIN] retain];
    NSString* llongMax = [[NSString stringWithFormat:@"%lld", LLONG_MAX] retain];
    
    [jsonDict setJSONInteger:LLONG_MIN forKey:keyName];
    expectedValue = llongMin;
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONInteger:LLONG_MAX forKey:keyName];
    expectedValue = llongMax;
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}


- (void) testSetJSONUInteger
{
    NSString* expectedValue = nil;
    NSString* actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setJSONUInteger:0 forKey:keyName];
    expectedValue = @"0";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONUInteger:1 forKey:keyName];
    expectedValue = @"1";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONUInteger:5000000 forKey:keyName];
    expectedValue = @"5000000";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    NSString* ullongMax = [[NSString stringWithFormat:@"%llu", ULLONG_MAX] retain];
    
    [jsonDict setJSONUInteger:ULLONG_MAX forKey:keyName];
    expectedValue = ullongMax;
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}


- (void) testSetJSONFloat
{
    NSString* expectedValue = nil;
    NSString* actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setJSONFloat:0 forKey:keyName];
    expectedValue = @"0";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONFloat:1 forKey:keyName];
    expectedValue = @"1";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONFloat:-1 forKey:keyName];
    expectedValue = @"-1";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONFloat:5000000 forKey:keyName];
    expectedValue = @"5000000";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONFloat:0.5678901 forKey:keyName];
    expectedValue = @"0.5678901";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONFloat:0.1 forKey:keyName];
    expectedValue = @"0.1";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONFloat:-0.0000000000000001 forKey:keyName];
    expectedValue = @"-1e-16";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}

- (void) testSetJSONNumber
{
    id expectedValue = nil;
    id actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setJSONNumber:[NSNumber numberWithInt:0] forKey:keyName];
    expectedValue = @"0";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONNumber:[NSNumber numberWithInt:1] forKey:keyName];
    expectedValue = @"1";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONNumber:[NSNumber numberWithInt:-1] forKey:keyName];
    expectedValue = @"-1";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONNumber:[NSNumber numberWithInt:5000000] forKey:keyName];
    expectedValue = @"5000000";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    NSString* llongMin = [[NSString stringWithFormat:@"%lld", LLONG_MIN] retain];
    NSString* llongMax = [[NSString stringWithFormat:@"%lld", LLONG_MAX] retain];
    
    [jsonDict setJSONNumber:[NSNumber numberWithLongLong:LLONG_MIN] forKey:keyName];
    expectedValue = llongMin;
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONNumber:[NSNumber numberWithLongLong:LLONG_MAX] forKey:keyName];
    expectedValue = llongMax;
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");

    NSString* ullongMax = [[NSString stringWithFormat:@"%llu", ULLONG_MAX] retain];
    
    [jsonDict setJSONNumber:[NSNumber numberWithUnsignedLongLong:ULLONG_MAX] forKey:keyName];
    expectedValue = ullongMax;
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");

    [jsonDict setJSONNumber:[NSNumber numberWithDouble:0.1] forKey:keyName];
    expectedValue = @"0.1";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONNumber:[NSNumber numberWithDouble:-0.0000000000000001] forKey:keyName];
    expectedValue = @"-1e-16";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONNumber:[NSNumber numberWithDouble:-0.12345678] forKey:keyName];
    expectedValue = @"-0.12345678";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONNumber:[NSNumber numberWithBool:YES] forKey:keyName];
    expectedValue = @"1";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONNumber:[NSNumber numberWithBool:NO] forKey:keyName];
    expectedValue = @"0";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONNumber:nil forKey:keyName];
    expectedValue = [NSNull null];
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}

- (void) testSetJSONDate
{
    id expectedValue = nil;
    id actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    NSDate* date = [NSDate date];
    unsigned long long timeInterval = [date timeIntervalSince1970];
    date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    [jsonDict setJSONDateInSeconds:date forKey:keyName];
    expectedValue = [NSString stringWithFormat:@"%llu", timeInterval];
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}

- (void) testSetJSONString
{
    id expectedValue = nil;
    id actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    [jsonDict setJSONString:@"blah" forKey:keyName];
    expectedValue = @"blah";
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONString:nil forKey:keyName];
    expectedValue = [NSNull null];
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}

- (void) testSetJSONDictionary
{
    id expectedValue = nil;
    id actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    expectedValue = [NSDictionary dictionaryWithObject:@"one" forKey:@"one"];
    [jsonDict setJSONDictionary:expectedValue forKey:keyName];
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONDictionary:nil forKey:keyName];
    expectedValue = [NSNull null];
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}

- (void) testSetJSONArray
{
    id expectedValue = nil;
    id actualValue = nil;
    NSString* keyName = @"a_key";
    
    NSMutableDictionary* jsonDict = [NSMutableDictionary dictionary];
    
    expectedValue = [NSArray arrayWithObject:@"blah"];
    [jsonDict setJSONArray:expectedValue forKey:keyName];
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
    
    [jsonDict setJSONArray:nil forKey:keyName];
    expectedValue = [NSNull null];
    actualValue = [jsonDict objectForKey:keyName];
    STAssertEqualObjects(actualValue, expectedValue, @"");
}

@end
