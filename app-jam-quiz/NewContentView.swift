//
//  NewContentView.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/22/20.
//

import Foundation
import SwiftUI

struct CategoryList: View {
  @State private var currentPosition = 0
  @State private var dragAmount = CGSize.zero
  @State private var tapped: Bool = false
  @State private var untapped: Bool = false
  @State private var scaleValue: CGFloat = 1.0
  
  let cards: [CardContent]
  
  @Binding var selectedCard: CardContent?
  
  var body: some View {
    PageView
  }
  
  private var PageView: some View {
    TabView {
      ForEach((0..<cards.count), id: \.self) { idx in
        CategoryListItem(card: cards[idx], selectedCard: $selectedCard)
          .padding()
          .onTapGesture {
//            self.tapped = true
//            }
            
//            withAnimation(Animation.default.delay(1.0)) {
//              scaleValue = 0.5
//            }

//            withAnimation(Animation.default.delay(1.0)
//            ) {
//              untapped.toggle()
//            }
//            withAnimation(Animation.easeIn.delay(1.0)) {
//              tapped = false
//            }
//            withAnimation {
//              selectedCard = cards[idx]
//            }
          }
      }
    }
    .tabViewStyle(PageTabViewStyle())
    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
  }
}

struct CategoryList_Previews: PreviewProvider {
  static var selectedCard = Category.allCases.map { CardContent(category: $0)}.first!
  
  static var selectedCardBinding = Binding<CardContent?>(
    get: {
      return selectedCard
    }, set: {
      selectedCard = $0!
    })
  
  static var previews: some View {
    Previewer {
      CategoryList(cards:  Category.allCases.map { CardContent(category: $0)},
                   selectedCard: selectedCardBinding)
    }
  }
}
