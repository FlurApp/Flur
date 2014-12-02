//
//  FLConstants.h
//  Flur
//
//  Created by David Lee on 11/24/14.
//  Copyright (c) 2014 Steve Zuckerman. All rights reserved.
//

#ifndef Flur_FLConstants_h
#define Flur_FLConstants_h

// most controllers use:

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

// FLInitialMapViewController
#define annotationTargetSize 60

// FLContributeVieController
#define contributeColor RGB(186,108,224)
#define darkContributeColor RGB(186/2,108/2,224/2);

// FLLoginViewController
#define MAXLENGTH 30

#define submitButtonColor RGB(54, 195, 200)
#define backgroundGradientDark RGB(124, 59, 102)
#define backgroundGradientLight RGB(124, 59, 102)


// FLMapManager
#define viewablePinRadius 10
#define refreshRadius 1
#define closeToPinDistance .02 //how close we are to open a pin

// FLSettingsViewController
#define profilePictureSize 120
#define profilePictureBorderSize 126
#define buttonHeight 70

#define personalInfoLeading 20

#define personalInfoColor RGB(120,120,120)
#define personalInfoFont [UIFont fontWithName:@"Avenir-Light" size:18]

// MainViewController
#define CORNER_RADIUS 4
#define SLIDE_TIMING .20
#define PANEL_WIDTH 120

#define TOP_BAR_HEIGHT 80



#endif
