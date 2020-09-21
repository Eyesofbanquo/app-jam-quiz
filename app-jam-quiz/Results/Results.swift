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
  
  var body: some View {
    ZStack {
      Color(ColorTheme.primary.rawValue)
        .edgesIgnoringSafeArea(.all)
      NavigationView {
        VStack {
          GroupBox(label: Label("Your Score", systemImage: "square.and.pencil"), content: {
            Text("90%")
              .font(.largeTitle)
              .bold()
          })
          
          GroupBox(label: HStack {
            Image(systemName: "checkmark.circle")
            Text("Correct")
          }
          .foregroundColor(Color(.systemGreen)), content: {
            HStack(alignment: .firstTextBaseline, spacing: 4.0) {
              Text("9")
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
                        Text("1")
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
          presentationMode.wrappedValue.dismiss()
        }) {
          Image(systemName: "xmark")
            .font(.title)
            .foregroundColor(Color(.label))
        })
        .navigationTitle(Text("Results"))
        .padding(.horizontal)
        .padding(.top)
      }
      
      
    }
    
  }
}

struct Results_Previews: PreviewProvider {
  static var previews: some View {
    Previewer {
      Results()
    }
  }
}

