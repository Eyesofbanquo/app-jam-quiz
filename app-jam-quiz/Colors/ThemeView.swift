//
//  ThemeView.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/19/20.
//

import Foundation
import SwiftUI

struct ThemeView: View {
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    ZStack(alignment: .center) {
      Rectangle()
        .edgesIgnoringSafeArea(.all)
        .setColorTheme(.primary)
      VStack {
        
        AccentGroup
        
        Divider()
        
        MainColorGroup
        
        Divider()
        
        ShapeGroup
        
        Divider()
        
        OnShapeGroup
        
      }.zIndex(1.0)
    }
  }
  
  private var AccentGroup: some View {
    Group {
      VStack {
        Text("Accent One")
          .setColorTheme(.accentOne)
        Text("Accent Two")
          .setColorTheme(.accentTwo)
      }
    }
  }
  private var MainColorGroup: some View {
    Group {
      Text("Primary")
        .setColorTheme(.primary)
      Text("Secondary")
        .setColorTheme(.secondary)
      Text("Tertiary")
        .setColorTheme(.tertiary)
      Text("White")
        .setColorTheme(.light)
    }
  }
  
  private var ShapeGroup: some View {
    
    func Item(_ theme: ColorTheme, textTheme: ColorTheme = .light) -> some View {
      HStack {
        RoundedRectangle(cornerRadius: 8.0)
          .frame(width: 20, height: 20)
          .setColorTheme(theme)
        Text("Text")
          .setColorTheme(textTheme)
      }
      
    }
    
    return Group {
      Item(.secondary, textTheme: .tertiary)
      Item(.tertiary, textTheme: .secondary)
      Item(.accentTwo, textTheme: .secondary)
      Item(.accentOne, textTheme: .tertiary)
    }
  }
  
  private var OnShapeGroup: some View {
    func Item(_ theme: ColorTheme, textTheme: ColorTheme = .light, scheme: ColorScheme = .light) -> some View {
      Group {
        Rectangle()
          .frame(minWidth: 0, maxWidth: .infinity)
          .frame(height: 44)
          .setColorTheme(theme)
          .overlay(Text("Text")
                    .setColorTheme(theme.compliment(colorScheme: scheme)))
      }
    }
    
    return Group {
      Item(.secondary, textTheme: .light, scheme: colorScheme)
      Item(.tertiary, textTheme: .light, scheme: colorScheme)
      Item(.accentTwo, textTheme: .secondary, scheme: colorScheme)
      Item(.accentOne, textTheme: .tertiary, scheme: colorScheme)
      Item(.light, textTheme: .secondary, scheme: colorScheme)
      Item(.primary, textTheme: .accentOne, scheme: colorScheme)
    }
  }
}

struct ThemeView_Previews: PreviewProvider {
  static var previews: some View {
    Previewer { ThemeView() }
  }
}
