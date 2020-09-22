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
  
  let cards: [CardContent] = Category.allCases.map { CardContent(category: $0)}
  
  @State var animateBubble: Bool = false
  
  @State var rotateSettingsIcon: Bool = false
  
  @State var bubbleTapped: Bool = false
  
  @State var launchSettings: Bool = false
  
  @State var selectedCard: CardContent?
  
  @State var cardDetailIsVisible = false
  
  @State var launchResults = false
  
  @State var launchQuiz = false
  
  @Namespace var cardAnimation
  
  var body: some View {
    ZStack(alignment: .center) {
      Background
        .sheet(isPresented: $firstTime, content: {
          Onboarding(firstLaunch: $firstTime)
        })
      
      VStack {
        CardStack(selectedCardAnimationID: cardAnimation,
                  cards: cards,
                  selectedCard: $selectedCard)
        
        Spacer()
          .frame(height: 8.0)
        
        GearIcon
        
        #if DEBUG
        Button(action: {
          self.launchResults.toggle()
        }) {
          Text("Launch results")
        }
        .sheet(isPresented: $launchResults) {
          Results(showResults: Binding<Bool>(
                    get: { return false}, set: { _ in }),
                  selectedCard: Binding<CardContent?>(get: { return nil }, set: {_ in }),
                  resultsData: Binding<[Int : Bool]>(
                      get: {
                        return [0: false, 1: true, 2: false, 3: true, 4: false, 5: true, 6: false, 7: true, 8: false, 9: true]
                      }, set: { _ in
                        
                      }))
        }
        #endif
        
        #if DEBUG
        Button(action: {
          self.launchQuiz.toggle()
        }) {
          Text("Launch Quiz")
        }
        .sheet(isPresented: $launchQuiz) {
          Quiz(cardAnimation: cardAnimation, selectedCard: $selectedCard)
        }
        #endif
      }
      
      if let selectedCard = selectedCard {
        // Put this in its own detail view
        Quiz(category: selectedCard.category,
             cardAnimation: cardAnimation,
             selectedCard: $selectedCard)
          .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .move(edge: .trailing)))
          .zIndex(1.0)
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
