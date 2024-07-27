//
//  MessagesViewController.swift
//  bratify MessagesExtension
//
//  Created by Mark Apinis on 7/24/24.
//

import UIKit
import Messages
import Foundation

class MessagesViewController: MSMessagesAppViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textEntry: UITextField!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var bratifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TextField Handling
    
    override func viewWillAppear(_ animated: Bool) {
        textEntry.delegate = self
        previewLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.3)
    }
    
    // close keyboard on "done"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // on editing begin, disable the bratify button
    @IBAction func textEntryEditBegin() {
        bratifyButton.isEnabled = false
    }
    
    // runs on change to text entry
    // edit the cover preview
    // reenable bratify button if there is text
    @IBAction func textEntryEditEnd() {
        if let text = textEntry.text, !text.isEmpty {
            previewLabel.text = text
            // enable button
            bratifyButton.isEnabled = true
        } else {
            previewLabel.text = "preview"
        }
    }
    
    
    // MARK: - Button Handling
        
    @IBAction func buttonPressed() {
        // Handles button press
        //  Make image
        //  Clear message
        //  Place image
        
        // only do any of this if there is an active conversation
        if let conversation = activeConversation {
            // Button is only enabled if editing is done, but just to make sure
            textEntry.resignFirstResponder()
            
            // make the image
            let image = preview.asImage()
            
            // get a unique URL in temp
            let fileName = "bratify-" + UUID().uuidString + ".jpg"
            guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName) else {
                print("Problem generating image URL")
                return
            }
            
            // get jpeg data, 0.4 compression for the style
            guard let jpegData = image.jpegData(compressionQuality: 0.01) else {
                print("No image data found, or other problem")
                return
            }
            
            // write it
            do {
                try jpegData.write(to: imageURL)
            } catch {
                print("Error writing jpegData to temporary file: \(error.localizedDescription)")
                return
            }
            
            // now we have a URL and image written to it, we can attach to conversation
            conversation.insertAttachment(imageURL, withAlternateFilename: fileName, completionHandler: {error in
                if let error = error {
                    print("Error attaching image: \(error.localizedDescription)")
                }
            })
        }
    }
}
