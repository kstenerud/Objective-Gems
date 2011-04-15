//
//  NSObject+contentsDesc.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 10-09-25.
//
// Copyright 2010 Karl Stenerud
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

#import "NSObject+contentsDesc.h"
#import <objc/runtime.h>

#pragma mark -
#pragma mark Constants

/** Standard indentation amount when building multiline, hierarchichal descriptions. */
#define kContentsDescIndentation 4

#define kInstanceName @"__INSTANCE__"


#pragma mark -
#pragma mark Code Generation

/** Generate a simple contentsDesc method by using this class' description method.
 *
 * @param CLASS The class to generate code for.
 */
#define CONTENTSDESC_USE_DESCRIPTION_FOR_CLASS(CLASS) \
@implementation CLASS (contentsDesc) \
\
- (NSString*) contentsDescWithIndentation:(unsigned int) spaces context:(NSMutableArray*) processedObjects \
{ \
	if(NSNotFound != [processedObjects indexOfObjectIdenticalTo:self]) \
	{ \
		return contentsDesc_makeBasicDesc(self, spaces); \
	} \
	[processedObjects addObject:self]; \
	\
	return [NSString stringWithFormat:@"%@%@", contentsDesc_makePadding(spaces), self]; \
} \
\
@end

/** Generate a simple contentsDesc method by using this class' description method,
 * enclosed within quotes.
 *
 * @param CLASS The class to generate code for.
 */
#define CONTENTSDESC_USE_DESCRIPTION_QUOTED_FOR_CLASS(CLASS) \
@implementation CLASS (contentsDesc) \
\
- (NSString*) contentsDescWithIndentation:(unsigned int) spaces context:(NSMutableArray*) processedObjects\
{ \
	if(NSNotFound != [processedObjects indexOfObjectIdenticalTo:self]) \
	{ \
		return contentsDesc_makeBasicDesc(self, spaces); \
	} \
	[processedObjects addObject:self]; \
	\
	return [NSString stringWithFormat:@"%@\"%@\"", contentsDesc_makePadding(spaces), self]; \
} \
\
@end

/** Generate a contentsDesc method for a vector or set collection type class.
 *
 * @param CLASS The class to generate code for.
 */
#define CONTENTSDESC_GENERATE_FOR_COLLECTION_CLASS(CLASS) \
@implementation CLASS (contentsDesc) \
\
- (NSString*) contentsDescWithIndentation:(unsigned int) spaces context:(NSMutableArray*) processedObjects \
{ \
	return contentsDesc_contentsOfCollection(self, spaces, processedObjects); \
} \
\
@end

/** Generate a contentsDesc method for a key-value collection type class.
 *
 * @param CLASS The class to generate code for.
 */
#define CONTENTSDESC_GENERATE_FOR_KEY_VALUE_COLLECTION_CLASS(CLASS) \
@implementation CLASS (contentsDesc) \
\
- (NSString*) contentsDescWithIndentation:(unsigned int) spaces context:(NSMutableArray*) processedObjects \
{ \
	return contentsDesc_contentsOfKeyValueCollection(self, spaces, processedObjects); \
} \
\
@end



#pragma mark -
#pragma mark Utility Prototypes

/** Generate padding equivalent to the specified number of spaces.
 *
 * @param SPACES The number of spaces to generate.
 * @return A string containing the specified number of spaces.
 */
static inline NSString* contentsDesc_makePadding(unsigned int spaces);

/** Generate a description of an instance, including class name and pointer address.
 *
 * @param OBJECT The object to genrate a description for.
 * @param PADDING the padding (as an NSString*) to prepend.
 * @raturn A string containing the description.
 */
static inline NSString* contentsDesc_makeInstanceDesc(id object, NSString* padding);

/** Generate a basic description of an instance, consisting solely of class name
 * and pointer address.
 *
 * @param OBJECT The object to genrate a description for.
 * @param PADDING the padding (as an NSString*) to prepend.
 * @raturn A string containing the description.
 */
static inline NSString* contentsDesc_makeBasicDesc(id object, int spaces);

/** Check if a description can be used for shorthand notation.
 * In shorthand notation, key-value pairs are shown on ths same line rather than
 * on separate lines.
 *
 * @param desc The description.
 * @return YES if this description can be used for shorthand notation.
 */
