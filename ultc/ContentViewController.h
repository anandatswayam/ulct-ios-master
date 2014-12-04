//
//  ContentViewController.h
//  ultc
//
//  Created by Matthew Shultz on 5/23/13.
//
//

#import <UIKit/UIKit.h>
#import "TitleTableViewCell.h"
#import "EntityBrowseController.h"


@interface ContentViewController : UIViewController <TitleTableViewCellDelegate>

@property (nonatomic, strong) EntityBrowseController * entityBrowseController;

@property (nonatomic, strong) NSNumber * itemId;

@property (nonatomic) BOOL saveAsRecent;

- (void) pushViewController: (UIViewController *) vc;
- (void) openMapAtAddress: (NSString *) fullAddress;
- (void) sendEmail: (NSString *) emailAddress;
- (void) callPhone: (NSString *) phoneNumber;
- (void) openUrl: (NSString*) url;


@end