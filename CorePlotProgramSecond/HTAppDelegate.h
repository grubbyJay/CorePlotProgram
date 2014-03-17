//
//  HTAppDelegate.h
//  CorePlotProgramSecond
//
//  Created by wb-shangguanhaitao on 14-2-26.
//  Copyright (c) 2014年 shangguan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
