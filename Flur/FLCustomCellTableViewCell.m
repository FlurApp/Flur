//
//  FLCustomCellTableViewCell.m
//  Flur
//
//  Created by Netanel Rubin on 11/21/14.
//  Copyright (c) 2014 stevezookerman@gmail.com. All rights reserved.
//

#import "FLCustomCellTableViewCell.h"
#import "FLConstants.h"
#import "GrowButton.h"
#import "FLPhotoManager.h"

@interface FLCustomCellTableViewCell() <UIGestureRecognizerDelegate> {}

@property (nonatomic, strong) UIPanGestureRecognizer *swipeRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;
@property (nonatomic) NSInteger rightButtonsLeading;

@property (nonatomic, strong) UIColor *buttonBackgroundColor;
@property (nonatomic, strong) UIColor *rightButtonBackgroundColor;
@property (nonatomic, strong) UIColor *leftButtonBackgroundColor;

@property (nonatomic) bool isOpen;
@property (nonatomic) CGFloat startPoint;


@end


@implementation FLCustomCellTableViewCell

static FLCustomCellTableViewCell* currentOpenCell;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        
        self.rightButtonBackgroundColor = RGB(219,219,219);
        self.rightButtonsColorLayer = [[UIView alloc] init];
        self.rightButtonsColorLayer.backgroundColor = self.rightButtonBackgroundColor;
        [self.rightButtonsColorLayer setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.rightButtonsColorLayer];
        
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButtonsColorLayer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButtonsColorLayer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButtonsColorLayer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButtonsColorLayer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        

        self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button1 = [[UIButton alloc] init];
        self.button1.backgroundColor =  RGB(179, 88, 224);
        [self.button1 addTarget:self action:@selector(viewAlbum:) forControlEvents:UIControlEventTouchUpInside];
        [self.button1 setTitle:@"View" forState:UIControlStateNormal];

        //[self.button1 setTitle:@"Photos" forState:UIControlStateNormal];
        //
//        [UIView animateWithDuration:.5
//                         animations:^{
//                             self.button1.imageView.transform = CGAffineTransformMakeScale(2, 2);
//                         }];
        
        [self.button1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        
//        // create image for button1
//        UIImage* tableIcon = [UIImage imageNamed:@"photos.png"];
//        CGRect temp_rect = CGRectMake(0,0,75,75);
//        UIGraphicsBeginImageContext(temp_rect.size);
//        [tableIcon drawInRect:temp_rect];
//        UIImage *tableIconResized = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        NSData *imgData = UIImagePNGRepresentation(tableIconResized);
//        UIImage *photosImg = [UIImage imageWithData:imgData];
//        
//        [self.button1 setBackgroundImage:photosImg forState:UIControlStateNormal];
//        [self.button1 setContentMode:UIViewContentModeCenter];
//        [self.button1 setImageEdgeInsets:UIEdgeInsetsMake(20,20,20,20)];
        
        [self.contentView addSubview:self.button1];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        
         [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
         [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-80]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        
        [self.contentView layoutIfNeeded];
        
        /*GrowButton *button = [[GrowButton alloc] init];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];

        [self.contentView addSubview:button];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-80]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        

        
        
        
        
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [button addGestureRecognizer:singleFingerTap];
        
        
        UILongPressGestureRecognizer *fingerHold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(fingerHold:)];
        [button addGestureRecognizer:fingerHold];
        fingerHold.minimumPressDuration = .01;//Up to you;*/

        
        
        
        
        
        

        
        self.button2 = [[UIButton alloc] init];
        self.button2.backgroundColor = RGB(219,219,219); // RGB(255,182,82); //RGBA(255,198,119,1);//RGB(232, 72, 49);
        [self.button2 setTitle:@"Map" forState:UIControlStateNormal];
        [self.button2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.button2 addTarget:self action:@selector(changeMapButtonColor:) forControlEvents:UIControlEventTouchDown];
        [self.button2 addTarget:self action:@selector(switchToFlurInfoVC:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.contentView addSubview:self.button2];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.button1 attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-80]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.button1 attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        
        self.rightButtonsLeading = -160;
        
        
   
        
        
        
        self.myContentView = [[UIView alloc] init];
        self.myContentView.backgroundColor = [UIColor whiteColor];
        [self.myContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.contentView addSubview:self.myContentView];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.myContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.myContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        self.contentViewLeftConstraint =[NSLayoutConstraint constraintWithItem:self.myContentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        
        [self.contentView addConstraint:self.contentViewLeftConstraint];
        
        self.contentViewRightConstraint = [NSLayoutConstraint constraintWithItem:self.myContentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
        
        [self.contentView addConstraint:self.contentViewRightConstraint];
        
        
       

        self.cellPrompt = [[UILabel alloc] init];
        [self.cellPrompt setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        self.cellPrompt.text = @"Hi this is a test of the app and how it handles long prompts";        [self.cellPrompt setFont:[UIFont fontWithName:@"Avenir-Light" size:19]];
        [self.cellPrompt setTextColor:RGB(50,50,50) ];
        self.cellPrompt.numberOfLines = 0;
        self.cellPrompt.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.myContentView addSubview:self.cellPrompt];
        
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellPrompt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:15]];
        
        
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellPrompt attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
        
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellPrompt attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];
        
        
        self.cellDate = [[UILabel alloc] init];
        //cellDate.text =[[self.pinsArray objectAtIndex:indexPath.row] dateAdded];
        [self.cellDate setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        self.cellDate.text = @"Aug 1, 2014";
        [self.cellDate setTextColor:RGB(13, 191, 255) ];
        [self.cellDate setFont:[UIFont fontWithName:@"Avenir-Light" size:14]];
        
        [self.myContentView addSubview:self.cellDate];
        
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellDate attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cellPrompt attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
        
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellDate attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
        
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellDate attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
        
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellDate attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];
        
        
        self.cellContentCount = [[UILabel alloc] init];
        //cellDate.text =[[self.pinsArray objectAtIndex:indexPath.row] dateAdded];
        [self.cellContentCount setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        self.cellContentCount.text = @"7 Contributors";
        [self.cellContentCount setTextColor:RGB(150,150,150) ];
        [self.cellContentCount setFont:[UIFont fontWithName:@"Avenir-Light" size:14]];
        
        [self.myContentView addSubview:self.cellContentCount];
        
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellContentCount attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cellPrompt attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
        
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellContentCount attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
        
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellContentCount attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:120]];
        
        [self.myContentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellContentCount attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.myContentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10]];
        
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTap:)];
        self.tapRecognizer.delegate = self;
        [self.myContentView addGestureRecognizer:self.tapRecognizer];
        
        self.swipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipe:)];
        self.swipeRecognizer.delegate = self;
        [self.myContentView addGestureRecognizer:self.swipeRecognizer];
        [self layoutIfNeeded];
        
        
        self.isOpen = false;
        currentOpenCell = nil;
        

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code

}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
   // NSLog(@"pressed");
}

