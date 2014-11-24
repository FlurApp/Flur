//
//  FLCustomCellTableViewCell.m
//  Flur
//
//  Created by Netanel Rubin on 11/21/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#import "FLCustomCellTableViewCell.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/1]

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
        
        self.rightButtonBackgroundColor = [UIColor greenColor];
        self.rightButtonsColorLayer = [[UIView alloc] init];
        self.rightButtonsColorLayer.backgroundColor = self.rightButtonBackgroundColor;
        [self.rightButtonsColorLayer setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.rightButtonsColorLayer];
        
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButtonsColorLayer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButtonsColorLayer attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButtonsColorLayer attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButtonsColorLayer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        
        self.button1 = [[UIButton alloc] init];
        self.button1.backgroundColor = [UIColor redColor];
        [self.button1 setTitle:@"Hi" forState:UIControlStateNormal];
        [self.button1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.button1 setImage:[UIImage imageNamed:@"mapIcon.png"] forState:UIControlStateNormal];
        
        
        [self.contentView addSubview:self.button1];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        
         [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
         [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-50]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        
        self.button2 = [[UIButton alloc] init];
        self.button2.backgroundColor = [UIColor greenColor];
        [self.button2 setTitle:@"Hi" forState:UIControlStateNormal];
        [self.button2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        
        [self.contentView addSubview:self.button2];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.button1 attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-50]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.button2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.button1 attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        
        self.rightButtonsLeading = -100;
        
        
   
        
        
        
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
        
        self.cellPrompt.text = @"Hi this is a test of the app and how it handles long prompts";//[[self.pinsArray objectAtIndex:indexPath.row] prompt];
        [self.cellPrompt setFont:[UIFont fontWithName:@"Avenir-Light" size:19]];
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
        [self.cellDate setTextColor:RGB(179, 88, 224) ];
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

        
        
        
        
        self.isOpen = false;
        currentOpenCell = nil;
        

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code

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
            NSLog(@"Pan Began at %f", (self.startPoint));
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
            //NSLog(@"Pan Moved %f", currentPoint.x);
            self.contentViewLeftConstraint.constant = deltaX;
            self.contentViewRightConstraint.constant = deltaX;
            
            if (self.contentViewRightConstraint.constant > 0)
                self.rightButtonsColorLayer.backgroundColor = [UIColor whiteColor];
            else
                self.rightButtonsColorLayer.backgroundColor = self.rightButtonBackgroundColor;
            
           // NSLog(@"Constant: %f", self.contentViewRightConstraint.constant);
            [self layoutIfNeeded];
        }
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Pan Ended");
            if (self.contentViewRightConstraint.constant < -50)
                [self openRight];
            else
                [self closeRight];
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"Pan Cancelled");
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

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.myContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            break;
  
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            NSLog(@"Pan Moved %f", deltaX);
        }
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Pan Ended");
            break;
        case UIGestureRecognizerStateCancelled:
            NSLog(@"Pan Cancelled");
            break;
        default:
            break;
    }
}

@end