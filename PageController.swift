//
//  PageControllerViewController.swift
//  InteractiveStory
//
//  Created by g tokman on 5/9/16.
//  Copyright © 2016 garytokman. All rights reserved.
//

import UIKit
import AudioToolbox

class PageController: UIViewController {
	// MARK: - Properties

	var page: Page?
	var sound: SystemSoundID = 0

	// MARK: - UI Properties

	let artwork = UIImageView()
	let storyLabel = UILabel()
	let firstChoiceButton = UIButton(type: .System)
	let secondChoiceButton = UIButton(type: .System)

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init(page: Page) {
		self.page = page
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .whiteColor()

		if let page = page {
			// Init artwork
			artwork.image = page.story.artwork

			// Init label with attributed string
			let attributedString = NSMutableAttributedString(string: page.story.text)

			let paragraphStyle = NSMutableParagraphStyle()
			paragraphStyle.lineSpacing = 10

			attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

			storyLabel.attributedText = attributedString

			// Init buttons
			if let firstChoice = page.firstChoice {
				firstChoiceButton.setTitle(firstChoice.title, forState: .Normal)
				firstChoiceButton.addTarget(self, action: #selector(PageController.loadFirstChoice), forControlEvents: .TouchUpInside)
			} else {
				firstChoiceButton.setTitle("Play Again?", forState: .Normal)
				firstChoiceButton.addTarget(self, action: #selector(PageController.playAgain), forControlEvents: .TouchUpInside)
			}

			if let secondChoice = page.secondChoice {
				secondChoiceButton.setTitle(secondChoice.title, forState: .Normal)
				secondChoiceButton.addTarget(self, action: #selector(PageController.loadSecondChoice), forControlEvents: .TouchUpInside)
			}
		}
	}

	override func viewWillLayoutSubviews() {
		// Add subview to viewcontrollers view
		view.addSubview(artwork)
		artwork.translatesAutoresizingMaskIntoConstraints = false

		// Contraints for artwork
		NSLayoutConstraint.activateConstraints([
			artwork.topAnchor.constraintEqualToAnchor(view.topAnchor),
			artwork.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
			artwork.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
			artwork.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
		])

		// Add label to subview
		view.addSubview(storyLabel)
		storyLabel.translatesAutoresizingMaskIntoConstraints = false
		storyLabel.numberOfLines = 0

		// Add label constraints
		NSLayoutConstraint.activateConstraints([
			storyLabel.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 16.0),
			storyLabel.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -16.0),
			storyLabel.topAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -48.0)
		])

		// Button constraints
		view.addSubview(firstChoiceButton)
		firstChoiceButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activateConstraints([
			firstChoiceButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
			firstChoiceButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -80.0)
		])

		view.addSubview(secondChoiceButton)
		secondChoiceButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activateConstraints([
			secondChoiceButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
			secondChoiceButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -32)
		])
	}

	// MARK: - Load new views

	func loadFirstChoice() {
		if let page = page, firstChoice = page.firstChoice {
			// Create new view controller with first choice
			let nextPage = firstChoice.page
			let pageController = PageController(page: nextPage)

			// Play sound
			playSound(nextPage.story.soundEffectURL)

			// Push onto navigation stack
			navigationController?.pushViewController(pageController, animated: true)
		}
	}

	func loadSecondChoice() {
		if let page = page, secondChoice = page.secondChoice {
			// Create new view controller with second choice
			let nextPage = secondChoice.page
			let pageController = PageController(page: nextPage)

			// Play sound
			playSound(nextPage.story.soundEffectURL)

			// Push on to navigation stack
			navigationController?.pushViewController(pageController, animated: true)
		}
	}

	func playAgain() {
		navigationController?.popViewControllerAnimated(true)
	}

	func playSound(url: NSURL) {
		AudioServicesCreateSystemSoundID(url, &sound)
		AudioServicesPlaySystemSound(sound)
	}
}
