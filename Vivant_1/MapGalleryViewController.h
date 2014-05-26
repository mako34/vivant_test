//
//  MainViewController.h
//  Vivant_1
//
//  Created by Manuel Betancurt on 24/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapGalleryViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


- (void)showSplash;
- (void)hideSplash;

@end
