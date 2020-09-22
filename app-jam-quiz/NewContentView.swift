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
  
  let cards: [CardContent]
  @Binding var selectedCard: CardContent?
  
  var body: some View {
    PageView
  }
  
  private func Item(_ card: CardContent) -> some View {
    Image(card.category.image)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: UIScreen.main.bounds.width * 0.95)
      
      .overlay(GeometryReader { geo in
        VStack {
          Spacer()
          Rectangle()
            .foregroundColor(card.color)
            .frame(height: geo.size.height * 0.35)
            .overlay(
              HStack {
                VStack(alignment: .leading, spacing: 8.0) {
                  Text(card.category.name)
                    .font(.largeTitle)
                    .bold()
                  VStack(alignment: .leading) {
                    HStack(spacing: 2.0) {
                      HStack(spacing: 1.0) {
                        Image(systemName: "lightbulb.fill")
                          .font(.subheadline)
                        Text("Test your knowledge")
                          .font(.subheadline)
                          .bold()
                      }
                      .foregroundColor(Color(.systemYellow))
                    }
                    Text(card.category.description)
                      .font(.subheadline)
                  }
                  
                  
                  Spacer()
                }.padding()
                Spacer()
                
              }.foregroundColor(.white))
        }
      })
      .clipped()
      .cornerRadius(16.0)
  }
  
  private var PageView: some View {
    TabView {
      ForEach((0..<cards.count), id: \.self) { idx in
        Item(cards[idx])
          .padding()
          .onTapGesture {
            withAnimation {
              selectedCard = cards[idx]
            }
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
