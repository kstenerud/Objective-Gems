//
//  NSString+RemoveCharactersInSet.h
//  Objective-Gems
//
// Created by Ed Watkeys
// From: http://www.cocoabuilder.com/archive/cocoa/94371-adding-methods-to-nsstring.html
//
// Public Domain
//

#import <Foundation/Foundation.h>


/** Enhancmenet for removing all characters in a set from a string.
 */
@interface NSString (RemoveCharactersInSet)

/** Returns a new string containing the contents of the old string with the
 * specified characters removed.
 *
 * @param charSet The character set containing the characters to remove.
 * @param mask A mask specifying search options. The following options may be
 *        specified by combining them with the C bitwise OR operator:
 *        NSCaseInsensitiveSearch, NSLiteralSearch, NSBackwardsSearch.
 * @return A new string with the specified characters removed.
 */
- (NSString*) stringByRemovingCharactersInSet:(NSCharacterSet*) charSet
                                       options:(unsigned) mask;

/** Returns a new string containing the contents of the old string with the
 * specified characters removed.
 *
 * @param charSet The character set containing the characters to remove.
 * @return A new string with the specified characters removed.
 */
- (NSString*) stringByRemovingCharactersInSet:(NSCharacterSet*) charSet;

/** Returns a new string containing the contents of the old string with all
 * instances of the specified character removed.
 *
 * @param character The character to remove.
 * @return A new string with the specified characters removed.
 */
- (NSString*) stringByRemovingCharacter:(unichar)character;

@end
