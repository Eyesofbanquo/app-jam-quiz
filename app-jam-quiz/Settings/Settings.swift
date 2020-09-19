//
//  Settigns.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/19/20.
//

import Foundation
import SwiftUI

struct Settings: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @Binding var firstLaunch: Bool
  
  @Binding var storageDifficulty: Int
  
  @Binding var storageContinuousMode: Bool

  var difficulty = ["Easy", "Normal", "Hard"]
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("GAMEPLAY")) {
          Toggle(isOn: $storageContinuousMode) {
            Text("Continuous Mode")
          }
          Text("This mode allows you to keep playing until you've answered the minimum number of questions correctly.")
            .font(.caption2)
            .foregroundColor(Color(.lightGray))
          Picker(selection: $storageDifficulty, label: Text("Preset Difficulty")) {
            ForEach(0 ..< difficulty.count) {
              Text(self.difficulty[$0])
            }
          }
          Text("This allows you to set a preferred difficulty setting.")
            .font(.caption2)
            .foregroundColor(Color(.lightGray))
        }
        
        Section(header: Text("ABOUT")) {
          HStack {
            Text("Version")
            Spacer()
            Text("1.0.0")
          }
        }
        
        Section {
          Button(action: {
            storageContinuousMode = false
            storageDifficulty = 1
            firstLaunch = true
            presentationMode.wrappedValue.dismiss()
          }) {
            Text("Reset All Settings")
          }
        }
      }
      .background(Rectangle()
                    .edgesIgnoringSafeArea(.all)
                    .foregroundColor(Color(ColorTheme.primary.rawValue)))
      .navigationTitle("Settings")
                   
    }
  }
  
}
//
//struct Settings_Previews: PreviewProvider {
//  static var previews: some View {
//    Previewer { Settings() }
//  }
//}
