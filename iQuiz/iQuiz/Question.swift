//
//  Question.swift
//  iQuiz
//
//  Created by Rhea on 3/2/19.
//  Copyright © 2019 Rhea. All rights reserved.
//

import Foundation
import UIKit

class QuestionClass {
	init(text: String, answer: String, answers: [String]) {
		self.text = text
		self.answer = answer
		self.answers = answers
	}
	
	var text = ""
	var answer = ""
	var answers : [String] = []
}
