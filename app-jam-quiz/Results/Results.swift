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
      VStack {
        Spacer()
        
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
          Text("9 correct")
            .font(.body)
            .foregroundColor(Color(.systemGreen))
        })
        
        GroupBox(label:
                  HStack {
                    Image(systemName: "xmark.circle")
                    Text("Incorrect")
                  }
                  .foregroundColor(Color(.systemRed)), content: {
          Text("1 incorrect")
            .font(.body)
            .foregroundColor(Color(.systemRed))
        })
        
        GroupBox(label:
                  HStack {
                    Image(systemName: "clock")
                    Text("Time Spent")
                  }
                  .foregroundColor(Color(.systemBlue)), content: {
          Text("20 minutes")
            .font(.body)
            .foregroundColor(Color(.systemBlue))
        })
        
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }) {
          Image(systemName: "xmark")
            .font(.largeTitle)
            .foregroundColor(Color(.label))
        }
        .padding(.top)
        
        
        Spacer()
      }
      .padding(.horizontal)
      
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

