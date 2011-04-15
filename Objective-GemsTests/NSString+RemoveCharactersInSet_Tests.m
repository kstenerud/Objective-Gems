//
//  NSString+RemoveCharactersInSet.m
//  Objective-Gems
//

#import "NSString+RemoveCharactersInSet.h"

@interface NSString_RemoveCharactersInSet : SenTestCase {}
@end


@implementation NSString_RemoveCharactersInSet

- (void) testRemoveCharacters
{
    NSString* original = @"This 1 is a test of some sort";
    NSString* expectedResult = @" 1      ";
    NSString* actualResult = [original stringByRemovingCharactersInSet:[NSCharacterSet letterCharacterSet]];
    
    STAssertEqualObjects(actualResult, expectedResult, @"[%@] did not match expected [%@]", actualResult, expectedResult);
}

@end
