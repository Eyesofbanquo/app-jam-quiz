//
//  Quiz.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/21/20.
//

struct EqualHeightPreferenceKey: PreferenceKey {
  typealias Value = CGFloat
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

struct EqualHeight: ViewModifier {
  let height: Binding<CGFloat?>
  func body(content: Content) -> some View {
    content.frame(height: height.wrappedValue, alignment: .leading)
      .background(GeometryReader { proxy in
        Color.clear.preference(key: EqualHeightPreferenceKey.self, value: proxy.size.height)
      }).onPreferenceChange(EqualHeightPreferenceKey.self) { (value) in
        self.height.wrappedValue = max(self.height.wrappedValue ?? 0, value)
      }
  }
}

extension View {
  func equal(_ height: Binding<CGFloat?>) -> some View {
    return modifier(EqualHeight(height: height))
  }
}

import Combine
import Foundation
import SwiftUI

struct Quiz: View {
  
  var category: Category = .books
  
  var columns: [GridItem] = Array(repeating: .init(.flexible(),
                                                   alignment: .center), count: 2)
  
  @State var cancellable: AnyCancellable?
  @State var currentQuestion: Int = 0
  @State var questions: [QuizQuestion] = []
  
  @State var questionsAnswered: [Int: Bool] = [:]
  
  @State private var equalHeight: CGFloat?
  @State private var equalLabelHeight: CGFloat?
  
  @ObservedObject private var network = Network()
  
  @State private var showResults = false
  
  var body: some View {
    ZStack {
      Color(category.colorName)
        .edgesIgnoringSafeArea(.all)
      
      QuizContent(question: questions[currentQuestion])
        .animation(.default)
    }
    .onAppear(perform: {
      cancellable = network.retrieveQuestions(forCategory: category)
        .assign(to: \.questions, on: self)
    })
  }
  
  private func setNextQuestion() {
    guard currentQuestion + 1 < questions.count else {
      showResults.toggle()
      return
    }
    
    currentQuestion += 1
  }
  
  private func grade(
                     answerChoice choice: String,
                     at idx: Int) {
    questionsAnswered[idx] = questions[idx].correctAnswer == choice
  }
  
  private func QuizButton(label: String,
                          content: String,
                          idx: Int) -> some View {
    Button(action: {
      setNextQuestion()
      grade(answerChoice: content, at: idx)
    }) {
      GroupBox(label: HStack {
        Spacer()
        Text(label)
          .lineLimit(0)
          .padding()
          .background(Color.red)
          .equal($equalLabelHeight)
          .clipShape(Circle())
        Spacer()
      }, content: {
        Text(content)
          .equal($equalHeight)
      })
    }
    .foregroundColor(.black)
  }
  
  private func QuizContent(question: QuizQuestion) -> some View {
    GroupBox(label: Text(question.question), content: {
      LazyVGrid(columns: columns, spacing: 10) {
        QuizButton(label: "A", content: question.correctAnswer, idx: 0)
        QuizButton(label: "B", content: question.incorrectAnswers[0], idx: 1)
        QuizButton(label: "C", content: question.incorrectAnswers[1], idx: 2)
        QuizButton(label: "D", content: question.incorrectAnswers[2], idx: 3)
      }
      
    })
    .padding()
  }
}

struct Quiz_Previews: PreviewProvider {
  static var previews: some View {
    Quiz(category: Category.allCases.first!, questions: [
      QuizQuestion(difficulty: "easy", question: "How old am I", correctAnswer: "12", incorrectAnswers: ["1", "2", "3"]),
      QuizQuestion(difficulty: "easy", question: "How old are U", correctAnswer: "12", incorrectAnswers: ["1", "2", "3"])
    ])
  }
}

