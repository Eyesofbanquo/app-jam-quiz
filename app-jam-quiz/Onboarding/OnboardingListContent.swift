//
//  OnboardingListContent.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/19/20.
//

import Foundation
import SwiftUI

enum OnboardingListContent: CaseIterable {
  case fitness
  case share
  case favorite
  
  var title: String {
    switch self {
      case .fitness: return "Flex your knowledge"
      case .share: return "Share your progress"
      case .favorite: return "Have fun"
    }
  }
  
  var subtitle: String {
    switch self {
      case .fitness: return "Test your might against an entire database of gaming knowledge."
      case .share: return "Get ready to brag! Let all of your friends and family see how well you've done."
      case .favorite: return "Remember: it's just a game. No stress. Just do your best! 😀"
    }
  }
  
  var imageName: String {
    switch self {
      case .fitness: return "fitness"
      case .share: return "share"
      case .favorite: return "favorite"
    }
  }
  
  func color(colorScheme scheme: ColorScheme) -> Color {
    switch self {
      case .fitness:
        switch scheme {
          case .dark: return Color(.systemGreen)
          default: return Color(.systemOrange)
            
        }
      case .share:
        switch scheme {
          case .dark: return Color(.systemTeal)
          default: return Color(.systemIndigo)
        }
      case .favorite: return Color(.systemRed)
    }
  }
}
