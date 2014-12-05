//
//  FLPhotoManager.m
//  Flur
//
//  Created by Netanel Rubin on 11/5/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Parse/Parse.h>
#import "FLPhotoManager.h"
#import "Flur.h"
#import "LocalStorage.h"

@implementation FLPhotoManager

- (void) uploadPhotoWithData:(NSData*)imageData withFlurObjectId:(NSString *)flurObjectId withCompletion:(void(^)()) completion {
    PFFile *imageFile = [PFFile fileWithName:@"t.gif" data:imageData];

    // Save PFFile
     [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (!error) {
             PFObject *userPhoto = [PFObject objectWithClassName:@"Images"];
             [userPhoto setObject:imageFile forKey:@"imageFile"];
             PFObject * flurPin = [PFObject objectWithoutDataWithClassName:@"FlurPin"
                                                                  objectId:flurObjectId];

             [userPhoto setObject:flurPin forKey:@"flurPin"];
             [userPhoto setObject:[PFUser currentUser] forKey:@"createdBy"];
             [userPhoto setObject:@33 forKey:@"contributionPosition"];
             NSLog(@"Need to fix uploadPhoto to incorporate contribute position");


     
             [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 if (error) {
                     // Log details of the failure
                     NSLog(@"Error: %@ %@", error, [error userInfo]);
                 }
                 else {
                     completion();
                 }
             }];
         }
         else{
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         
     } progressBlock:^(int percentDone) {
     // Update your progress spinner here. percentDone will be between 0 and 100.
     //HUD.progress = (float)percentDone/100;
     }];

}

- (void) uploadPhotoWithData:(NSData *)imageData forExistingFlur:(FLPin *)pin withServerCompletion:(void (^)())serverCompletion WithCoreDataCompletion:(void (^)())coreDataCompletion{
    
    [self uploadPhotoWithData:imageData withFlurObjectId:pin.pinId withCompletion:^{
        // Increment content count on server
        PFObject* flurPin = [PFObject objectWithoutDataWithClassName:@"FlurPin" objectId:pin.pinId];
        [flurPin incrementKey:@"totalContentCount"];
        [flurPin save];
        serverCompletion();
    }];
    
    // Add this flur to LOCAL copy of flurs I have contributed to
    NSMutableDictionary* flur = [[NSMutableDictionary alloc]init];
    
    flur[@"objectId"] = pin.pinId;
    flur[@"prompt"] = pin.prompt;
    
    flur[@"lat"] = [NSNumber numberWithDouble:pin.coordinate.latitude];
    flur[@"lng"] = [NSNumber numberWithDouble:pin.coordinate.longitude];
    
    pin.totalContentCount++;
    flur[@"totalContentCount"] = [NSNumber numberWithInt:pin.totalContentCount];
    flur[@"myContentPosition"] = [NSNumber numberWithInt:pin.totalContentCount];
    
    NSDate *date = [NSDate date];
    flur[@"dateAdded"] = date;
    flur[@"dateCreated"] = pin.dateCreated;
    
    flur[@"creatorUsername"] = pin.createdBy.username;
    
    [flur setObject:pin.createdBy.username forKey:@"creatorUsername"];
    
    NSLog(@"About to save flur in Photo Manager");
    [LocalStorage addFlur:flur withCompletion:coreDataCompletion];

}

- (void) uploadPhotoWithData:(NSData *)imageData forNewFlur:(FLPin *)pin withServerCompletion:(void (^)())serverCompletion WithCoreDataCompletion:(void (^)())coreDataCompletion{

    PFObject *flurPin = [PFObject objectWithClassName:@"FlurPin"];
    
    [flurPin setObject:pin.coordinate forKey:@"location"];
    [flurPin setObject: [PFUser currentUser]forKey:@"createdBy"];
    [flurPin setObject:pin.prompt forKey: @"prompt"];
    [flurPin setObject:@1 forKey:@"totalContentCount"];
    
    [flurPin saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            pin.pinId = [flurPin objectId];
            pin.createdBy = [PFUser currentUser];
            pin.dateCreated = [NSDate date];
            pin.totalContentCount = 1;
            pin.haveContributedTo = true;
        
            // Add image to server
            [self uploadPhotoWithData:imageData withFlurObjectId:[flurPin objectId] withCompletion:^{
                serverCompletion();
            }];
            
            // Add this flur to LOCAL copy of flurs I have contributed to
            NSMutableDictionary* flur = [[NSMutableDictionary alloc]init];
            
            flur[@"objectId"] = [flurPin objectId];
            flur[@"prompt"] = pin.prompt;
            
            flur[@"lat"] = [NSNumber numberWithDouble:pin.coordinate.latitude];
            flur[@"lng"] = [NSNumber numberWithDouble:pin.coordinate.longitude];
            
            flur[@"totalContentCount"] = @1;
            flur[@"myContentPosition"] = @1;
            
            flur[@"dateCreated"] = [NSDate date];
            flur[@"dateAdded"] = [NSDate date];
            
            flur[@"creatorUsername"] = [PFUser currentUser].username;
            
            [flur setObject:[PFUser currentUser].username forKey:@"creatorUsername"];
            [LocalStorage addFlur:flur withCompletion:^{
                coreDataCompletion();
            }];
            
        }
    }];
    
}

- (void) loadPhotosWithPin:(NSString *)flurPinObjectId withCompletion:(void (^)(NSMutableArray* allPhotos))completion {
    NSMutableArray* allPhotos = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Images"];
    
    PFObject * flurPin = [PFObject objectWithoutDataWithClassName:@"FlurPin"
                                                         objectId:flurPinObjectId];

    [query whereKey:@"flurPin" equalTo:flurPin];
    [query orderByAscending:@"createdAt"];

    // Run query to download all relevant photos
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {

            // Iterate over all objects and download corresponding data
            int i = 0;
            if (objects.count == 0)
                completion(allPhotos);


            for (PFObject *object in objects) {
                i++;
                PFFile *imageFile = [object objectForKey:@"imageFile"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        [allPhotos addObject:data];
                    }
                    else {
                        NSLog(@"fack me");
                    }

                    if (i == objects.count) {
                        NSLog(@"ready to go");
                        completion(allPhotos);
                    }
                    
                }];
            }
        }
    }];

}

@end
