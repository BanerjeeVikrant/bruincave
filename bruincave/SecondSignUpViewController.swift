//
//  SecondSignUpViewController.swift
//  bruincave
//
//  Created by user128030 on 12/28/17.
//  Copyright © 2017 user128030. All rights reserved.
//

import UIKit

class SecondSignUpViewController: UIViewController  {
    
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yearClicked(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Year", message: "Choose your year", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Freshman", style: .default, handler: { (action: UIAlertAction!) in
            self.yearButton.setTitle("Freshman", for: .normal)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Sophomore", style: .default, handler: { (action: UIAlertAction!) in
            self.yearButton.setTitle("Sophomore", for: .normal)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Junior", style: .default, handler: { (action: UIAlertAction!) in
            self.yearButton.setTitle("Junior", for: .normal)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Senior", style: .default, handler: { (action: UIAlertAction!) in
            self.yearButton.setTitle("Senior", for: .normal)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func genderClicked(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Gender", message: "Choose what suits best", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Male", style: .default, handler: { (action: UIAlertAction!) in
            self.genderButton.setTitle("Male", for: .normal)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Female", style: .default, handler: { (action: UIAlertAction!) in
            self.genderButton.setTitle("Female", for: .normal)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let current_year: String = yearButton.currentTitle!
        let current_gender: String = genderButton.currentTitle!
        
        if(current_year != "Year" && current_gender != "Gender"){
            
            let defaults = UserDefaults.standard
            defaults.set(current_year, forKey: "signupyear")
            defaults.set(current_gender, forKey: "signupgender")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "signup3") as! SWRevealViewController
            
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
