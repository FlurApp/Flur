//
//  LocalStorage.m
//  Flur
//
//  Created by Netanel Rubin on 11/8/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

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

+ (void) destroyLocalStorage {
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    
    NSString* documentName = @"MyDocument";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];

    [[NSFileManager defaultManager] removeItemAtPath:url.path error:&error];
    NSLog(@"error : %@", error);
}

+ (void) syncWithServer {
    
    PFUser* curUser = [PFUser currentUser];
    if (!curUser) {
        NSLog(@"Error: Trying to sync with server in LocalStorage.m but not logged.");
        return;
    }
    
    // Set up inner query so that the User pointer points to the local users account
    PFQuery *innerQuery = [PFQuery queryWithClassName:@"_User"];
    [innerQuery whereKey:@"username" equalTo:curUser.username];
    
    // Find all images that have been added by the local user
    PFQuery *query = [PFQuery queryWithClassName:@"Images"];
    [query whereKey:@"createdBy" matchesQuery:innerQuery];
    [query includeKey:@"flurPin"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *imagesContributed, NSError *error) {
        if (!error) {
            NSMutableDictionary *localStorageFlurData = [[NSMutableDictionary alloc] init];
            NSMutableArray *flurObjectIds = [[NSMutableArray alloc] init];

            for (id image in imagesContributed) {
                PFObject *flurContributedTo = image[@"flurPin"];

                if ([localStorageFlurData objectForKey:flurContributedTo[@"objectId"]] == nil) {
                    NSMutableDictionary *flurToAdd = [[NSMutableDictionary alloc] init];
                    
                    flurToAdd[@"objectId"] = [flurContributedTo objectId];
                    flurToAdd[@"prompt"] = flurContributedTo[@"prompt"];
                    
                    PFGeoPoint *location =((PFGeoPoint *)flurContributedTo[@"location"]);
                    flurToAdd[@"lat"] = [NSNumber numberWithDouble:location.latitude];
                    flurToAdd[@"lng"] = [NSNumber numberWithDouble:location.longitude];
                    
                    flurToAdd[@"numContributions"] = flurContributedTo[@"contentCount"];

                    flurToAdd[@"dateCreated"] = [flurContributedTo createdAt];
                    flurToAdd[@"dateAdded"] = [image createdAt];

                    [localStorageFlurData setObject:flurToAdd forKey:[flurContributedTo objectId]];
                    [flurObjectIds addObject:[flurContributedTo objectId]];
                }
            }
            
            PFQuery *query2 = [PFQuery queryWithClassName:@"FlurPin"];
            [query2 whereKey:@"objectId" containedIn:[NSArray arrayWithArray:flurObjectIds]];
            [query2 includeKey:@"createdBy"];
            [query2 selectKeys:@[@"createdBy", @"objectId"]];
                                                                                                                                                                                                                                        

            [query2 findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
                for (id user in users) {
                    NSMutableDictionary *flurToAdd = [localStorageFlurData objectForKey:[user objectId]];
                    NSString *creatorUsername = user[@"createdBy"][@"username"];
                    flurToAdd[@"creatorUsername"] = creatorUsername;
                }
                
                for (id key in localStorageFlurData) {
                    [LocalStorage addFlur:[localStorageFlurData objectForKey:key]];
                }
                
            }];
            //flurToAdd[@"creatorUsername"] = flurContributedTo[@"creatorUsername"];


            
                //[LocalStorage openDocumentWithCompletion:^{
                    /*Flur* flur = [NSEntityDescription insertNewObjectForEntityForName:@"Flur"
                                                               inManagedObjectContext:document.managedObjectContext];
                    flur.prompt = flurContributedTo[@"prompt"];
                    
                    PFGeoPoint *location =((PFGeoPoint *)flurContributedTo[@"location"]);

                    flur.lng = [NSNumber numberWithDouble:location.longitude];
                    flur.lat = [NSNumber numberWithDouble:location.latitude];
                    
                    flur.numContributions = flurContributedTo[@"contentCount"];
                    flur.objectId = flurContributedTo[@"objectId"];
                    
                    flur.creatorUsername = flurContributedTo[@"creatorUsername"];
                    flur.dateAdded = flurContributedTo[@"dateAdded"];
                    flur.dateCreated = flurContributedTo[@"dateCreated"];
                    
                    
                    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
                        NSLog(@"saved");
                    }];
                    
                    NSLog(@"lat: %@", flurContributedTo[@"location"]);
                    NSLog(@"asdf: %f", f.latitude);
                    NSLog(@"lat: %@", ((PFGeoPoint *)flurContributedTo[@"location"]).latitude);*/
                    
                
                
                //}];
        }
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

+ (void) getFlursInDict:(void(^)(NSMutableDictionary*)) completion {
    [LocalStorage getFlurs:^(NSMutableDictionary *data)  {
        NSArray* allFlurs = [data objectForKey:@"allFlurs"];
        NSMutableDictionary* allFlursHashed = [[NSMutableDictionary alloc] init];
        for (int i=0; i<allFlurs.count; i++)
            allFlursHashed[((Flur*)allFlurs[i]).objectId] = allFlurs[i];
        completion(allFlursHashed);
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
        
        return;
        
        Flur* flur = [NSEntityDescription insertNewObjectForEntityForName:@"Flur"
                                                   inManagedObjectContext:document.managedObjectContext];
        flur.prompt = flurToAdd[@"prompt"];
        flur.lng = flurToAdd[@"lng"];
        flur.lat = flurToAdd[@"lat"];
        flur.numContributions = flurToAdd[@"numContributions"];
        flur.objectId = flurToAdd[@"objectId"];
        flur.creatorUsername = flurToAdd[@"creatorUsername"];
        flur.dateAdded = flurToAdd[@"dateAdded"];
        flur.dateCreated = flurToAdd[@"dateCreated"];


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

+ (void) createTestData {
    NSMutableDictionary *flur1 = [[NSMutableDictionary alloc] init];
    [flur1 setObject:@"Nikki is awesome" forKey:@"prompt"];
    [flur1 setObject:@"9hCC7XSqj1" forKey:@"objectId"];
    [flur1 setObject:[NSNumber numberWithDouble:42.27855013634855] forKey:@"lat"];
    [flur1 setObject:[NSNumber numberWithDouble:-83.74086164719826] forKey:@"lng"];
    [flur1 setObject:[NSNumber numberWithInt:9] forKey:@"numContributions"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    
    NSDate *dateCreated1 = [dateFormatter dateFromString: @"2012-09-16 23:59:59 JST"];
    [flur1 setObject:dateCreated1 forKey:@"dateAdded"];
    
    NSDate *dateAdded1 = [dateFormatter dateFromString: @"2012-09-20 23:59:59 JST"];
    [flur1 setObject:dateAdded1 forKey:@"dateCreated"];
    [flur1 setObject:@"petebes" forKey:@"creatorUsername"];

    
    [self addFlur:flur1];
    
    
    NSMutableDictionary *flur2 = [[NSMutableDictionary alloc] init];
    [flur2 setObject:@"Take a picture of your inspiration!" forKey:@"prompt"];
    [flur2 setObject:@"yh1ej5UCQ4" forKey:@"objectId"];
    [flur2 setObject:[NSNumber numberWithDouble:42.28902135362213] forKey:@"lat"];
    [flur2 setObject:[NSNumber numberWithDouble:-83.71347471014678] forKey:@"lng"];
    [flur2 setObject:[NSNumber numberWithInt:11] forKey:@"numContributions"];
    
    dateCreated1 = [dateFormatter dateFromString: @"2012-11-3 23:59:59 JST"];
    [flur2 setObject:dateCreated1 forKey:@"dateAdded"];
    
    dateAdded1 = [dateFormatter dateFromString: @"2012-11-16 23:59:59 JST"];
    [flur2 setObject:dateAdded1 forKey:@"dateCreated"];

    [flur2 setObject:@"joly" forKey:@"creatorUsername"];

    
    [self addFlur:flur2];
    
    
    NSMutableDictionary *flur3 = [[NSMutableDictionary alloc] init];
    [flur3 setObject:@"What's the weirdest thing you've seen at the UGLI today?" forKey:@"prompt"];
    //[flur3 setObject:@"P94Sa0RpoS" forKey:@"objectId"];
    [flur3 setObject:@"c8kzGmjHaU" forKey:@"objectId"];

    [flur3 setObject:[NSNumber numberWithDouble:42.275403] forKey:@"lat"];
    [flur3 setObject:[NSNumber numberWithDouble:-83.737254] forKey:@"lng"];
    [flur3 setObject:[NSNumber numberWithInt:16] forKey:@"numContributions"];
    
    dateCreated1 = [dateFormatter dateFromString: @"2013-3-22 23:59:59 JST"];
    [flur3 setObject:dateCreated1 forKey:@"dateAdded"];
    
    dateAdded1 = [dateFormatter dateFromString: @"2013-3-29 23:59:59 JST"];
    [flur3 setObject:dateCreated1 forKey:@"dateCreated"];
    
    [flur3 setObject:@"davmlee" forKey:@"creatorUsername"];
    
    [self addFlur:flur3];
}


@end