static inline bool contentsDesc_canUseShorthandForDesc(NSString* desc);

/** Attempt to call contentsDiscWithIndentation:context: on the specified object.
 * If the object doesn't implement the method, call the C version manually.
 *
 * @param obj The object to get the description for.
 * @param spaces The number of spaces to indent the description.
 * @param processedObjects A list of objects that have already been processed.
 * @return The descriptions.
 */
static inline NSString* contentsDesc_performContentsDiscOnObject(id object,
																 unsigned int spaces,
																 NSMutableArray* processedObjects);

/** Get a description of a list-like collection's contents, indenting the specified amount.
 * This method also keeps a history of previously processed object so as to avoid
 * an endless loop when it encounters a cyclical graph.
 *
 * @param collection The collection to generate a description for.
 * @param spaces The number of spaces to indent.
 * @param processedObjects A mutable array containing objects that have already been processed.
 * @return The description.
 */
static inline NSString* contentsDesc_contentsOfCollection(id collection,
														  unsigned int spaces,
														  NSMutableArray* processedObjects);

/** Get a description of a key-value collection's contents, indenting the specified amount.
 * This method also keeps a history of previously processed object so as to avoid
 * an endless loop when it encounters a cyclical graph.
 *
 * @param collection The collection to generate a description for.
 * @param spaces The number of spaces to indent.
 * @param processedObjects A mutable array containing objects that have already been processed.
 * @return The description.
 */
static inline NSString* contentsDesc_contentsOfKeyValueCollection(id collection,
																  unsigned int spaces,
																  NSMutableArray* processedObjects);

/** Get descriptions of all ivars in an object according to the specified class.
 *
 * @param obj The object to get ivar descriptions for.
 * @param cls The class definition to use when extracting ivars.
 * @param spaces The number of spaces to indent the descriptions.
 * @param processedObjects A list of objects that have already been processed.
 * @return An array of descriptions.
 */
static inline NSMutableArray* contentsDesc_getIvarDescriptions(id obj,
															   Class cls,
															   unsigned int spaces,
															   NSMutableArray* processedObjects);

/** Get descriptions of all ivars in an object for all superclasses.
 *
 * @param obj The object to get ivar descriptions for.
 * @param spaces The number of spaces to indent the descriptions.
 * @param processedObjects A list of objects that have already been processed.
 * @return An array of descriptions.
 */
static inline NSMutableArray* contentsDesc_getAllIvarDescriptions(id obj,
																  unsigned int spaces,
																  NSMutableArray* processedObjects);

/** Get a description of an object's contents, indenting the specified amount.
 * This method also keeps a history of previously processed object so as to avoid
 * an endless loop when it encounters a cyclical graph.
 *
 * @param obj The object to generate a description for.
 * @param spaces The number of spaces to indent.
 * @param processedObjects A mutable array containing objects that have already been processed.
 * @return The description.
 */
static inline NSString* contentsDesc_contentsOfObject(id obj,
													  unsigned int spaces,
													  NSMutableArray* processedObjects);



#pragma mark -
#pragma mark Utility Functions

static inline NSString* contentsDesc_makePadding(unsigned int spaces)
{
	return 0 == spaces ? @"" :
	[NSString stringWithFormat:[NSString stringWithFormat:@"%%%ds", spaces], ""];
}

static inline NSString* contentsDesc_makeInstanceDesc(id object, NSString* padding)
{
	return [NSString stringWithFormat:@"%@%@ : %p (%@*)",
			padding, kInstanceName, object, object_getClass(object)];
}

static inline NSString* contentsDesc_makeBasicDesc(id object, int spaces)
{
	return [NSString stringWithFormat:@"%@{ %@ : %p (%@*) }",
			contentsDesc_makePadding(spaces), kInstanceName, object, object_getClass(object)];
}

static inline bool contentsDesc_canUseShorthandForDesc(NSString* desc)
{
	return NSNotFound == [desc rangeOfString:@"\n"].location;
}

static inline NSString* contentsDesc_performContentsDiscOnObject(id object,
													unsigned int spaces,
													NSMutableArray* processedObjects)
{
	Class cls = object_getClass(object);

	if(NULL != class_getInstanceMethod(cls, @selector(contentsDescWithIndentation:context:)))
	{
		return [object contentsDescWithIndentation:spaces context:processedObjects];
	}
	
	return contentsDesc_contentsOfObject(object,
										 spaces,
										 processedObjects);
}


