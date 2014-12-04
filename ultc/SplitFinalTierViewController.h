//
//  SplitFinalTierViewController.h
//  ulct
//
//  Created by Matthew Shultz on 10/26/13.
//
//

#import <UIKit/UIKit.h>
#import "DrillDownViewController.h"
#import "ContentViewController.h"

@interface SplitFinalTierViewController : UIViewController

@property (nonatomic, strong) DrillDownViewController * drillDownViewController;
@property (nonatomic, weak) IBOutlet UIView * drillDownView;
@property (nonatomic, strong) ContentViewController * contentViewController;
@property (nonatomic, weak) IBOutlet UIView * contentView;

@end
