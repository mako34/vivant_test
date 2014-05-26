//
//  ListGalleryViewController.m
//  Vivant_1
//
//  Created by Manuel Betancurt on 26/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//

#import "ListGalleryViewController.h"
#import "Gallery.h"
#import "GalleryDetailViewController.h"

@interface ListGalleryViewController ()
@property (nonatomic, strong)NSArray *galleriesArray;
@end

@implementation ListGalleryViewController

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
    
    self.title = @"Galleries List";

    self.galleryTable.delegate = self;
    self.galleryTable.dataSource = self;
    
    self.galleriesArray = [Gallery MR_findAllSortedBy:@"suburb" ascending:YES];
    
    [self.galleryTable reloadData];
}

#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return self.galleriesArray.count;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HistoryCell";
    
    // Similar to UITableViewCell, but
    UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    // Just want to test, so I hardcode the data
    
    Gallery *galleryObj = [self.galleriesArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = galleryObj.suburb;
    cell.detailTextLabel.text = galleryObj.address;
    
    return cell;
}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GalleryDetailViewController *gVC = [[GalleryDetailViewController alloc]
                                        initWithGallery:[self.galleriesArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:gVC animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
