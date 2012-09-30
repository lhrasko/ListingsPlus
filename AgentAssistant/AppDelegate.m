//
//  AppDelegate.m
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-29.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import "AppDelegate.h"
#import "ListingsViewController.h"
#import "Listing.h"
#import "Appirater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Appirater setAppId:@"566802084"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:2];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    
    // OPTION 1
    
    //UITabBarController *rootViewController;
    //UINavigationController *navigationController;
    //ListingsViewController *listingsViewController;
    
    // Get the root window (UITabBarController)
    //rootViewController = (UITabBarController *)self.window.rootViewController;
    
    
    // Get the second item of the UITabBarController
    //navigationController = [[rootViewController viewControllers] objectAtIndex:0];
    
    // Get the first item of the UINavigationController (ItemsTableViewController)
    //listingsViewController = [[navigationController viewControllers] objectAtIndex:0];
    //listingsViewController.managedObjectContext = self.managedObjectContext;
    
    
    /// OPTION 2
    
    
    
    // Get the third item of the UITabBarController (again ItemsTableViewController)
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    // Get the first item of the UINavigationController (ItemsTableViewController)
    ListingsViewController *firstViewController = (ListingsViewController *)[navigationController topViewController];
    firstViewController.managedObjectContext = self.managedObjectContext;
    
    [navigationController.navigationBar setTintColor:[UIColor colorWithRed:55.0f/255.0f green:95.0f/255.0f blue:18.0f/255.0f alpha:1]];

    [Appirater appLaunched:YES];
    
    return YES;
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
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



//Explicitly write Core Data accessors
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
        
        //Undo Support
        NSUndoManager *anUndoManager = [[NSUndoManager  alloc] init];
        [managedObjectContext setUndoManager:anUndoManager];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"ListingsPlus.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:options error:&error]) {
        /*Error for store creation should be handled in here*/
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
