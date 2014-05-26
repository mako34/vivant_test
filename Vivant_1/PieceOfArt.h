//
//  PieceOfArt.h
//  Vivant_1
//
//  Created by Manuel Betancurt on 26/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Gallery;

@interface PieceOfArt : NSManagedObject

@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Gallery *gallery;

@end
