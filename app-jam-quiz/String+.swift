//
//  String+.swift
//  app-jam-quiz
//
//  Created by Markim Shaw on 9/22/20.
//

import Foundation

extension String {
  
  init?(htmlEncodedString: String) {
    
    guard let data = htmlEncodedString.data(using: .utf8) else {
      return nil
    }
    
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ]
    
    guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
      return nil
    }
    
    self.init(attributedString.string)
    
  }
  
  func convert() -> String {
    return String(htmlEncodedString: self) ?? ""
  }
}

extension String {
  /// Converts HTML string to a `NSAttributedString`
  
  var htmlAttributedString: NSAttributedString? {
    return try? NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
  }
}


extension String {
  func convertHtml() -> NSAttributedString {
    guard let data = data(using: .utf8) else { return NSAttributedString() }
    
    if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
      return attributedString
    } else {
      return NSAttributedString()
    }
  }
}
