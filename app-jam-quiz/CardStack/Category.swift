//
//  Category.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/20/20.
//

import Foundation

enum QuizType: String {
  case trueFalse = "boolean"
  case multipleChoice = "multiple"
}

enum QuizDifficulty: String {
  case easy = "easy"
  case normal = "medium"
  case hard = "hard"
}

enum Category: String, CaseIterable {
  case videoGames = "Video Games"
  case books = "Books"
  case movies = "Movies"
  case music = "Music"
  case celebrities = "Celebrities"
  
  var name: String {
    rawValue
  }
  
  var imageName: String {
    switch self {
      case .videoGames: return "gamecontroller.fill"
      case .books: return "book.fill"
      case .movies: return "film.fill"
      case .music: return "music.note"
      case .celebrities: return "moon.stars.fill"
    }
  }
  
  var colorName: String {
    switch self {
      case .videoGames: return "videoGames"
      case .books: return "books"
      case .movies: return "movies"
      case .music: return "music"
      case .celebrities: return "celebrities"
    }
  }
  
  var number: Int {
    switch self {
      case .videoGames: return 15
      case .books: return 10
      case .movies: return 11
      case .music: return 12
      case .celebrities: return 36
    }
  }
  
  func urlGenerator(difficulty: QuizDifficulty,
                    type: QuizType = .multipleChoice) -> String {
    return "https://opentdb.com/api.php?amount=10&category=\(self.number)&difficulty=\(difficulty.rawValue)&type=\(type.rawValue)"
  }
}


