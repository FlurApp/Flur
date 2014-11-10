//
//  LocalStorage.m
//  Flur
//
//  Created by Netanel Rubin on 11/8/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

#import "LocalStorage.h"
#import "User.h"


@implementation LocalStorage

static UIManagedDocument * document;
static bool documentLoaded = false;
static bool userFound = false;

+ (BOOL) getUserFound {
    return userFound;
}


+ (void) openDocument {
    if (documentLoaded)
        return;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    
    NSString* documentName = @"MyDocument";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success)
                
            if (!success) NSLog(@"couldn’t open document at %@", url);
        }]; } else {
            [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
                   completionHandler:^(BOOL success) {
                       if (success) {
                           documentLoaded = true;
                           [self documentIsReady];
                       }
                       if (!success) NSLog(@"couldn’t create document at %@", url);
                   }];
        }
}

+ (User*) loadCurrentUser {
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                inManagedObjectContext:document.managedObjectContext];
    return user;
}

+ (void) saveCurrentUser {
    
}


+ (void) documentIsReady {
    NSLog(@"HELOOOO");
    if (document.documentState == UIDocumentStateNormal) { // start using document
        
        NSManagedObjectContext *context = document.managedObjectContext;

        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        request.fetchBatchSize = 1;
        request.fetchLimit = 1;
        
        NSError *error;
        NSArray *users = [context executeFetchRequest:request error:&error];
        if (!users) {
            NSLog(@"Error loading user");
        }
        else {
            if (users.count == 1) {
                NSLog(@"we have a user");
                userFound = true;
            }
            else {
                NSLog(@"Could not find any user");
            }
            //[self.document.managedObjectContext deleteObject:users[0]];
            //users = nil;
        }
    }
}



@end
