//
//  ListGalleryViewController.h
//  Vivant_1
//
//  Created by Manuel Betancurt on 26/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListGalleryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *galleryTable;

@end
