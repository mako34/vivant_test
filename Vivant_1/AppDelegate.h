//
//  AppDelegate.h
//  Vivant_1
//
//  Created by Manuel Betancurt on 24/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) UITabBarController *tabBars;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
