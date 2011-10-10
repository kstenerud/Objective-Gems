//
//  NSDictionary+JSONSupport.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 6/25/11.
//
// Copyright 2011 Karl Stenerud
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall remain in place
// in this source code.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "NSDictionary+JSONSupport.h"

@implementation NSDictionary (JSONSupport)

#pragma mark readJSONxxx

- (BOOL) readJSONNumber:(NSNumber**) dest forKey:(NSString*) key
{
    id value = [self valueForKey:key];
    if([value isKindOfClass:[NSNumber class]])
    {
        *dest = value;
        return YES;
    }
    return NO;
}

- (BOOL) readJSONBool:(BOOL*) dest forKey:(NSString*) key
{
    NSNumber* value;
    if([self readJSONNumber:&value forKey:key])
    {
        *dest = [value boolValue];
        return YES;
    }
    return NO;
}

- (BOOL) readJSONInteger:(int64_t*) dest forKey:(NSString*) key
{
    NSNumber* value;
    if([self readJSONNumber:&value forKey:key])
    {
        *dest = [value longLongValue];
        return YES;
    }
    return NO;
}

- (BOOL) readJSONUInteger:(uint64_t*) dest forKey:(NSString*) key
{
    NSNumber* value;
    if([self readJSONNumber:&value forKey:key])
    {
        *dest = [value unsignedLongLongValue];
        return YES;
    }
    return NO;
}

- (BOOL) readJSONFloat:(double*) dest forKey:(NSString*) key
{
    NSNumber* value;
    if([self readJSONNumber:&value forKey:key])
    {
        *dest = [value doubleValue];
        return YES;
    }
    return NO;
}

- (BOOL) readJSONDateInSeconds:(NSDate**) dest forKey:(NSString*) key
{
    uint64_t timeInterval;
    if([self readJSONUInteger:&timeInterval forKey:key])
    {
        *dest = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        return YES;
    }
    return NO;
}

- (BOOL) readJSONString:(NSString**) dest forKey:(NSString*) key
{
    id value = [self valueForKey:key];
    if([value isKindOfClass:[NSString class]])
    {
        *dest = value;
        return YES;
    }
    return NO;
}

- (BOOL) readJSONDictionary:(NSDictionary**) dest forKey:(NSString*) key
{
    id value = [self valueForKey:key];
    if([value isKindOfClass:[NSDictionary class]])
    {
        *dest = value;
        return YES;
    }
    return NO;
}

- (BOOL) readJSONArray:(NSArray**) dest forKey:(NSString*) key
{
    id value = [self valueForKey:key];
    if([value isKindOfClass:[NSArray class]])
    {
        *dest = value;
        return YES;
    }
    return NO;
}



#pragma mark JSONxxxForKey

- (BOOL) JSONBoolForKey:(NSString*) key defaultValue:(BOOL) defaultValue
{
    BOOL result;
    if([self readJSONBool:&result forKey:key])
    {
        return result;
    }
    return defaultValue;
}

- (int64_t) JSONIntegerForKey:(NSString*) key defaultValue:(int64_t) defaultValue
{
    int64_t result;
    if([self readJSONInteger:&result forKey:key])
    {
        return result;
    }
    return defaultValue;
}

- (uint64_t) JSONUIntegerForKey:(NSString*) key defaultValue:(uint64_t) defaultValue
{
    uint64_t result;
    if([self readJSONUInteger:&result forKey:key])
    {
        return result;
    }
    return defaultValue;
}

- (double) JSONFloatForKey:(NSString*) key defaultValue:(double) defaultValue
{
    double result;
    if([self readJSONFloat:&result forKey:key])
    {
        return result;
    }
    return defaultValue;
}

- (NSNumber*) JSONNumberForKey:(NSString*) key defaultValue:(NSNumber*) defaultValue
{
    NSNumber* result;
    if([self readJSONNumber:&result forKey:key])
    {
        return result;
    }
    return defaultValue;
}

- (NSDate*) JSONDateInSecondsForKey:(NSString*) key defaultValue:(NSDate*) defaultValue
{
    NSDate* result;
    if([self readJSONDateInSeconds:&result forKey:key])
    {
        return result;
    }
    return defaultValue;
}

- (NSString*) JSONStringForKey:(NSString*) key defaultValue:(NSString*) defaultValue
{
    NSString* result;
    if([self readJSONString:&result forKey:key])
    {
        return result;
    }
    return defaultValue;
}

- (NSDictionary*) JSONDictionaryForKey:(NSString*) key defaultValue:(NSDictionary*) defaultValue
{
    NSDictionary* result;
    if([self readJSONDictionary:&result forKey:key])
    {
        return result;
    }
    return defaultValue;
}

- (NSArray*) JSONArrayForKey:(NSString*) key defaultValue:(NSArray*) defaultValue
{
    NSArray* result;
    if([self readJSONArray:&result forKey:key])
    {
        return result;
    }
    return defaultValue;
}

@end


@implementation NSMutableDictionary (JSONSupport)

#pragma mark setJSONxxx

- (void) setJSONBool:(BOOL) value forKey:(NSString*) key
{
    NSString* stringValue = value ? @"true" : @"false";
    [self setValue:stringValue forKey:key];
}

- (void) setJSONInteger:(int64_t) value forKey:(NSString*) key
{
    NSString* stringValue = [NSString stringWithFormat:@"%lld", value];
    [self setValue:stringValue forKey:key];
}

- (void) setJSONUInteger:(uint64_t) value forKey:(NSString*) key
{
    NSString* stringValue = [NSString stringWithFormat:@"%llu", value];
    [self setValue:stringValue forKey:key];
}

- (void) setJSONFloat:(double) value forKey:(NSString*) key
{
    NSString* stringValue = [[NSNumber numberWithDouble:value] stringValue];
    [self setValue:stringValue forKey:key];
}

- (void) setJSONNumber:(NSNumber*) value forKey:(NSString*) key
{
    if(value != nil)
    {
        NSAssert([value isKindOfClass:[NSNumber class]], @"Value must be of type NSNumber");
        [self setValue:[value stringValue] forKey:key];
    }
    else
    {
        [self setValue:[NSNull null] forKey:key];
    }
}

- (void) setJSONDateInSeconds:(NSDate*) value forKey:(NSString*) key
{
    if(value != nil)
    {
        NSAssert([value isKindOfClass:[NSDate class]], @"Value must be of type NSDate");
        uint64_t timeInterval = [value timeIntervalSince1970];
        [self setJSONUInteger:timeInterval forKey:key];
    }
    else
    {
        [self setValue:[NSNull null] forKey:key];
    }
}

- (void) setJSONString:(NSString*) value forKey:(NSString*) key
{
    if(value != nil)
    {
        NSAssert([value isKindOfClass:[NSString class]], @"Value must be of type NSString");
        [self setValue:value forKey:key];
    }
    else
    {
        [self setValue:[NSNull null] forKey:key];
    }
}

- (void) setJSONDictionary:(NSDictionary*) value forKey:(NSString*) key
{
    if(value != nil)
    {
        NSAssert([value isKindOfClass:[NSDictionary class]], @"Value must be of type NSDictionary");
        [self setValue:value forKey:key];
    }
    else
    {
        [self setValue:[NSNull null] forKey:key];
    }
}

- (void) setJSONArray:(NSArray*) value forKey:(NSString*) key
{
    if(value != nil)
    {
        NSAssert([value isKindOfClass:[NSArray class]], @"Value must be of type NSArray");
        [self setValue:value forKey:key];
    }
    else
    {
        [self setValue:[NSNull null] forKey:key];
    }
}

@end
