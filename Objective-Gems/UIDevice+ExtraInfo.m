//
//  UIDevice+ExtraInfo.m
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

#import "UIDevice+ExtraInfo.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "LoadableCategory.h"

MAKE_CATEGORIES_LOADABLE(ObjectiveGems_UIDevice_ExtraInfo);


/** Ensure these extensions are initialized.
 */
#define ENSURE_INITIALIZED() \
if(!ksdInitialized_) \
{ \
    [self ksdInit]; \
}
    

@interface UIDevice ()

/** Initialize global data for this category.
 */
- (void) ksdInit;

/** Get a description for the last error based on errno.
 *
 * @return A description of the last error.
 */
- (NSString*) ksdDescriptionForError;

/** Get a 32-bit integer from sysctl.
 *
 * @param name The name of the value to get.
 * @return The value
 */
- (int) ksdInt32Value:(NSString*) name;

/** Get a 64-bit integer from sysctl.
 *
 * @param name The name of the value to get.
 * @return The value
 */
- (int64_t) ksdInt64Value:(NSString*) name;

/** Get a string from sysctl.
 *
 * @param name The name of the value to get.
 * @return The value
 */
- (NSString*) ksdStringValue:(NSString*) name;

/** Get a date from sysctl that uses truct timeval.
 *
 * @param name The name of the value to get.
 * @return The value
 */
- (NSDate*) ksdDateValueTimeVal:(NSString*) name;

/** Get a date from sysctl that return seconds from 1970.
 *
 * @param name The name of the value to get.
 * @return The value
 */
- (NSDate*) ksdksdDateValueInt:(NSString*) name;

/** Get the family of a machine.
 *
 * @param machine The machine identifier (e.g. iPhone2,1).
 * @return The family of the machine.
 */
- (KSDFamily) ksdFamilyForMachine:(NSString*) machine;

/** Get the generation of a machine.
 *
 * @param family The machine family.
 * @param majorValue The major value of the machine identifier.
 * @param minorValue The minor value of the machine identifier.
 * @return The generation of the machine.
 */
- (KSDGeneration) ksdGenerationForFamily:(KSDFamily) family
                             majorValue:(NSUInteger) majorValue
                             minorValue:(NSUInteger) minorValue;

/** Get the wireless band of a machine.
 *
 * @param family The machine family.
 * @param generation The generation of the machine.
 * @return The band this machine uses.
 */
- (KSDGeneration) ksdBandForFamily:(KSDFamily) family
                       generation:(KSDGeneration) generation
                       minorValue:(NSUInteger) minorValue;

/** Parse the machine string and set some internal values.
 */
- (void) ksdParseMachineString;

/** Parse the version string into a float value.
 */
- (void) ksdParseVersionString;

@end


@implementation UIDevice (ExtraInfo)

/** If YES, the global values for this category are initialized. */
static bool ksdInitialized_;

/** The family of the current machine. */
static KSDFamily ksdFamily_;

/** The generation of the current machine. */
static KSDGeneration ksdGeneration_;

/** The cellular band of the current machine. */
static KSDBand ksdBand_;

/** If YES, this machine has a retina display. */
static BOOL ksdRetina_;

/** If YES, this machine supports multitasking. */
static BOOL ksdMultitasking_;

/** If YES, this machine has a camera. */
static BOOL ksdCamera_;

/** The system version, as a float (e.g. 4.21000) */
static Float32 ksdSystemVersionNumber_;

/** The scaling between a point and a pixel. */
static Float32 ksdScale_;


- (NSString*) machine
{
    return [self ksdStringValue:@"hw.machine"];
}

- (NSString*) modelId
{
    return [self ksdStringValue:@"hw.model"];
}

- (NSString*) kernelVersion
{
    return [self ksdStringValue:@"kern.version"];
}

- (UInt32) cpuFrequency
{
    return [self ksdInt32Value:@"hw.cpufrequency"];
}

- (UInt32) busFrequency
{
    return [self ksdInt32Value:@"hw.busfrequency"];
}

- (uint64_t) totalMemory
{
    return [self ksdInt64Value:@"hw.memsize"];
}

