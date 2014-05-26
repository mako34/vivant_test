//
//  MainViewController.m
//  Vivant_1
//
//  Created by Manuel Betancurt on 24/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//


#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "Gallery.h"
#import "GalleryDetailViewController.h"
#import "Location.h"
#import "MapGalleryViewController.h"


#define METERS_PER_MILE 1609.344
#define SydneyLatitude  -33.8678500
#define SydneyLongitude 151.2073200
#define kDelayForSplash 3


@interface MapGalleryViewController ()

@end

@implementation MapGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Galleries Map";
    
    self.mapView.delegate = self;
    [self plotCrimePositions];

}




//- (void)plotCrimePositions:(NSData *)responseData {
- (void)plotCrimePositions  {
    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    NSArray *galleries = [Gallery MR_findAll];
    
    for (Gallery *galleryObj in galleries) {
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [galleryObj.lat floatValue];
        coordinate.longitude = [galleryObj.lon floatValue];
        Location *annotation = [[Location alloc] initWithName:galleryObj.suburb address:galleryObj.address coordinate:coordinate] ;
        [_mapView addAnnotation:annotation];
    }
    

}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = SydneyLatitude;
    zoomLocation.longitude= SydneyLongitude;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    
    // 3
    [_mapView setRegion:viewRegion animated:YES];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *annReuseId = @"currentloc";
    
    MKPinAnnotationView *annView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annReuseId];
    if (annView == nil)
    {
        annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annReuseId];
        
        annView.animatesDrop = YES;
        annView.canShowCallout = YES;
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annView.rightCalloutAccessoryView=detailButton;
    }
    else {
        annView.annotation = annotation;
    }
    
    return annView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Location *locationObj = view.annotation;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"address = %@",locationObj.subtitle];
    NSArray *itemsArraya = [Gallery MR_findAllWithPredicate:predicate];
    
    GalleryDetailViewController *gVC = [[GalleryDetailViewController alloc]initWithGallery:[itemsArraya objectAtIndex:0]];
    [self.navigationController pushViewController:gVC animated:YES];
    
}

- (void)showSplash
{
    UIViewController *modalViewController = [[UIViewController alloc] init];
    
    UIImageView *modelView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    modelView.image = [UIImage imageNamed:@"splash"];
    
    
    modalViewController.view = modelView;
    
    
    [self presentViewController:modalViewController animated:NO completion:nil];
    
    [self performSelector:@selector(hideSplash) withObject:nil afterDelay:kDelayForSplash];
}
- (void)hideSplash
{
    
    [self dismissViewControllerAnimated:NO completion:nil];
 }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
