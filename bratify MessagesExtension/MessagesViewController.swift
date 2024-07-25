//
//  MessagesViewController.swift
//  bratify MessagesExtension
//
//  Created by Mark Apinis on 7/24/24.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textEntry: UITextField!
    @IBOutlet weak var previewText: UITextView!
    @IBOutlet weak var preview: UIView! // TODO: - Use this to generate image
    @IBOutlet weak var bratifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TextField Handling
    
    override func viewWillAppear(_ animated: Bool) {
        textEntry.delegate = self
        previewText.transform = CGAffineTransform(scaleX: 1.0, y: 1.3)
    }
    
    // close keyboard on "done"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // runs on change to text entry
    // edut the cover preview
    @IBAction func textEntryChanged() {
        if let text = textEntry.text, !text.isEmpty {
            previewText.text = text.lowercased()
        } else {
            previewText.text = "preview"
        }
    }
    
    
    // MARK: - Button Handling
        
    @IBAction func buttonPressed() {
        // Handles button press
        //  Get current message
        //  Make image
        //  Clear message
        //  Place image
       
        if let conversation = activeConversation {
            if let text = textEntry.text {
                conversation.insertText(text, completionHandler: {error in
                    if let error = error {
                        print("Error inserting text: \(error.localizedDescription)")
                    }
                })
            }
        }
    }
    
    
}
