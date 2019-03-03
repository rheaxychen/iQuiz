//
//  Question View Controller.swift
//  iQuiz
//
//  Created by Rhea on 3/2/19.
//  Copyright © 2019 Rhea. All rights reserved.
//

import Foundation

class QuestionViewController: UIViewController {
	// UI Components
	@IBOutlet weak var questionLabel: UILabel!
	
	@IBOutlet weak var answer0: UIButton!
	@IBOutlet weak var answer1: UIButton!
	@IBOutlet weak var answer2: UIButton!
	@IBOutlet weak var answer3: UIButton!
	var answerButtons : [UIButton] = []
	
	// Variables
	var quizzes : [Quiz] = []
	var categoryIndex : Int = -1
	var currentQuestionIndex : Int = -1
	
	var selectedAnswer : Int = -1
	var currentAnswered : Int = 0
	var currentCorrect : Int = 0
	
	// Custom Interaction Helper functions
	func updateAnswerSelection(_ answerIdx : Int) {
		for ans in answerButtons { highlightAnswer(ans, highlighted: false) }
		highlightAnswer(answerButtons[answerIdx], highlighted: true)
	}
	
	func highlightAnswer(_ answerButt : UIButton, highlighted : Bool) {
		if highlighted {
			answerButt.layer.cornerRadius = 5.0
			answerButt.backgroundColor = UIColor.lightGray
			answerButt.setTitleColor(UIColor.black, for: .normal)
		} else {
			answerButt.backgroundColor = UIColor.white
			answerButt.setTitleColor(UIColor.darkGray, for: .normal)
		}
		
	}
	
	// Interaction Functions
	@IBAction func buttonPressed (_ sender : UIButton) {
		updateAnswerSelection(sender.tag)
		selectedAnswer = sender.tag
	}
	
	@IBAction func submitAnswer(_ sender: Any) {
		if selectedAnswer == -1 {
			let alert = UIAlertController(title: "No answer selected", message: "Please select an answer to move on", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
			
			self.present(alert, animated: true, completion: nil)
		} else {
			// perform segue
			performSegue(withIdentifier: "toAnswer", sender: self)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let answerView = segue.destination as! AnswerViewController
		answerView.quizzes = quizzes
		answerView.categoryIndex = categoryIndex
		
		answerView.currentQuestionIndex = currentQuestionIndex
		answerView.selectedAnswer = selectedAnswer
		answerView.currentAnswered = currentAnswered
		answerView.currentCorrect = currentCorrect
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		answerButtons = [answer0, answer1, answer2, answer3]
		
		// Set up data taken from previous screen
		let currQuestion : QuestionClass = quizzes[categoryIndex].questions[currentQuestionIndex]
		questionLabel.text = currQuestion.text
		
		for i in 0..<answerButtons.count {
			highlightAnswer(answerButtons[i], highlighted: false) // Reset style
			answerButtons[i].setTitle(currQuestion.answers[i], for: .normal)
		}
	}
	
}
