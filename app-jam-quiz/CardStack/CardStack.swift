//
//  CardStack.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/20/20.
//

import Foundation
import SwiftUI

struct CardContent {
  var category: Category
  var color: Color {
    return Color(category.colorName)
  }
}

struct CardStack: View {
  @Environment(\.colorScheme) var colorScheme
  
  let cards: [CardContent] = Category.allCases.map { CardContent(category: $0)}
  var numberInStack: Int = 3
  
  @State private var dragAmount = CGSize.zero
  
  @State private var adjustScale = false
  
  @State private var fadeOverlay = false
  
  @State private var currentPosition = 0
    
  private static var width: CGFloat = UIScreen.main.bounds.width * widthPercentage
  private static var widthPercentage: CGFloat = 0.67
  private static var aspectRatio: CGFloat = 200/150
  private static var factor: CGFloat = 0.067
  private static var offset: CGFloat = 8.0
  
  
  
  var body: some View {
    ZStack(alignment: .center) {
      BottomCard
      
      CardList
      
      TopCard
    }
  }
  
  private var TopCard: some View {
    VStack {
      RoundedRectangle(cornerRadius: 16.0)
        .frame(width: Self.width, height: Self.width * Self.aspectRatio)
        .foregroundColor(cards[currentPosition].color)
        .offset(dragAmount)
        .opacity(adjustScale ? 0.0 : 1.0)
        .overlay(VStack {
          VStack(spacing: 8.0) {
            Image(systemName: cards[currentPosition].category.imageName)
              .font(.largeTitle)
              .foregroundColor(colorScheme == .light ? .white : .black)
            Text(cards[currentPosition].category.name)
              .font(.caption)
              .foregroundColor(colorScheme == .light ? .white : .black)
          }
          .offset(dragAmount)
          .opacity(fadeOverlay ? 0.0 : 1.0)
        })
        .gesture(DragGesture()
                  .onChanged { value in
                    self.dragAmount = value.translation
                    
                    if abs(value.translation.width) > 100  || abs(value.translation.height) > 100 {
                      withAnimation {
                        fadeOverlay = true
                        adjustScale = true
                      }
                    }
                  }
                  .onEnded { value in
                    self.dragAmount = .zero
                    adjustScale = false
                    
                    if abs(value.translation.width) > 100  || abs(value.translation.height) > 100 {
                      
                      if currentPosition + 1 == cards.count {
                        currentPosition = 0
                      } else {
                        currentPosition += 1
                      }
                      
                      withAnimation {
                        fadeOverlay = false
                      }
                      
                    }
                  })
    }
  }
  
  private var BottomCard: some View {
    RoundedRectangle(cornerRadius: 16.0)
      .frame(width: adjustScale ? calculateWidth(fromPosition: 2) :  calculateWidth(fromPosition: 3) , height: Self.width * Self.aspectRatio)
      .foregroundColor(adjustScale ?
                        cards[(currentPosition + 3) % cards.count].color :
                        cards[(currentPosition + 2) % cards.count].color)
      .scaleEffect(0.95)
      .opacity(adjustScale ? 1.0 : 0.0)
      .offset(y: adjustScale ? 24.0 : 32.0)
  }
  
  private var CardList: some View {
    ForEach((1..<numberInStack).reversed(), id: \.self) { idx in
      Card(position: idx,
           card: cards[(currentPosition + idx) % cards.count])
    }
  }
  
  private func Card(position: Int, card: CardContent) -> some View {
    RoundedRectangle(cornerRadius: 16.0)
      .frame(width: adjustScale ?
              calculateWidth(fromPosition: position - 1) :
              calculateWidth(fromPosition: position),
             height: Self.width * Self.aspectRatio)
      .foregroundColor(card.color)
      .scaleEffect(setScaleEffect(fromPosition: position-1))
      .offset(y: adjustScale ?
                self.calculateOffset(fromPosition: position-1) :
                self.calculateOffset(fromPosition: position))
  }
  
  private func calculateWidth(fromPosition pos: Int) -> CGFloat {
    switch pos {
      case 0: return Self.width
      default: return Self.width * (1-CGFloat(pos) * Self.factor)
    }
  }
  
  private func setScaleEffect(fromPosition pos: Int) -> CGFloat {
    switch pos {
      case 0: return self.adjustScale ? 1.0 : 0.95
      default: return 0.95
    }
  }
  private func calculateOffset(fromPosition pos: Int) -> CGFloat {
    switch pos {
      case 0: return 0.0
      case 1: return 16.0
      default:
        return Self.offset + (8.0 * CGFloat(pos))
    }
  }
  
  private func distance(fromPosition start: Int, to end: Int) -> Int {
    return start - end
  }
}

struct CardStack_Previews: PreviewProvider {
  static var previews: some View {
    Previewer {
      CardStack()
    }
  }
}

