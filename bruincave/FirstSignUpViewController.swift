//
//  FirstSignUpViewController.swift
//  bruincave
//
//  Created by user128030 on 12/28/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class FirstSignUpViewController: UIViewController {

    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        let firstname: String = firstnameTF.text!
        let lastname: String = lastnameTF.text!
        
        if(firstname != "" && lastname != ""){
            let defaults = UserDefaults.standard
            defaults.set(firstname, forKey: "signupfirstname")
            defaults.set(lastname, forKey: "signuplastname")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "signup2") as! SWRevealViewController
            DispatchQueue.main.async(execute: {
                self.present(newViewController, animated: true, completion: nil)
            })
        }else{
            let refreshAlert = UIAlertController(title: "Error", message: "Please complete all the questions", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstSignUpViewController.dismissKeyboard))
        
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
