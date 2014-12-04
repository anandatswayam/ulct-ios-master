//
//  EventsCalendarViewController.h
//  ultc
//
//  Created by shallowsummer on 9/8/13.
//
//

#import "DynamicDrillDownViewController.h"

@interface EventsCalendarViewController : DynamicDrillDownViewController


@property(nonatomic,strong) NSMutableDictionary * items_by_month;
@property(nonatomic,strong) NSMutableDictionary * items_dict;

@end    
