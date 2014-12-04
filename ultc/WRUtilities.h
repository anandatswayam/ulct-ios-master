//
//  WRUtilities.h
//  joinman
//
//  Created by Matthew Shultz on 4/13/13.
//
//

#import <Foundation/Foundation.h>

@interface WRUtilities : NSObject

+ (id)getViewFromNib: (NSString *) nibName class: (id) class;
+ (void) criticalError: (NSError *) error;
+ (void) criticalErrorWithString: (NSString *) error;

@end
