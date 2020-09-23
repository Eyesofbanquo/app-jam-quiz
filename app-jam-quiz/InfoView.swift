//
//  InfoView.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/23/20.
//

import Foundation
import SwiftUI

struct InfoView: View {
  
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    ZStack {
      if colorScheme == .light {
        Color(ColorTheme.accentOne.rawValue)
          .ignoresSafeArea()
      }
      
      VStack(alignment: .leading) {
        Text("Powered by")
          .font(.title)
          .bold()
          .foregroundColor(colorScheme == .light ? Color(.systemOrange) : .white)
        Image("logo")
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
      .padding()
      .padding()
    }
    
  }
}

struct InfoView_Previews: PreviewProvider {
  static var previews: some View {
    Previewer {
      InfoView()
    }
  }
}

