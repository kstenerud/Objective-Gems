//
//  JSONStuff.h
//  Objective-Gems
//
//  Created by Karl Stenerud on 6/24/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"



@protocol JSONCodable <NSObject>

+ (Class) keyType:(NSString*) path;
+ (Class) valueType:(NSString*) path;

@end



@protocol JSONCodec <NSObject>

- (NSDictionary*) objectToDictionary:(id) object;

- (id) dictionaryToObject:(NSDictionary*) dict;

@end



@protocol PropertyFiller <NSObject>

- (BOOL) fillPropertyInObject:(id) object fromDictionary:(NSDictionary*) dict;
- (BOOL) fillPropertyInDictionary:(NSMutableDictionary*) dict fromObject:(id) object;

@end


@interface BasicPropertyFiller : NSObject<PropertyFiller>
{
    NSString* _propertyName;
    SEL _getter;
    SEL _setter;
}

+ (id) fillerWithPropertyName:(NSString*) propertyName;

- (id) initWithPropertyName:(NSString*) propertyName;

@end

@interface ObjectPropertyFiller : BasicPropertyFiller
{
    Class _objectClass;
}

+ (id) fillerWithPropertyName:(NSString*) propertyName objectClass:(Class) objectClass;

- (id) initWithPropertyName:(NSString*) propertyName objectClass:(Class) objectClass;

@end


@interface BoolPropertyFiller : BasicPropertyFiller @end
@interface CharPropertyFiller : BasicPropertyFiller @end
@interface ShortPropertyFiller : BasicPropertyFiller @end
@interface IntPropertyFiller : BasicPropertyFiller @end
@interface LongPropertyFiller : BasicPropertyFiller @end
@interface LongLongPropertyFiller : BasicPropertyFiller @end
@interface UCharPropertyFiller : BasicPropertyFiller @end
@interface UShortPropertyFiller : BasicPropertyFiller @end
@interface UIntPropertyFiller : BasicPropertyFiller @end
@interface ULongPropertyFiller : BasicPropertyFiller @end
@interface ULongLongPropertyFiller : BasicPropertyFiller @end
@interface FloatPropertyFiller : BasicPropertyFiller @end
@interface DoublePropertyFiller : BasicPropertyFiller @end
@interface StringPropertyFiller : BasicPropertyFiller @end


@interface DictionaryJSONCodec : NSObject<JSONCodec>
{
}

@end

typedef NSDictionary* (^ToDictionaryBlock)(id object);
typedef id (^ToObjectBlock)(NSDictionary* dict);

@interface BlockJSONCodec : NSObject<JSONCodec>
{
    ToDictionaryBlock _toDictionaryBlock;
    ToObjectBlock _toObjectBlock;
}

+ (BlockJSONCodec*) codecWithDictionaryConverter:(ToDictionaryBlock) toDictionaryBlock
                                 objectConverter:(ToObjectBlock) toObjectBlock;

- (id) initWithToDictionaryConverter:(ToDictionaryBlock) toDictionaryBlock
                     objectConverter:(ToObjectBlock) toObjectBlock;

@end



@interface FillerBasedJSONCodec : NSObject<JSONCodec>
{
    Class _cls;
    NSMutableArray* _propertyFillers;
}
@property(nonatomic,readonly,retain) NSMutableArray* propertyFillers;

+ (FillerBasedJSONCodec*) codecWithClass:(Class) cls;

+ (FillerBasedJSONCodec*) codecWithClass:(Class) cls
                         propertyFillers:(NSArray*) propertyFillers;

- (id) initWithClass:(Class) cls;

- (id) initWithClass:(Class) cls
     propertyFillers:(NSArray*) propertyFillers;

@end




@interface JSONCodecs : NSObject
{
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(JSONCodecs);

- (void) registerCodec:(id<JSONCodec>) codec forClass:(Class) cls;

- (void) registerDefaultCodecForClass:(Class) cls usingProperties:(NSArray*) properties;

- (void) registerDefaultCodecForClass:(Class) cls;


//- (id) decode:(NSDictionary*) dict;

//- (NSDictionary*) encode:(id) object;


// For codec use only
- (id<JSONCodec>) codecForClass:(Class) cls;

@end
