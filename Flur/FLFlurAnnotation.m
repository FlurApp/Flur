//
//  FLFlurAnnotation.m
//  Flur
//
//  Created by Lily Hashemi on 10/5/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import "FLFlurAnnotation.h"

@interface FLFlurAnnotation ()

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, copy) NSString *title;

@end

@implementation FLFlurAnnotation


- (id)initWithPin:(FLPin *)pin {
    self = [super init];
    
    if (self) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(pin.coordinate.latitude,
                                                                  pin.coordinate.longitude);
        _coordinate = coord;
        self.pin = pin;
    }
    
    return self;
}

- (id) initWithLat:(double) lat initWithLng:(double) lng {
    self = [super init];
    if (self) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
        _coordinate = coord;
        self.pin = nil;
    }
    return self;
}

- (id) init {
    self = [super init];
    return self;
}

- (void) showAnnotationAsOpenable:(MKAnnotationView *) annotationViewFromMap {
    for (UIView *subView in [annotationViewFromMap subviews]) {
        if (subView.tag == 10) {
            [subView removeFromSuperview];
        }
    }
    NSLog(@"Hey");
    UIImageView* animatedImageView = [[UIImageView alloc] init];
    animatedImageView.userInteractionEnabled = YES;
    animatedImageView.tag = 10;
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"14.png"],
                                         [UIImage imageNamed:@"14.png"],
                                         [UIImage imageNamed:@"14.png"],
                                         [UIImage imageNamed:@"14.png"],
                                         [UIImage imageNamed:@"14.png"],
                                         [UIImage imageNamed:@"13.png"],
                                         [UIImage imageNamed:@"12.png"],
                                         [UIImage imageNamed:@"11.png"],
                                         [UIImage imageNamed:@"10.png"],
                                         [UIImage imageNamed:@"9.png"],
                                         [UIImage imageNamed:@"8.png"],
                                         [UIImage imageNamed:@"7.png"],
                                         [UIImage imageNamed:@"6.png"],
                                         [UIImage imageNamed:@"5.png"],
                                         [UIImage imageNamed:@"4.png"],
                                         [UIImage imageNamed:@"3.png"],
                                         [UIImage imageNamed:@"2.png"],
                                         [UIImage imageNamed:@"1.png"],
                                         [UIImage imageNamed:@"0.png"],
                                         [UIImage imageNamed:@"0.png"],
                                         [UIImage imageNamed:@"0.png"],
                                         [UIImage imageNamed:@"0.png"],
                                         [UIImage imageNamed:@"0.png"],
                                         [UIImage imageNamed:@"1.png"],
                                         [UIImage imageNamed:@"2.png"],
                                         [UIImage imageNamed:@"3.png"],
                                         [UIImage imageNamed:@"4.png"],
                                         [UIImage imageNamed:@"5.png"],
                                         [UIImage imageNamed:@"6.png"],
                                         [UIImage imageNamed:@"7.png"],
                                         [UIImage imageNamed:@"8.png"],
                                         [UIImage imageNamed:@"9.png"],
                                         [UIImage imageNamed:@"10.png"],
                                         [UIImage imageNamed:@"11.png"],
                                         [UIImage imageNamed:@"12.png"],
                                         [UIImage imageNamed:@"13.png"], nil];
    animatedImageView.animationDuration = 1.3f;
    animatedImageView.animationRepeatCount = 0;
    [animatedImageView startAnimating];
    [animatedImageView setFrame: CGRectMake(-15,-15,30,30)];
    
    [annotationViewFromMap addSubview:animatedImageView];
}

- (void) showAnnotationAsNonOpenable:(MKAnnotationView *) annotationViewFromMap {
    for (UIView *subView in [annotationViewFromMap subviews]) {
        if (subView.tag == 10) {
            [subView removeFromSuperview];
        }
     }
     UIImageView* animatedImageView = [[UIImageView alloc] init];
     animatedImageView.tag = 10;
     [animatedImageView setImage:[UIImage imageNamed:@"14.png"]];
     
     [animatedImageView setFrame: CGRectMake(-15,-15,30,30)];
     
     
     [annotationViewFromMap addSubview:animatedImageView];

}

- (MKAnnotationView*) annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                    reuseIdentifier:@"MyCustomAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = NO;

    if (self.pin.contentCount)
        [self showAnnotationAsOpenable:annotationView];
    else
        [self showAnnotationAsNonOpenable:annotationView];
    
    return annotationView;
}

-(NSString *) description {
    //return [NSString stringWithFormat:@"lat: %f   lng: %f    isAnimated: %@", self.coordinate.latitude, self.coordinate.longitude, self.isAnimated  ? @"Yes" : @"No"];
    return @"Need to redo print message in FLFlurAnnotation.m";
}

@end
