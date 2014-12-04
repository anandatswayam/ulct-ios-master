//
//  Recent.h
//  ultc
//
//  Created by Matthew Shultz on 9/27/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recent : NSManagedObject

@property (nonatomic, retain) NSNumber * itemId;
@property (nonatomic, retain) NSString * viewController;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * accessDate;

@end
