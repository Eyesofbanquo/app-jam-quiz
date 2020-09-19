//
//  Onboarding.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/19/20.
//

import Foundation
import SwiftUI

struct Onboarding: View {
  
  @Binding var firstLaunch: Bool
  
  @Environment(\.colorScheme) var colorScheme
  
  let content: [OnboardingListContent] = OnboardingListContent.allCases
  
  var body: some View {
    GeometryReader { proxy in
      VStack {
        Spacer()
        
        Header
        
        Spacer()
          .frame(height: 48.0)
        
        SubContent
          .padding(.horizontal)
          .padding(.horizontal)
        
        Spacer()
        
        Spacer()
        
        Spacer()
        
        
        Button(action: {
          self.firstLaunch = false
          
        }) {
          Text("Continue")
            .font(.body)
            .bold()
            .foregroundColor(.white)
        }
        .frame(minWidth: 0.0, maxWidth: proxy.frame(in: .global).width * 0.75)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12.0).foregroundColor(.green))

        
        Spacer()
          .frame(height: 8.0)
      }
    }
    .onDisappear {
      self.firstLaunch = false
    }
    
  }
  
  private var Header: some View {
    Text("Welcome to Qizzo")
      .font(.largeTitle)
      .bold()
  }
  
  private var SubContent: some View {
    VStack(alignment: .leading, spacing: 44.0) {
      ForEach(content, id: \.self) { item in
        listContentItem(item)
      }
    }
  }
  
  private func listContentItem(_ item: OnboardingListContent) -> some View {
    HStack(alignment: .center) {
      Image(item.imageName)
        .resizable()
        .renderingMode(.template)
        .foregroundColor(item.color(colorScheme: colorScheme))
        .aspectRatio(contentMode: .fit)
        .frame(width: 44.0, height: 44.0)
        .padding()
      
      VStack(alignment: .leading, spacing: 8.0) {
        Text(item.title)
          .font(.headline)
        Text(item.subtitle)
          .foregroundColor(colorScheme == .dark ? .secondary : .secondary)
      }
    }
  }
  
  private func SubContentItem(imageName: String = "play.fill",
                              title: String = "",
                              subtitle: String = "") -> some View {
    HStack(alignment: .center) {
      Image(imageName)
        .resizable()
        .renderingMode(.template)
        .foregroundColor(.red)
        .aspectRatio(contentMode: .fit)
        .frame(width: 44.0, height: 44.0)

      VStack(alignment: .leading, spacing: 8.0) {
        Text(title)
        Text(subtitle)
      }
    }
  }
}

struct Onboarding_Previews: PreviewProvider {
  static var binding: Bool = false
  static var bindingBinding = Binding<Bool> (
    get: {
      return binding
    },
    set: {
      binding = $0
    })
  static var previews: some View {
    Group {
      Onboarding(firstLaunch: bindingBinding)
      Onboarding(firstLaunch: bindingBinding).preferredColorScheme(.dark)
    }
  }
}
