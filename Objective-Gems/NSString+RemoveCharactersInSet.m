//
//  NSString+RemoveCharactersInSet.m
//  Objective-Gems
//
// Created by Ed Watkeys
// From: http://www.cocoabuilder.com/archive/cocoa/94371-adding-methods-to-nsstring.html
//
// Public Domain
//

#import "NSString+RemoveCharactersInSet.h"


@implementation NSString (RemoveCharactersInSet)

- (NSString*) stringByRemovingCharactersInSet:(NSCharacterSet*) charSet options:(unsigned) mask
{
	NSRange                 range;
	NSMutableString*        newString = [NSMutableString string];
	unsigned                len = [self length];
	
	mask &= ~NSBackwardsSearch;
	range = NSMakeRange (0, len);
	
	while(range.length)
	{
		NSRange substringRange;
		unsigned pos = range.location;
		
		range = [self rangeOfCharacterFromSet:charSet options:mask range:range];
		if (range.location == NSNotFound)
			range = NSMakeRange (len, 0);
		
		substringRange = NSMakeRange (pos, range.location - pos);
		[newString appendString:[self 
								 substringWithRange:substringRange]];
		
		range.location += range.length;
		range.length = len - range.location;
	}
	
	return newString;
}

- (NSString*) stringByRemovingCharactersInSet:(NSCharacterSet*) charSet
{
	return [self stringByRemovingCharactersInSet:charSet options:0];
}

- (NSString*) stringByRemovingCharacter:(unichar)character
{
    NSCharacterSet *charSet = [NSCharacterSet
                               characterSetWithRange:NSMakeRange (character, 1)];
    
    return [self stringByRemovingCharactersInSet:charSet];
}

@end
