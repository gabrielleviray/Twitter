//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Gabrielle Viray on 9/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
    }

    // Method that calls API
    func loadTweet(){
        
        let tweet_url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 10]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweet_url, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll() // emptying list
            for tweet in tweets {
                self.tweetArray.append(tweet) // repopulate list
            }
            
            self.tableView.reloadData() // reload data with content
            
        }, failure: { (Error) in
            print("Could not retreive tweets! oh no!!")
        })
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout();self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "user_logged_in")
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        // Pull user
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let image_url = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: image_url!)
        
        if let image_data = data {
            cell.profileImageView.image = UIImage(data: image_data)
        }
        
        return cell
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }



}
