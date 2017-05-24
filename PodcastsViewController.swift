//
//  PodcastsViewController.swift
//  Pod Player
//
//  Created by ALLAN E JONES on 5/8/17.
//  Copyright © 2017 ALLAN E JONES. All rights reserved.
//

import Cocoa

class PodcastsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var podcastURLTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!

    let ad = NSApplication.shared().delegate as? AppDelegate
    var podcasts : [Podcast] = []
    var episodeVC : EpisodeViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      /*  podcastURLTextField.stringValue = "http://www.espn.com/espnradio/podcast/feeds/itunes/podCast?id=2406595"  */
        
        getPodcasts()
    }
    
    func getPodcasts() {
        
        if let context = self.ad?.persistentContainer.viewContext {
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            do {
                podcasts = try context.fetch(fetchy)
                print(podcasts)
            }
            catch {}
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addPodcastClicked(_ sender: Any) {
        if let url = URL(string: podcastURLTextField.stringValue) {
            URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
                
                if error != nil {
                    print(error)
                } else {
                    if data != nil {
                        let parser = Parser()
                        let info = parser.getPodcastMetaData(data: data!)
                        
                        if !self.podcastExists(rssURL: self.podcastURLTextField.stringValue) {
                            if (self.ad?.persistentContainer.viewContext) != nil {
                                let context = self.ad?.persistentContainer.viewContext
                                let podcast = Podcast(context: context!)
                                podcast.rssURL = self.podcastURLTextField.stringValue
                                podcast.imageURL = info.imageURL
                                podcast.title = info.title
                                
                                self.ad?.saveAction(nil)
                                
                                self.getPodcasts()
                                
                                DispatchQueue.main.async {
                                    self.podcastURLTextField.stringValue = ""
                                }
                            }
                        }
                    }
                }
            }.resume()
           
        }
        
    }
    
    func podcastExists(rssURL: String) -> Bool {
        
        if let context = self.ad?.persistentContainer.viewContext {
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.predicate = NSPredicate(format: "rssURL == %@", rssURL)
            
            do {
                let matchingPodcasts = try context.fetch(fetchy)
                if matchingPodcasts.count >= 1 {
                    return true
                } else {
                    return false
                }
            }
            catch {}
        }
        
        return false
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.make(withIdentifier: "podcastCell", owner: self) as? NSTableCellView
        let podcast = podcasts[row]
        if podcast.title != nil {
            cell?.textField?.stringValue = podcast.title!
        } else {
            cell?.textField?.stringValue = "UNKNOWN TITLE"
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let podcast = podcasts[tableView.selectedRow]
            episodeVC?.podcast = podcast
            episodeVC?.updateView()
        }
    }
    
}
