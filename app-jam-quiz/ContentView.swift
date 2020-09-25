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
  
  @AppStorage(AppStorageKeys.instant.key) var instantKey: Bool = false
  
  let cards: [CardContent] = Category.allCases.map { CardContent(category: $0) }
    
  @State var launchSettings: Bool = false
  
  @State var launchInfo: Bool = false
  
  @State var selectedCard: CardContent?

  @Namespace var cardAnimation
  
  var body: some View {
    ZStack(alignment: .center) {
      Background
        .sheet(isPresented: $firstTime, content: {
          Onboarding(firstLaunch: $firstTime)
        })
      
      VStack(spacing: 0.0) {
        Spacer()
        Navbar(left: { Title }, right: { OptionsButton })
          .padding(.horizontal)
        CategoryList(cards: cards, selectedCard: $selectedCard)
          .padding(.bottom)
        Spacer()
          .frame(height: 8.0)
      }
      
      if let selectedCard = selectedCard {
        Quiz(category: selectedCard.category,
             cardAnimation: cardAnimation,
             selectedCard: $selectedCard)
          .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .move(edge: .trailing)))
          .zIndex(1.0)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Previewer {
      ContentView()
    }
  }
}

extension ContentView {
  private var Title: some View {
    Button(action: {
      launchInfo.toggle()
      let impact = UIImpactFeedbackGenerator(style: .medium)
      impact.prepare()
      impact.impactOccurred()
    }) {
      Text("Quizzo")
        .font(.largeTitle)
        .bold()
        .foregroundColor(Color(.label))
    }
    .sheet(isPresented: $launchInfo, content: {
      InfoView()
    })
  }
  
  private var Background: some View {
    Rectangle()
      .edgesIgnoringSafeArea(.all)
      .foregroundColor(colorScheme == .dark ? Color(.black) : Color(.white))
  }
  
  private var OptionsButton: some View {
    Button(action: {
      let impact = UIImpactFeedbackGenerator(style: .medium)
      impact.prepare()
      impact.impactOccurred()
      self.launchSettings = true
      
    }) {
      HStack(spacing: 8.0) {
        Image(systemName: "gear")
        Text("Options")
          .font(.subheadline)
        
      }
      .foregroundColor(Color(.label))
    }
    .sheet(isPresented: $launchSettings, content: {
      Settings()
    })
    .padding(.vertical)
    .contentShape(Rectangle())
    
  }
}
