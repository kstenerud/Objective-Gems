//
//  UIDevice+ExtraInfo.h
//  Objective-Gems
//
//  Created by Karl Stenerud on 11/01/02.
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

#import <UIKit/UIKit.h>


/** The top level "family" for devices */
typedef enum
{
    KSDFamilySimulator,
    KSDFamilyIphone,
    KSDFamilyIpodTouch,
    KSDFamilyIpad,
    KSDFamilyUnknown,
} KSDFamily;

/** The generation within a device family */
typedef enum
{
    KSDGeneration1,
    KSDGeneration2,
    KSDGeneration3,
    KSDGeneration3GS,
    KSDGeneration4,
    KSDGenerationUnknown,
} KSDGeneration;

/** The cellular band/carrier used by a device */
typedef enum
{
    KSDBandNone,
    KSDBandGSM,
    KSDBandCDMA,
    KSDBandVerizon,
    KSDBandUnknown,
} KSDBand;


/**
 * UIDevice + enhanced information.
 */
@interface UIDevice (ExtraInfo)

/** The current device's machine identifier (e.g. iPhone2,1) */
@property(readonly) NSString* machine;

/** The current device's machine family */
@property(readonly) KSDFamily family;

/** The current device's machine generation */
@property(readonly) KSDGeneration generation;

/** The cellular band that the current machine uses */
@property(readonly) KSDBand band;

/** This machine's model ID (e.g. N88AP) */
@property(readonly) NSString* modelId;

/** The system version as a floating point numnber (e.g. 4.210000) */
@property(readonly) Float32 systemVersionNumber;

/** The kernel version string. e.g.
 * Darwin Kernel Version 10.4.0: Wed Oct 20 20:08:31 PDT 2010; root:xnu-1504.58.28~3/RELEASE_ARM_S5L8920X
 */
@property(readonly) NSString* kernelVersion;

/** The total amount of memory on this device */
@property(readonly) uint64_t totalMemory;

/** The maximum amount of memory available for user processes on this device */
@property(readonly) UInt32 usableMemory;

/** The amount of memory not currently in use */
@property(readonly) UInt32 freeMemory;

/** The CPU frequency in Hz */
@property(readonly) UInt32 cpuFrequency;

/** The bus frequency in Hz */
@property(readonly) UInt32 busFrequency;

/** The last time this machine was rebooted */
@property(readonly) NSDate* bootTime;

/** If YES, this machine has a camera */
@property(readonly) BOOL hasCamera;

/** If YES, this machine supports multitasking */
@property(readonly) BOOL multitasking;

/** If YES, this machine has a retina display */
@property(readonly) BOOL hasRetina;

/** The scaling from pixel to point */
@property(readonly) Float32 scale;

@end
