//
//  ThirdSignUpViewController.swift
//  bruincave
//
//  Created by user128030 on 12/28/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class ThirdSignUpViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordAgainTF: UITextField!
    
    var loginError: Bool = false
    
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        let defaults = UserDefaults.standard
        let firstname = defaults.string(forKey: "signupfirstname")
        let lastname = defaults.string(forKey: "signuplastname")
        let year = defaults.string(forKey: "signupyear")
        let gender = defaults.string(forKey: "signupgender")
        let username: String = usernameTF.text!
        let password: String = passwordTF.text!
        let passwordAgain: String = passwordAgainTF.text!
        
        if(firstname != "" && lastname != "" && year != "Year" && gender != "Gender" && username != ""){
            if(password == passwordAgain){
                let myUrl = URL(string: "http://www.bruincave.com/m/ios/register.php");
                
                var request = URLRequest(url:myUrl!)
                
                request.httpMethod = "POST"// Compose a query string
                
                let postString2 = "fn="+firstname!+"&ln="+lastname!
                let postString1 = postString2+"&usr="+username
                let postString = postString1+"&psw="+password+"&grade="+year!
                
                request.httpBody = postString.data(using: String.Encoding.utf8);
                
                let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                    
                    
                    //Let's convert response sent from a server side script toa NSDictionary object:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        
                        if json != nil {
                            
                            if let postArray = json?["register"] as? NSArray {
                                for post in postArray{
                                    if let postDict = post as? NSDictionary {
                                        if let login = postDict.value(forKey: "loginError") {
                                            self.loginError = login as! Bool
                                            
                                            if(self.loginError == true){
                                                let defaults = UserDefaults.standard
                                                defaults.set(username, forKey: "username")
                                                
                                                if defaults.string(forKey: "username") != nil {
                                                    print("username exists:",defaults.object(forKey: "username") as Any)
                                                    self.changeStoryBoard()
                                                    
                                                } else {
                                                    print(defaults.object(forKey: "username") as Any)
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
            }else{
                let refreshAlert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                    
                }))
                
                present(refreshAlert, animated: true, completion: nil)
            }
        }else{
            let refreshAlert = UIAlertController(title: "Error", message: "Please complete all the questions", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func changeStoryBoard() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "homeView") as! SWRevealViewController
        DispatchQueue.main.async(execute: {
            self.present(newViewController, animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ThirdSignUpViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
