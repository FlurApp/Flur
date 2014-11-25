//
//  FLFlurAnnotation.h
//  Flur
//
//  Created by Lily Hashemi on 10/5/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "FLPin.h"


@interface FLFlurAnnotation : NSObject<MKAnnotation>

//+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;

- (id)initWithPin:(FLPin*) pin;
- (MKAnnotationView*) annotationView;
- (NSString *) description;

- (void) showAnnotationAsOpenable:(MKAnnotationView *) annotationViewFromMap;
- (void) showAnnotationAsNonOpenable:(MKAnnotationView *) annotationViewFromMap;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, strong) FLPin* pin;

//@property (nonatomic) NSString *pinId;
//@property (nonatomic) bool isAnimated;


@end
