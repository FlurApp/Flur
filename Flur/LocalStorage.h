//
//  LocalStorage.h
//  Flur
//
//  Created by Netanel Rubin on 11/8/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface LocalStorage : NSObject

+ (void) openDocumentWithCompletion:(void(^)())completion;
+ (void) loadCurrentUser:(void(^)(NSMutableDictionary*)) completion;
+ (void) getUserFound:(void(^)(bool))completion;

@end
