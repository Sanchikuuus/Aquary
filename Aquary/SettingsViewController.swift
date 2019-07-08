//
//  SettingsViewController.swift
//  Aquary
//
//  Created by Sashko Shel on 7/7/19.
//  Copyright © 2019 Sashko Shel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
	
	@IBOutlet weak var dailyGoal: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()
		let goal = UserDefaults.standard.integer(forKey: "dailyGoal")
		dailyGoal.text = String(goal)
	}
	
	@IBAction func dailyGoalChanged(_ sender: UITextField) {
		if let newText = sender.text {
			if newText == "" {
				sender.text = String(UserDefaults.standard.integer(forKey: "dailyGoal"))
			} else {
				UserDefaults.standard.set(Int(newText), forKey: "dailyGoal")
			}
		}
	}
}

extension UITextField{
	@IBInspectable var doneAccessory: Bool{
		get{
			return self.doneAccessory
		}
		set (hasDone) {
			if hasDone{
				addDoneButtonOnKeyboard()
			}
		}
	}
	
	func addDoneButtonOnKeyboard()
	{
		let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
		doneToolbar.barStyle = .default
		
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
		
		let items = [flexSpace, done]
		doneToolbar.items = items
		doneToolbar.sizeToFit()
		
		self.inputAccessoryView = doneToolbar
	}
	
	@objc func doneButtonAction()
	{
		self.resignFirstResponder()
	}
}
