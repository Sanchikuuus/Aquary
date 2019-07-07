//
//  AddViewController.swift
//  Aquary
//
//  Created by Sashko Shel on 7/6/19.
//  Copyright © 2019 Sashko Shel. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
	
	@IBOutlet weak var drinkPicker: UIPickerView!
	@IBOutlet weak var volumePicker: UIPickerView!
	@IBOutlet weak var timePicker: UIDatePicker!
	
	let drinksList: [String] = ["water", "tea", "coffee"]
	let volumeList: [Int] = [30, 50, 100, 150, 200, 250]
	var pickedDrink = "water"
	var pickedVolume = 30
	var pickedTime: Date = Date()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		drinkPicker.delegate = self
		volumePicker.delegate = self
		drinkPicker.dataSource = self
		volumePicker.dataSource = self
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		timePicker.maximumDate = Date()
	}
	
    @IBAction func changedTimePicker(_ sender: UIDatePicker) {
		pickedTime = sender.date
    }
	
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let addState = History(context: context)
		addState.date = pickedTime
		addState.drink = pickedDrink
		addState.volume = Int16(pickedVolume)
		
		do {
			try context.save()
			print("saved: \(addState)")
		} catch let error {
			print("some error \(error)")
		}
		
		self.navigationController?.popViewController(animated: true)
	}
    
}

extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		if pickerView == drinkPicker {
			return 1
		} else if pickerView == volumePicker{
			return 1
		}
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == drinkPicker {
			return drinksList.count
		} else if pickerView == volumePicker{
			return volumeList.count
		}
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if pickerView == drinkPicker {
			return drinksList[row]
		} else if pickerView == volumePicker{
			return "\(volumeList[row]) ml"
		}
		return ""
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if pickerView == drinkPicker {
			pickedDrink = drinksList[row]
		} else if pickerView == volumePicker{
			pickedVolume = volumeList[row]
		}
	}
	
}

