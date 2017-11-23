//
//  ViewController.swift
//  bruincave
//
//  Created by user128030 on 5/27/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    var username = ""
    var password = ""
    var loginError = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTF.delegate = self
        self.passwordTF.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        
        view.addGestureRecognizer(tap)
        
        let borderUsername = CALayer()
        let borderPassword = CALayer()
        let width = CGFloat(2.0)
        borderUsername.borderColor = UIColor.white.cgColor
        borderUsername.frame = CGRect(x: 0, y: usernameTF.frame.size.height - width, width: usernameTF.frame.size.width, height: usernameTF.frame.size.height)
        
        borderUsername.borderWidth = width
        usernameTF.layer.addSublayer(borderUsername)
        usernameTF.layer.masksToBounds = true
        
        borderPassword.borderColor = UIColor.white.cgColor
        borderPassword.frame = CGRect(x: 0, y: passwordTF.frame.size.height - width, width:  passwordTF.frame.size.width, height: passwordTF.frame.size.height)
        
        borderPassword.borderWidth = width
        passwordTF.layer.addSublayer(borderPassword)
        passwordTF.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        var usernameSet: String = ""
        let defaults = UserDefaults.standard
        
        if(defaults.string(forKey: "username") != nil || defaults.string(forKey: "username") != ""){
            usernameSet = defaults.string(forKey: "username")!
        }
        
        if(usernameSet != ""){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "homeView") as! SWRevealViewController
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func invokeLogin(_ sender: UIButton) {
        username = usernameTF.text!
        password = passwordTF.text!
        
        let myUrl = URL(string: "http://www.bruincave.com/m/ios/login.php");
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"// Compose a query string
        
        let postString = "usr="+username+"&psw="+password;
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            //Let's convert response sent from a server side script toa NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                if json != nil {
                    
                    if let postArray = json?["login"] as? NSArray {
                        for post in postArray{
                            if let postDict = post as? NSDictionary {
                                if let login = postDict.value(forKey: "loginError") {
                                    self.loginError = login as! Bool
                                    
                                    if(self.loginError == true){
                                        let defaults = UserDefaults.standard
                                        defaults.set(self.username, forKey: "username")
                                        
                                        var usernameSet: String = ""
                                        
                                        if(defaults.string(forKey: "username") != ""){
                                            usernameSet = defaults.string(forKey: "username")!
                                        }
                                        
                                        if(usernameSet != ""){
                                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "homeView") as! SWRevealViewController
                                            self.present(newViewController, animated: true, completion: nil)
                                        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}

