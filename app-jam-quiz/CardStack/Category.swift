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
  
  static func getDifficulty(forIndex idx: Int) -> QuizDifficulty {
    switch idx {
      case 1: return .normal
      case 2: return .hard
      default: return .easy
    }
  }
}

enum Category: String, CaseIterable {
  case videoGames = "Video Games"
  case books = "Books"
  case movies = "Movies"
  case music = "Music"
//  case celebrities = "Celebrities"
  
  var name: String {
    rawValue
  }
  
  var imageName: String {
    switch self {
      case .videoGames: return "gamecontroller.fill"
      case .books: return "book.fill"
      case .movies: return "film.fill"
      case .music: return "music.note"
    }
  }
  
  var colorName: String {
    switch self {
      case .videoGames: return "videoGames"
      case .books: return "books"
      case .movies: return "movies"
      case .music: return "music"
    }
  }
  
  var number: Int {
    switch self {
      case .videoGames: return 15
      case .books: return 10
      case .movies: return 11
      case .music: return 12
    }
  }
  
  var image: String {
    colorName
  }
  
  var description: String {
    switch self {
      case .videoGames: return
        """
A wise man once said there's nothing more fun than playing video games. A wise app once said: "Tap on me to see if you really know which wise man said that."
"""
      case .books: return "Guards! Guards! Do you know where that line is from? Or is it a title?  Well I have more questions for you so why don't you tap on me for more of the kind!"
      case .movies: return "Did you know that you should know if your time machine works before you flipped the switch? Well that's what a movie told me. I forgot the name of it...Could you help me remember?"
      case .music: return "Welcome to the hotel of Cali-Qizzo. This card is such a lovely place (such a lovely place) to match a lovely face. Tap in for more."
    }
  }
  
  func urlGenerator(difficulty: QuizDifficulty,
                    type: QuizType = .multipleChoice) -> String {
    return "https://opentdb.com/api.php?amount=10&category=\(self.number)&difficulty=\(difficulty.rawValue)&type=\(type.rawValue)"
  }
}


