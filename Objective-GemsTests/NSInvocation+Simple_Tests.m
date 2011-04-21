//
//  NSInvocation+Simple_Tests.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 4/20/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import "NSInvocation+Simple.h"

@interface NSInvocation_Simple_Tests : SenTestCase {}
@end

@interface InvocationTester : NSObject
{
}

@property(readwrite,assign) BOOL stringMethodCalled;
- (NSString*) stringMethod;

@property(readwrite,assign) BOOL voidMethodCalled;
- (void) voidMethod;

@property(readwrite,assign) BOOL intMethodCalled;
- (int) intMethod;

@property(readwrite,assign) BOOL oneParamMethodCalled;
- (NSString*) oneParamMethod:(NSString*) firstParam;

@property(readwrite,assign) BOOL twoParamMethodCalled;
- (NSString*) twoParamMethod:(NSString*) firstParam second:(NSString*) secondParam;

@end

@implementation InvocationTester

@synthesize stringMethodCalled;
- (NSString*) stringMethod
{
    self.stringMethodCalled = YES;
    return @"A String";
}

@synthesize voidMethodCalled;
- (void) voidMethod
{
    self.voidMethodCalled = YES;
}

@synthesize intMethodCalled;
- (int) intMethod
{
    self.intMethodCalled = YES;
    return 100;
}

@synthesize oneParamMethodCalled;
- (NSString*) oneParamMethod:(NSString*) firstParam;
{
    self.oneParamMethodCalled = YES;
    return firstParam;
}

@synthesize twoParamMethodCalled;
- (NSString*) twoParamMethod:(NSString*) firstParam second:(NSString*) secondParam
{
    self.twoParamMethodCalled = YES;
    return [firstParam stringByAppendingString:secondParam];
}

@end


@implementation NSInvocation_Simple_Tests

- (void) testInvokeAndReturn
{
    InvocationTester* testObject = [[InvocationTester new] autorelease];
    NSInvocation* invocation = [NSInvocation invocationWithTarget:testObject selector:@selector(stringMethod)];
    id expectedResult = @"A String";
    id actualResult = [invocation invokeAndReturn];
    
    STAssertTrue(testObject.stringMethodCalled, @"Method was not called");
    STAssertEqualObjects(actualResult, expectedResult, @"Not equal");
}

- (void) testInvokeAndReturn2
{
    InvocationTester* testObject = [[InvocationTester new] autorelease];
    NSInvocation* invocation = [NSInvocation invocationWithTarget:testObject selector:@selector(voidMethod)];
    id expectedResult = nil;
    id actualResult = [invocation invokeAndReturn];
    
    STAssertTrue(testObject.voidMethodCalled, @"Method was not called");
    STAssertEqualObjects(actualResult, expectedResult, @"Not equal");
}

- (void) testInvokeAndReturn3
{
    InvocationTester* testObject = [[InvocationTester new] autorelease];
    NSInvocation* invocation = [NSInvocation invocationWithTarget:testObject selector:@selector(intMethod)];
    id expectedResult = [NSNumber numberWithInt:100];
    id actualResult = [invocation invokeAndReturn];
    
    STAssertTrue(testObject.intMethodCalled, @"Method was not called");
    STAssertEqualObjects(actualResult, expectedResult, @"Not equal");
}

- (void) testInvokeWithObject
{
    InvocationTester* testObject = [[InvocationTester new] autorelease];
    NSInvocation* invocation = [NSInvocation invocationWithTarget:testObject selector:@selector(oneParamMethod:)];
    id expectedResult = @"Something";
    id actualResult = [invocation invokeWithObject:expectedResult];
    
    STAssertTrue(testObject.oneParamMethodCalled, @"Method was not called");
    STAssertEqualObjects(actualResult, expectedResult, @"Not equal");
}

- (void) testInvokeWithObjectAndObject
{
    InvocationTester* testObject = [[InvocationTester new] autorelease];
    NSInvocation* invocation = [NSInvocation invocationWithTarget:testObject selector:@selector(twoParamMethod:second:)];
    id expectedResult = @"Something else";
    id actualResult = [invocation invokeWithObject:@"Something " withObject:@"else"];
    
    STAssertTrue(testObject.twoParamMethodCalled, @"Method was not called");
    STAssertEqualObjects(actualResult, expectedResult, @"Not equal");
}

@end
