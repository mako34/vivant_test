//
//  Gallery.h
//  Vivant_1
//
//  Created by Manuel Betancurt on 26/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PieceOfArt;

@interface Gallery : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * suburb;
@property (nonatomic, retain) NSNumber * postcode;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * idRef;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * piecesArt;
@property (nonatomic, retain) NSSet *pieceOfArt;
@end

@interface Gallery (CoreDataGeneratedAccessors)

- (void)addPieceOfArtObject:(PieceOfArt *)value;
- (void)removePieceOfArtObject:(PieceOfArt *)value;
- (void)addPieceOfArt:(NSSet *)values;
- (void)removePieceOfArt:(NSSet *)values;

@end
