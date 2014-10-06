//
//  FLFlurAnnotation.m
//  Flur
//
//  Created by Lily Hashemi on 10/5/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import "FLFlurAnnotation.h"

@interface FLFlurAnnotation ()

@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *prompt;

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

@implementation FLFlurAnnotation


- (FLFlurAnnotation *)initWithTitle:(NSString *)title prompt:(NSString *)prompt coordinate:(CLLocationCoordinate2D *)coordinate
{    
    if (self = [[FLFlurAnnotation alloc] init]) {
        [self setPlaceName:title];
        [self setPrompt:prompt];
        [self setCoordinate:*coordinate];
        
    }
    else {
        NSLog(@"DIDN'T ALLOC INIT IN ANNOTATION");
    }
    
    return self;
}

- (NSString *)title
{
    return self.placeName;
}

- (NSString *)subtitle
{
    return self.prompt;
}


+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *returnedAnnotationView =
    	[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([FLFlurAnnotation class])];
    
    if (returnedAnnotationView == nil)
    {
        returnedAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([FLFlurAnnotation class])];
        
        returnedAnnotationView.canShowCallout = YES;
        
    }
    else
    {
        returnedAnnotationView.annotation = annotation;
    }
    
    return returnedAnnotationView;
}


@end
