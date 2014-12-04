//
//  SingleLineTableViewCell.h
//  ultc
//
//  Created by Elliott De Aratanha on 5/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleLineTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel * title;
@property (nonatomic,weak) IBOutlet UILabel * content;

@end
