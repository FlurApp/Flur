//
//  LocalStorage.h
//  Flur
//
//  Created by Netanel Rubin on 11/8/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Flur.h"

@interface LocalStorage : NSObject

// + (void) openDocumentWithCompletion:(void(^)())completion;
+ (void) destroyLocalStorage;

+ (void) loadCurrentUser:(void(^)(NSMutableDictionary*)) completion;
+ (void) getUserFound:(void(^)(bool))completion;

+ (void) getFlurs:(void(^)(NSMutableDictionary*)) completion;
+ (void) getFlursInDict:(void(^)(NSMutableDictionary*)) completion;
+ (void) addFlur:(NSMutableDictionary*)flurToAdd;
+ (void) deleteAllFlurs;

+ (void) syncWithServer:(void(^)()) completion;

+ (void) createTestData;

@end
