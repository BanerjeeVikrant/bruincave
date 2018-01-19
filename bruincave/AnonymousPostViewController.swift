//
//  AnonymousPostViewController.swift
//  bruincave
//
//  Created by user128030 on 12/26/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class AnonymousPostViewController: UIViewController {
    
    @IBOutlet weak var postTF: UITextField!
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendAnonymousComment(_ sender: Any) {
        let defaults = UserDefaults.standard
        let username: String = defaults.string(forKey: "username")!
        
        let txt: String = postTF.text!
        
        let myUrl = URL(string: "http://www.bruincave.com/m/ios/postcrush.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        print(username)
        print(txt)
        
        let postString = "u="+username+"&post="+txt;
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            //Let's convert response sent from a server side script toa NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if json != nil {
                    
                    if let postArray = json?["info"] as? NSArray {
                        for post in postArray{
                            if let postDict = post as? NSDictionary {
                                if let successError: Bool = postDict.value(forKey: "successError") as? Bool {
                                    if(successError == true){
                                        
                                        DispatchQueue.main.async(execute: {
                                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                            
                                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "anonymousView")
                                            
                                            self.present(newViewController, animated: true, completion: nil)
                                        })
                                        
                                    }else{
                                        print("Inside success errror is false")
                                    }
                                }
                            }
                        }
                    }
                }
                
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
