//
//  Results View Controller.swift
//  iQuiz
//
//  Created by Rhea on 3/2/19.
//  Copyright © 2019 Rhea. All rights reserved.
//

import Foundation

class ResultsViewController: UIViewController {
	// UI Components
	@IBOutlet weak var msgLabel: UILabel!
	@IBOutlet weak var finalScoreLabel: UILabel!
	
	
	// Variables
	var questionCount : Int = 0
	var finalCorrect : Int = 0
	
	
	@IBAction func closeQuizPressed(_ sender: Any) {
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		finalScoreLabel.text = "\(finalCorrect) of \(questionCount)"
		var resultMsg : String = ""
		switch questionCount - finalCorrect {
		case 0: resultMsg = "Perfect Score!"
		case 1: resultMsg = "So close!!"
		default: resultMsg = "Nice try..."
		}
		
		msgLabel.text = resultMsg
	}
}
