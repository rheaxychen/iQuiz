//
//  ViewController.swift
//  iQuiz
//
//  Created by Rhea on 2/28/19.
//  Copyright © 2019 Rhea. All rights reserved.
//

import UIKit
import SystemConfiguration

struct Category: Codable {
	let title: String
	let desc: String
	let questions: [Question]
}

struct Question: Codable {
	let text: String
	let answer: String
	let answers: [String]
}

class ViewController: UIViewController, UITableViewDelegate {
	@IBOutlet weak var mainTableView: UITableView!
	private let refreshControl = UIRefreshControl()
	
	
	var dataSource : QuizDataSource? = nil
	var quizRepo : QuizRepository = (UIApplication.shared.delegate as! AppDelegate).quizRepository
	var quizzes : [Quiz] = []
	
	// Data
	let defaults = UserDefaults.standard
	var jsonUrlString: String = UserDefaults().object(forKey: "fetch_url") as? String ?? "https://tednewardsandbox.site44.com/questions.json"
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("User selected row at \(indexPath)")
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		//check which cell is pressed, and send over data
		if let indexPath = mainTableView.indexPathForSelectedRow {
			let categoryIndex = indexPath.row
			let questionView = segue.destination as! QuestionViewController
			questionView.quizzes = quizzes
			questionView.categoryIndex = categoryIndex
			questionView.currentQuestionIndex = 0
		}
	}
	
	@IBAction func settingsTapped(_ sender: Any) {
		let alert = UIAlertController(title: "Settings", message: "Check from your own URL", preferredStyle: .alert)
		// Add Text Field
		alert.addTextField { (textField) in textField.placeholder = "Data URL" }
		alert.addAction(UIAlertAction(title: "Check now", style: .default, handler: { [weak alert] (_) in
			self.fetchJsonData(alert!.textFields![0].text!)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in return }))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		quizzes = quizRepo.getQuizzes()
		dataSource = QuizDataSource(quizzes)
		mainTableView.dataSource = dataSource
		mainTableView.delegate = self
		
		mainTableView.addSubview(refreshControl)
		refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if Reachability.isConnectedToNetwork(){
			// Internet Connection Available! Fetch new copy
			fetchJsonData(jsonUrlString)
		} else {
			if UserDefaults().object(forKey: "data") == nil {
				// Internet Connection not Available, please connect for the first time
				self.showDownloadFailed()
			} else {
				// No internet, using local data
				self.showUsingLocal()
				
				// Get data from saved userdefaults
				let data = UserDefaults().object(forKey: "data") as! Data
				let categories = try! JSONDecoder().decode([Category].self, from: data)
				let fetchedQuizzes : [Quiz] = self.convertJsonToQuizzes(categories)
				
				DispatchQueue.main.async{
					print(fetchedQuizzes)
					self.quizzes = fetchedQuizzes
					self.dataSource = QuizDataSource(self.quizzes)
					self.mainTableView.dataSource = self.dataSource
					self.mainTableView.reloadData()
				}
			}
		}
	}
	
	@objc private func refreshData(_ sender : Any) {
		jsonUrlString = UserDefaults().object(forKey: "fetch_url") as? String ?? "https://tednewardsandbox.site44.com/questions.json"
		print(jsonUrlString)
		if !Reachability.isConnectedToNetwork(){
			self.refreshControl.endRefreshing()
			showDownloadFailed()
		} else {
			fetchJsonData(jsonUrlString)
		}
	}
	
	func fetchJsonData(_ fetchUrl: String){
		let url = URL(string: fetchUrl)
		if url == nil {
			self.refreshControl.endRefreshing()
			self.showURLFailed();
		}
		else {
			URLSession.shared.dataTask(with: url!) { (data, res, err) in
				guard let data = data else {
					// No data to decode
					self.refreshControl.endRefreshing()
					self.showURLFailed()
					
					return
				}
				
				guard let categories = try? JSONDecoder().decode([Category].self, from: data) else {
					// Couldn't decode data into a Category
					self.refreshControl.endRefreshing()
					self.showURLFailed()
					
					return
				}
				
				UserDefaults.standard.set(data, forKey: "data") // Saved for offline use
				let fetchedQuizzes : [Quiz] = self.convertJsonToQuizzes(categories)
				
				DispatchQueue.main.async{
					print(fetchedQuizzes)
					self.quizzes = fetchedQuizzes
					self.dataSource = QuizDataSource(self.quizzes)
					self.mainTableView.dataSource = self.dataSource
					self.mainTableView.reloadData()
					
					// Stop the refresh control if needed
					print("new data!")
					self.refreshControl.endRefreshing()
				}
				}.resume()
		}
	}
	
	
	func convertJsonToQuizzes (_ cat : [Category]) -> [Quiz] {
		var returnQuizzes : [Quiz] = []
		for c in cat {
			var questionList : [QuestionClass] = []
			for q in c.questions {
				questionList.append(QuestionClass(text: q.text, answer: q.answer, answers: q.answers))
			}
			returnQuizzes.append(Quiz(title: c.title, desc: c.desc, questions: questionList))
		}
		
		return returnQuizzes
	}
	
	// Alerts
	func showURLFailed() {
		let alert = UIAlertController(title: "Download Failed", message: "Please check that the URL entered is a valid quiz database", preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	
	func showDownloadFailed() {
		let alert = UIAlertController(title: "Download Failed", message: "Please check your internet connection and try again later", preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func showUsingLocal() {
		let alert = UIAlertController(title: "No internet connection", message: "Using previously downloaded data for quizzes", preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
}

