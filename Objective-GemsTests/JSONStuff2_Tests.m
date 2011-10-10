//
//  JSONStuff2_Tests.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 7/1/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "JSONStuff.h"

@interface JSONStuff2_Tests : SenTestCase {} @end



@interface SomeClass: NSObject
{
    NSDate* _aDate;
}
@property(readwrite,retain) NSString* aString;
@property(readwrite,retain) id anObject;
@property(readwrite,retain) SomeClass* aSomeClass;
@property(readwrite,assign) int anInt;
@property(readwrite,retain) NSDate* aDate;

@end

@implementation SomeClass

@synthesize aString = _aString;
@synthesize anObject = _anObject;
@synthesize aSomeClass = _aSomeClass;
@synthesize anInt = _anInt;

- (void) dealloc
{
    [_aDate release];
    [_aString release];
    [_anObject release];
    [_aSomeClass release];
    [super dealloc];
}

- (NSDate*) aDate
{
    return _aDate;
}

- (void) setADate:(NSDate *)aDate
{
    [_aDate autorelease];
    _aDate = [aDate retain];
}

@end



@implementation JSONStuff2_Tests

- (void) testBlah
{
    NSNumber* number;
    
    number = [NSNumber numberWithBool:YES];
    NSLog(@"bool = %s", [number objCType]);
}

- (void) testSomething
{
    JSONCodecs* codecs = [JSONCodecs sharedInstance];
    
    [codecs registerDefaultCodecForClass:[SomeClass class]];
    
    
    SomeClass* instance = [[[SomeClass alloc] init] autorelease];
    instance.aString = @"this is a string";
    instance.anObject = [NSArray array];
    instance.anInt = 42;
    
    id<JSONCodec> codec = [codecs codecForClass:[SomeClass class]];
    NSDictionary* dict = [codec objectToDictionary:instance];
    NSLog(@"RESULT: %@", dict);
}

@end
