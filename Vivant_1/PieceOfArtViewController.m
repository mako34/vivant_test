//
//  PieceOfArtViewController.m
//  Vivant_1
//
//  Created by Manuel Betancurt on 27/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//

#import "PieceOfArtViewController.h"

@interface PieceOfArtViewController ()
@property (nonatomic, strong)PieceOfArt *piece;
@end

@implementation PieceOfArtViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)saveButtonPressed:(id)sender {
    [self performSave];
}

- (id)initWithPieceOfArt:(PieceOfArt*)piece
{
    self = [super init];
    if (self) {
        self.piece = piece;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Piece of Art";
    
    self.pieceTitle.keyboardType = UIKeyboardTypeAlphabet;
    self.pieceScore.keyboardType = UIKeyboardTypeNumberPad;
 
}

 
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self performSave];
    }
    [super viewWillDisappear:animated];
}
-(void) performSave {
    
    
    //save
    
    //PieceOfArt *pieceInsert = [PieceOfArt MR_createEntity];
    
    
    BOOL saveTransaction = NO;
    
    if (self.pieceTitle.text.length > 0) {
        self.piece.name = self.pieceTitle.text;
        saveTransaction = YES;
    }
    if (self.pieceScore.text.length > 0) {
        self.piece.rate = [NSNumber numberWithInt:[self.pieceScore.text intValue]];
        saveTransaction = YES;
    }
 
    
    if (saveTransaction) {
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