static inline bool getPageSizeAndVMStats(vm_size_t* pageSize, vm_statistics_data_t* vmStats)
{
    mach_port_t hostPort = mach_host_self();
    
    host_page_size(hostPort, pageSize);        
    
    mach_msg_type_number_t hostSize = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    kern_return_t error = host_statistics(hostPort, HOST_VM_INFO, (host_info_t)vmStats, &hostSize);
    if(KERN_SUCCESS != error)
    {
        NSLog(@"Error: %s: Could not get kernel stats: %d", __PRETTY_FUNCTION__, error);
        return NO;
    }
    return YES;
}

- (UInt32) usableMemory
{
    vm_size_t pageSize;
    vm_statistics_data_t vmStats;
    if(!getPageSizeAndVMStats(&pageSize, &vmStats))
    {
        return 0;
    }
    
    return (vmStats.active_count + vmStats.inactive_count + vmStats.wire_count + vmStats.free_count) * pageSize;
}

- (UInt32) freeMemory
{
    vm_size_t pageSize;
    vm_statistics_data_t vmStats;
    if(!getPageSizeAndVMStats(&pageSize, &vmStats))
    {
        return 0;
    }
    
    return vmStats.free_count * pageSize;
}

- (NSDate*) bootTime
{
    return [self ksdDateValueTimeVal:@"kern.boottime"];
}

- (KSDFamily) family
{
    ENSURE_INITIALIZED();
    return ksdFamily_;
}

- (KSDGeneration) generation
{
    ENSURE_INITIALIZED();
    return ksdGeneration_;
}

- (KSDBand) band
{
    ENSURE_INITIALIZED();
    return ksdBand_;
}

- (BOOL) hasRetina
{
    ENSURE_INITIALIZED();
    return ksdRetina_;
}

- (BOOL) hasCamera
{
    ENSURE_INITIALIZED();
    return ksdCamera_;
}

- (BOOL) multitasking
{
    ENSURE_INITIALIZED();
    return ksdMultitasking_;
}

- (Float32) systemVersionNumber
{
    ENSURE_INITIALIZED();
    return ksdSystemVersionNumber_;
}

- (Float32) scale
{
    ENSURE_INITIALIZED();
    return ksdScale_;
}

- (NSString*) ksdDescriptionForError
{
    switch(errno)
    {
        case EFAULT:
            return @"Invalid Address";
        case EINVAL:
            return [NSString stringWithFormat:@"Name length was < 2 or > %d", CTL_MAXNAME];
        case ENOMEM:
            return @"Insufficient memory";
        case ENOTDIR:
            return @"Name specified an intermediate rather than terminal name";
        case EISDIR:
            return @"Name specified a terminal name, but the actual name is not terminal";
        case ENOENT:
            return @"Unknown name";
        case EPERM:
            return @"Insufficient privileges";
    }
    return [NSString stringWithFormat:@"Unknown (%d)", errno];
}

- (int) ksdInt32Value:(NSString*) name
{
    int value = 0;
    size_t size = sizeof(value);
    
    int error = sysctlbyname([name cStringUsingEncoding:NSUTF8StringEncoding],
                             &value,
                             &size,
                             NULL,
                             0);
    
    if(0 != error)
    {
        NSLog(@"Error: %s: Could not get int32 value for %@: %@",
              __PRETTY_FUNCTION__,
              name,
              [self ksdDescriptionForError]);
    }
    
    return value;
}

- (int64_t) ksdInt64Value:(NSString*) name
{
    int64_t value = 0;
    size_t size = sizeof(value);
    
    int error = sysctlbyname([name cStringUsingEncoding:NSUTF8StringEncoding],
                             &value,
                             &size,
                             NULL,
                             0);
    
    if(0 != error)
    {
        NSLog(@"Error: %s: Could not get int64 value for %@: %@",
              __PRETTY_FUNCTION__,
              name,
              [self ksdDescriptionForError]);
        return 0;
    }
    
    return value;
}

- (NSString*) ksdStringValue:(NSString*) name
{
    int error;
    size_t size = 0;

    error = sysctlbyname([name cStringUsingEncoding:NSUTF8StringEncoding],
                         NULL,
                         &size,
                         NULL,
                         0);
    
    if(0 != error)
    {
        NSLog(@"Error: %s: Could not get string value for %@: %@",
              __PRETTY_FUNCTION__,
              name,
              [self ksdDescriptionForError]);
        return nil;
    }

    char* value = malloc(size);

    error = sysctlbyname([name cStringUsingEncoding:NSUTF8StringEncoding],
                             value,
                             &size,
                             NULL,
                             0);
    
    if(0 != error)
    {
        free(value);
        NSLog(@"Error: %s: Could not get string value for %@: %@",
              __PRETTY_FUNCTION__,
              name,
              [self ksdDescriptionForError]);
        return nil;
    }

    NSString* str = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];

    free(value);

    return str;
}

