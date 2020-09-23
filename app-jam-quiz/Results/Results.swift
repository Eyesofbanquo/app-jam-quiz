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

class Grader: ObservableObject {
  func numberCorrect(in resultsData: [Int: Bool]) -> Int {
    return resultsData.filter { $0.value == true }.count
  }
  func numberIncorrect(in resultsData: [Int: Bool]) -> Int {
    return resultsData.filter { $0.value == false }.count
  }
  func totalScore(in resultsData: [Int: Bool]) -> Float {
    floor(Float(numberCorrect(in: resultsData)) / Float(resultsData.count) * 100.0)
  }
  
}

struct Results: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  static var checkmark: Image = Image(systemName: "checkmark.circle")
  static var cross: Image = Image(systemName: "xmark.circle")
  
  var category: Category = .books
  
  @StateObject var grader: Grader = Grader()
  
  @Binding var showResults: Bool
  @Binding var selectedCard: CardContent?
  @Binding var resultsData: [Int: Bool]
  @Binding var streak: Int
  
  var body: some View {
    ZStack {
      Color(ColorTheme.primary.rawValue)
        .edgesIgnoringSafeArea(.all)
      NavigationView {
        VStack {
          GroupBox(label: Label("Your Score", systemImage: "square.and.pencil"), content: {
            Text("\(grader.totalScore(in: resultsData), specifier: "%.1f")%")
              .font(.largeTitle)
              .bold()
          })
          
          ScrollView {
            
            Data(title: "Correct",
                 metric: "\(grader.numberCorrect(in: resultsData))",
                 subtitle: "correct",
                 imageName: "checkmark.circle",
                 tint: Color(.systemGreen))
            
            Data(title: "Incorrect",
                 metric: "\(grader.numberIncorrect(in: resultsData))",
                 subtitle: "incorrect",
                 imageName: "xmark.circle",
                 tint: Color(.systemRed))
            
            Data(title: "Streak",
                 metric: "\(streak)",
                 subtitle: "in a row",
                 imageName: "flame",
                 tint: Color(.systemOrange))
            
            Data(title: "Time Spent",
                 metric: "Coming",
                 subtitle: "soon",
                 imageName: "clock",
                 tint: Color(.systemBlue))
          }
          

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
  
  private func Data(title: String, metric: String, subtitle: String, imageName: String, tint: Color) -> some View {
    GroupBox(label: HStack {
      Image(systemName: imageName)
      Text(title)
    }
    .foregroundColor(tint), content: {
      HStack(alignment: .firstTextBaseline, spacing: 4.0) {
        Text(metric)
          .font(.title)
          .bold()
          .foregroundColor(Color(.label))
        Text(subtitle)
          .font(.body)
          .foregroundColor(Color(.lightGray))
        Spacer()
      }
      .padding(.top)
    })
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
                  
                }), streak: Binding<Int>(get: { return 1}, set: { _ in }))
    }
  }
}

