//
//  SplitController.swift
//  Pod Player
//
//  Created by ALLAN E JONES on 5/9/17.
//  Copyright © 2017 ALLAN E JONES. All rights reserved.
//

import Cocoa

class SplitController: NSSplitViewController {
    
    @IBOutlet weak var podcastsItem: NSSplitViewItem!
    @IBOutlet weak var episodesItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let podcastsVC = podcastsItem.viewController as? PodcastsViewController {
            if let episodeVC = episodesItem.viewController as? EpisodeViewController {
                podcastsVC.episodeVC = episodeVC
                episodeVC.podcastsVC = podcastsVC
                
            }
        }
    }
    
}
