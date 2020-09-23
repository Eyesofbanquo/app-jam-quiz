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
import UIKit

struct Quiz: View {
    
  @Environment(\.colorScheme) var colorScheme
  
  @AppStorage(AppStorageKeys.prefferedDifficulty.key) var difficultyIndex: Int = 1
  
  @AppStorage(AppStorageKeys.instant.key) var instantKey: Bool = false
    
  var category: Category = .books
  
  var columns: [GridItem] = Array(repeating: .init(.flexible(),
                                                   alignment: .center), count: 2)
  
  let generator = UINotificationFeedbackGenerator()
  
  @State var cancellable: AnyCancellable?
  @State var currentQuestion: Int = 0
  @State var questions: [QuizQuestion] = []
  
  @State var questionsAnswered: [Int: Bool] = [:]
  
  @State private var equalHeight: CGFloat?
  @State private var equalLabelHeight: CGFloat?
  
  @ObservedObject private var network = Network()
  
  var colorPicker = ColorPicker()
  
  var cardAnimation: Namespace.ID
  
  var personalizedStreak: Int = 3
  
  @Binding var selectedCard: CardContent?
  
  @State private var showResults = false
  
  @State private var streak: Int = 0
  @State private var correctAnswers: Double = 0
  @State private var isCorrect: Bool?
  
  private static var AnswerLabels: [String] = [
  "A", "B", "C", "D"
  ]
  
  @State var quizTitle: String = ""
  
  
  var body: some View {
    ZStack {
      Color(.systemBackground)
        .matchedGeometryEffect(id: "card",
                               in: cardAnimation,
                               properties: [.size], isSource: true)
      
      VStack() {
        VStack {
          VStack {
            HStack {
              Text(category.rawValue)
                .font(.largeTitle)
                .bold()
                .foregroundColor(colorPicker.textColor(for: category, forScheme: colorScheme))
              Spacer()
              Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.prepare()
                impact.impactOccurred()
                withAnimation {
                  selectedCard = nil
                }
              }) {
                Text("Leave Quiz")
                  .foregroundColor(colorPicker.textColor(for: category, forScheme: colorScheme))
              }
              
            }
            
            if true {
              VStack {
                Group {
                  if let isCorrect = isCorrect, isCorrect == true {
                    Text("Correct!")
                  }
                  
                  if let isCorrect = isCorrect, isCorrect == false {
                    Text("Incorrect!")
                  }
                }
                .font(.headline)
                .foregroundColor(colorPicker.textColor(for: category, forScheme: colorScheme))
                .padding(.top)
                
                HStack {
                  ProgressView(value: (Double(currentQuestion) / Double(10)))
                    .progressViewStyle(LinearProgressViewStyle(tint: colorPicker.textColor(for: category, forScheme: colorScheme)))
                  Text("\(correctAnswers, specifier: "%.0f")/\(10)")
                    .font(.body)
                    .padding(.leading)
                    .foregroundColor(colorPicker.textColor(for: category, forScheme: colorScheme))
                }
                .padding()
              }
            }
          }
          .padding()
          .background(Color(category.colorName).edgesIgnoringSafeArea(.top))
          
          
          if questions.count > 0  {
            QuizContent(question: questions[currentQuestion])
              .animation(.default)
          }
        }
        
        if questions.count == 0 {
          Spacer()
          ProgressView()
            .scaleEffect(1.5)
            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
          
        }
        
        
        Spacer()
        
        Color(category.colorName)
          .edgesIgnoringSafeArea(.bottom)
          .frame(height: UIScreen.main.bounds.height * 0.05)
          .opacity(0.2)
        
      }
      
      if showResults {
        Results(category: category,
                showResults: $showResults,
                selectedCard: $selectedCard,
                resultsData: $questionsAnswered,
                streak: $streak)
          .transition(.move(edge: .trailing))
          .animation(.default)
          .zIndex(1.0)
      }
    }
    .onAppear(perform: {
      cancellable = network.retrieveQuestions(forCategory: category,
                                              difficulty: QuizDifficulty.getDifficulty(forIndex: difficultyIndex))
        .assign(to: \.questions, on: self)
    })
  }
  
  private var HeaderOverlay: some View {
    Group {
      if instantKey {
        EmptyView()
      }
    }
  }
  
  private func setNextQuestion() {
    guard currentQuestion + 1 < questions.count else {
      showResults.toggle()
      return
    }
    
    currentQuestion += 1
    equalHeight = nil
  }
  
  private func grade(
                     answerChoice choice: String,
                     at idx: Int) {
    let isCorrect = questions[currentQuestion].correctAnswer == choice
    questionsAnswered[currentQuestion] = isCorrect
    self.isCorrect = isCorrect
    
    withAnimation {
      if isCorrect {
        streak += 1
      } else {
        streak = 0
      }
    }
    
    
    if instantKey, isCorrect {
      withAnimation {
        correctAnswers += 1
        generator.prepare()
        generator.notificationOccurred(.success)
      }
    }
  }
  
  private func QuizContent(question: QuizQuestion) -> some View {
    var question = question
    question.randomized()
    var quizTitleBinding =  Binding<String>(get: {
      return quizTitle
    }, set: { val in
      DispatchQueue.main.async {
        quizTitle = val.convertHtml().string
      }
    })
    quizTitleBinding.wrappedValue = question.question

    return ScrollView(showsIndicators: false) {
      GroupBox(label: Text(quizTitleBinding.wrappedValue), content: {
        LazyVStack(alignment: .leading) {
          ForEach((0..<question.total), id: \.self) { idx in
            QuizButton(label: Self.AnswerLabels[idx], content: question.randomizedQuestions[idx]) {
              grade(answerChoice: question.randomizedQuestions[idx], at: idx)
            } next: {
              setNextQuestion()
            }
            .animation(.none)
          }
          .layoutPriority(1.0)
          
        }
        
      })
    }
    .padding()
  }
}

struct Quiz_Previews: PreviewProvider {
  @Namespace static var id
  static var previews: some View {
    Previewer {
      Quiz(category: Category.allCases.first!, questions: [
        QuizQuestion(difficulty: "easy", question: "How old am I", correctAnswer: "12", incorrectAnswers: ["1", "2", "3"]),
        QuizQuestion(difficulty: "easy", question: "How old are U", correctAnswer: "12", incorrectAnswers: ["1", "2", "3"])
      ], cardAnimation: id, selectedCard: Binding<CardContent?>(get: { return nil }, set: {_ in }))
    }
  }
}

