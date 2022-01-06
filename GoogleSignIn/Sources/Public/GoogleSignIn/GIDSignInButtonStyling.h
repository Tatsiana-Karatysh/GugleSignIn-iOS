/*
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>
#import "CoreGraphics/CoreGraphics.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Button Style and Scheme

/// The layout styles supported by the `GIDSignInButton`.
///
/// The minimum size of the button depends on the language used for text.
/// The following dimensions (in points) fit for all languages:
/// - kGIDSignInButtonStyleStandard: 230 x 48
/// - kGIDSignInButtonStyleWide:     312 x 48
/// - kGIDSignInButtonStyleIconOnly: 48 x 48 (no text, fixed size)
typedef NS_ENUM(NSInteger, GIDSignInButtonStyle) {
  kGIDSignInButtonStyleStandard = 0,
  kGIDSignInButtonStyleWide = 1,
  kGIDSignInButtonStyleIconOnly = 2
};

/// The color schemes supported by the `GIDSignInButton`.
typedef NS_ENUM(NSInteger, GIDSignInButtonColorScheme) {
  kGIDSignInButtonColorSchemeDark = 0,
  kGIDSignInButtonColorSchemeLight = 1
};

#pragma mark - Constants

// Standard accessibility identifier.
extern NSString *const kAccessibilityIdentifier;

// The name of the font for button text.
extern NSString *const kFontNameRobotoBold;

// Button text font size.
extern const CGFloat kFontSize;

#pragma mark - Icon Constants

// The name of the image for the Google "G"
extern NSString *const kGoogleImageName;

// Keys used for NSCoding.
extern NSString *const kStyleKey;
extern NSString *const kColorSchemeKey;
extern NSString *const kButtonState;

#pragma mark - Sizing Constants

// The corner radius of the button
extern const int kCornerRadius;

// The standard height of the sign in button.
extern const int kButtonHeight;

// The width of the icon part of the button in points.
extern const int kIconWidth;

// Left and right text padding.
extern const int kTextPadding;

// The icon (UIImage)'s frame.
extern const CGRect kIconFrame;

#pragma mark - Appearance Constants

extern const CGFloat kBorderWidth;

extern const CGFloat kHaloShadowAlpha;
extern const CGFloat kHaloShadowBlur;

extern const CGFloat kDropShadowAlpha;
extern const CGFloat kDropShadowBlur;
extern const CGFloat kDropShadowYOffset;

extern const CGFloat kDisabledIconAlpha;

#pragma mark - Colors

// All colors in hex RGBA format (0xRRGGBBAA)

extern const NSUInteger kColorGoogleBlue;
extern const NSUInteger kColorGoogleDarkBlue;

extern const NSUInteger kColorWhite;
extern const NSUInteger kColorLightestGrey;
extern const NSUInteger kColorLightGrey;
extern const NSUInteger kColorDisabledGrey;
extern const NSUInteger kColorDarkestGrey;

extern const NSUInteger kColors[12];

# pragma mark - Button State

/// The state of the button:
typedef NS_ENUM(NSUInteger, GIDSignInButtonState) {
  kGIDSignInButtonStateNormal = 0,
  kGIDSignInButtonStateDisabled = 1,
  kGIDSignInButtonStatePressed = 2,
};
extern NSUInteger const kNumGIDSignInButtonStates;

/// Used to lookup specific colors from the kColors table:
typedef NS_ENUM(NSUInteger, GIDSignInButtonStyleColor) {
  kGIDSignInButtonStyleColorBackground = 0,
  kGIDSignInButtonStyleColorForeground = 1,
};
extern NSUInteger const kNumGIDSignInButtonStyleColors;

@interface GIDSignInButtonStyling : NSObject

+ (NSURL *)googleIconURL;
+ (NSURL *)googleFontURL;

@end

NS_ASSUME_NONNULL_END
