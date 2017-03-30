//
//  ViewController.swift
//  Tumblr
//
//  Created by Krishna Alex on 3/29/17.
//  Copyright © 2017 Krishna Alex. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblrTableView: UITableView!

    var posts: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tblrTableView.delegate = self
        tblrTableView.dataSource = self
    
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.tblrTableView.reloadData()
                        //print(self.posts)
                    }
                }
        });
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tblrTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(self.posts.count)
        return self.posts.count
    }
    
    func tableView(_ tblrTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblrTableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell

        let post = self.posts[indexPath.row]
        if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageUrl = URL(string: imageUrlString!) {
                cell.photoImageView.setImageWith(imageUrl)
            }
        }
        else
        {
        }
        cell.photoLabel?.text = "This is row \(indexPath.row)"
        tblrTableView.rowHeight = 180
        return cell
    }
}

