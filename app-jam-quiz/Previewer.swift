//
//  Previewer.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/19/20.
//

import Foundation
import SwiftUI

struct Previewer<Content: View>: View {
  
  let content: Content
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    Group {
      content
      content.preferredColorScheme(.dark)
    }
  }
}
