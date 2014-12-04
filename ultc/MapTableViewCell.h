//
//  MapTableViewCell.h
//  ultc
//
//  Created by Elliott De Aratanha on 5/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
