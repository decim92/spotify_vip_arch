//
//  TrackDetailViewController.swift
//  spotifyvip
//
//  Created by Douglas Poveda on 10/29/17.
//  Copyright © 2017 Sundevs. All rights reserved.
//

import UIKit
import Alamofire

class TrackDetailViewController: UIViewController {
    
    var albumUrl:String!
    var trackName:String!
    var artists:[Artist]!
    var albumTitle:String!
    var duration:Int!
    var popularity:Int!
    var explicit:Bool!
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistsLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var explicitLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(albumUrl).responseData(completionHandler:{ (response) in
            self.albumImageView.image = UIImage(data: response.data!, scale:1)
            })
        trackNameLabel.text = trackName
        var artistText = ""
        var comma = ""
        for (index, artist) in artists.enumerated() {
            if index == artists.count - 1 && artists.count > 1 {
                comma = ", "
            } else {
                comma = ""
            }
            artistText = "\(artistText)\(comma)\(artist.name!)"
        }
        artistsLabel.text = artistText
        albumLabel.text = albumTitle
        let durationInMinutes = Float(duration!)/1000.0/60.0
        let seconds = (durationInMinutes - Float(Int(durationInMinutes))) * 60.0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: "\(Int(durationInMinutes)):\(Int(seconds))")
        if let date = date {
            let formattedDuration = dateFormatter.string(from: date)
            durationLabel.text = formattedDuration
        }
        popularityLabel.text = "\(popularity!)/100"
        explicitLabel.text = explicit == true ? "Yes" : "No"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
