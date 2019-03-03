//
//  QuizDataSource.swift
//  iQuiz
//
//  Created by Rhea on 3/2/19.
//  Copyright © 2019 Rhea. All rights reserved.
//

import Foundation
import UIKit

class QuizDataSource : NSObject, UITableViewDataSource
{
	var data : [Quiz] = []
	init(_ elements : [Quiz]) {
		data = elements
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "quizCatCell") as! MainCell
		
		let currData = data[indexPath.row]
		cell.quizName.text = currData.title
		cell.quizDesc.text = currData.desc
		cell.quizImg.image = currData.img
		
		return cell
	}
}
