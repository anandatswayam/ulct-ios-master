//
//  NSDate+Pretty.m
//  joinman
//
//  Created by Matthew Shultz on 4/14/13.
//
//

#import "NSDate+Pretty.h"

static NSDateFormatter *formatter = nil;

@implementation NSDate (Pretty)

- (NSString *) pretty {
    
    if(!formatter){
        formatter = [[NSDateFormatter alloc] init];
    }
    
    [formatter setDateFormat:@"HH:mm zzz"];
    NSString *timeFromDate = [formatter stringFromDate:self];
    [formatter setDateFormat:@"Y/M/d"];
    NSString *dateFromDate = [formatter stringFromDate:self];
    NSString *exportDateString = [NSString stringWithFormat:@"%@ at %@", dateFromDate, timeFromDate ];
    return exportDateString;
}

- (NSString *) prettyJustDate {
    
    if(!formatter){
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat:@"M/d/Y"];
    //    [formatter setDateFormat:@"Y/M/d"];
    NSString *dateFromDate = [formatter stringFromDate:self];
    NSString *exportDateString = [NSString stringWithFormat:@"%@", dateFromDate ];
    return exportDateString;
}

- (NSString *) prettyJustMonthYear {
    
    if(!formatter){
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat:@"M/Y"];
    //    [formatter setDateFormat:@"Y/M/d"];
    NSString *dateFromDate = [formatter stringFromDate:self];
    NSString *exportDateString = [NSString stringWithFormat:@"%@", dateFromDate ];
    return exportDateString;
}

- (NSString *) dayAndTime{
    if(!formatter){
        formatter = [[NSDateFormatter alloc] init];
    }
    
    [formatter setDateFormat:@"hh:mm a"];
    NSString *timeFromDate = [formatter stringFromDate:self];
    [formatter setDateFormat:@"EE"];
    NSString *dateFromDate = [[formatter stringFromDate:self] uppercaseString];
    NSString *dayToday = [[formatter stringFromDate:[NSDate date]] uppercaseString];
    NSString *exportDateString;
    if([dayToday isEqualToString:dateFromDate]){
        exportDateString= [NSString stringWithFormat:@"%@", timeFromDate ];
    } else {
        exportDateString= [NSString stringWithFormat:@"%@ %@", dateFromDate, timeFromDate ];
    }
    return exportDateString;
}


- (NSString *) formatted {
    
    if(!formatter){
        formatter = [[NSDateFormatter alloc] init];
    }
    
    [formatter setDateFormat:@"HH:mm zzz"];
    NSString *timeFromDate = [formatter stringFromDate:self];
    [formatter setDateFormat:@"Y/M/d"];
    NSString *dateFromDate = [formatter stringFromDate:self];
    NSString *exportDateString = [NSString stringWithFormat:@"%@ %@", dateFromDate, timeFromDate ];
    return exportDateString;
}

@end
