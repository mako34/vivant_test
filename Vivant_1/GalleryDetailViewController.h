//
//  GalleryDetailViewController.h
//  Vivant_1
//
//  Created by Manuel Betancurt on 26/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gallery.h"
#import "PieceOfArt.h"

@interface GalleryDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *suburbLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UITableView *galleryDetailTable;


- (id)initWithGallery:(Gallery*)gallery;

@end