static inline NSMutableArray* contentsDesc_getIvarDescriptions(id obj,
															   Class cls,
															   unsigned int spaces,
															   NSMutableArray* processedObjects)
{
	NSString* padding = contentsDesc_makePadding(spaces);

	unsigned int numIvars = 0;
	Ivar* ivars = class_copyIvarList(cls, &numIvars);
	NSMutableArray* components = [NSMutableArray arrayWithCapacity:numIvars];
	
	for(unsigned int i = 0; i < numIvars; i++)
	{
		const char* name = ivar_getName(ivars[i]);
		if(0 == strcmp(name, "isa"))
		{
			// Skip the "isa" ivar.
			continue;
		}
		const char* encoding = ivar_getTypeEncoding(ivars[i]);
		void* valuePtr = (void*)obj + ivar_getOffset(ivars[i]);
		
		switch(*encoding)
		{
			case 'c':
			{
				char value = *((char*)valuePtr);
				if(value >= ' ' && value <= '~')
				{
					[components addObject:[NSString stringWithFormat:@"\n%@%s : %d (%c)",
										   padding, name, value, value]];
				}
				else
				{
					[components addObject:[NSString stringWithFormat:@"\n%@%s : %d",
										   padding, name, value]];
				}

				break;
			}
			case 's':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %d",
									   padding, name, *((short*)valuePtr)]];
				break;
			case 'i':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %d",
									   padding, name, *((int*)valuePtr)]];
				break;
			case 'l':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %ld",
									   padding, name, *((long*)valuePtr)]];
				break;
			case 'q':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %lld",
									   padding, name, *((long long*)valuePtr)]];
				break;
			case 'C':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %u",
									   padding, name, *((unsigned char*)valuePtr)]];
				break;
			case 'S':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %u",
									   padding, name, *((unsigned short*)valuePtr)]];
				break;
			case 'I':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %u",
									   padding, name, *((unsigned int*)valuePtr)]];
				break;
			case 'B':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %@",
									   padding, name, *((unsigned char*)valuePtr) ? @"true" : @"false"]];
				break;
			case 'L':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %lu",
									   padding, name, *((unsigned long*)valuePtr)]];
				break;
			case 'Q':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %llu",
									   padding, name, *((unsigned long long*)valuePtr)]];
				break;
			case 'f':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %f",
									   padding, name, *((float*)valuePtr)]];
				break;
			case 'd':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %f",
									   padding, name, *((double*)valuePtr)]];
				break;
			case '*':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : \'%s\'",
									   padding, name, *((char**)valuePtr)]];
				break;
			case '^':
			{
				void* pointer = *((void**)valuePtr);
				// TODO: This doesn't handle pointer to struct properly.
				const char* endPtr = strchr(encoding, '=');
				if(NULL == endPtr)
				{
					endPtr = strchr(encoding, '}');
					if(NULL == endPtr)
					{
						endPtr = encoding + strlen(encoding);
					}
				}
				const char* startPtr = encoding+2;
				int length = endPtr - startPtr;
				char* pointerType = malloc(length+1);
				if(NULL == pointerType)
				{
					[components addObject:[NSString stringWithFormat:@"\n%@%s : %p (%s*)",
										   padding, name, pointer, encoding]];
				}
				else
				{
					memcpy(pointerType, startPtr, length);
					pointerType[length] = 0;
					[components addObject:[NSString stringWithFormat:@"\n%@%s : %p (%s*)",
										   padding, name, pointer, pointerType]];
					free(pointerType);
				}
				break;
			}
				// TODO: array, struct, union, bitfield, pointers
				
			case '#':
				[components addObject:[NSString stringWithFormat:@"\n%@%s : %@",
									   padding, name, *((Class*)valuePtr)]];
				break;
			case '@':
			{
				id object = *((id*)valuePtr);
				if(NULL == object)
				{
					[components addObject:[NSString stringWithFormat:@"\n%@%s : null",
										   padding, name]];
				}
				else
				{
					
					NSString* valueDesc = contentsDesc_performContentsDiscOnObject(object,
																				   spaces,
																				   processedObjects);
					if(contentsDesc_canUseShorthandForDesc(valueDesc))
					{
						[components addObject:[NSString stringWithFormat:@"\n%@%s : %@",
											   padding,
											   name,
											   [valueDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]];
					}
					else
					{
						[components addObject:[NSString stringWithFormat:@"\n%@%s :\n%@",
											   padding, name, valueDesc]];
					}
				}
				break;
			}
			default:
				[components addObject:[NSString stringWithFormat:@"\n%@%s : (\?\?) %s",
									   padding, name, encoding]];
		}
	}
	free(ivars);
	
	return components;
}

