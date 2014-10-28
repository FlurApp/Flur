//
//  FLFlurAnnotation.m
//  Flur
//
//  Created by Lily Hashemi on 10/5/14.
//  Copyright (c) 2014 lhashemi. All rights reserved.
//

#import "FLFlurAnnotation.h"

@interface FLFlurAnnotation ()

@property (nonatomic, strong) PFObject *object;


@end

@implementation FLFlurAnnotation


- (id)initWithPin:(FLPin *)location isAnimated:(bool)isAnimated {
    self = [super init];
    if (self) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(location.coordinate.latitude,
                                                                  location.coordinate.longitude);
        _coordinate = coord;
        _isAnimated = isAnimated;
        _pinId = location.pinId;
    }
    return self;
}

- (id)initWithAnnotation:(FLFlurAnnotation*)annotation isAnimated:(bool)isAnimated {
    self = [super init];
    if (self) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(annotation.coordinate.latitude,
                                                                  annotation.coordinate.longitude);
        _coordinate = coord;
        _isAnimated = isAnimated;
    }
    return self;
}



- (MKAnnotationView*) annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                    reuseIdentifier:@"MyCustomAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = NO;
    annotationView.image = [UIImage imageNamed:@"flur_25px.png"];
    return annotationView;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"lat: %f   lng: %f    isAnimated: %@", self.coordinate.latitude, self.coordinate.longitude, self.isAnimated  ? @"Yes" : @"No"];
}




@end
