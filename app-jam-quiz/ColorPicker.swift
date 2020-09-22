//
//  ColorPicker.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/22/20.
//

import Foundation
import SwiftUI

class ColorPicker {
  
  func textColor(for category: Category, forScheme scheme: ColorScheme) -> Color {
    switch scheme {
      case .light:
        switch category {
          case .books: return Color(.white)
          case .movies: return Color(.white)
          case .music: return Color(.white)
          case .videoGames: return Color(.white)
        }
      case .dark:
        switch category {
          case .books: return Color(.white)
          case .movies: return Color(ColorTheme.accentOne.rawValue)
          case .music: return Color(.white)
          case .videoGames: return Color(.black)
        }
      default:
        switch category {
          case .books: return Color(.white)
          case .movies: return Color(.white)
          case .music: return Color(.white)
          case .videoGames: return Color(.white)
        }
    }
  }
}
