//
//  Results.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/21/20.
//

import Foundation
import SwiftUI

struct ResultsGroupStyle: GroupBoxStyle {
  
  var color: Color
  
  func makeBody(configuration: Configuration) -> some View {
    GroupBox(label: HStack {
      configuration.label.foregroundColor(color)
      Spacer()
    }) {
      configuration.content.padding(.top)
    }
  }
  
}

struct Results: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  static var checkmark: Image = Image(systemName: "checkmark.circle")
  static var cross: Image = Image(systemName: "xmark.circle")
  
  var category: Category = .books
  
  @Binding var showResults: Bool
  @Binding var selectedCard: CardContent?
  @Binding var resultsData: [Int: Bool]
  
  var body: some View {
    ZStack {
      Color(ColorTheme.primary.rawValue)
        .edgesIgnoringSafeArea(.all)
      NavigationView {
        VStack {
          GroupBox(label: Label("Your Score", systemImage: "square.and.pencil"), content: {
            Text("\(totalScore(), specifier: "%.1f")%")
              .font(.largeTitle)
              .bold()
          })
          
          GroupBox(label: HStack {
            Image(systemName: "checkmark.circle")
            Text("Correct")
          }
          .foregroundColor(Color(.systemGreen)), content: {
            HStack(alignment: .firstTextBaseline, spacing: 4.0) {
              Text("\(numberCorrect())")
                .font(.title)
                .bold()
                .foregroundColor(Color(.label))
              Text("correct")
                .font(.body)
                .foregroundColor(Color(.lightGray))
              Spacer()
            }
            .padding(.top)
          })
          
          GroupBox(label:
                    HStack {
                      Image(systemName: "xmark.circle")
                      Text("Incorrect")
                    }
                    .foregroundColor(Color(.systemRed)), content: {
                      HStack(alignment: .firstTextBaseline, spacing: 4.0) {
                        Text("\(numberIncorrect())")
                          .font(.title)
                          .bold()
                          .foregroundColor(Color(.label))
                        Text("incorrect")
                          .font(.body)
                          .foregroundColor(Color(.lightGray))
                        Spacer()
                      }
                      .padding(.top)
                    })
          
          GroupBox(label:
                    HStack {
                      Image(systemName: "clock")
                      Text("Time Spent")
                    }
                    .foregroundColor(Color(.systemBlue)), content: {
                      HStack(alignment: .firstTextBaseline, spacing: 4.0) {
                        Text("20")
                          .font(.title)
                          .bold()
                          .foregroundColor(Color(.label))
                        Text("minutes")
                          .font(.body)
                          .foregroundColor(Color(.lightGray))
                        Spacer()
                      }
                      .padding(.top)
                      
                    })
          Spacer()
        }
        .navigationBarItems(trailing: Button(action: {
          selectedCard = nil
          presentationMode.wrappedValue.dismiss()
        }) {
          Image(systemName: "xmark")
            .font(.title)
            .foregroundColor(Color(.label))
            .clipShape(Rectangle())
        })
        .navigationTitle(Text("Results"))
        .padding(.horizontal)
        .padding(.top)
      }
      
      
    }
    
  }
  
  private func numberCorrect() -> Int {
    return resultsData.filter { $0.value == true }.count
  }
  private func numberIncorrect() -> Int {
    return resultsData.filter { $0.value == false }.count
  }
  private func totalScore() -> Float {
    ceil(Float(numberCorrect()) / Float(resultsData.count) * 100.0)
  }
}

struct Results_Previews: PreviewProvider {
  
  static var previews: some View {
    Previewer {
      Results(showResults: Binding<Bool>(
                get: { return false}, set: { _ in }),
              selectedCard: Binding<CardContent?>(get: { return nil }, set: {_ in }),
              resultsData: Binding<[Int : Bool]>(
                  get: {
                    return [0: false, 1: true, 2: false, 3: true, 4: false, 5: true, 6: false, 7: true, 8: false, 9: true]
                  }, set: { _ in
                    
                  }))
    }
  }
}

