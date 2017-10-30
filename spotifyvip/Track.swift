//
//  Track.swift
//  spotifyvip
//
//  Created by Douglas Poveda on 10/29/17.
//  Copyright © 2017 Sundevs. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Track {
    
    var id:String!
    var name:String!
    var duration:Int!
    var popularity:Int!
    var explicit:Bool!
    var album:Album!
    var artists:[Artist]!

    init(json:JSON) {
        id = json["id"].string!
        name = json["name"].string!
        duration = json["duration_ms"].int!
        popularity = json["popularity"].int!
        explicit = json["explicit"].bool!
        album = Album(json: json["album"])
        let artistsJSON = json["artists"].array!
        self.artists = artists(in: artistsJSON)
    }
    
    private func artists(in json: [JSON]) -> [Artist] {
        var artists = [Artist]()
        for artistJSON in json {
            let artist = Artist(json: artistJSON)
            artists.append(artist)
        }
        return artists
    }
}

struct Artist {
    var id:String!
    var name:String!
    
    init(json:JSON) {
        id = json["id"].string!
        name = json["name"].string!
    }
}

struct Album {
    var id:String!
    var name:String!
    var imagesUrls:[String]!
    
    init(json:JSON) {
        id = json["id"].string!
        name = json["name"].string!
        imagesUrls = imagesUrls(in: json["images"].array!)
    }
    
    private func imagesUrls(in json: [JSON]) -> [String] {
        var imagesUrls = [String]()
        for imageJSON in json {
            if let imageUrl = imageJSON.dictionary!["url"] {
                imagesUrls.append(imageUrl.string!)
            }
        }
        return imagesUrls
    }
    
}
