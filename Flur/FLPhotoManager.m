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
             [userPhoto setObject:flurObjectId forKey:@"pinId"];
     
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

- (void) uploadPhotoWithData:(NSData *)imageData forExistingFlur:(FLPin *)pin withCompletion:(void (^)())completion {
    
    [self uploadPhotoWithData:imageData withFlurObjectId:pin.pinId withCompletion:^{
        // Increment content count on server
        pin.contentCount++;
        PFObject* flurPin = [PFObject objectWithoutDataWithClassName:@"FlurPin" objectId:pin.pinId];
        [flurPin incrementKey:@"contentCount"];
        [flurPin save];
        
        // Add this flur to LOCAL copy of flurs I have contributed to
        NSMutableDictionary* flur = [[NSMutableDictionary alloc]init];
        flur[@"prompt"] = pin.prompt;
        flur[@"lat"] = [NSNumber numberWithDouble:pin.coordinate.latitude];
        flur[@"lng"] = [NSNumber numberWithDouble:pin.coordinate.longitude];
        flur[@"objectId"] = pin.pinId;
        flur[@"totalContentCount"] = [NSNumber numberWithInt:pin.contentCount];
        flur[@"myContentPosition"] = [NSNumber numberWithInt:pin.contentCount];
        flur[@"dateCreated"] = pin.dateCreated;
        flur[@"dateCreated"] = [NSDate date];
        
        NSDate *date = [NSDate date];
        flur[@"dateAdded"] = date;
        [flur setObject:[PFUser currentUser].username forKey:@"creatorUsername"];
        
        [LocalStorage addFlur:flur];
 
    }];
}

- (void) uploadPhotoWithData:(NSData *)imageData forNewFlur:(FLPin *)pin withCompletion:(void (^)())completion {
    
}

- (void) loadPhotosWithPin:(FLPin *)pin withCompletion:(void (^)(NSMutableArray* allPhotos))completion {
    NSMutableArray* allPhotos = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Images"];
    [query whereKey:@"pinId" equalTo:pin.pinId];
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
