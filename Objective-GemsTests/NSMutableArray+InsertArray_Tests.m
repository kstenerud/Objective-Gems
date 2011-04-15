//
//  NSMutableArray+InsertArray_Tests.m
//  Objective-Gems
//

#import "NSMutableArray+InsertArray.h"

@interface NSMutableArray_InsertArray_Tests : SenTestCase {}
@end


@implementation NSMutableArray_InsertArray_Tests

- (void) testInsertArray
{
    NSMutableArray* expectedResult = [NSMutableArray arrayWithObjects:
                                      @"1",
                                      @"2",
                                      @"3",
                                      @"a",
                                      @"b",
                                      @"c",
                                      @"4",
                                      nil];
    
    NSMutableArray* initialArray = [NSMutableArray arrayWithObjects:
                                    @"1",
                                    @"2",
                                    @"3",
                                    @"4",
                                    nil];

    NSMutableArray* insertArray = [NSMutableArray arrayWithObjects:
                                    @"a",
                                    @"b",
                                    @"c",
                                    nil];

    NSMutableArray* actualResult = [NSMutableArray arrayWithArray:initialArray];
    [actualResult insertArray:insertArray atIndex:3];
    
    STAssertEqualObjects(actualResult, expectedResult, @"Arrays did not match");
}

@end
