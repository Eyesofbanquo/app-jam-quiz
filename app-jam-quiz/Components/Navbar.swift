//
//  Navbar.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/23/20.
//

import Foundation
import SwiftUI

struct Navbar<Header: View, Body: View>: View {
  
  let left: Header
  let right: Body
  
  init(@ViewBuilder left: () -> Header, @ViewBuilder right: () -> Body) {
    self.left = left()
    self.right = right()
  }
  
  var body: some View {
    HStack {
      left
      Spacer()
      right
    }
  }
}

struct Navbar_Previews: PreviewProvider {
  static var previews: some View {
    Previewer {
      Navbar(left: { Text("Left") }, right: { Text("Right") })
    }
  }
}

