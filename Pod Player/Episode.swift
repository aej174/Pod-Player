//
//  Episode.swift
//  Pod Player
//
//  Created by ALLAN E JONES on 5/10/17.
//  Copyright © 2017 ALLAN E JONES. All rights reserved.
//

import Cocoa

class Episode {
    
    var title = ""
    var htmlDescription = ""
    var audioURL = ""
    var pubDate = Date()
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }() 
}


