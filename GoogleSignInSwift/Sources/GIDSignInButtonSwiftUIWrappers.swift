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

import SwiftUI
import GoogleSignIn

/// This protocol provides that API required for wrapping a setting from
/// `GIDSignInButton` so that its changes can be published.
protocol GIDSignInButtonWrapper {
  /// The value to wrap.
  associatedtype WrappedValue
  /// The `WrappedValue` property.
  var wrapped: WrappedValue { get set }

  /// An initializer to create the wrapper with its `WrappedValue`.
  /// - parameter wrapped: The value to wrap.
  init(wrapped: WrappedValue)
}

/// A wrapper for `GIDSignInButtonState` to make it observable in SwiftUI.
@available(iOS 13.0, macOS 10.15, *)
class GIDSignInButtonStateWrapper: ObservableObject, GIDSignInButtonWrapper {
  /// The `@Published` property of this wrapper that will trigger view updates
  /// if observed.
  @Published var wrapped: GIDSignInButtonState

  required init(wrapped: GIDSignInButtonState) {
    self.wrapped = wrapped
  }
}

@available(iOS 13.0, macOS 10.15, *)
class GIDSignInButtonColorSchemeWrapper: ObservableObject, GIDSignInButtonWrapper {
  @Published var wrapped: GIDSignInButtonColorScheme

  required init(wrapped: GIDSignInButtonColorScheme) {
    self.wrapped = wrapped
  }
}

@available(iOS 13.0, macOS 10.15, *)
class GIDSignInButtonStyleWrapper: ObservableObject, GIDSignInButtonWrapper {
  @Published var wrapped: GIDSignInButtonStyle

  required init(wrapped: GIDSignInButtonStyle) {
    self.wrapped = wrapped
  }
}
