//
//  NSDate+Pretty.h
//  joinman
//
//  Created by Matthew Shultz on 4/14/13.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Pretty)

- (NSString *) pretty;
- (NSString *) prettyJustDate;
- (NSString *) prettyJustMonthYear;
- (NSString *) dayAndTime;
- (NSString *) formatted;

@end
