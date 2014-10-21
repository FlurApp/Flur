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


@interface FLFlurAnnotation : NSObject<MKAnnotation>

/*- (FLFlurAnnotation *)initWithTitle:(NSString *)title prompt:(NSString *)prompt coordinate:(CLLocationCoordinate2D*)coordinate;

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;*/

- (id)initWithObject:(PFGeoPoint*) location;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@end
