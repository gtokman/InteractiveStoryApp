//
//  ViewController.swift
//  InteractiveStory
//
//  Created by g tokman on 5/9/16.
//  Copyright © 2016 garytokman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let story = Page(story: .TouchDown)
		story.firstChoice = (title: "Title", page: Page(story: .Droid))
	}

	// MARK: - Navigtation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "StartAdventure" {
			if let pageController = segue.destinationViewController as? PageController {
				pageController.page = Adventure.story
			}
		}
	}
    

}

