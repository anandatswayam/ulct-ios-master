//
//  WRUtilities.m
//  joinman
//
//  Created by Matthew Shultz on 4/13/13.
//
//

#import "WRUtilities.h"
#import "NSDate+Pretty.h"

@implementation WRUtilities

+ (id)getViewFromNib: (NSString *) nibName class: (id) class {
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:nibName
                                                owner:nil options:nil];
    UIView * view;
    for (id object in bundle) {
        if ([object isKindOfClass:class])
            view = (UIView *)object;
    }
    assert(view != nil && "View can't be nil");
    return view;
    
}

+ (void) criticalError: (NSError *) error {
    
    NSLog(@"%@ Critical Error: %@", [[NSDate date] pretty], [error debugDescription]);
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Critical Error"
                          message: [error debugDescription]
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
}

+ (void) criticalErrorWithString: (NSString *) error {
    
    NSLog(@"%@ Critical Error: %@", [[NSDate date] pretty] , error);
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Critical Error"
                          message: error
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    
}

@end
