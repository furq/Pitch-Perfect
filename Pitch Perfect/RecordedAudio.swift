//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Khan, Furqan on 1/17/16.
//  Copyright © 2016 Khan, Furqan. All rights reserved.
//

import Foundation

class RecordedAudio {
  var filePathUrl: NSURL!
  var title: String!

  //constructor or initializer
  init (filePathUrl: NSURL, title: String) {
    self.filePathUrl = filePathUrl
    self.title = title
  }
}