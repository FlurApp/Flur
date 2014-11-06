//
//  FLPhotoManager.h
//  Flur
//
//  Created by Netanel Rubin on 11/5/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLPin.h"

@interface FLPhotoManager : NSObject

- (void) uploadPhotoWithData : (NSData*) imageData withPin:(FLPin*) pin withCompletion:(void (^)()) completion;
- (void) loadPhotosWithPin:(FLPin *)pin withCompletion:(void (^)(NSMutableArray* allPhotos))completion;

@end
