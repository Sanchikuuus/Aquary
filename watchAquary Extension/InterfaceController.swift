//
//  InterfaceController.swift
//  watchAquary Extension
//
//  Created by Sashko Shel on 7/9/19.
//  Copyright © 2019 Sashko Shel. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

	var session : WCSession!

    @IBOutlet var todayProgressLabel: WKInterfaceLabel!
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		if sessionSupported() {
			requestData()
		}
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		
		if sessionSupported() {
			requestData()
		}
    }
	
	private func sessionSupported() -> Bool {
		if WCSession.isSupported() {
			session = WCSession.default
			session.delegate = self
			session.activate()
			return true
		}
		return false
	}
	
	private func requestData() {
		session.sendMessage(["getData": true], replyHandler: nil, errorHandler: nil)
		print("FFFFFFFFFFFFFFFUUUUUUUUUUUUUUUUUU")
	}

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		
	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		
		print("here")
		
		let message = message["drinked"] as? String
		if let message = message {
			print(message)
			print("YES!!!!!!!")
			todayProgressLabel.setText(message)
		}

	}
	
	func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
		todayProgressLabel.setText("some trouble")
	}
	
}
