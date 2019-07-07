//
//  StatisticTableViewController.swift
//  Aquary
//
//  Created by Sashko Shel on 7/6/19.
//  Copyright © 2019 Sashko Shel. All rights reserved.
//

import UIKit
import CoreData

class StatisticTableViewController: UITableViewController {

    var history: [History] = []
	
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var context: NSManagedObjectContext = NSManagedObjectContext()
	
	let fetchRequest = History.fetchRequest() as NSFetchRequest<History>
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		context = appDelegate.persistentContainer.viewContext
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		do {
			history = try context.fetch(fetchRequest)
			self.tableView.reloadData()
//			self.reloadInputViews()
		} catch let error {
			print("some error: \(error)")
		}
		
	}

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return history.count
    }
	
	private func getNiceDate(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm, EEEE, dd/MM/YYYY"
		return dateFormatter.string(from: date)
	}
		
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
		let index = history.count - indexPath.row - 1
		cell.textLabel!.text = "\(history[index].volume) mL of \(history[index].drink!)"
		cell.detailTextLabel!.text = getNiceDate(history[index].date!)
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
			let deleteData = history[indexPath.row]
			context.delete(deleteData)
			do {
				try context.save()
			} catch let error {
				print(error)
			}
			history.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
