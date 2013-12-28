//
//  AppDelegate.h
//  AgentAssistant
//
//  Created by Lubos Hrasko on 2012-08-29.
//  Copyright (c) 2012 WhiteRockLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingsViewController.h"

// stackmob
@class SMClient;
@class SMCoreDataStore;
//

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectModel *managedObjectModel_sql;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *managedObjectContext_sql;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    ListingsViewController *listingsViewController;
    bool useSqlLite;
}

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel_sql;
@property (strong, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, retain, readonly) NSManagedObjectContext *managedObjectContext_sql;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) bool useSqlLite;

// Stackmob
@property (strong, nonatomic) SMCoreDataStore *coreDataStore;
@property (strong, nonatomic) SMClient *client;
//


- (NSString *)applicationDocumentsDirectory;

@property (strong, nonatomic) UIWindow *window;

@end
