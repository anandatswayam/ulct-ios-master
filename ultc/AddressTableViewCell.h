//
//  AddressTableViewCell.h
//  ultc
//
//  Created by Elliott De Aratanha on 5/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel * title;
@property (nonatomic, weak) IBOutlet UILabel * addressLine1;
@property (nonatomic, weak) IBOutlet UILabel * addressLine2;


@end
