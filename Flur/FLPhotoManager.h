//
//  FLPhotoManager.h
//  Flur
//
//  Created by Netanel Rubin on 11/5/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLPin.h"

@interface FLPhotoManager : NSObject

- (void) loadPhotosWithPin:(FLPin *)pin withCompletion:(void (^)(NSMutableArray* allPhotos))completion;

- (void) uploadPhotoWithData:(NSData*)imageData withFlurObjectId:(NSString *)flurObjectId withCompletion:(void(^)()) completion;

- (void) uploadPhotoWithData:(NSData *)imageData forExistingFlur:(FLPin *)pin withCompletion:(void (^)())completion;

@end