static inline NSMutableArray* contentsDesc_getAllIvarDescriptions(id obj,
																  unsigned int spaces,
																  NSMutableArray* processedObjects)
{
	NSMutableArray* components = [NSMutableArray array];
	for(Class cls = object_getClass(obj);; cls = class_getSuperclass(cls))
	{
		[components addObjectsFromArray:contentsDesc_getIvarDescriptions(obj,
																		 cls,
																		 spaces,
																		 processedObjects)];
		if(class_getSuperclass(cls) == cls)
		{
			break;
		}
	}
	return components;
}

static inline NSString* contentsDesc_contentsOfObject(id obj,
													  unsigned int spaces,
													  NSMutableArray* processedObjects)
{
	if(NSNotFound != [processedObjects indexOfObjectIdenticalTo:obj])
	{
		return contentsDesc_makeBasicDesc(obj, spaces);
	}
	[processedObjects addObject:obj];
	
	NSMutableArray* ivarDescriptions = contentsDesc_getAllIvarDescriptions(obj,
																		   spaces+kContentsDescIndentation,
																		   processedObjects);
	
	if(0 == [ivarDescriptions count])
	{
		return contentsDesc_makeBasicDesc(obj, spaces);
	}
	
	NSString* padding = contentsDesc_makePadding(spaces);
	NSString* innerPadding = contentsDesc_makePadding(spaces+kContentsDescIndentation);
	
	[ivarDescriptions sortUsingSelector:@selector(caseInsensitiveCompare:)];
	
	NSMutableArray* components = [NSMutableArray arrayWithCapacity:[ivarDescriptions count] + 12];
	
	[components addObject:[padding stringByAppendingString:@"{"]];
	[components addObject:@"\n"];
	[components addObject:contentsDesc_makeInstanceDesc(obj, innerPadding)];
	
	for(NSString* desc in ivarDescriptions)
	{
		[components addObject:desc];
		[components addObject:@","];
	}
	
	[components removeLastObject];
	[components addObject:@"\n"];
	[components addObject:[padding stringByAppendingString:@"}"]];
	
	unsigned int totalLength = 0;
	for(NSString* component in components)
	{
		totalLength += [component length];
	}
	
	NSMutableString* desc = [NSMutableString stringWithCapacity:totalLength];
	for(NSString* component in components)
	{
		[desc appendString:component];
	}
	return desc;
}

static inline NSString* contentsDesc_contentsOfCollection(id collection,
														  unsigned int spaces,
														  NSMutableArray* processedObjects)
{
	if(NSNotFound != [processedObjects indexOfObjectIdenticalTo:collection])
	{
		return contentsDesc_makeBasicDesc(collection, spaces);
	}
	[processedObjects addObject:collection];
	
	unsigned int numObjects = [collection count];
	if(0 == numObjects)
	{
		return contentsDesc_makeBasicDesc(collection, spaces);
	}
	
	NSString* padding = contentsDesc_makePadding(spaces);
	NSString* innerPadding = contentsDesc_makePadding(spaces+kContentsDescIndentation);
	
	NSMutableArray* components = [NSMutableArray arrayWithCapacity:numObjects*3 + 12];
	[components addObject:[padding stringByAppendingString:@"{"]];
	[components addObject:@"\n"];
	[components addObject:contentsDesc_makeInstanceDesc(collection, innerPadding)];
	if(numObjects > 0)
	{
		[components addObject:@"\n"];
		[components addObject:[innerPadding stringByAppendingString:@"["]];
		for(id object in collection)
		{
			[components addObject:@"\n"];
			[components addObject:contentsDesc_performContentsDiscOnObject(object,
																		   spaces+kContentsDescIndentation*2,
																		   processedObjects)];
			[components addObject:@","];
		}
		[components removeLastObject];
		[components addObject:@"\n"];
		[components addObject:[innerPadding stringByAppendingString:@"]"]];
	}
	[components addObject:@"\n"];
	[components addObject:[padding stringByAppendingString:@"}"]];
	
	
	unsigned int totalLength = 0;
	for(NSString* component in components)
	{
		totalLength += [component length];
	}
	
	NSMutableString* desc = [NSMutableString stringWithCapacity:totalLength];
	for(NSString* component in components)
	{
		[desc appendString:component];
	}
	return desc;
}

