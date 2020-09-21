//
//  Quiz.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/21/20.
//

extension String {
  func decoded() -> String? {
    guard let data = self.data(using: .utf8) else { return nil }
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
    let attString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    return attString?.string
  }
}

struct EqualHeightPreferenceKey: PreferenceKey {
  typealias Value = CGFloat
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    print(nextValue(), "toasted")
    value = nextValue()
  }
}

struct EqualHeight: ViewModifier {
  let height: Binding<CGFloat?>
  func body(content: Content) -> some View {
    content
      .frame(height: height.wrappedValue, alignment: .bottomLeading)
      .background(GeometryReader { proxy in
        Color.clear.preference(key: EqualHeightPreferenceKey.self, value: proxy.size.height)
      })
      .onPreferenceChange(EqualHeightPreferenceKey.self) { (value) in
        print(value)
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
  
  private static var AnswerLabels: [String] = [
  "A", "B", "C", "D"
  ]
  
  var body: some View {
    ZStack {
      Color(category.colorName)
        .edgesIgnoringSafeArea(.all)
      
      VStack(alignment: .leading) {
        Text("Name")
          .padding(.horizontal)
        
        if questions.count == 0 {
          ProgressView()
            .scaleEffect(1.5)
            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
          
        } else {
          QuizContent(question: questions[currentQuestion])
            .animation(.default)
        }
      }
      
      
      
      if showResults {
        Results(category: category,
                resultsData: $questionsAnswered)
          .transition(.move(edge: .trailing))
          .animation(.default)
          .zIndex(1.0)
      }
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
          .lineLimit(nil)
          .padding()
          .background(Color.red)
          .clipShape(Circle())
        Spacer()
      }, content: {
        VStack {
          Spacer()
          Text("\(content)")
            .multilineTextAlignment(.center)
            .equal($equalHeight)
          Spacer()
        }
        
      })
    }
    
    .foregroundColor(.black)
  }
  
  private func QuizContent(question: QuizQuestion) -> some View {
    var question = question
    question.randomized()
    
    return GroupBox(label: Text(question.question), content: {
      LazyVGrid(columns: columns, spacing: 10) {
        ForEach((0..<question.total), id: \.self) { idx in
          QuizButton(label: Self.AnswerLabels[idx], content: question.randomizedQuestions[idx], idx: idx)
        }
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

