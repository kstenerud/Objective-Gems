//
//  NSMutableArray+Stack+Queue_Tests.m
//  Objective-Gems
//

#import "NSMutableArray+Stack+Queue.h"

@interface NSMutableArray_Stack_Queue_Tests : SenTestCase {}
@end

@implementation NSMutableArray_Stack_Queue_Tests

- (void) testStackPush
{
    int expectedCount;
    int actualCount;
    NSMutableArray* array = [NSMutableArray array];
    [array push:@"a"];
    
    expectedCount = 1;
    actualCount = [array count];
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
    
    [array push:@"b"];
    
    expectedCount = 2;
    actualCount = [array count];
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
    
}

- (void) testStackPop
{
    id expectedObject;
    id actualObject;
    int expectedCount;
    int actualCount;
    NSMutableArray* array = [NSMutableArray arrayWithObjects:@"a", @"b", nil];
    
    expectedObject = @"b";
    expectedCount = 1;
    
    actualObject = [array pop];
    actualCount = [array count];
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
    STAssertEqualObjects(actualObject, expectedObject, @"Expected [%@] but got [%@]", expectedObject, actualObject);
    
    expectedObject = @"a";
    expectedCount = 0;
    
    actualObject = [array pop];
    actualCount = [array count];
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
    STAssertEqualObjects(actualObject, expectedObject, @"Expected [%@] but got [%@]", expectedObject, actualObject);
    
    expectedObject = nil;
    expectedCount = 0;
    
    actualObject = [array pop];
    actualCount = [array count];
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
    STAssertEqualObjects(actualObject, expectedObject, @"Expected [%@] but got [%@]", expectedObject, actualObject);
}

- (void) testStackPeek
{
    id expectedObject;
    id actualObject;
    int expectedCount;
    int actualCount;
    NSMutableArray* array = [NSMutableArray arrayWithObjects:@"a", @"b", nil];
    
    expectedObject = @"b";
    expectedCount = 2;
    
    actualObject = [array peek];
    actualCount = [array count];
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
    STAssertEqualObjects(actualObject, expectedObject, @"Expected [%@] but got [%@]", expectedObject, actualObject);
}

- (void) testEnqueue
{
    int expectedCount;
    int actualCount;
    NSMutableArray* array = [NSMutableArray array];
    [array enqueue:@"a"];
    
    expectedCount = 1;
    actualCount = [array count];
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
    
    [array enqueue:@"b"];
    
    expectedCount = 2;
    actualCount = [array count];
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
}

- (void) testDequeue
{
    id expectedObject;
    id actualObject;
    int expectedCount;
    int actualCount;
    NSMutableArray* array = [NSMutableArray array];
    [array enqueue:@"a"];
    [array enqueue:@"b"];
    
    expectedCount = 2;
    actualCount = [array count];
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
    
    expectedObject = @"a";
    expectedCount = 1;
    actualObject = [array dequeue];
    actualCount = [array count];
    
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
    STAssertEqualObjects(actualObject, expectedObject, @"Expected [%@] but got [%@]", expectedObject, actualObject);
    
    expectedObject = @"b";
    expectedCount = 0;
    actualObject = [array dequeue];
    actualCount = [array count];
    
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
    STAssertEqualObjects(actualObject, expectedObject, @"Expected [%@] but got [%@]", expectedObject, actualObject);
    
    expectedObject = nil;
    expectedCount = 0;
    actualObject = [array dequeue];
    actualCount = [array count];
    
    STAssertEquals(actualCount, expectedCount, @"Array had count %d, should be %d", actualCount, expectedCount);
    STAssertEqualObjects(actualObject, expectedObject, @"Expected [%@] but got [%@]", expectedObject, actualObject);
}

@end
