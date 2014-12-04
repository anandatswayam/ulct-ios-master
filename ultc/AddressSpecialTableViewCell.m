//
//  AddressSpecialTableViewCell.m
//  ultc
//
//  Created by shallowsummer on 9/19/13.
//
//

#import "AddressSpecialTableViewCell.h"

@implementation AddressSpecialTableViewCell

@synthesize title, addressLine1;

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
