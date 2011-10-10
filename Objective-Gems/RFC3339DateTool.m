//
//  RFC3339DateTool.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 10/9/11.
//  Copyright (c) 2011 KarlStenerud. All rights reserved.
//

#import "RFC3339DateTool.h"

@implementation RFC3339DateTool

static NSDateFormatter* g_formatter;

+ (void)initialize
{
    [super initialize];
    
    g_formatter = [[NSDateFormatter alloc] init];
    // Is this even needed?
    NSLocale* locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [g_formatter setLocale:locale];
    [g_formatter setDateFormat:@"\"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'\""];
    [g_formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
}

+ (NSString*) stringFromDate:(NSDate*) date
{
    return [g_formatter stringFromDate:date];
}

+ (NSDate*) dateFromString:(NSString*) string
{
    return [g_formatter dateFromString:string];
}

+ (NSString*) stringFromUNIXTimestamp:(unsigned int) timestamp
{
    return [self stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
}

+ (unsigned int) UNIXTimestampFromString:(NSString*) string
{
    return (unsigned int)[[self dateFromString:string] timeIntervalSince1970];
}

@end
