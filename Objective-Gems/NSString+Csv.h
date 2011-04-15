//
//  NSString+Csv.h
//  Objective-Gems
//
// Created by Drew McCormack
// From http://macresearch.org/cocoa-scientists-part-xxvi-parsing-csv-data
//
// Public Domain
//

#import <Foundation/Foundation.h>


/** Enhancement for reading CSV data from a string.
 */
@interface NSString (Csv)

/** Interpret this string's data as CSV data and return an array of arrays
 * representing the CSV rows and columns.
 *
 * @return An array of rows, which each contain an array of columns.
 */
-(NSArray *)csvRows;

@end
