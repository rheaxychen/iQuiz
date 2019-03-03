//
//  Results View Controller.swift
//  iQuiz
//
//  Created by Rhea on 3/2/19.
//  Copyright © 2019 Rhea. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {
	// UI Components
	@IBOutlet weak var FeedbackMsg: UILabel!
	@IBOutlet weak var FinalScoreLabel: UILabel!
	
	// Variables
	var questionCount : Int = 0
	var finalCorrect : Int = 0
	
	
	@IBAction func closeQuizPressed(_ sender: Any) {
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		FinalScoreLabel.text = "\(finalCorrect) of \(questionCount)"
		var resultMsg : String = ""
		switch questionCount - finalCorrect {
		case 0: resultMsg = "Perfect!"
		case 1: resultMsg = "Almost!!!"
		default: resultMsg = "Not bad!"
		}
		
		FeedbackMsg.text = resultMsg
	}
}
