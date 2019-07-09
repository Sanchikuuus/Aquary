//
//  SettingsViewController.swift
//  Aquary
//
//  Created by Sashko Shel on 7/7/19.
//  Copyright © 2019 Sashko Shel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
	
    @IBOutlet weak var settilngTable: UITableView!
    @IBOutlet weak var dailyGoal: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let goal = UserDefaults.standard.integer(forKey: "dailyGoal")
		dailyGoal.text = String(goal)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		settilngTable.delegate = self
		settilngTable.dataSource = self
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
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "settingsIdentifier", for: indexPath)
		cell.textLabel?.text = "test"
		return cell
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
