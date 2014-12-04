//
//  TitleTableViewCell.h
//  ultc
//
//  Created by Elliott De Aratanha on 5/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentViewController;

@protocol TitleTableViewCellDelegate <NSObject>

- (void) didToggleFavorite: (BOOL) selected;

@end

@interface TitleTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TitleTableViewCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton * button;

@property (nonatomic, weak) IBOutlet UILabel * title;

- (void) selectIfFavorited: (ContentViewController *) vc;

- (void) toggleFavorite;


@end