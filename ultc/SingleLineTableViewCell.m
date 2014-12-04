//
//  SingleLineTableViewCell.m
//  ultc
//
//  Created by Elliott De Aratanha on 5/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SingleLineTableViewCell.h"

@implementation SingleLineTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
