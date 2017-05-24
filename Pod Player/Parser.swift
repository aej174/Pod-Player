//
//  Parser.swift
//  Pod Player
//
//  Created by ALLAN E JONES on 5/8/17.
//  Copyright © 2017 ALLAN E JONES. All rights reserved.
//

import Foundation

class Parser {
    
    func getPodcastMetaData(data:Data) -> (title:String?, imageURL:String?) {
     
        let xml = SWXMLHash.parse(data)
        //print(xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)
        
        return ((xml["rss"]["channel"]["title"].element?.text)!, (xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text))
    }
    
    func getEpisodes(data:Data) -> [Episode] {
        
        let xml = SWXMLHash.parse(data)
        
        var episodes : [Episode] = []
        
        for item in xml["rss"]["channel"]["item"] {
            let episode = Episode()
            
            if let title = item["title"].element?.text {
                episode.title = title
            }
            if let htmlDescription = item["description"].element?.text {
                episode.htmlDescription = htmlDescription
            }
            if let audioURL = item["enclosure"].element?.attribute(by: "url")?.text {
                episode.audioURL = audioURL
            }
            if let pubDate = item["pubDate"].element?.text {
                if let date = Episode.formatter.date(from: pubDate) {
                    episode.pubDate = date
                }
            }  
            episodes.append(episode)
            
        }
        
        return episodes
    }
        
}
