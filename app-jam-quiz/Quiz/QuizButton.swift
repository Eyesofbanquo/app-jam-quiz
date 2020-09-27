//
//  QuizButton.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/22/20.
//

import Foundation
import SwiftUI

extension Text {
  func prepareRecolor(_ colorScheme: ColorScheme) -> some View {
    return Group {
      if colorScheme == .light {
        self.colorInvert()
      } else {
        self
      }
    }
    
  }
}

struct QuizButton: View {
  
  @Environment(\.colorScheme) var colorScheme
  
  @State var convertedLabel: String = ""
  @State var isCorrect: Bool = false
  @State var selectedChoice: Bool = false
  @State var labelFGColor: Color = Color(.label)
  @State var contentFGColor: Color = Color(.label)
  var upNext: Binding<Bool>
  var label: String
  var content: String
  var gradeAction: () -> Bool
  var next: () -> Void
  
  init(label: String,
       content: String,
       upNext: Binding<Bool>,
       gradeAction: @escaping () -> Bool,
       next: @escaping () -> Void) {
    self.label = label
    self.content = content
    self.gradeAction = gradeAction
    self.next = next
    self.upNext = upNext
  }
  
  var body: some View {
    
    let quizTitleBinding =  Binding<String>(get: {
      return convertedLabel
    }, set: { val in
      DispatchQueue.main.async {
        convertedLabel = val.convertHtml().string
      }
    })
    quizTitleBinding.wrappedValue = content
    
    return Button(action: {
      self.isCorrect = gradeAction()

      withAnimation(Animation.easeInOut.delay(0.75)) {
        selectedChoice = true
      }
      
        
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
        selectedChoice = false
        withAnimation {
          upNext.wrappedValue = true
        }
      }
    }) {
      HStack(alignment: .center) {
        Text(label)
          .lineLimit(nil)
          .padding(12.0)
          
          .foregroundColor(Color(.label))
          .colorMultiply(selectedChoice ? labelTextColor : Color(.black))
          .background(selectedChoice ? labelBackgroundColor : Color(.systemRed))
          .clipShape(Circle())
        
        Text(convertedLabel)
          .foregroundColor(Color(.label))
          .prepareRecolor(colorScheme)
          .colorMultiply(selectedChoice ? Color(.white) : Color(.label))
        Spacer()
      }
      .padding()
      .background(selectedChoice ? answerChoiceBackgroundColor : Color(.tertiarySystemBackground))
      .cornerRadius(16.0)
    }
    
  }
  
  private var answerChoiceBackgroundColor: Color {
    switch (isCorrect) {
      case false: return Color(.systemRed)
      case true: return Color(.systemGreen)
    }
  }
  
  private var answerChoiceTextColor: Color {
    switch (isCorrect) {
      default: return Color(.white)
    }
  }
  
  private var labelBackgroundColor: Color {
    switch (isCorrect) {
      default: return Color(.white)
    }
  }
  
  private var labelTextColor: Color {
    switch (isCorrect) {
      default: return Color(.systemBackground)
    }
  }
}

//struct QuizButton_Previews: PreviewProvider {
//  static var previews: some View {
//    QuizButton()
//  }
//}

