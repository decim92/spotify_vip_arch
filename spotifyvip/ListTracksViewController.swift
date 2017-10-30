//
//  ListTracksViewController.swift
//  spotifyvip
//
//  Created by Douglas Poveda on 10/29/17.
//  Copyright © 2017 Sundevs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListTracksViewController: UIViewController {
    
    var token = ""
    var tracks = [Track]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let expirationTokenDate = UserDefaults.standard.value(forKey: "com.sundevs.expires_in") as? Date {
            if expirationTokenDate.compare(Date()) == .orderedAscending {
                let params: Parameters = ["grant_type": "client_credentials"]
                let authorization = "669360ac59124239bba5bd45849d84ee:175086c5a3d8457eb93c3c7c0c043a58".data(using: .utf8)
                if let authorization = authorization {
                    let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Basic \(String(describing: authorization.base64EncodedString()))"]
                    Alamofire.request("https://accounts.spotify.com/api/token", method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                        switch (response.result) {
                        case .success(_):
                            print("success")
                            if let data = response.result.value{
                                print(data)
                                let dictionary: [String: Any] = data as! [String: Any]
                                if let token = dictionary["access_token"] as? String {
                                    self.token = token
                                    UserDefaults.standard.set(token, forKey: "com.sundevs.authentication_token")
                                    if let refreshToken = dictionary["refresh_token"] as? String {
                                        UserDefaults.standard.set(refreshToken, forKey: "com.sundevs.refresh_token")
                                    }
                                    if let expirationTimeInSeconds = dictionary["expires_in"] as? Int {
                                        let expirationDate = Date().addingTimeInterval(TimeInterval(expirationTimeInSeconds))
                                        UserDefaults.standard.set(expirationDate, forKey: "com.sundevs.expires_in")
                                    }
                                } else {
                                    print("Error")
                                }
                            }
                        case .failure(_):
                            print("Error")
                        }
                    })
                }
            } else {
                self.token = UserDefaults.standard.value(forKey: "com.sundevs.authentication_token") as! String
            }
        } else {
            let params: Parameters = ["grant_type": "client_credentials"]
            let authorization = "669360ac59124239bba5bd45849d84ee:175086c5a3d8457eb93c3c7c0c043a58".data(using: .utf8)
            if let authorization = authorization {
                let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded", "Authorization": "Basic \(String(describing: authorization.base64EncodedString()))"]
                Alamofire.request("https://accounts.spotify.com/api/token", method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                    switch (response.result) {
                    case .success(_):
                        print("success")
                        if let data = response.result.value{
                            print(data)
                            let dictionary: [String: Any] = data as! [String: Any]
                            if let token = dictionary["access_token"] as? String {
                                self.token = token
                                UserDefaults.standard.set(token, forKey: "com.sundevs.authentication_token")
                                if let expirationTimeInSeconds = dictionary["expires_in"] as? Int {
                                    let expirationDate = Date().addingTimeInterval(TimeInterval(expirationTimeInSeconds))
                                    UserDefaults.standard.set(expirationDate, forKey: "com.sundevs.expires_in")
                                }
                            } else {
                                print("Error")
                            }
                        }
                    case .failure(_):
                        print("Error")
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func searchSongs() {
        if let query = searchBar.text {
            let encodedQuery:String = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            Alamofire.request("https://api.spotify.com/v1/search?q=\(encodedQuery)&type=track&market=US", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) in
                switch (response.result) {
                case .success(_):
                    print("success")
                    if let data = response.result.value{
                        let json = JSON(data)
                        print(json)
                        if let tracksJSON = json.dictionary?["tracks"]{
                            var tracks = [Track]()
                            if let itemsJSON = tracksJSON["items"].array {
                                for item in itemsJSON {
                                    let track = Track(json: item)
                                    tracks.append(track)
                                }
                                self.tracks = tracks
                                self.tableView.reloadData()
                            }
                        }
                    }
                case .failure(_):
                    print("Error")
                }
            })
        }
    }
}

extension ListTracksViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // to limit network activity, reload half a second after last key press.
        if (searchText.characters.count > 0) {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchSongs), object: nil)
            self.perform(#selector(searchSongs), with: nil, afterDelay: 0.3)
        }
    }
}

extension ListTracksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongSummaryCell") as! SongSummaryCell
        cell.nameLabel.text = tracks[indexPath.row].name
        cell.artistsLabel.text = tracks[indexPath.row].artists[0].name
        cell.albumLabel.text = tracks[indexPath.row].album.name
        
        return cell
    }
}