- (NSDate*) ksdDateValueTimeVal:(NSString*) name
{
    struct timeval value;
    size_t size = sizeof(value);
    
    int error = sysctlbyname([name cStringUsingEncoding:NSUTF8StringEncoding],
                             &value,
                             &size,
                             NULL,
                             0);
    
    if(0 != error)
    {
        NSLog(@"Error: %s: Could not get struct timeval value for %@: %@",
              __PRETTY_FUNCTION__,
              name,
              [self ksdDescriptionForError]);
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)value.tv_sec];
}

- (KSDFamily) ksdFamilyForMachine:(NSString*) machine
{
    if([machine rangeOfString:@"x86_64"].location == 0 ||
       [machine rangeOfString:@"i386"].location == 0)
    {
        return KSDFamilySimulator;
    }
    if([machine rangeOfString:@"iPhone"].location == 0)
    {
        return KSDFamilyIphone;
    }
    if([machine rangeOfString:@"iPod"].location == 0)
    {
        return KSDFamilyIpodTouch;
    }
    if([machine rangeOfString:@"iPad"].location == 0)
    {
        return KSDFamilyIpad;
    }

    return KSDFamilyUnknown;
}

- (KSDGeneration) ksdGenerationForFamily:(KSDFamily) family
                             majorValue:(NSUInteger) majorValue
                             minorValue:(NSUInteger) minorValue
{
    switch(family)
    {
        case KSDFamilySimulator:
            return KSDGenerationUnknown;
        case KSDFamilyIphone:
            switch(majorValue)
        {
            case 1:
                switch(minorValue)
            {
                case 1:
                    return KSDGeneration2;
                case 2:
                    return KSDGeneration3;
            }
                break;
            case 2:
                return KSDGeneration3GS;
            case 3:
                return KSDGeneration4;
        }
            break;
        case KSDFamilyIpodTouch:
            switch(majorValue)
        {
            case 1:
                return KSDGeneration1;
            case 2:
                return KSDGeneration2;
            case 3:
                return KSDGeneration3;
            case 4:
                return KSDGeneration4;
        }
            break;
        case KSDFamilyIpad:
            switch(majorValue)
        {
            case 1:
                return KSDGeneration1;
            case 2:
                return KSDGeneration2;
        }
        default:
            break;
    }
    return KSDGenerationUnknown;
}

- (KSDGeneration) ksdBandForFamily:(KSDFamily) family
                       generation:(KSDGeneration) generation
                       minorValue:(NSUInteger) minorValue
{
    switch(family)
    {
        case KSDFamilySimulator:
            return KSDBandNone;
        case KSDFamilyIphone:
            switch(generation)
        {
            case KSDGeneration2:
                return KSDBandGSM;
            case KSDGeneration3:
                return KSDBandGSM;
            case KSDGeneration3GS:
                return KSDBandGSM;
            case KSDGeneration4:
                switch(minorValue)
            {
                case 1:
                    return KSDBandGSM;
                case 2:
                    return KSDBandVerizon;
                case 3:
                    return KSDBandCDMA;
            }
            default:
                break;
        }
            break;
        case KSDFamilyIpodTouch:
            return KSDBandNone;
        case KSDFamilyIpad:
            switch(generation)
        {
            case KSDGeneration1:
                return KSDBandNone;
            case KSDGeneration2:
                switch(minorValue)
            {
                case 1:
                    return KSDBandNone;
                case 2:
                    return KSDBandGSM;
                case 3:
                    return KSDBandCDMA;
            }
            default:
                break;
        }
        default:
            break;
    }
    return KSDBandUnknown;
}

/* iPhone1,1: iPhone 2G
 * iPhone1,2: iPhone 3G
 * iPhone2,1: iPhone 3GS
 * iPhone3,1: iPhone 4
 * iPhone3,2: iPhone 4 (Verizon)
 * iPhone3,3: iPhone 4 (CDMA)
 * iPod1,1:   iPod Touch 1G
 * iPod2,1:   iPod Touch 2G
 * iPod3,1:   iPod Touch 3G
 * iPod4,1:   iPod Touch 4G
 * iPad1,1:   iPad
 * iPad2,1:   iPad 2 (WIFI)
 * iPad2,2:   iPad 2 (GSM)
 * iPad2,3:   iPad 2 (CDMA)
 * i386:      Simulator
 * x86_64:    Simulator
 */
