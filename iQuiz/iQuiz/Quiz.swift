//
//  Quiz.swift
//  iQuiz
//
//  Created by Rhea on 3/2/19.
//  Copyright © 2019 Rhea. All rights reserved.
//

import Foundation
import UIKit

class Quiz {
	init(title: String, desc: String, questions: [QuestionClass]) {
		self.title = title
		self.desc = desc
//		self.img = [#imageLiteral(resourceName: "science.jpg"),#imageLiteral(resourceName: "marvel.jpg"),#imageLiteral(resourceName: "math.jpg")]
		self.img = #imageLiteral(resourceName: "math.jpg")
		self.questions = questions
	}
	
	var title = ""
	var desc = ""
	var img = UIImage()
//	var img = [UIImage]()
	var questions : [QuestionClass] = []
}

protocol QuizRepository {
	func getQuizzes() -> [Quiz]
}

class SimpleQuizRepository : QuizRepository {
	private static var _repo : QuizRepository? = nil
	
	static var theInstance : QuizRepository {
		get {
			if _repo == nil { _repo = SimpleQuizRepository() }
			return _repo!
		}
	}
	
	let localTestingData : [Quiz] = []
	
	
	func getQuizzes() -> [Quiz] {
		return localTestingData
	}
}
