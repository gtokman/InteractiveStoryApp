//
//  ViewController.swift
//  InteractiveStory
//
//  Created by g tokman on 5/9/16.
//  Copyright © 2016 garytokman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	// MARK: - Error

	enum Error: ErrorType {
		case NoName
	}

	// MARK: - Properties

	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.kewboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}

	// MARK: - Navigtation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "StartAdventure" {
			do {
				if let name = nameTextField.text {
					if name == "" {
						throw Error.NoName
					}

					if let pageController = segue.destinationViewController as? PageController {
						pageController.page = Adventure.story("Gary")
					}
				}
			} catch Error.NoName {
				// Alert enter name in textfield
				let alertController = UIAlertController(title: "Name not provided", message: "Provide a name to start your story", preferredStyle: .Alert)
				let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
				alertController.addAction(action)

				// Present alert
				presentViewController(alertController, animated: true, completion: nil)
			} catch let error {
				fatalError("\(error)")
			}
		}
	}

	// MARK: - Notifaction observer

	func kewboardWillShow(notification: NSNotification) {
		// Set constant value of constraint to new value
		if let userInfoDict = notification.userInfo, keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
			// Got height of keyboard
			let keyboardFrame = keyboardFrameValue.CGRectValue()

			UIView.animateWithDuration(0.8) {
				self.textFieldBottomConstraint.constant = keyboardFrame.size.height + 10
				self.view.layoutIfNeeded()
			}
		}
	}

	func keyboardWillHide(notification: NSNotification) {
		// Set to orginal constraint value
		UIView.animateWithDuration(0.8) {
			self.textFieldBottomConstraint.constant = 40.0
			self.view.layoutIfNeeded()
		}
	}
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()

		return true
	}
}