- (void) ksdParseMachineString
{
    ksdGeneration_ = KSDGenerationUnknown;
    ksdBand_ = KSDBandNone;

    NSString* machine = [self ksdStringValue:@"hw.machine"];

    ksdFamily_ = [self ksdFamilyForMachine:machine];

    NSRange range = [machine rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(NSNotFound != range.location)
    {
        NSUInteger majorValue = [[machine substringWithRange:range] intValue];
        NSUInteger minorValue = [[machine substringFromIndex:range.location+range.length+1] intValue];
        
        ksdGeneration_ = [self ksdGenerationForFamily:ksdFamily_ majorValue:majorValue minorValue:minorValue];
        ksdBand_ = [self ksdBandForFamily:ksdFamily_ generation:ksdGeneration_ minorValue:minorValue];
    }
    
    ksdCamera_ = (KSDFamilyIphone == ksdFamily_)
    || (KSDFamilyIpad == ksdFamily_ && KSDGeneration2 == ksdGeneration_);
}

- (void) ksdParseVersionString
{
    NSString* versionStr = [self systemVersion];

    unichar ch = [versionStr characterAtIndex:0];
    if(ch < '0' || ch > '9' || [versionStr characterAtIndex:1] != '.')
    {
        NSLog(@"Error: %s: Cannot parse iOS version string \"%@\"", __PRETTY_FUNCTION__, versionStr);
    }
    
    ksdSystemVersionNumber_ = (Float32)(ch - '0');
    
    Float32 multiplier = 0.1f;
    unsigned int vLength = [versionStr length];
    for(unsigned int i = 2; i < vLength; i++)
    {
        ch = [versionStr characterAtIndex:i];
        if(ch >= '0' && ch <= '9')
        {
            ksdSystemVersionNumber_ += (ch - '0') * multiplier;
            multiplier /= 10;
        }
        else if('.' != ch)
        {
            break;
        }
    }
}

- (void) ksdInit
{
    [self ksdParseMachineString];
    [self ksdParseVersionString];
    
    UIDevice* device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
    {
        ksdMultitasking_ = [device isMultitaskingSupported];
    }
    
    ksdScale_ = 1.0f;
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        ksdScale_ = [[UIScreen mainScreen] scale];
    }
    
    ksdRetina_ = ksdScale_ > 1.99f && ksdScale_ < 2.01f;
    
    ksdInitialized_ = YES;
}

- (NSString*) familyAndGeneration
{
    switch(self.family)
    {
        case KSDFamilyIpad:
            switch(self.generation)
        {
            case KSDGeneration1:
                return @"iPad";
            case KSDGeneration2:
                return @"iPad 2";
            case KSDGeneration3:
                return @"iPad 3";
            default:
                return [NSString stringWithFormat:@"? (%@)", self.machine];
        }
        case KSDFamilyIphone:
            switch(self.generation)
        {
            case KSDGeneration2:
                return @"iPhone";
            case KSDGeneration3:
                return @"iPhone 3G";
            case KSDGeneration3GS:
                return @"iPhone 3GS";
            case KSDGeneration4:
                return @"iPhone 4";
            default:
                return [NSString stringWithFormat:@"? (%@)", self.machine];
        }
        case KSDFamilyIpodTouch:
                switch(self.generation)
            {
                case KSDGeneration1:
                    return @"iPod Touch 1G";
                case KSDGeneration2:
                    return @"iPod Touch 2G";
                case KSDGeneration3:
                    return @"iPod Touch 3G";
                case KSDGeneration4:
                    return @"iPod Touch 4G";
                default:
                    return [NSString stringWithFormat:@"? (%@)", self.machine];
            }
        case KSDFamilySimulator:
            return @"Simulator";
        default:
            return [NSString stringWithFormat:@"? (%@)", self.machine];
    }
}

- (NSString*) bandName
{
    switch(self.band)
    {
        case KSDBandNone:
            return @"None";
        case KSDBandGSM:
            return @"GSM";
        case KSDBandCDMA:
            return @"CDMA";
        case KSDBandVerizon:
            return @"Verizon";
        default:
            return @"Unknown";
    }
}

@end
