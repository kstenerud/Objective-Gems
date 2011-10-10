//
//  SymbolAsString.h
//  Objective-Gems
//
//  Created by Karl Stenerud on 7/12/11.
//
// From http://borkware.com/quickies/single?id=396
//

#define SYMBOL_AS_STRING_INTERNAL(x) #x
#define SYMBOL_AS_STRING(x) SYMBOL_AS_STRING_INTERNAL(x)

#define SYMBOL_AS_NSSTRING_INTERNAL(x) @#x
#define SYMBOL_AS_NSSTRING(x) SYMBOL_AS_NSSTRING_INTERNAL(x)
