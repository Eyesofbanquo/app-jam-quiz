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
  
  @AppStorage(AppStorageKeys.firstLaunch.key) var firstLaunch: Bool = true
  
  @AppStorage(AppStorageKeys.prefferedDifficulty.key) var difficultyIndex: Int = 1
  
  @AppStorage(AppStorageKeys.continuousMode.key) var continuousMode: Bool = false
  
  @AppStorage(AppStorageKeys.instant.key) var instantKey: Bool = false

  var difficulty = ["Easy", "Normal", "Hard"]
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("GAMEPLAY")) {
          Toggle(isOn: .constant(false)) {
            Text("Continuous Mode")
          }
          Text("This mode allows you to keep playing until you've answered the minimum number of questions correctly. Currently disabled")
            .font(.caption2)
            .foregroundColor(Color(.lightGray))
          
          Toggle(isOn: $instantKey) {
            Text("Instant Feedback")
          }
          Text("Enabling this will allow for live grading while taking quizzes. This means you'll get feedback on each question the moment you answer it!")
            .font(.caption2)
            .foregroundColor(Color(.lightGray))
          
          Picker(selection: $difficultyIndex, label: Text("Preset Difficulty")) {
            ForEach(0 ..< difficulty.count) {
              Text(self.difficulty[$0])
            }
          }
          Text("This allows you to set a preferred difficulty mode.")
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
            continuousMode = false
            difficultyIndex = 1
            instantKey = false
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
struct Settings_Previews: PreviewProvider {
  static var previews: some View {
    Previewer { Settings() }
  }
}
