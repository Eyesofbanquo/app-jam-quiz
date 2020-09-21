//
//  Quiz.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/21/20.
//

struct EqualHeightPreferenceKey: PreferenceKey {
  typealias Value = CGFloat
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

struct EqualHeight: ViewModifier {
  let height: Binding<CGFloat?>
  func body(content: Content) -> some View {
    content.frame(height: height.wrappedValue, alignment: .leading)
      .background(GeometryReader { proxy in
        Color.clear.preference(key: EqualHeightPreferenceKey.self, value: proxy.size.height)
      }).onPreferenceChange(EqualHeightPreferenceKey.self) { (value) in
        self.height.wrappedValue = max(self.height.wrappedValue ?? 0, value)
      }
  }
}

extension View {
  func equal(_ height: Binding<CGFloat?>) -> some View {
    return modifier(EqualHeight(height: height))
  }
}

import Foundation
import SwiftUI

struct Quiz: View {
  
  var category: Category
  
  var columns: [GridItem] = Array(repeating: .init(.flexible(),
                                                   alignment: .center), count: 2)
  
  @State private var equalHeight: CGFloat?
  
  var body: some View {
    ZStack {
      Color(category.colorName)
        .edgesIgnoringSafeArea(.all)
      
      GroupBox(label: Text("Hello"), content: {
        LazyVGrid(columns: columns, spacing: 10) {
          GroupBox(label: Text("yes"), content: {
            Text("Content\nContent\nContent")
              .equal($equalHeight)

          })
          GroupBox(label: Text("yes"), content: {
            Text("Content")
              .equal($equalHeight)

          })
          GroupBox(label: Text("yes"), content: {
            Text("Content")
              .equal($equalHeight)

          })
          GroupBox(label: Text("yes"), content: {
            Text("Content")
              .equal($equalHeight)

          })
          
        }
        
      })
      .padding()
    }
  }
}

struct Quiz_Previews: PreviewProvider {
  static var previews: some View {
    Quiz(category: Category.allCases.first!)
  }
}

