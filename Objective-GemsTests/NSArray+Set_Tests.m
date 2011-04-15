//
//  NSArray+Set_Tests.m
//  Objective-Gems
//

#import "NSArray+Set.h"

@interface NSArray_Set_Tests : SenTestCase {}
@end

@implementation NSArray_Set_Tests

- (void) testArrayToSetToArray
{
    NSArray* expectedResult = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4",nil];
    
    NSSet* set = [NSSet setWithArray:expectedResult];
    
    NSArray* actualResult = [[NSArray arrayWithSet:set] sortedArrayUsingSelector:@selector(compare:)];
    
    STAssertEqualObjects(actualResult, expectedResult, @"Arrays were not equal");
}

@end
