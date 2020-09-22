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
  
  var cardAnimation: Namespace.ID
  
  @Binding var selectedCard: CardContent?
  
  @State private var showResults = false
  
  private static var AnswerLabels: [String] = [
  "A", "B", "C", "D"
  ]
  
  var body: some View {
    ZStack {
      Color(.systemBackground)
        .edgesIgnoringSafeArea(.all)
        .matchedGeometryEffect(id: "card",
                               in: cardAnimation,
                               properties: [.size], isSource: true)
      
      VStack() {

        Spacer()
          .frame(height: 8.0)

        
        VStack {
          Rectangle()
            .foregroundColor(Color(category.colorName))
            .frame(height: UIScreen.main.bounds.height * 0.2)
            .overlay(VStack {
              HStack {
                Text(category.rawValue)
                  .font(.largeTitle)
                  .bold()
                  .foregroundColor(Color(.black))
                Spacer()
                Text("Leave Quiz")
              }
              
              HStack {
                Image(systemName: "heart.fill")
                  .padding(.trailing)
                  .foregroundColor(.red)
                ProgressView()
                  .progressViewStyle(LinearProgressViewStyle(tint: .white))
                Text("\(currentQuestion)/\(10)")
                  .font(.body)
                  .padding(.leading)
                  .foregroundColor( { () -> Color in
                    switch (currentQuestion) {
                      case (0..<4): return Color.white
                      case (4..<7): return Color.orange
                      default: return Color.green
                    }
                  }())
              }
              .padding()
              Spacer()
            }.padding())
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
        
        HStack {
          Spacer()
          Button(action: {
            withAnimation {
              selectedCard = nil
            }
          }) {
            Text("Leave")
          }
          .foregroundColor(Color(.label))
          Spacer()
        }
        
        Color(category.colorName)
          .frame(height: UIScreen.main.bounds.height * 0.05)
          .edgesIgnoringSafeArea(.bottom)
          .opacity(0.2)
        
      }
      
      if showResults {
        Results(category: category,
                showResults: $showResults,
                selectedCard: $selectedCard,
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
    
    equalHeight = nil
    currentQuestion += 1
  }
  
  private func grade(
                     answerChoice choice: String,
                     at idx: Int) {
    questionsAnswered[currentQuestion] = questions[currentQuestion].correctAnswer == choice
  }
  
  private func QuizButton(label: String,
                          content: String,
                          idx: Int) -> some View {
    Button(action: {
      grade(answerChoice: content, at: idx)
      setNextQuestion()
    }) {
      GroupBox(label: HStack {
        Spacer()
        Text(label)
          .lineLimit(nil)
          .padding(12.0)
          .background(Color.red)
          .clipShape(Circle())
        Spacer()
      }, content: {
        VStack {
          Text("\(content)")
            .foregroundColor(Color(.label))
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

