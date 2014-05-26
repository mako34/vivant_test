//
//  PieceOfArtViewController.h
//  Vivant_1
//
//  Created by Manuel Betancurt on 27/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieceOfArt.h"

@interface PieceOfArtViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UITextField *pieceTitle;
@property (weak, nonatomic) IBOutlet UITextField *pieceScore;
- (IBAction)saveButtonPressed:(id)sender;

- (id)initWithPieceOfArt:(PieceOfArt*)piece;

@end
