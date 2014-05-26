//
//  GalleryDetailViewController.m
//  Vivant_1
//
//  Created by Manuel Betancurt on 26/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//

#import "GalleryDetailViewController.h"
#import "PieceOfArtViewController.h"

@interface GalleryDetailViewController ()
@property (nonatomic, strong)Gallery *gallery;
@property (nonatomic, strong)PieceOfArt *pieceOfArt;
@property (nonatomic, strong)NSArray *itemsArraya;
@end

@implementation GalleryDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithGallery:(Gallery*)gallery
{
    self = [super init];
    if (self) {
        self.gallery = gallery;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.gallery.suburb;
    self.addressLabel.text = self.gallery.address;
    self.suburbLabel.text = self.gallery.suburb;
    self.stateLabel.text = self.gallery.state;
    
    self.galleryDetailTable.dataSource = self;
    self.galleryDetailTable.delegate = self;
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"gallery = %@",self.gallery];
    self.itemsArraya = [PieceOfArt MR_findAllWithPredicate:predicate];
 
    [self initSourceTable];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self initSourceTable];
}

- (void)initSourceTable
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"gallery = %@",self.gallery];
    self.itemsArraya = [PieceOfArt MR_findAllWithPredicate:predicate];
    [self.galleryDetailTable reloadData];
}

#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArraya.count;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HistoryCell";
    
    UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
 
    
    PieceOfArt *pieceObj = [self.itemsArraya objectAtIndex:indexPath.row];
    NSString *titleMessage = [NSString stringWithFormat:@"%d. %@" , indexPath.row +1, pieceObj.name];
    
    if (pieceObj.name == nil) {
        titleMessage = @"Please set a title for the piece";
    }
    
    cell.textLabel.text = titleMessage;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", pieceObj.rate];
    
    return cell;
}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PieceOfArtViewController *pieceVC = [[PieceOfArtViewController alloc]initWithPieceOfArt:[self.itemsArraya objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:pieceVC animated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
