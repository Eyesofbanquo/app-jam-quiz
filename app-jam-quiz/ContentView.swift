//
//  ContentView.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/19/20.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.colorScheme) var colorScheme
  
  @AppStorage(AppStorageKeys.firstLaunch.key) var firstTime: Bool = true
  
  @AppStorage(AppStorageKeys.prefferedDifficulty.key) var difficultyIndex: Int = 1
  
  @AppStorage(AppStorageKeys.continuousMode.key) var continuousMode: Bool = false
  
  @State var animateBubble: Bool = false
  
  @State var rotateSettingsIcon: Bool = false
  
  @State var bubbleTapped: Bool = false
  
  @State var launchSettings: Bool = false
  
  var body: some View {
    ZStack(alignment: .center) {
      Background
        .sheet(isPresented: $firstTime, content: {
          Onboarding(firstLaunch: $firstTime)
        })
      
      VStack {
        CardStack()
        
        Spacer()
          .frame(height: 8.0)
        
        GearIcon
      }
    }.onAppear {
      withAnimation(Animation.easeOut(duration: 0.2)) {
        self.animateBubble = true
       
      }
      
      withAnimation(Animation.easeInOut(duration: 0.4).delay(0.5)) {
        self.rotateSettingsIcon = true
      }
    }
    
  }
  
  private var Background: some View {
    Rectangle()
      .edgesIgnoringSafeArea(.all)
      .setColorTheme(.primary)
  }
  
  private var GearIcon: some View {
    Image(systemName: "gear")
      .font(.title)
      .foregroundColor(rotateSettingsIcon ? Color(ColorTheme.tertiary.rawValue) : Color(ColorTheme.secondary.rawValue))
      .padding()
      .scaleEffect(rotateSettingsIcon ? 1.0 : 0.01)
      .rotationEffect(rotateSettingsIcon ? .degrees(360) : .degrees(0))
      .onTapGesture {
        print("tapped")
        self.launchSettings = true
      }
      .contentShape(Circle())
      .sheet(isPresented: $launchSettings, content: {
        Settings(firstLaunch: $firstTime,
                 storageDifficulty: $difficultyIndex,
                 storageContinuousMode: $continuousMode)
      })
  }
  private func complimentConverter(_ theme: ColorTheme) -> ColorTheme {
    theme.compliment(colorScheme: colorScheme)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Previewer {
      ContentView()
    }
  }
}
