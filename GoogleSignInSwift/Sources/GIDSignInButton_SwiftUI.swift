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
import CoreGraphics

// MARK: - Custom Width
@available(iOS 13.0, macOS 10.15, *)
fileprivate struct Width {
  let min, max: CGFloat
}

extension GIDSignIn {

}

// MARK: - Width and Text By Button Style
@available(iOS 13.0, macOS 10.15, *)
extension GIDSignInButtonStyle {
  fileprivate var width: Width {
    switch self {
    case .iconOnly: return Width(min: CGFloat(kIconWidth), max: CGFloat(kIconWidth))
    case .standard: return Width(min: 90, max: .infinity)
    case .wide: return Width(min: 170, max: .infinity)
    default:
      fatalError("Unrecognized case for `GIDSignInButtonStyle: \(self)")
    }
  }

  fileprivate var buttonText: String {
    switch self {
    case .wide: return "Sign in with Google"
    case .standard: return "Sign in"
    case .iconOnly: return ""
    default:
      fatalError("Unrecognized case for `GIDSignInButtonStyle: \(self)")
    }
  }
}

// MARK: - Button Style
@available(iOS 13.0, macOS 10.15, *)
struct SwiftUIButtonStyle: ButtonStyle {
  let style: GIDSignInButtonStyle

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(minWidth: style.width.min,
             maxWidth: style.width.max,
             minHeight: CGFloat(kButtonHeight),
             maxHeight: CGFloat(kButtonHeight))
      .foregroundColor(.blue)
      .background(Color.white)
      .cornerRadius(5)
      .shadow(color: .gray, radius: 2, x: 0, y: 2)
  }
}

/// A Google Sign In button to be used in SwiftUI.
@available(iOS 13.0, macOS 10.15, *)
public struct GIDSwiftUISignInButton: View {
  private let googleImageName = "google"
  private let action: () -> Void

  // MARK: - Button attribute wrappers

  @ObservedObject private var styleWrapper: GIDSignInButtonStyleWrapper
  /// The `GIDSignInButtonStyle` for the button.
  public var style: GIDSignInButtonStyle {
    set {
      styleWrapper.wrapped = newValue
    }
    get {
      return styleWrapper.wrapped
    }
  }

  @ObservedObject private var colorSchemeWrapper: GIDSignInButtonColorSchemeWrapper
  /// The `GIDSignInButtonColorScheme` for the button.
  public var colorScheme: GIDSignInButtonColorScheme {
    set {
      colorSchemeWrapper.wrapped = newValue
    }
    get {
      return colorSchemeWrapper.wrapped
    }
  }

  @ObservedObject private var stateWrapper: GIDSignInButtonStateWrapper
  /// The `GIDSignInButtonState` for the button.
  public var state: GIDSignInButtonState {
    set {
      stateWrapper.wrapped = newValue
    }
    get {
      return stateWrapper.wrapped
    }
  }

  /// Creates an instance of the Google Sign-In button for use in SwiftUI
  /// - parameter style: The button style to use.
  /// - parameter colorScheme: The color scheme for the button.
  /// - parameter state: The button's state to use.
  /// - parameter action: A closure to use as the button's action upon press.
  public init(
    style: GIDSignInButtonStyle = .standard,
    colorScheme: GIDSignInButtonColorScheme = .light,
    state: GIDSignInButtonState = .normal,
    action: @escaping () -> Void
  ) {
    self.styleWrapper = GIDSignInButtonStyleWrapper(wrapped: style)
    self.colorSchemeWrapper = GIDSignInButtonColorSchemeWrapper(wrapped: colorScheme)
    self.stateWrapper = GIDSignInButtonStateWrapper(wrapped: state)
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      switch style {
      case .iconOnly:
        Image(path: GIDSignInButtonStyling.googleIconURL().path)
      case .standard, .wide:
        HStack {
          Image(path: GIDSignInButtonStyling.googleIconURL().path)
            .padding(.leading, 8)
          Text(style.buttonText)
            .padding(.trailing, 8)
          Spacer()
        }
      default:
        fatalError("Unrecognized case for `GIDSignInButtonStyle: \(self)")
      }
    }
    .buttonStyle(SwiftUIButtonStyle(style: style))
    .font(Font.signInButtonFont)
  }
}

// MARK: - Google Icon Image
@available(iOS 13.0, macOS 10.15, *)
private extension Image {
  init(path: String) {
    #if os(iOS) || targetEnvironment(macCatalyst)
    guard let uiImage = UIImage(contentsOfFile: path) else {
      fatalError("Failed to create `UIImage` from `path`: \(path)")
    }
    self.init(uiImage: uiImage)
    #elseif os(macOS)
    guard let nsImage = NSImage(contentsOfFile: path) else {
      fatalError("Failed to create `NSImage` from `path`: \(path)")
    }
    self.init(nsImage: nsImage)
    #else
    fatalError("Unrecognized platform for SwiftUI `Image` with path: \(path)")
    #endif
  }
}

// MARK: - Google Font
@available(iOS 13.0, macOS 10.15, *)
private extension Font {
  static var signInButtonFont: Font {
    #if os(iOS) || targetEnvironment(macCatalyst)
    guard let uiFont = UIFont(name: kFontNameRobotoBold,
                              size: UIFont.systemFontSize) else {
      do {
        let newFont = try Font.loadCGFont()
        return Font(CTFontCreateWithGraphicsFont(newFont, 0, nil, nil))
      } catch {
        fatalError("Unable to log font (\(kFontNameRobotoBold): \(error)")
      }
    }
    return Font(uiFont as CTFont)
    #elseif os(macOS)
    guard let nsFont = NSFont(name: kFontNameRobotoBold,
                              size: NSFont.systemFontSize) else {
      do {
        let newFont = try Font.loadCGFont()
        return Font(CTFontCreateWithGraphicsFont(newFont, 0, nil, nil))
      } catch {
        fatalError("Unable to log font (\(kFontNameRobotoBold): \(error)")
      }
    }
    return Font(nsFont as CTFont)
    #else
    fatalError("Unrecognized platform for SwiftUI sign in button font")
    #endif
  }

  static func loadCGFont() throws -> CGFont {
    let fontURL = GIDSignInButtonStyling.googleFontURL()
    guard let dataProvider = CGDataProvider(filename: fontURL.path),
            let newFont = CGFont(dataProvider) else {
              throw Error.unableToLoadFont
    }
    return newFont
  }

  enum Error: Swift.Error {
    case unableToLoadFont
  }
}
