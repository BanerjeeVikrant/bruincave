//
//  SeniorViewController.swift
//  bruincave
//
//  Created by user128030 on 7/27/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class SeniorViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet var postTableView: UITableView!
    
    var idArray = [Int]()
    var nameArray = [String]()
    var timeArray = [String]()
    var profilePictureArray = [String]()
    var captionArray = [String]()
    var postPictureArray = [String]()
    var likedByMeArray = [Int]()
    var likesCountArray = [Int]()
    var commentsCountArray = [Int]()
    
    @IBAction func searchUsers(_ sender: Any) {
        let searchUserVC = self.storyboard?.instantiateViewController(withIdentifier: "searchView") as! SWRevealViewController
        self.present(searchUserVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        var usernameSet: String = ""
        if(defaults.string(forKey: "username") != nil){
            usernameSet = defaults.string(forKey: "username")!
        }
        
        
        postTableView.estimatedRowHeight = 100
        postTableView.rowHeight = UITableViewAutomaticDimension
        
        sideMenus()
        
        //change tab picture
        self.tabBarController?.tabBar.items![3].selectedImage = UIImage(named: "seniorfilled")
        
        let myUrl = URL(string: "http://www.bruincave.com/m/android/bringposts.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "type=4&o=0&user="+usernameSet+"&group=0";
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            //Let's convert response sent from a server side script toa NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                if json != nil {
                    
                    if let postArray = json?["home"] as? NSArray {
                        for post in postArray{
                            if let postDict = post as? NSDictionary {
                                if let id = postDict.value(forKey: "id") {
                                    self.idArray.append(id as! Int)
                                }
                                if let name = postDict.value(forKey: "name") {
                                    self.nameArray.append(name as! String)
                                }
                                if let time = postDict.value(forKey: "time_added") {
                                    self.timeArray.append(time as! String)
                                }
                                if let profilepicturelink = postDict.value(forKey: "userpic") {
                                    self.profilePictureArray.append(profilepicturelink as! String)
                                }
                                if let caption = postDict.value(forKey: "body") {
                                    self.captionArray.append(caption as! String)
                                }
                                if let postPicture = postDict.value(forKey: "picture_added"){
                                    self.postPictureArray.append(postPicture as! String)
                                }
                                if let likedByMe = postDict.value(forKey: "likedByMe") {
                                    self.likedByMeArray.append(likedByMe as! Int)
                                }
                                if let likes = postDict.value(forKey: "likesCount") {
                                    self.likesCountArray.append(likes as! Int)
                                }
                                if let comments = postDict.value(forKey: "commentsCount"){
                                    self.commentsCountArray.append(comments as! Int)
                                }
                            }
                        }
                    }
                    
                    
                    OperationQueue.main.addOperation({
                        self.postTableView.reloadData()
                    })
                    
                    
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
    
    func tableView(_ postTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    
    func tableView(_ postTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "seniorcell") as! SeniorTableViewCell
        
        
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.dateLabel.text = timeArray[indexPath.row]
        cell.captionLabel.text = captionArray[indexPath.row]
        
        print(String(commentsCountArray[indexPath.row])+" "+String(indexPath.row))
        cell.commentsCountLabel.text = String(commentsCountArray[indexPath.row])
        
        cell.likesCountLabel.text = String(likesCountArray[indexPath.row])+" likes."
        
        if(likedByMeArray[indexPath.row] == 1){
            if let image = UIImage(named: "favoritefilled.png") {
                cell.likedByMeImage.setImage(image, for: .normal)
            }
        }else{
            if let image = UIImage(named: "favoriteoutlined.png") {
                cell.likedByMeImage.setImage(image, for: .normal)
            }
            
        }
        
        
        let imgURL = NSURL(string: profilePictureArray[indexPath.row])
        
        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.profileImage.image = UIImage(data: data! as Data)
        }
        
        let postimgURL = NSURL(string: postPictureArray[indexPath.row])
        
        if postimgURL != nil {
            let data = NSData(contentsOf: (postimgURL as URL?)!)
            
            //cell.postedImageView.image = UIImage(data:  data! as Data)
            let postedImage = UIImage(data:  data! as Data)
            if(postedImage != nil){
                cell.setPostedImage(image: postedImage!)
            }else{
                cell.postedImageView.image = nil
            }
        }
        
        if indexPath.row == self.idArray.count - 1 {
            self.loadMore()
        }
        
        return cell
    }
    
    // number of items to be fetched each time (i.e., database LIMIT)
    let itemsPerBatch = 50
    
    // Where to start fetching items (database OFFSET)
    var offset = 0
    
    // a flag for when all database items have already been loaded
    var reachedEndOfItems = false
    
    func loadMore() {
        /*
         // don't bother doing another db query if already have everything
         guard !self.reachedEndOfItems else {
         return
         }
         */
        let defaults = UserDefaults.standard
        var usernameSet: String = ""
        if(defaults.string(forKey: "username") != nil){
            usernameSet = defaults.string(forKey: "username")!
        }
        
        let myUrl = URL(string: "http://www.bruincave.com/m/android/bringposts.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        offset = offset + 5
        let postString = "type=4&o="+String(offset)+"&user="+usernameSet+"&group=0"
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            //Let's convert response sent from a server side script toa NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                if json != nil {
                    
                    if let postArray = json?["home"] as? NSArray {
                        for post in postArray{
                            if let postDict = post as? NSDictionary {
                                if let id = postDict.value(forKey: "id") {
                                    self.idArray.append(id as! Int)
                                }
                                if let name = postDict.value(forKey: "name") {
                                    self.nameArray.append(name as! String)
                                }
                                if let time = postDict.value(forKey: "time_added") {
                                    self.timeArray.append(time as! String)
                                }
                                if let profilepicturelink = postDict.value(forKey: "userpic") {
                                    self.profilePictureArray.append(profilepicturelink as! String)
                                }
                                if let caption = postDict.value(forKey: "body") {
                                    self.captionArray.append(caption as! String)
                                }
                                if let postPicture = postDict.value(forKey: "picture_added"){
                                    self.postPictureArray.append(postPicture as! String)
                                }
                                if let likedByMe = postDict.value(forKey: "likedByMe") {
                                    self.likedByMeArray.append(likedByMe as! Int)
                                }
                                if let likes = postDict.value(forKey: "likesCount") {
                                    self.likesCountArray.append(likes as! Int)
                                }
                                if let comments = postDict.value(forKey: "commentsCount"){
                                    self.commentsCountArray.append(comments as! Int)
                                }
                            }
                        }
                    }
                    
                    
                    OperationQueue.main.addOperation({
                        self.postTableView.reloadData()
                    })
                    
                    
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenus(){
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

}
