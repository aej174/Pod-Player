//
//  EpisodeCell.swift
//  Pod Player
//
//  Created by ALLAN E JONES on 5/11/17.
//  Copyright © 2017 ALLAN E JONES. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView {

    @IBOutlet weak var pubDateLabel: NSTextField!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var webView: WKWebView!
        
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
