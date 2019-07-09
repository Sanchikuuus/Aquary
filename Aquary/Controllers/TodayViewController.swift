//
//  TodayViewController.swift
//  Aquary
//
//  Created by Sashko Shel on 7/6/19.
//  Copyright © 2019 Sashko Shel. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TodayViewController: UIViewController {
   
    @IBOutlet weak var goalLabel: UILabel!
	@IBOutlet weak var volumeLabel: UILabel!
	var history: [History] = []
	var todayDrinked: Int16 = 0

	override func viewDidLoad() {
		super.viewDidLoad()
	
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = History.fetchRequest() as NSFetchRequest<History>
		do {
			history = try context.fetch(fetchRequest)
		} catch let error {
			print("some error: \(error)")
		}
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-dd"
		let today = dateFormatter.string(from: Date())
		
		todayDrinked = 0
		for i in 0..<history.count {
			let date = dateFormatter.string(from: history[i].date!)
			if date == today {
				todayDrinked += history[i].volume
			}
		}
		
		let drinked: Double = Double(todayDrinked)/1000
		var goal = UserDefaults.standard.integer(forKey: "dailyGoal")
		if goal == 0 {
			goal = 1000
			UserDefaults.standard.set(1000, forKey: "dailyGoal")
		}
		let percent = Int(100 * Double(todayDrinked) / Double(goal))
		volumeLabel.text = "\(drinked) L"
		goalLabel.text = "It's \(percent)% from your goal - \(Double(goal)/1000) L"
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
//		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//		}
		sheduleNotification()
	}
	
	func sheduleNotification(type: String = "Don't forget to drink!") {
		let content = UNMutableNotificationContent()
		let toGetGoal = Double(UserDefaults.standard.integer(forKey: "dailyGoal") - Int(todayDrinked))/1000
		if toGetGoal > 0 {
			content.title = type
			content.body = "Just \(toGetGoal) L to get daily goal!"
		} else {
			content.title = "You reached goal today, but..."
			content.body = "you can More! Don't stop, keep going!"
		}

		content.sound = UNNotificationSound.default
		content.badge = 1
		
		var times = DateComponents()
		times.minute = 20
		let trigger = UNCalendarNotificationTrigger(dateMatching: times, repeats: true)
		let identifier = "LocalIdentificator"
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
		UNUserNotificationCenter.current().add(request) { (error) in
			if let error = error {
				print(error)
			}
		}
	}
	
}
