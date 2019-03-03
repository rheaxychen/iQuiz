//
//  Answer View Controller.swift
//  iQuiz
//
//  Created by Rhea on 3/2/19.
//  Copyright © 2019 Rhea. All rights reserved.
//

import Foundation
import UIKit

class AnswerViewController: UIViewController {
	// UI Componenets
	@IBOutlet weak var ResultLabel: UILabel!
	@IBOutlet weak var UserAnswerLabel: UILabel!
	@IBOutlet weak var QuestionLabel: UILabel!
	@IBOutlet weak var CorrectAnswerLabel: UILabel!
	@IBOutlet weak var NextButton: UIButton!
	
	// Variables
	var quizzes : [Quiz] = []
	var categoryIndex : Int = -1
	var currentQuestionIndex : Int = -1
	
	var selectedAnswer : Int = -1
	var currentAnswered : Int = 0
	var currentCorrect : Int = 0
	var completedQuiz : Bool = false
	
	@IBAction func nextPressed(_ sender: Any) {
		if !completedQuiz { performSegue(withIdentifier: "toQuestion", sender: self) }
		else { performSegue(withIdentifier: "toResults", sender: self) }
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toQuestion" {
			let questionView = segue.destination as! QuestionViewController
			questionView.quizzes = quizzes
			questionView.categoryIndex = categoryIndex
			
			questionView.currentQuestionIndex = currentQuestionIndex
			questionView.currentAnswered = currentAnswered
			questionView.currentCorrect = currentCorrect
		} else if segue.identifier == "toResults" {
			let resultsView = segue.destination as! ResultsViewController
			resultsView.questionCount = currentAnswered
			resultsView.finalCorrect = currentCorrect
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let currQuestion : QuestionClass = quizzes[categoryIndex].questions[currentQuestionIndex]
		let answerIndex : Int = Int(currQuestion.answer)! - 1 // JSON answer is 1-indexed
		
		// Iteration
		currentQuestionIndex += 1
		currentAnswered += 1
		if selectedAnswer == answerIndex {
			ResultLabel.text = "You're right!"
			ResultLabel.textColor = #colorLiteral(red: 0.3210366907, green: 0.6404753093, blue: 0.1294117647, alpha: 1)
			currentCorrect += 1
		} else {
			ResultLabel.text = "Incorrect answer!"
			ResultLabel.textColor = UIColor.red
		}
		
		if currentQuestionIndex == quizzes[categoryIndex].questions.count {
			NextButton.setTitle("Check your results", for: .normal)
			completedQuiz = true
		}
		
		// Set UI Components
		QuestionLabel.text = currQuestion.text
		UserAnswerLabel.text = currQuestion.answers[selectedAnswer]
		CorrectAnswerLabel.text = currQuestion.answers[answerIndex]
		
		// Current Status
		print("")
		print("Status of the question just finished")
		print("Question #\(currentQuestionIndex)")
		print("Answered \(currentAnswered) questions")
		print("Got \(currentCorrect) correct")
	}
}
