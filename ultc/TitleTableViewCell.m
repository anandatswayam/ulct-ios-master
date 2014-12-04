//
//  TitleTableViewCell.m
//  ultc
//
//  Created by Elliott De Aratanha on 5/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TitleTableViewCell.h"
#import "ContentViewController.h"

@implementation TitleTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}



- (IBAction) didTapButton: (id) sender {
    if(_button.selected) {
        [_delegate didToggleFavorite:false];
        [self toggleFavorite];
    }
    else {
        [_delegate didToggleFavorite:true];
        [self toggleFavorite];
    }
}

- (void) toggleFavorite {
    if(_button.selected) {
        _button.selected = false;
    }
    else {
        _button.selected = true;
    }
}


- (void) selectIfFavorited: (ContentViewController *) vc {
    
    
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Favorite"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"itemId = %@ AND viewController = %@", vc.itemId, NSStringFromClass([vc class])];
    [request setPredicate:predicate];
    NSError * error;
    NSArray * results = [[AppDelegate getAppDelegate].managedObjectContext executeFetchRequest:request error:&error];
    if(results == nil){
        [WRUtilities criticalError:error];
        return;
    }

    if([results count] > 0){
        _button.selected = true;
    }
}


@end
