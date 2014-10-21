//
//  FLFlurAnnotation.m
//  Flur
//
//  Created by Lily Hashemi on 10/5/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import "FLFlurAnnotation.h"

@interface FLFlurAnnotation ()

/*@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *prompt;

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;*/
@property (nonatomic, strong) PFObject *object;


@end

@implementation FLFlurAnnotation


/*- (FLFlurAnnotation *)initWithTitle:(NSString *)title prompt:(NSString *)prompt coordinate:(CLLocationCoordinate2D *)coordinate
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
}*/

- (id)initWithObject:(PFGeoPoint *)location {
    self = [super init];
    if (self) {
        [self setGeoPoint:location];
    }
    return self;
}


#pragma mark - MKAnnotation

// Called when the annotation is dragged and dropped. We update the geoPoint with the new coordinates.
/*- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self setGeoPoint:geoPoint];
    [self.object setObject:geoPoint forKey:@"location"];
    [self.object saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // Send a notification when this geopoint has been updated. MasterViewController will be listening for this notification, and will reload its data when this notification is received.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"geoPointAnnotiationUpdated" object:self.object];
        }
    }];
}*/


#pragma mark - ()

- (void)setGeoPoint:(PFGeoPoint *)geoPoint {
    _coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.maximumFractionDigits = 3;
    }
    
    _title = [dateFormatter stringFromDate:self.object.updatedAt];
    _subtitle = [NSString stringWithFormat:@"%@, %@", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.latitude]],
                 [numberFormatter stringFromNumber:[NSNumber numberWithDouble:geoPoint.longitude]]];
}



@end
