//
//  EntityBrowseController.h
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import <UIKit/UIKit.h>

@interface EntityBrowseController : UIViewController

@property(nonatomic, strong) UINavigationController * navController;
@property(nonatomic, strong) UIViewController * rootDrillDownViewController;

- (void) placeIntoContentView: (UIViewController *) vc;
- (void) clearContentView;

@end