- (void)fingerHold:(UILongPressGestureRecognizer *)recognizer {
    NSLog(@"HOlding");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    /*UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if ([[touch.view class] isSubclassOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)touch.view;
        if (CGRectContainsPoint(label.frame, touchLocation)) {
            dragging = YES;
            oldX = touchLocation.x;
            oldY = touchLocation.y;
        }
    }*/
    //NSLog(@"fuck");
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) cellTap:(UITapGestureRecognizer *)recognizer {
    if (self.isOpen)
        [self closeRight];
    else
        [self openRight];
}

- (void)cellSwipe:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.startPoint = self.contentViewRightConstraint.constant;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
            CGFloat deltaX = currentPoint.x + self.startPoint;
            
            // If another cell is open, close it
            if (currentOpenCell != nil && currentOpenCell != self) {
                [currentOpenCell closeRight];
                currentOpenCell = nil;
            }
            if (deltaX > 0 && self.contentViewRightConstraint.constant >= 0)
                break;
            self.contentViewLeftConstraint.constant = deltaX;
            self.contentViewRightConstraint.constant = deltaX;
            
            if (self.contentViewRightConstraint.constant > 0)
                self.rightButtonsColorLayer.backgroundColor = [UIColor whiteColor];
            else
                self.rightButtonsColorLayer.backgroundColor = self.rightButtonBackgroundColor;
            
            [self layoutIfNeeded];
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.contentViewRightConstraint.constant < -30)
                [self openRight];
            else
                [self closeRight];
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
}

- (void) openRight {
    self.rightButtonsColorLayer.backgroundColor = self.rightButtonBackgroundColor;
    self.isOpen = true;
    
    // If another cell is open, close it
    if (currentOpenCell != nil && currentOpenCell != self) {
        [currentOpenCell closeRight];
    }
    
    currentOpenCell = self;
    
    if (self.contentViewRightConstraint.constant < self.rightButtonsLeading) {
        [UIView animateWithDuration:.2 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentViewLeftConstraint.constant = self.rightButtonsLeading;
            self.contentViewRightConstraint.constant = self.rightButtonsLeading;
            [self layoutIfNeeded];
        } completion:nil];
        
        return;
    }
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentViewLeftConstraint.constant = self.rightButtonsLeading-10;
        self.contentViewRightConstraint.constant = self.rightButtonsLeading-10;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentViewLeftConstraint.constant = self.rightButtonsLeading;
            self.contentViewRightConstraint.constant = self.rightButtonsLeading;
            [self layoutIfNeeded];
        } completion:nil];
    }];
    
 
}

+ (void) closeCurrentlyOpenCell {
    if (currentOpenCell != nil)
        [currentOpenCell closeRight];
}

- (void) closeRight {
    self.rightButtonsColorLayer.backgroundColor = [UIColor whiteColor];

    self.isOpen = false;
    [UIView animateWithDuration:.17 delay:0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentViewLeftConstraint.constant = 0;
        self.contentViewRightConstraint.constant = 0;
        [self layoutIfNeeded];
    } completion:nil];
}

- (CGFloat)buttonTotalWidth {
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.button2.frame);
}

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)endEditing
{
    //TODO: Build.
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate
{
    //TODO: Build
}

- (IBAction)changeMapButtonColor:(id)sender {
    UIButton* button = (UIButton*) sender;
   // button.backgroundColor = RGB(232, 102, 67);
}

- (IBAction)switchToFlurInfoVC:(id)sender {
    UIButton* button = (UIButton*) sender;
    //button.backgroundColor = RGB(232, 72, 49);
    NSMutableDictionary *data = [[NSMutableDictionary alloc ] init];
    [data setObject:self.flur forKey:@"flur"];
    [FLCustomCellTableViewCell closeCurrentlyOpenCell];

    [self.delegate showInfo:data];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (IBAction)viewAlbum:(id)sender {
    
    FLPhotoManager *photoManager = [[FLPhotoManager alloc] init];
    [photoManager loadPhotosWithPin:self.flur.objectId withCompletion:^(NSMutableArray *allPhotos) {
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:self.flur forKey: @"flur"];
        [data setObject:allPhotos forKey:@"allPhotos"];
        [data setObject:@"tablePage" forKey:@"previousPage"];
        [_delegate showPhotoPage:data];
    }];
    [FLCustomCellTableViewCell closeCurrentlyOpenCell];

}

@end
