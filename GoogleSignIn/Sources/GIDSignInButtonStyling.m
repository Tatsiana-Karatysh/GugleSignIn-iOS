// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "GoogleSignIn/Sources/Public/GoogleSignIn/GIDSignInButtonStyling.h"
#import "GoogleSignIn/Sources/NSBundle+GID3PAdditions.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Constants

// Standard accessibility identifier.
NSString *const kAccessibilityIdentifier = @"GIDSignInButton";

// The name of the font for button text.
NSString *const kFontNameRobotoBold = @"Roboto-Bold";

// Button text font size.
const CGFloat kFontSize = 14;

#pragma mark - Icon Constants

// The name of the image for the Google "G"
NSString *const kGoogleImageName = @"google";

// Keys used for NSCoding.
NSString *const kStyleKey = @"style";
NSString *const kColorSchemeKey = @"color_scheme";
NSString *const kButtonState = @"state";

#pragma mark - Sizing Constants

// The corner radius of the button
const int kCornerRadius = 2;

// The standard height of the sign in button.
const int kButtonHeight = 48;

// The width of the icon part of the button in points.
const int kIconWidth = 40;

// Left and right text padding.
const int kTextPadding = 14;

// The icon (UIImage)'s frame.
const CGRect kIconFrame = { {9, 10}, {29, 30} };

#pragma mark - Appearance Constants

const CGFloat kBorderWidth = 4;

const CGFloat kHaloShadowAlpha = 12.0 / 100.0;
const CGFloat kHaloShadowBlur = 2;

const CGFloat kDropShadowAlpha = 24.0 / 100.0;
const CGFloat kDropShadowBlur = 2;
const CGFloat kDropShadowYOffset = 2;

const CGFloat kDisabledIconAlpha = 40.0 / 100.0;

#pragma mark - Colors

// All colors in hex RGBA format (0xRRGGBBAA)

const NSUInteger kColorGoogleBlue = 0x4285f4ff;
const NSUInteger kColorGoogleDarkBlue = 0x3367d6ff;

const NSUInteger kColorWhite = 0xffffffff;
const NSUInteger kColorLightestGrey = 0x00000014;
const NSUInteger kColorLightGrey = 0xeeeeeeff;
const NSUInteger kColorDisabledGrey = 0x00000066;
const NSUInteger kColorDarkestGrey = 0x00000089;

const NSUInteger kColors[12] = {
  // |Background|, |Foreground|,

  kColorGoogleBlue, kColorWhite,              // Dark Google Normal
  kColorLightestGrey, kColorDisabledGrey,     // Dark Google Disabled
  kColorGoogleDarkBlue, kColorWhite,          // Dark Google Pressed

  kColorWhite, kColorDarkestGrey,             // Light Google Normal
  kColorLightestGrey, kColorDisabledGrey,     // Light Google Disabled
  kColorLightGrey, kColorDarkestGrey,         // Light Google Pressed

};

# pragma mark - Button State

const NSUInteger kNumGIDSignInButtonStates = 3;
const NSUInteger kNumGIDSignInButtonStyleColors = 2;

@interface GIDSignInButtonStyling ()

@end

@implementation GIDSignInButtonStyling

/// Retrieves the Google icon URL from the bundle.
+ (NSURL *)googleIconURL {
  NSBundle *bundle = [NSBundle gid_frameworkBundle];
  NSString *iconPath = [bundle pathForResource:kGoogleImageName ofType:@"png"];
  return [NSURL URLWithString:iconPath];
}

/// Retrieves the Google font URL from the bundle.
+ (NSURL *)googleFontURL {
  NSBundle *bundle = [NSBundle gid_frameworkBundle];
  NSString *fontPath = [bundle pathForResource:kFontNameRobotoBold ofType:@"ttf"];
  return [NSURL URLWithString:fontPath];
}

@end

NS_ASSUME_NONNULL_END
