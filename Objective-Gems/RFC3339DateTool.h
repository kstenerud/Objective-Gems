//
//  RFC3339DateTool.h
//  Objective-Gems
//
//  Created by Karl Stenerud on 10/9/11.
//

#import <Foundation/Foundation.h>

@interface RFC3339DateTool : NSObject

+ (NSString*) stringFromDate:(NSDate*) date;

+ (NSDate*) dateFromString:(NSString*) string;

+ (NSString*) stringFromUNIXTimestamp:(unsigned int) timestamp;

+ (unsigned int) UNIXTimestampFromString:(NSString*) string;

@end
