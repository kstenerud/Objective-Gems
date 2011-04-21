//
//  KSProxyAndReference_Tests.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 4/20/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import "KSProxyAndReference.h"

@protocol MyProtocol

- (void) doSomething;

@end


@interface KSProxyAndReference_Tests : SenTestCase {}
@end

@interface ProxyTestClass: NSObject<NSCopying, MyProtocol>
{
}
@property(readwrite,assign) int value;

@end

@implementation ProxyTestClass

- (void) doSomething
{
    
}

@synthesize value;

- (id) copyWithZone:(NSZone *)zone
{
    return [[[self class] alloc] init];
}

@end


@implementation KSProxyAndReference_Tests

- (void) testProxy
{
    ProxyTestClass* testObject = [[ProxyTestClass new] autorelease];
    int expectedResult = 10;
    KSProxy* proxy = [KSProxy proxyTo:testObject];
    ((ProxyTestClass*)proxy).value = expectedResult;
    int actualResult = testObject.value;
    
    STAssertEquals(actualResult, expectedResult, @"Not equal");
}

- (void) testWeakProxy
{
    ProxyTestClass* testObject = [[ProxyTestClass new] autorelease];
    KSProxy* proxy = [KSProxy weakProxyTo:testObject];
    
    STAssertTrue([testObject retainCount] == 1, @"Retain count was not 1");
    
    proxy = [KSProxy proxyTo:testObject];
    
    STAssertTrue([testObject retainCount] == 2, @"Retain count was not 2");
}

- (void) testProxyDeepCopy
{
    ProxyTestClass* testObject = [[ProxyTestClass new] autorelease];
    KSProxy* proxy = [[KSProxy alloc] initWithReference:testObject weakReference:NO deepCopy:YES];
    KSProxy* copy = [[proxy copyWithZone:nil] autorelease];
    [proxy release];
    
    STAssertNotNil(copy, @"Copy was nil");
    STAssertTrue([testObject retainCount] == 1, @"Retain count was not 1");
}

- (void) testProxyRespondsToSelector
{
    ProxyTestClass* testObject = [[ProxyTestClass new] autorelease];
    KSProxy* proxy = [KSProxy proxyTo:testObject];
    
    STAssertTrue([proxy respondsToSelector:@selector(setValue:)], @"Does not respond to selector");
}

- (void) testProxyConformsToProtocol
{
    ProxyTestClass* testObject = [[ProxyTestClass new] autorelease];
    KSProxy* proxy = [KSProxy proxyTo:testObject];
    
    STAssertTrue([proxy conformsToProtocol:@protocol(MyProtocol)], @"Does not conform to protocol");
}

- (void) testIsMemberOfClass
{
    ProxyTestClass* testObject = [[ProxyTestClass new] autorelease];
    KSProxy* proxy = [KSProxy proxyTo:testObject];
    
    STAssertTrue([proxy isMemberOfClass:[ProxyTestClass class]], @"Not member of class");
}

- (void) testPerformSelector
{
    ProxyTestClass* testObject = [[ProxyTestClass new] autorelease];
    KSProxy* proxy = [KSProxy proxyTo:testObject];
    [proxy performSelector:@selector(doSomething)];
}

- (void) testReference
{
    ProxyTestClass* testObject = [[ProxyTestClass new] autorelease];
    KSReference* reference = [KSReference referenceTo:testObject];
    
    STAssertEqualObjects(reference.reference, testObject, @"Not equal");
    STAssertTrue([testObject retainCount] == 2, @"Retain count was not 2");
}

- (void) testWeakReference
{
    ProxyTestClass* testObject = [[ProxyTestClass new] autorelease];
    KSReference* reference = [KSReference weakReferenceTo:testObject];
    
    STAssertEqualObjects(reference.reference, testObject, @"Not equal");
    STAssertTrue([testObject retainCount] == 1, @"Retain count was %d. Expected 1", [testObject retainCount]);
}

@end
