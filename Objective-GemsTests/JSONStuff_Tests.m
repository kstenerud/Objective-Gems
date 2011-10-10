//
//  JSONStuff_Tests.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 6/26/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import "JSONStuff.h"

@interface JSONStuff_Tests : SenTestCase {} @end


@interface JSONTestClass : NSObject
{
}
@property(readwrite,assign) char someChar;
@property(readwrite,assign) short someShort;
@property(readwrite,assign) int someInt;
@property(readwrite,assign) long someLong;
@property(readwrite,assign) long long someLongLong;
@property(readwrite,assign) unsigned char someUChar;
@property(readwrite,assign) unsigned short someUShort;
@property(readwrite,assign) unsigned int someUInt;
@property(readwrite,assign) unsigned long someULong;
@property(readwrite,assign) unsigned long long someULongLong;
@property(readwrite,assign) float someFloat;
@property(readwrite,assign) double someDouble;
@property(readwrite,assign) BOOL someBool;

@end

@implementation JSONTestClass

@synthesize someChar;
@synthesize someShort;
@synthesize someInt;
@synthesize someLong;
@synthesize someLongLong;
@synthesize someUChar;
@synthesize someUShort;
@synthesize someUInt;
@synthesize someULong;
@synthesize someULongLong;
@synthesize someFloat;
@synthesize someDouble;
@synthesize someBool;

@end

@implementation JSONStuff_Tests

- (void) testPrimitives
{
    JSONTestClass* testObject = [[[JSONTestClass alloc] init] autorelease];
    testObject.someBool = YES;
    testObject.someChar = 2;
    testObject.someShort = 3;
    testObject.someInt = 4;
    testObject.someLong = 5;
    testObject.someLongLong = 6;
    testObject.someUChar = 7;
    testObject.someUShort = 8;
    testObject.someUInt = 9;
    testObject.someULong = 10;
    testObject.someULongLong = 11;
    testObject.someFloat = 12.0f;
    testObject.someDouble = 13.2;
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    id<PropertyFiller> boolFiller = [BoolPropertyFiller fillerWithPropertyName:@"someBool"];
    [boolFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someBool"], [NSNumber numberWithBool:YES], @"");
    
    id<PropertyFiller> charFiller = [CharPropertyFiller fillerWithPropertyName:@"someChar"];
    [charFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someChar"], [NSNumber numberWithInteger:2], @"");
    
    id<PropertyFiller> shortFiller = [ShortPropertyFiller fillerWithPropertyName:@"someShort"];
    [shortFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someShort"], [NSNumber numberWithInteger:3], @"");
    
    id<PropertyFiller> intFiller = [IntPropertyFiller fillerWithPropertyName:@"someInt"];
    [intFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someInt"], [NSNumber numberWithInteger:4], @"");
    
    id<PropertyFiller> longFiller = [LongPropertyFiller fillerWithPropertyName:@"someLong"];
    [longFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someLong"], [NSNumber numberWithInteger:5], @"");
    
    id<PropertyFiller> longLongFiller = [LongLongPropertyFiller fillerWithPropertyName:@"someLongLong"];
    [longLongFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someLongLong"], [NSNumber numberWithInteger:6], @"");
    
    id<PropertyFiller> ucharFiller = [UCharPropertyFiller fillerWithPropertyName:@"someUChar"];
    [ucharFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someUChar"], [NSNumber numberWithInteger:7], @"");
    
    id<PropertyFiller> ushortFiller = [UShortPropertyFiller fillerWithPropertyName:@"someUShort"];
    [ushortFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someUShort"], [NSNumber numberWithInteger:8], @"");
    
    id<PropertyFiller> uintFiller = [UIntPropertyFiller fillerWithPropertyName:@"someUInt"];
    [uintFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someUInt"], [NSNumber numberWithInteger:9], @"");
    
    id<PropertyFiller> ulongFiller = [ULongPropertyFiller fillerWithPropertyName:@"someULong"];
    [ulongFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someULong"], [NSNumber numberWithInteger:10], @"");
    
    id<PropertyFiller> ulongLongFiller = [ULongLongPropertyFiller fillerWithPropertyName:@"someULongLong"];
    [ulongLongFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someULongLong"], [NSNumber numberWithInteger:11], @"");
    
    id<PropertyFiller> floatFiller = [FloatPropertyFiller fillerWithPropertyName:@"someFloat"];
    [floatFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someFloat"], [NSNumber numberWithInteger:12], @"");
    
    id<PropertyFiller> doubleFiller = [DoublePropertyFiller fillerWithPropertyName:@"someDouble"];
    [doubleFiller fillPropertyInDictionary:dict fromObject:testObject];
    STAssertEqualObjects([dict objectForKey:@"someDouble"], [NSNumber numberWithDouble:13.1], @"");
}

- (void) testFillerBasedJSONCodecEncode
{
    
}


@end
