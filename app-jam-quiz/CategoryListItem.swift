//
//  CategoryListItem.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/27/20.
//

import Foundation
import SwiftUI

struct CategoryListItem: View {
  
  var card: CardContent
  
  @Binding var selectedCard: CardContent?
  
  let impact = UIImpactFeedbackGenerator(style: .soft)
  
  @State private var scale: CGFloat = 1.0
  @State private var expand: Bool = false
  
  var body: some View {
    Image(card.category.image)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(width: UIScreen.main.bounds.width * 0.95)
      .scaleEffect(expand ? 1.2 : 1.0)
      .animation(Animation.easeOut(duration: 0.1))
      
      .scaleEffect(expand ? 1.0 : 1.2)
      .animation(Animation.easeIn(duration: 0.1).delay(0.1))
      .overlay(GeometryReader { geo in
        VStack {
          Spacer()
          Rectangle()
            .foregroundColor(card.color)
            .frame(height: geo.size.height * 0.35)
            .overlay(Overlay(card: card))
        }
      })
      .clipped()
      .cornerRadius(16.0)
      .onTapGesture {
        impact.prepare()
        expand = true
        withAnimation(.none) {
          expand = false
        }
        
        withAnimation(Animation.default.delay(0.1)) {
          impact.impactOccurred()
          selectedCard = card
        }
      }
  }
}

struct CategoryListItem_Previews: PreviewProvider {
  static var previews: some View {
    CategoryListItem(card: CardContent(category: .books), selectedCard: Binding<CardContent?>(get: { return nil }, set: { _ in }))
  }
}

extension CategoryListItem {
  private func Overlay(card: CardContent) -> some View {
    ScrollView(.vertical, showsIndicators: false) {
      HStack {
        VStack(alignment: .leading, spacing: 8.0) {
          OverlayTitle(card)
          OverlayBody(card)
          Spacer()
        }
        .padding()
        Spacer()
      }.foregroundColor(.white)
    }
  }
  
  private func OverlayTitle(_ card: CardContent) -> some View {
    Text(card.category.name)
      .font(.largeTitle)
      .bold()
  }
  
  private func OverlayBody(_ card: CardContent) -> some View {
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
  }
}
