//
//  JSONStuff.m
//  Objective-Gems
//
//  Created by Karl Stenerud on 6/24/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import "JSONStuff.h"
#import "NSDictionary+JSONSupport.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation BasicPropertyFiller

+ (id) fillerWithPropertyName:(NSString*) propertyName
{
    return [[[self alloc] initWithPropertyName:propertyName] autorelease];
}

- (id) initWithPropertyName:(NSString*) propertyName
{
    if((self = [super init]))
    {
        _propertyName = [propertyName retain];
        _getter = NSSelectorFromString(_propertyName);
        NSString* setterName = [NSString stringWithFormat:@"set%@%@",
                                [[_propertyName substringToIndex:1] uppercaseString],
                                [_propertyName substringFromIndex:1]];
        _setter = NSSelectorFromString(setterName);
    }
    return self;
}

- (void) dealloc
{
    [_propertyName release];
    [super dealloc];
}

- (BOOL) fillPropertyInObject:(id) object fromDictionary:(NSDictionary*) dict
{
    NSAssert(FALSE, @"Subclasses must override fillPropertyInObject:fromDictionary:");
    return FALSE;
}

- (BOOL) fillPropertyInDictionary:(NSMutableDictionary*) dict fromObject:(id) object
{
    NSAssert(FALSE, @"Subclasses must override fillPropertyInDictionary:fromObject:");
    return FALSE;
}

@end


#define SYNTHESIZE_PROPERTY_FILLER(NAME, TYPE, BASETYPE, METHOD, MSGSEND) \
@implementation NAME##PropertyFiller \
 \
