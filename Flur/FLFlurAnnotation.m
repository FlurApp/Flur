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

@property (nonatomic, strong) UIImageView *myAnnotationView;
@property (nonatomic) CGRect myImageSize;
@property (nonatomic) NSInteger hey;


@end

@implementation FLFlurAnnotation


- (id)initWithPin:(FLPin *)pin {
    self = [super init];
    
    if (self) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(pin.coordinate.latitude,
                                                                  pin.coordinate.longitude);
        _coordinate = coord;
        self.pin = pin;
        self.myAnnotationView = [[UIImageView alloc] init];
        self.myImageSize = CGRectMake(-15,-15,30,30);
        self.hey = 1;
        self.newFlur = false;
    }
    
    return self;
}

- (id) initWithLat:(double) lat initWithLng:(double) lng {
    self = [super init];
    if (self) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lng);
        _coordinate = coord;
        self.pin = nil;
        self.myAnnotationView = [[UIImageView alloc] init];
        self.myImageSize = CGRectMake(-15,-15,30,30);
        self.hey = 1;
        self.newFlur = false;



    }
    return self;
}

- (id) init {
    self = [super init];
    self.myAnnotationView = [[UIImageView alloc] init];
    self.myImageSize = CGRectMake(-15,-15,30,30);
    self.hey = 1;
    self.newFlur = false;


    return self;
}

- (void) showAnnotationAsOpenable:(MKAnnotationView *) annotationViewFromMap {
    if (self.pin.haveContributedTo) {
        [self animateRed];
    }
    else {
        [self animateBlue];
    }
}


- (void) showAnnotationAsNonOpenable:(MKAnnotationView *) annotationViewFromMap {
    if (self.pin.haveContributedTo) {
        [self drawRed];
    }
    else {
        [self drawBlue];
    }
}

- (void) growFlur:(MKAnnotationView *) annotationViewFromMap {
    NSLog(@"GROWWING");
    self.myAnnotationView.userInteractionEnabled = YES;
    [self.myAnnotationView setImage:[UIImage imageNamed:@""]];

    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    for (int i=1; i<=18; i++)
        [frames addObject:[UIImage imageNamed:[NSString stringWithFormat:@"redGrowing%d.png", i]]];
    for (int i=18; i>=15; i--)
        [frames addObject:[UIImage imageNamed:[NSString stringWithFormat:@"redGrowing%d.png", i]]];
    
    
    self.myAnnotationView.animationImages = [[NSArray alloc] initWithArray:frames];
    
    self.myAnnotationView.animationDuration = .5f;
    self.myAnnotationView.animationRepeatCount = 1;
    [self.myAnnotationView startAnimating];
    [self.myAnnotationView setFrame: self.myImageSize];
    
    [self performSelector:@selector(drawRedIB:) withObject:nil afterDelay:.4];

}

- (IBAction)drawRedIB:(id)sender {
    [self drawRed];
}

- (void) animateRed {
    self.myAnnotationView.userInteractionEnabled = YES;
    [self.myAnnotationView setImage:[UIImage imageNamed:@""]];

    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    for (int i=1; i<=16; i++)
        [frames addObject:[UIImage imageNamed:[NSString stringWithFormat:@"redPulsing%d.png", i]]];
    
    for (int i=1; i<=4; i++)
        [frames addObject:[UIImage imageNamed:@"redPulsing16"]];
    
    for (int i=16; i>=1; i--)
        [frames addObject:[UIImage imageNamed:[NSString stringWithFormat:@"redPulsing%d.png", i]]];
    
    for (int i=1; i<=4; i++)
        [frames addObject:[UIImage imageNamed:@"redPulsing1"]];
    
         
    self.myAnnotationView.animationImages = nil;
    self.myAnnotationView.animationImages = [[NSArray alloc] initWithArray:frames];
    
    self.myAnnotationView.animationDuration = 1.0f;
    self.myAnnotationView.animationRepeatCount = 0;
    [self.myAnnotationView startAnimating];
    [self.myAnnotationView setFrame: self.myImageSize];
}

- (void) animateBlue {
    self.myAnnotationView.userInteractionEnabled = YES;
    [self.myAnnotationView setImage:[UIImage imageNamed:@""]];

    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    for (int i=1; i<=16; i++)
        [frames addObject:[UIImage imageNamed:[NSString stringWithFormat:@"bluePulsing%d.png", i]]];
    
    for (int i=1; i<=4; i++)
        [frames addObject:[UIImage imageNamed:@"bluePulsing16"]];
    
    for (int i=16; i>=1; i--)
        [frames addObject:[UIImage imageNamed:[NSString stringWithFormat:@"bluePulsing%d.png", i]]];
    
    for (int i=1; i<=4; i++)
        [frames addObject:[UIImage imageNamed:@"bluePulsing1"]];

    
    self.myAnnotationView.animationImages = [[NSArray alloc] initWithArray:frames];
    
    self.myAnnotationView.animationDuration = 1.0f;
    self.myAnnotationView.animationRepeatCount = 0;
    [self.myAnnotationView startAnimating];
    [self.myAnnotationView setFrame: self.myImageSize];
}

- (void) drawRed {
    [self.myAnnotationView stopAnimating];
    [self.myAnnotationView setImage:[UIImage imageNamed:@"redPulsing1.png"]];
    [self.myAnnotationView setFrame: self.myImageSize];
}

- (void) drawBlue {
    [self.myAnnotationView stopAnimating];
    [self.myAnnotationView setImage:[UIImage imageNamed:@"bluePulsing1.png"]];
    [self.myAnnotationView setFrame: self.myImageSize];
}



- (MKAnnotationView*) annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                    reuseIdentifier:@"MyCustomAnnotation"];
    // I dont know why this function is getting called twice
    if (self.hey == 2)
        return annotationView;
    self.hey++;
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = NO;
    
    [annotationView addSubview:self.myAnnotationView];
    if (self.newFlur)
        [self growFlur:annotationView];
    else if (self.pin.openable)
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
