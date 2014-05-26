//
//  AppDelegate.m
//  Vivant_1
//
//  Created by Manuel Betancurt on 24/05/2014.
//  Copyright (c) 2014 Manuel Betancurt. All rights reserved.
//

#import "AppDelegate.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "Gallery.h"
#import <iOS-Hierarchy-Viewer/iOSHierarchyViewer.h>
#import "ListGalleryViewController.h"
#import "MapGalleryViewController.h"
#import "PieceOfArt.h"
 

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"MyDatabase.sqlite"];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.tabBars = [[UITabBarController alloc] init];
 
    
    MapGalleryViewController *galleryVC = [[MapGalleryViewController alloc]init];
    UINavigationController *galleryNav=[[UINavigationController alloc]initWithRootViewController:galleryVC];
    
    ListGalleryViewController *listVC = [[ListGalleryViewController alloc]init];
    UINavigationController *listNav=[[UINavigationController alloc]initWithRootViewController:listVC];
    listNav.tabBarItem.title=@"Gallery List";
    
    NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:5];
    [localViewControllersArray addObject:galleryNav];
    [localViewControllersArray addObject:listNav];

    self.tabBars.viewControllers = localViewControllersArray;

    [self.window setRootViewController:self.tabBars];

    
    //[self.window setRootViewController:mainVC];
    
    [self.window makeKeyAndVisible];
    
    [self getGalleries];
    
    [galleryVC showSplash];
    

    
    return YES;
}

- (void)getGalleries
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.vivant.com.au/tmp/"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"http://www.vivant.com.au/tmp/galleries.json"
                                                      parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        
        
        [self saveGalleriesToCD:dict];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
}

- (void)saveGalleriesToCD:(NSDictionary*)dicto
{
    
    [Gallery MR_truncateAll];
    [PieceOfArt MR_truncateAll];
    
    NSArray *galleries = [dicto objectForKey:@"galleries"];

    for (NSDictionary *dataDicto in galleries) {
        
        Gallery *galleryInsert = [Gallery MR_createEntity];
        galleryInsert.address = [dataDicto objectForKey:@"address"];
        galleryInsert.idRef = @([[dataDicto objectForKey:@"id"]intValue]);
        galleryInsert.lat = @([[dataDicto objectForKey:@"lat"]floatValue]);
        galleryInsert.lon = @([[dataDicto objectForKey:@"lon"]floatValue]);
        galleryInsert.postcode = @([[dataDicto objectForKey:@"postcode"]intValue]);
        galleryInsert.state = [dataDicto objectForKey:@"state"];
        galleryInsert.suburb = [dataDicto objectForKey:@"suburb"];
 
        
        NSInteger piecesOfArt =  [[dataDicto objectForKey:@"piecesofart"]intValue];
        
        for (int i=0; i<piecesOfArt; i++) {
            PieceOfArt *pieceOfArtInsert = [PieceOfArt MR_createEntity];
            pieceOfArtInsert.gallery = galleryInsert;
        }
        
        
     }
    
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
 
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
#ifdef DEBUG
    [iOSHierarchyViewer start];
    
    // Enable for viewing of core data
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [iOSHierarchyViewer addContext:localContext name:@"Root managed context"];
#endif
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
    [MagicalRecord cleanUp];

}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Vivant_1" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Vivant_1.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
