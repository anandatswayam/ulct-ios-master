//
//  DynamicDrillDownViewController.h
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import "DrillDownViewController.h"

@interface DynamicDrillDownViewController : DrillDownViewController <UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) NSString * searchKey;

@property (nonatomic) BOOL hideSearchBar;

- (void)hideTheSearchBar;

@end
