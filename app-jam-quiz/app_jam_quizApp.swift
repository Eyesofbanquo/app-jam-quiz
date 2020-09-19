//
//  app_jam_quizApp.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/19/20.
//

import SwiftUI

@main
struct app_jam_quizApp: App {
  
  @AppStorage(AppStorageKeys.firstLaunch.key) var firstTime: Bool = true
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .sheet(isPresented: $firstTime, content: {
          Onboarding(firstLaunch: $firstTime)
        })
    }
  }
}
