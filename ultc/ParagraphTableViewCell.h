//
//  ParagraphTableViewCell.h
//  ulct
//
//  Created by Matthew Shultz on 1/8/14.
//
//

#import <UIKit/UIKit.h>

@interface ParagraphTableViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel * title;
@property (nonatomic,weak) IBOutlet UILabel * content;

@end
