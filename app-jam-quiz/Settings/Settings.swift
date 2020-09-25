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

  private static var difficulty = ["Easy", "Normal", "Hard"]
  
  private static var Title: String = "Settings"
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("GAMEPLAY")) {
          ContinuousButton
          InstantFeedback
          Difficulty
        }
        
        Section(header: Text("ABOUT")) {
          Version
        }
        
        Section {
         ResetSettings
        }
      }
      .background(BackgroundColor)
      .navigationTitle(Self.Title)
                   
    }
  }
  
  private var ContinuousButton: some View {
    Group {
      Toggle(isOn: .constant(false)) {
        Text("Continuous Mode")
      }
      
      Text("This mode allows you to keep playing until you've answered the minimum number of questions correctly. Currently disabled")
        .font(.caption2)
        .foregroundColor(Color(.lightGray))
    }
    
  }
  
  private var InstantFeedback: some View {
    Group {
      Toggle(isOn: $instantKey) {
        Text("Instant Feedback")
      }
      
      Text("Enabling this will allow for live grading while taking quizzes. This means you'll get feedback on each question the moment you answer it!")
        .font(.caption2)
        .foregroundColor(Color(.lightGray))
    }
  }
  
  private var Difficulty: some View {
    Group {
      Picker(selection: $difficultyIndex, label: Text("Preset Difficulty")) {
        ForEach(0 ..< Self.difficulty.count) {
          Text(Self.difficulty[$0])
        }
      }
      
      Text("This allows you to set a preferred difficulty mode.")
        .font(.caption2)
        .foregroundColor(Color(.lightGray))
    }
  }
  
  private var Version: some View {
    HStack {
      Text("Version")
      Spacer()
      Text("1.0.0")
    }
  }
  
  private var ResetSettings: some View {
    Group {
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
  
  private var BackgroundColor: some View {
    Rectangle()
      .edgesIgnoringSafeArea(.all)
      .foregroundColor(Color(ColorTheme.primary.rawValue))
  }
}
//
struct Settings_Previews: PreviewProvider {
  static var previews: some View {
    Previewer { Settings() }
  }
}
