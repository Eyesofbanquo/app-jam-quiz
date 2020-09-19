//
//  AppStorageKeys.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/19/20.
//

import Foundation

enum AppStorageKeys: String, RawRepresentable {
  
  case firstLaunch
  case prefferedDifficulty
  case continuousMode
  
  var key: String {
    return self.rawValue
  }
}
