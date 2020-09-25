//
//  Network.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/21/20.
//

import Combine
import Foundation

struct QuizQuestionContainer: Decodable {
  var results: [QuizQuestion]
}

struct QuizQuestion: Decodable {
  var difficulty: String
  var question: String
  var correctAnswer: String
  var incorrectAnswers: [String]
  var randomizedQuestions: [String] = []
  
  var total: Int {
    return 1 + incorrectAnswers.count
  }
  
  mutating func randomized() {
    var array: [String] = []
    array.append(contentsOf: incorrectAnswers)
    array.append(correctAnswer)
    
    randomizedQuestions = array.shuffled()
  }
  
  enum CodingKeys: String, CodingKey {
    case difficulty, question
    case correctAnswer = "correct_answer"
    case incorrectAnswers = "incorrect_answers"
  }
}

class QuizQuestionEntity {
  var difficulty: String
  var question: String
  var correctAnswer: String
  var incorrectAnswers: [String]
  var randomizedQuestions: [String] = []
  
  var total: Int {
    return 1 + incorrectAnswers.count
  }
  
  init(from quiz: QuizQuestion) {
    self.difficulty = quiz.difficulty
    self.question = quiz.question
    self.correctAnswer = quiz.correctAnswer
    self.incorrectAnswers = quiz.incorrectAnswers
    
    var array: [String] = []
    array.append(contentsOf: incorrectAnswers)
    array.append(correctAnswer)
    
    randomizedQuestions = array.shuffled()
  }
}

class Network: ObservableObject {
  
  func retrieveQuestions(forCategory category: Category,
                         difficulty: QuizDifficulty = .easy,
                         type: QuizType = .multipleChoice) -> AnyPublisher<[QuizQuestion], Never> {
      
      let url = URL(string: category.urlGenerator(difficulty: difficulty, type: type))
      
      let session = URLSession.shared
      let publisher = session.dataTaskPublisher(for: url!)
        .map { $0.data }
        .decode(type: QuizQuestionContainer.self, decoder: JSONDecoder())
        .map { $0.results }
        .replaceError(with: [])
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    
    return publisher
  }
}
