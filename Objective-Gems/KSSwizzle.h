//
//  KSSwizzle.h
//  Objective-Gems
//
//  Created by Karl Stenerud on 5/1/11.
//  Copyright 2011 KarlStenerud. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KSSwizzle : NSObject {
    
}

- (void) swapMethod:(SEL) selector withMethod:(SEL) otherSelector;
- (void) removeMethod;
- (void) addMethod;
- (void) copyMethod;
- (void) replaceMethod;

// class method
// instance method

@end



