//
//  EpisodeViewController.swift
//  Pod Player
//
//  Created by ALLAN E JONES on 5/9/17.
//  Copyright © 2017 ALLAN E JONES. All rights reserved.
//

import Cocoa
import AVFoundation

class EpisodeViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var deleteButton: NSButton!    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var pausePlayButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var imageView: NSImageView!
    
    let ad = NSApplication.shared().delegate as? AppDelegate
    var podcastsVC : PodcastsViewController? = nil
    var podcast : Podcast? = nil
    var episodes : [Episode] = []
    var player : AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    func updateView() {
        
        if podcast?.title != nil {
            titleLabel.stringValue = podcast!.title!
        } else {
            titleLabel.stringValue = ""
        }
        if podcast?.imageURL != nil {
            let image = NSImage(byReferencing: URL(string: podcast!.imageURL!)!)
            imageView.image = image
        } else {
            imageView.image = nil
        }
        if podcast?.title != nil {
            tableView.isHidden = false
            deleteButton.isHidden = false
        } else {
            tableView.isHidden = true
            deleteButton.isHidden = true
        }
        
        pausePlayButton.isHidden = true
        
        getEpisodes()
    }
    
    func getEpisodes() {
        
        if podcast?.rssURL != nil {
            if let url = URL(string: podcast!.rssURL!) {
                URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
                    
                    if error != nil {
                        print(error)
                    } else {
                        if data != nil {
                            let parser = Parser()
                            self.episodes = parser.getEpisodes(data: data!)
                            DispatchQueue.main.async{
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }.resume()
            }
            
        }
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        
        if podcast != nil {
            if let context = self.ad?.persistentContainer.viewContext {
                context.delete(podcast!)
                ad?.saveAction(nil)
                podcastsVC?.getPodcasts()
            }
        }
        updateView()
    }
    
    @IBAction func pausePlayClicked(_ sender: Any) {
        if pausePlayButton.title == "Pause" {
            player?.pause()
            pausePlayButton.title = "Play"
        } else {
            player?.play()
            pausePlayButton.title = "Pause"
        }
        
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let episode = episodes[row]
        let cell = tableView.make(withIdentifier: "episodeCell", owner: self) as? EpisodeCell
        cell?.titleLabel.stringValue = episode.title
        cell?.webView.loadHTMLString(episode.htmlDescription, baseURL: nil)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d, yyyy"
        cell?.pubDateLabel.stringValue = dateformatter.string(from: episode.pubDate)
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let episode = episodes[tableView.selectedRow]
            if let url = URL(string: episode.audioURL) {
                player?.pause()
                player = nil
                player = AVPlayer(url: url)
                player?.play()
            }
            pausePlayButton.isHidden = false
            pausePlayButton.title = "Pause"
        }
    }
}

