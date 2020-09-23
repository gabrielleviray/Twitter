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
    var numOfTweets: Int!
    
    let refresh_control = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        refresh_control.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = refresh_control
        
    }

    // Method that calls API, gets triggered automatically when we load the scree and when the user pulls to refresh
    @objc func loadTweets(){
        
        numOfTweets = 20
        let tweets_url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweets_url, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll() // emptying list
            for tweet in tweets {
                self.tweetArray.append(tweet) // repopulate list
            }
            
            self.tableView.reloadData() // reload data with content
            self.refresh_control.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retreive tweets! oh no!!")
        })
        
    }
    
    func loadAdditionalTweets(){
        let tweets_url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numOfTweets = numOfTweets + 20
        let myParams = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweets_url, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll() // emptying list
            for tweet in tweets {
                self.tweetArray.append(tweet) // repopulate list
            }
            
            self.tableView.reloadData() // reload data with content
//            self.refresh_control.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retreive tweets! oh no!!")
        })
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row + 1 == tweetArray.count{
            loadAdditionalTweets()
        }
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