static inline NSString* contentsDesc_contentsOfKeyValueCollection(id collection,
																  unsigned int spaces,
																  NSMutableArray* processedObjects)
{
	if(NSNotFound != [processedObjects indexOfObjectIdenticalTo:collection])
	{
		return contentsDesc_makeBasicDesc(collection, spaces);
	}
	[processedObjects addObject:collection];
	
	unsigned int numObjects = [collection count];
	if(0 == numObjects)
	{
		return contentsDesc_makeBasicDesc(collection, spaces);
	}

	NSString* padding = contentsDesc_makePadding(spaces);
	NSString* innerPadding = contentsDesc_makePadding(spaces+kContentsDescIndentation);
	
	NSMutableArray* components = [NSMutableArray arrayWithCapacity:numObjects*5 + 12];
	[components addObject:[padding stringByAppendingString:@"{"]];
	[components addObject:@"\n"];
	[components addObject:contentsDesc_makeInstanceDesc(collection, innerPadding)];
	if([collection count] > 0)
	{
		for(id key in [collection allKeys])
		{
			id object = [collection objectForKey:key];
			[components addObject:@"\n"];
			NSString* keyDesc = contentsDesc_performContentsDiscOnObject(key,
																		 spaces+kContentsDescIndentation,
																		 processedObjects);
			NSString* valueDesc = contentsDesc_performContentsDiscOnObject(object,
																		   spaces+kContentsDescIndentation*2,
																		   processedObjects);
			if(contentsDesc_canUseShorthandForDesc(keyDesc) &&
			   contentsDesc_canUseShorthandForDesc(valueDesc))
			{
				[components addObject:keyDesc];
				[components addObject:@" : "];
				[components addObject:[valueDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
			}
			else
			{
				[components addObject:keyDesc];
				[components addObject:@" :\n"];
				[components addObject:valueDesc];
			}
			[components addObject:@","];
		}
		[components removeLastObject];
	}
	[components addObject:@"\n"];
	[components addObject:[padding stringByAppendingString:@"}"]];
	
	
	unsigned int totalLength = 0;
	for(NSString* component in components)
	{
		totalLength += [component length];
	}
	
	NSMutableString* desc = [NSMutableString stringWithCapacity:totalLength];
	for(NSString* component in components)
	{
		[desc appendString:component];
	}
	return desc;
}



#pragma mark -
#pragma mark NSObject

@implementation NSObject (ContentsDesc)

- (NSString*) contentsDesc
{
	return [self contentsDescWithIndentation:0];
}

- (NSString*) contentsDescWithIndentation:(unsigned int) spaces
{
	return [self contentsDescWithIndentation:spaces context:[NSMutableArray array]];
}

- (NSString*) contentsDescWithIndentation:(unsigned int) spaces context:(NSMutableArray*) processedObjects
{
	return contentsDesc_contentsOfObject(self, spaces, processedObjects);
}

@end



#pragma mark -
#pragma mark Special Case Classes


#pragma mark NSNumber

CONTENTSDESC_USE_DESCRIPTION_FOR_CLASS(NSNumber);


#pragma mark NSString

CONTENTSDESC_USE_DESCRIPTION_QUOTED_FOR_CLASS(NSString);


#pragma mark NSDate

CONTENTSDESC_USE_DESCRIPTION_QUOTED_FOR_CLASS(NSDate);


#pragma mark NSArray

CONTENTSDESC_GENERATE_FOR_COLLECTION_CLASS(NSArray);


#pragma mark NSSet

CONTENTSDESC_GENERATE_FOR_COLLECTION_CLASS(NSSet);


#pragma mark NSDictionary

CONTENTSDESC_GENERATE_FOR_KEY_VALUE_COLLECTION_CLASS(NSDictionary);
