// Copyright 2021 Google LLC
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
#import <TargetConditionals.h>

#if TARGET_OS_IOS || TARGET_OS_MACCATALYST

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "GoogleSignIn/Sources/Public/GoogleSignIn/GIDSignInButton.h"
#import "GoogleSignIn/Sources/Public/GoogleSignIn/GIDSignInButtonStyling.h"

#ifdef SWIFT_PACKAGE
@import OCMock;
#else
#import <OCMock/OCMock.h>
#endif

static NSString *const kWidthConstraintIdentifier =
    @"buttonWidth - auto generated by GIDSignInButton";
static NSString *const kHeightConstraintIdentifier =
    @"buttonHeight - auto generated by GIDSignInButton";

static NSString * const kAppBundleId = @"FakeBundleID";

@interface GIDSignInButton (Test)

- (void)updateUI;

@end

@interface GIDSignInButtonTest : XCTestCase

@end

@implementation GIDSignInButtonTest

#pragma mark - Tests

// Verify the default style and color scheme for the button.
- (void)testDefaultButtonSettings {
  GIDSignInButton *button = [[GIDSignInButton alloc] init];
  XCTAssertTrue(button.style == kGIDSignInButtonStyleStandard,
      @"Default button style is incorrect");
  XCTAssertTrue(button.colorScheme == kGIDSignInButtonColorSchemeLight,
      @"Default button color scheme is incorrect");
}

// Verify that setting the button's style/color scheme will refresh the image.
- (void)testRefreshImage {
  GIDSignInButton *button = [[GIDSignInButton alloc] init];
  id buttonMock = OCMPartialMock(button);
  [[buttonMock expect] updateUI];
  [(GIDSignInButton *)buttonMock setStyle:kGIDSignInButtonStyleWide];
  [buttonMock verify];

  [[buttonMock expect] updateUI];
  [buttonMock setColorScheme:kGIDSignInButtonColorSchemeDark];
  [buttonMock verify];
}

- (void)testNSCoding {
  GIDSignInButton *button = [[GIDSignInButton alloc] init];
  button.style = kGIDSignInButtonStyleIconOnly;
  button.colorScheme = kGIDSignInButtonColorSchemeLight;
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:button];
  GIDSignInButton *newButton = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  XCTAssertEqual(button.style, newButton.style);
  XCTAssertEqual(button.colorScheme, newButton.colorScheme);
}

- (void)testSetStyle {
  GIDSignInButton *button = [[GIDSignInButton alloc] init];
  id buttonMock = OCMPartialMock(button);
  [[buttonMock expect] setNeedsDisplay];

  button.style = kGIDSignInButtonStyleWide;
  [buttonMock verify];
  XCTAssertEqual(button.style, kGIDSignInButtonStyleWide);

  [[buttonMock expect] setNeedsDisplay];

  button.style = kGIDSignInButtonStyleIconOnly;
  [buttonMock verify];
  XCTAssertEqual(button.style, kGIDSignInButtonStyleIconOnly);

  [[buttonMock expect] setNeedsDisplay];

  button.style = kGIDSignInButtonStyleStandard;
  [buttonMock verify];
  XCTAssertEqual(button.style, kGIDSignInButtonStyleStandard);
}

- (void)testSetEnabled {
  GIDSignInButton *button = [[GIDSignInButton alloc] init];
  id buttonMock = OCMPartialMock(button);
  // Checks default value for |button.enabled|
  XCTAssertTrue(button.enabled, @"Button should be default enabled");
  // Checks that button redraw when enabled set YES.
  [[buttonMock expect] setNeedsDisplay];
  button.enabled = NO;
  [buttonMock verify];
  // Checks nothing happen if setting same value.
  button.enabled = NO;
  // Checks that button redraw when enabled set YES.
  [[buttonMock expect] setNeedsDisplay];
  button.enabled = YES;
  [buttonMock verify];
  // Checks nothing happen if setting same value.
  button.enabled = YES;
}

- (void)testWidthAndHeightConstraintAddition {
  GIDSignInButton *button = [[GIDSignInButton alloc] init];
  XCTAssertEqual([button.constraints count], 0u);
  [button updateConstraints];
  XCTAssertEqual([button.constraints count], 2u);
  // Ensure we don't duplicate constraints
  [button updateConstraints];
  XCTAssertEqual([button.constraints count], 2u);
}

- (void)testHeightConstraintReplacement {
  GIDSignInButton *button = [[GIDSignInButton alloc] init];
  [button addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:30]];
  XCTAssertEqual([button.constraints count], 1u);
  [button updateConstraints];
  XCTAssertEqual([button.constraints count], 2u);
  for (NSLayoutConstraint *constraint in button.constraints) {
    if ([constraint.identifier isEqualToString:kHeightConstraintIdentifier]) {
      XCTAssertEqual(constraint.firstAttribute, NSLayoutAttributeHeight);
      XCTAssertEqual(constraint.constant, 48);
      return;
    }
  }
  XCTFail(@"New constraint not found.");
}

- (void)testWidthConstraintBelowMinimumRemoval {
  GIDSignInButton *button = [[GIDSignInButton alloc] init];
  [button addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:50]];
  XCTAssertEqual([button.constraints count], 1u);
  [button updateConstraints];
  XCTAssertEqual([button.constraints count], 2u);
  for (NSLayoutConstraint *constraint in button.constraints) {
    XCTAssertTrue([constraint.identifier isEqualToString:kWidthConstraintIdentifier] ||
                  [constraint.identifier isEqualToString:kHeightConstraintIdentifier]);
  }
}

- (void)testDontRemoveValidWidthConstraint {
  GIDSignInButton *button = [[GIDSignInButton alloc] init];
  NSLayoutConstraint *widthConstraint =
      [NSLayoutConstraint constraintWithItem:button
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0
                                    constant:250];
  [button addConstraint:widthConstraint];
  XCTAssertEqual([button.constraints count], 1u);
  [button updateConstraints];
  XCTAssertEqual([button.constraints count], 3u);
  XCTAssertTrue([button.constraints containsObject:widthConstraint]);
}

- (void)testDontRemoveValidHeightConstraint {
  GIDSignInButton *button = [[GIDSignInButton alloc] init];
  NSLayoutConstraint *heightConstraint =
      [NSLayoutConstraint constraintWithItem:button
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1.0
                                    constant:48];
  [button addConstraint:heightConstraint];
  XCTAssertEqual([button.constraints count], 1u);
  [button updateConstraints];
  XCTAssertEqual([button.constraints count], 2u);
  XCTAssertTrue([button.constraints containsObject:heightConstraint]);
}

@end

#endif
