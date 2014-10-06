//
//  FLFlurAnnotation.h
//  Flur
//
//  Created by Lily Hashemi on 10/5/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FLFlurAnnotation : NSObject<MKAnnotation>

- (FLFlurAnnotation *)initWithTitle:(NSString *)title prompt:(NSString *)prompt coordinate:(CLLocationCoordinate2D*)coordinate;

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;


@end
