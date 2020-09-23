//
//  QuizButton.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/22/20.
//

import Foundation
import SwiftUI

struct QuizButton: View {
  
  @State var convertedLabel: String = ""
  var label: String
  var content: String
  var gradeAction: () -> Void
  var next: () -> Void
  
  init(label: String,
       content: String,
       gradeAction: @escaping () -> Void,
       next: @escaping () -> Void ) {
    self.label = label
    self.content = content
    self.gradeAction = gradeAction
    self.next = next
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
      gradeAction()
      next()
    }) {
      GroupBox(label: HStack(alignment: .center) {
        Text(label)
          .lineLimit(nil)
          .padding(12.0)
          .background(Color.red)
          .clipShape(Circle())
        Text(quizTitleBinding.wrappedValue)
          .foregroundColor(Color(.label))
        Spacer()
      }, content: {
        
      })
    }
    
    .foregroundColor(.black)
  }
}

//struct QuizButton_Previews: PreviewProvider {
//  static var previews: some View {
//    QuizButton()
//  }
//}

