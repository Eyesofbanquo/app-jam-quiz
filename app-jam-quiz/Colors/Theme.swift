//
//  Theme.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/19/20.
//

import Foundation
import SwiftUI

enum ColorTheme: String {
  case primary
  case secondary
  case tertiary
  case accentOne
  case accentTwo
  case light
}

extension Text {
  func setColorTheme(_ theme: ColorTheme) -> Text {
    self.foregroundColor(Color(theme.rawValue))
  }
}

extension View {
  func setColorTheme(_ theme: ColorTheme) -> some View {
    self.foregroundColor(Color(theme.rawValue))
  }
  
  func setBackgroundColorTheme(_ theme: ColorTheme) -> some View {
    self.background(Color(theme.rawValue))
  }
}

extension ColorTheme {
  func compliment(colorScheme: ColorScheme) -> ColorTheme {
    switch colorScheme {
      case .dark: switch self {
        case .primary: return .secondary
        default: return .primary
      }
      case .light:
        switch self {
          case .primary: return .secondary
          case .secondary: return .light
          case .tertiary: return .light
          case .accentTwo: return .secondary
          case .accentOne: return .tertiary
          case .light: return .tertiary
        }
      default: return .primary
    }
  }
}
