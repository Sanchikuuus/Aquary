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
import WatchKit
import WatchConnectivity

class TodayViewController: UIViewController {
   
    @IBOutlet weak var goalLabel: UILabel!
	@IBOutlet weak var volumeLabel: UILabel!
	private var history: [History] = []
	private var todayDrinked: Int16 = 0
	private var session: WCSession!
	private var goal: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		_ = sessionSupported()
	}
	
	private func watchConnectionStatus() {
		print("isPaired",session.isPaired)
		print("session.isWatchAppInstalled",session.isWatchAppInstalled)
		print(session.watchDirectoryURL)
	}
	
	private func sessionSupported() -> Bool {
		if WCSession.isSupported() {
			session = WCSession.default
			session.delegate = self
			session.activate()
			watchConnectionStatus()
			return true
		}
		return false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		getDataFromCore()
		let today = getOnlyDate(from: Date())
		todayDrinked(by: today)
		getUserDefaults()
		updateUI()
	}
	
	private func getDataFromCore() {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = History.fetchRequest() as NSFetchRequest<History>
		do {
			history = try context.fetch(fetchRequest)
		} catch let error {
			print("some error: \(error)")
		}
	}
	
	private func getOnlyDate(from date: Date) -> String{
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-dd"
		return dateFormatter.string(from: date)
	}
	
	private func todayDrinked(by date: String) {
		todayDrinked = 0
		for i in 0..<history.count {
			let dateFromHistory = getOnlyDate(from: history[i].date!) // sorry ;)
			if dateFromHistory == date {
				todayDrinked += history[i].volume
			}
		}
	}
	
	private func getUserDefaults() {
		goal = UserDefaults.standard.integer(forKey: "dailyGoal")
		if goal == 0 {
			goal = 1000
			UserDefaults.standard.set(1000, forKey: "dailyGoal")
		}
	}
	
	private func updateUI() {
		let drinked: Double = Double(todayDrinked)/1000
		let percent = Int(100 * Double(todayDrinked) / Double(goal))
		volumeLabel.text = "\(drinked) L"
		goalLabel.text = "It's \(percent)% from your goal - \(Double(goal)/1000) L"
		
		sendDataToWatch()
	}
	
	private func sendDataToWatch() {
		session.sendMessage(["drinked": String(todayDrinked)], replyHandler: nil, errorHandler: nil)
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
		times.second = 20
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

extension TodayViewController: WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		watchConnectionStatus()
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
//
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
//
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		
		if (message["getData"] != nil) {
			sendDataToWatch()
		}
	}
	
}

