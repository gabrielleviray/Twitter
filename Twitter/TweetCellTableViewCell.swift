//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Gabrielle Viray on 9/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    var favorited:Bool = false
    var tweetId:Int = -1
    var retweteed:Bool = false

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited
        if (toBeFavorited){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: {(error) in print("Favorite did not succeed: \(error)" )
                
            })
        } else{
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {self.setFavorite(false)}, failure: {(error) in print("Unfavorite did not succceed: \(error)" )
            })
        }
    }
    @IBAction func retweet(_ sender: Any) {
//        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
//            self.setRetweet(true)
//        }, failure: { (Error) in
//            print("Error is retweeting: \(Error)")
//        })
        let toBeRetweeted = !favorited
        if (toBeRetweeted){
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweet(true)
            }, failure: {(error) in print("Retweet did not succeed: \(error)" )
                
            })
        } else{
            TwitterAPICaller.client?.unretweet(tweetId: tweetId, success: {self.setRetweet(false)}, failure: {(error) in print("Retweet did not succceed: \(error)" )
            })
        }
    }
    
    
    func setFavorite(_ isFavorited: Bool){
        favorited = isFavorited
        if(favorited){
            favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        } else{
            favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweet(_ isRetweeted:Bool){
            if (isRetweeted){
                retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            } else {
                retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
//                retweetButton.isEnabled = true
            }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