- (BOOL) fillPropertyInObject:(id) object fromDictionary:(NSDictionary*) dict \
{ \
    BASETYPE propertyValue; \
    if([dict readJSON##METHOD:&propertyValue forKey:_propertyName]) \
    { \
        TYPE sendValue = (TYPE)propertyValue; \
		objc_msgSend(object, _setter, sendValue); \
        return YES; \
    } \
    return NO; \
} \
 \
- (BOOL) fillPropertyInDictionary:(NSMutableDictionary*) dict fromObject:(id) object \
{ \
    BASETYPE value = ((TYPE (*)(id, SEL))MSGSEND)(object, _getter); \
    [dict setJSON##METHOD:value forKey:_propertyName]; \
    return YES; \
} \
 \
@end

#define SYNTHESIZE_SIGNED_PROPERTY_FILLER(NAME, TYPE) \
SYNTHESIZE_PROPERTY_FILLER(NAME, TYPE, int64_t, Integer, objc_msgSend)

#define SYNTHESIZE_UNSIGNED_PROPERTY_FILLER(NAME, TYPE) \
SYNTHESIZE_PROPERTY_FILLER(NAME, TYPE, uint64_t, UInteger, objc_msgSend)

#if defined(__i386__) || defined(__x86_64__)

#define SYNTHESIZE_FLOAT_PROPERTY_FILLER(NAME, TYPE) \
SYNTHESIZE_PROPERTY_FILLER(NAME, TYPE, double, Float, objc_msgSend_fpret)

#else

#define SYNTHESIZE_FLOAT_PROPERTY_FILLER(NAME, TYPE) \
SYNTHESIZE_PROPERTY_FILLER(NAME, TYPE, double, Float, objc_msgSend)

#endif


SYNTHESIZE_SIGNED_PROPERTY_FILLER(Char, char);
SYNTHESIZE_SIGNED_PROPERTY_FILLER(Short, short);
SYNTHESIZE_SIGNED_PROPERTY_FILLER(Int, int);
SYNTHESIZE_SIGNED_PROPERTY_FILLER(Long, long);
SYNTHESIZE_SIGNED_PROPERTY_FILLER(LongLong, long long);

SYNTHESIZE_UNSIGNED_PROPERTY_FILLER(UChar, unsigned char);
SYNTHESIZE_UNSIGNED_PROPERTY_FILLER(UShort, unsigned short);
SYNTHESIZE_UNSIGNED_PROPERTY_FILLER(UInt, unsigned int);
SYNTHESIZE_UNSIGNED_PROPERTY_FILLER(ULong, unsigned long);
SYNTHESIZE_UNSIGNED_PROPERTY_FILLER(ULongLong, unsigned long long);

SYNTHESIZE_FLOAT_PROPERTY_FILLER(Float, float);
SYNTHESIZE_FLOAT_PROPERTY_FILLER(Double, double);

SYNTHESIZE_PROPERTY_FILLER(Bool, BOOL, BOOL, Bool, objc_msgSend);

SYNTHESIZE_PROPERTY_FILLER(String, NSString*, NSString*, String, objc_msgSend);

//SYNTHESIZE_PROPERTY_FILLER(Date, NSDate*, NSDate*, Date, objc_msgSend);


@implementation ObjectPropertyFiller

+ (id) fillerWithPropertyName:(NSString*) propertyName objectClass:(Class) objectClass
{
    return [[[self alloc] initWithPropertyName:propertyName objectClass:objectClass] autorelease];
}

- (id) initWithPropertyName:(NSString*) propertyName objectClass:(Class) objectClass
{
    if((self = [super initWithPropertyName:propertyName]))
    {
        _objectClass = objectClass;
    }
    return self;
}

- (id<JSONCodec>) codec
{
    id<JSONCodec> codec = [[JSONCodecs sharedInstance] codecForClass:_objectClass];
    if(codec == nil)
    {
        NSLog(@"Error: Could not find codec for class %@", _objectClass);
    }
    return codec;
}

- (BOOL) fillPropertyInObject:(id) object fromDictionary:(NSDictionary*) dict
{
    NSDictionary* propertyValue;
    if([dict readJSONDictionary:&propertyValue forKey:_propertyName])
    {
        id<JSONCodec> codec = [self codec];
        if(codec == nil)
        {
            return NO;
        }
        id sendValue = [codec dictionaryToObject:propertyValue];
		objc_msgSend(object, _setter, sendValue);
        return YES;
    }
    return NO;
}

- (BOOL) fillPropertyInDictionary:(NSMutableDictionary*) dict fromObject:(id) object
{
    id subObject = ((id (*)(id, SEL))objc_msgSend)(object, _getter);
    id<JSONCodec> codec = [self codec];
    if(codec == nil)
    {
        return NO;
    }
    NSDictionary* value = [codec objectToDictionary:subObject];
    [dict setJSONDictionary:value forKey:_propertyName];
    return YES;
}

@end



@implementation BlockJSONCodec

+ (BlockJSONCodec*) codecWithDictionaryConverter:(ToDictionaryBlock) toDictionaryBlock
                                 objectConverter:(ToObjectBlock) toObjectBlock
{
    return [[[self alloc] codecWithDictionaryConverter:toDictionaryBlock
                                       objectConverter:toObjectBlock] autorelease];
}

- (id) initWithToDictionaryConverter:(ToDictionaryBlock) toDictionaryBlock
                     objectConverter:(ToObjectBlock) toObjectBlock
{
    if((self = [super init]))
    {
        _toDictionaryBlock = [toDictionaryBlock copy];
        _toObjectBlock = [toObjectBlock copy];
    }
    return self;
}

- (void) dealloc
{
    [_toDictionaryBlock release];
    [_toObjectBlock release];
    [super dealloc];
}

- (NSDictionary*) objectToDictionary:(id) object
{
    return _toDictionaryBlock(object);
}

- (id) dictionaryToObject:(NSDictionary*) dict
{
    return _toObjectBlock(dict);
}

@end


@implementation FillerBasedJSONCodec

@synthesize propertyFillers = _propertyFillers;

+ (FillerBasedJSONCodec*) codecWithClass:(Class) cls
                             propertyFillers:(NSArray*) propertyFillers
{
    return [[[self alloc] initWithClass:cls
                        propertyFillers:propertyFillers] autorelease];
}

+ (FillerBasedJSONCodec*) codecWithClass:(Class)cls
{
    return [[[self alloc] init] autorelease];
}

- (id) initWithClass:(Class) cls
     propertyFillers:(NSArray*) propertyFillers
{
    if((self = [super init]))
    {
        _cls = cls;
        _propertyFillers = [propertyFillers mutableCopy];
    }
    return self;
}

- (id) initWithClass:(Class)cls
{
    if((self = [super init]))
    {
        _cls = cls;
        _propertyFillers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [_propertyFillers release];
    [super dealloc];
}

- (id) dictionaryToObject:(NSDictionary*) dict
{
    id object = [[[_cls alloc] init] autorelease];
    if(object != nil)
    {
        for(id<PropertyFiller> filler in _propertyFillers)
        {
            if(![filler fillPropertyInObject:object fromDictionary:dict])
            {
                return nil;
            }
        }
    }
    return object;
}

- (NSDictionary*) objectToDictionary:(id) object
{
    if(object == nil)
    {
        return nil;
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[_propertyFillers count]];
    for(id<PropertyFiller> filler in _propertyFillers)
    {
        if(![filler fillPropertyInDictionary:dict fromObject:object])
        {
            return nil;
        }
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end


@interface JSONCodecs ()

@property(nonatomic, readwrite, retain) NSMutableDictionary* codecs;

@end



SYNTHESIZE_SINGLETON_FOR_CLASS_PROTOTYPE(JSONCodecs);

@implementation JSONCodecs

SYNTHESIZE_SINGLETON_FOR_CLASS(JSONCodecs);

@synthesize codecs = _codecs;

- (id) init
{
    if((self = [super init]))
    {
        _codecs = [[NSMutableDictionary dictionary] retain];
    }
    return self;
}

- (void) dealloc
{
    [_codecs release];
    [super dealloc];
}

- (NSArray*) writablePropertyNamesForClass:(Class) cls
{
	unsigned int numProperties;
	objc_property_t* properties = class_copyPropertyList(cls, &numProperties);
    
    NSMutableArray* propertyNames = [NSMutableArray arrayWithCapacity:numProperties];
	for(unsigned int i = 0; i < numProperties; i++)
	{
		NSString* propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
		objc_property_t property = class_getProperty(cls, [propertyName UTF8String]);
		const char* attributes = property_getAttributes(property);
		// Only add writable properties.
		if(NULL == strstr(attributes, ",R,"))
		{
			[propertyNames addObject:propertyName];
		}
	}
	free(properties);
    
    return propertyNames;
}

- (void) registerCodec:(id<JSONCodec>)codec forClass:(Class)cls
{
    [self.codecs setObject:codec forKey:cls];
}

- (void) registerDefaultCodecForClass:(Class) cls usingProperties:(NSArray*) properties
{
    NSMutableArray* fillers = [NSMutableArray arrayWithCapacity:[properties count]];

    for(NSString* propertyName in properties)
    {
        objc_property_t property = class_getProperty(cls, [propertyName cStringUsingEncoding:NSUTF8StringEncoding]);
        const char* attributesC = property_getAttributes(property);
        NSString* attributes = [NSString stringWithCString:attributesC encoding:NSUTF8StringEncoding];
        NSLog(@"Property %@: %@", propertyName, attributes);
        id<PropertyFiller> propertyFiller = nil;
        if([attributes length] > 2)
        {
            switch([attributes characterAtIndex:1])
            {
                case 'c':
                    propertyFiller = [CharPropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case 'C':
                    propertyFiller = [UCharPropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case 's':
                    propertyFiller = [ShortPropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case 'S':
                    propertyFiller = [UShortPropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case 'i':
                    propertyFiller = [IntPropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case 'I':
                    propertyFiller = [UIntPropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case 'l':
                    propertyFiller = [LongPropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case 'L':
                    propertyFiller = [ULongPropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case 'q':
                    propertyFiller = [LongLongPropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case 'Q':
                    propertyFiller = [ULongLongPropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case 'f':
                    propertyFiller = [FloatPropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case 'd':
                    propertyFiller = [DoublePropertyFiller fillerWithPropertyName:propertyName];
                    break;
                case '@':
                {
                    
                    Need special cases for string, date, dict, array, which dont return dicts with subobjects
                    NSRange classNameRange = [attributes rangeOfString:@"\"" options:0 range:NSMakeRange(3, [attributes length]-3)];
                    if(classNameRange.location != NSNotFound)
                    {
                        NSString* className = [attributes substringWithRange:NSMakeRange(3, classNameRange.location-3)];
                        Class objectClass = objc_getClass([className cStringUsingEncoding:NSUTF8StringEncoding]);
                        if(objectClass == nil)
                        {
                            NSLog(@"Error: Could not get class of type %@", className);
                            break;
                        }
                        propertyFiller = [ObjectPropertyFiller fillerWithPropertyName:propertyName objectClass:objectClass];
                        break;
                    }
                }
                default:
                    // Not a type we're interested in.
                    break;
            }
        }
        if(propertyFiller != nil)
        {
            [fillers addObject:propertyFiller];
        }
    }
    // TODO: Check for case where there are no property fillers?
    [self registerCodec:[FillerBasedJSONCodec codecWithClass:cls propertyFillers:fillers] forClass:cls];
}

- (void) registerDefaultCodecForClass:(Class) cls
{
    [self registerDefaultCodecForClass:cls usingProperties:[self writablePropertyNamesForClass:cls]];
}


- (id<JSONCodec>) codecForClass:(Class) cls
{
    return [self.codecs objectForKey:cls];
}



/*
- (JSONCodec*) buildCodecForClass:(Class) cls
{
    
}

- (JSONCodec*) codecForClass:(Class) cls
{
    JSONCodec* codec = [self.codecs objectForKey:cls];
    if(codec == nil)
    {
        
    }
    return codec;
}


- (void) registerCodecForClass:(Class) cls
                   encodeBlock:(EncodeBlock) encodeBlock
                   decodeBlock:(DecodeBlock) decodeBlock
{
    JSONCodec* codec = [JSONCodec codecWithEncodeBlock:encodeBlock decodeBlock:decodeBlock];
    const char* className = class_getName(cls);
    [self.codecs setValue:codec forKey:[NSString stringWithUTF8String:className]];
}

- (id) decodeObjectOfType:(Class) cls from:(NSDictionary*) dict
{
    JSONCodec* codec = [self.codecs objectForKey:cls];
    return [codec decode:dict];
}

- (NSDictionary*) encode:(id) object
{
    JSONCodec* codec = [self.codecs objectForKey:[object class]];
    return [codec encode:object];
}
*/

@end
