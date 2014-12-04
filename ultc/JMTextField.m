//
//  JMTextField.m
//  joinman
//
//  Created by Matthew Shultz on 4/12/13.
//
//

#import "JMTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation JMTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.font = [UIFont systemFontOfSize:28.0f];
    self.borderStyle = UITextBorderStyleNone;
    self.background = [UIImage imageNamed:@"username-password"];
    CGRect frame = self.frame;
    frame.size.height =  frame.size.height + 20;
    self.frame = frame;

}


- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8,
                      bounds.size.width - 20, bounds.size.height - 16);
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}
@end
