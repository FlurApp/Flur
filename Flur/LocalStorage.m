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
#import "Flur.h"


@implementation LocalStorage

static UIManagedDocument * document;
static bool documentLoaded = false;
static bool userFound = false;

+ (void) getUserFound:(void(^)(bool))completion {
    [LocalStorage loadCurrentUser:^(NSMutableDictionary *data) {
        completion(data.count == 1);
    }];
}


+ (void) openDocumentWithCompletion:(void(^)())completion {
    if (documentLoaded) {
        completion();
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    
    NSString* documentName = @"MyDocument";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                documentLoaded = true;
                completion();
            }
                
            if (!success) NSLog(@"couldn’t open document at %@", url);
        }]; } else {
            [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
                   completionHandler:^(BOOL success) {
                       if (success) {
                           documentLoaded = true;
                           completion();
                       }
                       if (!success) NSLog(@"couldn’t create document at %@", url);
                   }];
        }
}

+ (void) loadCurrentUser:(void(^)(NSMutableDictionary*)) completion {
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [LocalStorage openDocumentWithCompletion:^ {
        if (documentLoaded) {
            User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                 inManagedObjectContext:document.managedObjectContext];
            [data setObject:user forKey:@"USER"];
            completion(data);
        }
        else {
            completion(data);
        }
    }];
}

+ (void) getFlurs:(void(^)(NSMutableDictionary*)) completion {
    [LocalStorage openDocumentWithCompletion:^ {
        if (documentLoaded) {
            NSManagedObjectContext *context = document.managedObjectContext;
            
            
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Flur"];
            //request.fetchBatchSize = 1;
            //request.fetchLimit = 1;
            
            NSError *error;
            NSArray *allFlurs = [context executeFetchRequest:request error:&error];
            if (!allFlurs) {
                NSLog(@"Error loading flurs");
            }
            else {
                //NSLog(@"Size %lu", allFlurs.count);
               // for (Flur* obj in allFlurs)
               // [document.managedObjectContext deleteObject:obj];
                
                NSMutableDictionary* data = [[NSMutableDictionary alloc ] init];
                [data setObject:allFlurs forKey:@"allFlurs"];
                completion(data);
            }
        }
        else {
        }
    }];
}

+ (void) addFlur:(NSMutableDictionary*)flurToAdd {
    [LocalStorage getFlurs:^(NSMutableDictionary *allFlurs) {
        for (Flur* flur in [allFlurs objectForKey:@"allFlurs"]) {
            if ([flur.objectId isEqualToString:flurToAdd[@"objectId"]]) {
                NSLog(@"Flur with this object ID already exists, not adding");
                return;
            }
        }
        
        NSLog(@"Adding flur to DB");
        Flur* flur = [NSEntityDescription insertNewObjectForEntityForName:@"Flur"
                                                   inManagedObjectContext:document.managedObjectContext];
        flur.prompt = flurToAdd[@"prompt"];
        flur.lng = flurToAdd[@"lng"];
        flur.lat = flurToAdd[@"lat"];
        flur.numContributions = flurToAdd[@"numContributions"];
        flur.objectId = flurToAdd[@"objectId"];
        
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            NSLog(@"saved");
        }];
    }];
}

+ (void) deleteAllFlurs {
   /* [LocalStorage getFlurs:^(NSMutableDictionary *allFlurs) {
        for (Flur* flur in [allFlurs objectForKey:@"allFlurs"]) {
            NSLog(@"Deleting object");
            [document.managedObjectContext deleteObject:flur];
        }
    }];*/
    
        [LocalStorage openDocumentWithCompletion:^ {
            if (documentLoaded) {
                NSManagedObjectContext *context = document.managedObjectContext;
                
                
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Flur"];
                //request.fetchBatchSize = 1;
                //request.fetchLimit = 1;
                
                NSError *error;
                NSArray *allFlurs = [context executeFetchRequest:request error:&error];
                if (!allFlurs) {
                    NSLog(@"Error loading flurs");
                }
                else {
                    NSLog(@"Size %lu", allFlurs.count);
                     for (Flur* obj in allFlurs)
                     [document.managedObjectContext deleteObject:obj];
                    
                    //NSMutableDictionary* data = [[NSMutableDictionary alloc ] init];
                   // [data setObject:allFlurs forKey:@"allFlurs"];
                }
            }
            else {
            }
        }];
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
