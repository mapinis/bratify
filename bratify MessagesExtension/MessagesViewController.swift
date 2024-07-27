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
    @IBOutlet weak var previewText: UITextView!
    @IBOutlet weak var preview: UIView!
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
    
    // on editing begin, disable the bratify button
    @IBAction func textEntryEditBegin() {
        bratifyButton.isEnabled = false
    }
    
    // runs on change to text entry
    // edit the cover preview
    // reenable bratify button if there is text
    @IBAction func textEntryEditEnd() {
        if let text = textEntry.text, !text.isEmpty {
            let oldText = previewText.text!
            previewText.text = text.lowercased()
            
            // font size control
            let font = previewText.font
            // if the new text is longer than the old text, decrease size as needed (down to 1)
            if var font = font {
                if text.count >= oldText.count {
                    while font.pointSize > 1 && previewText.bounds.height > preview.bounds.height - 25 {
                        // while pointSize is greater than 1 and contentSize is too large
                        // get new font with smaller size and set it
                        font = font.withSize(font.pointSize - 1)
                        previewText.font = font
                    }
                } else {
                    // if the new text is shorter than the old text, increase size as needed (up to 42)
                    while font.pointSize < 42 && previewText.bounds.height <= preview.bounds.height - 25 {
                        // while pointSize is less than 42 and contentSize fits
                        // get new font with bigger size and set it
                        font = font.withSize(font.pointSize + 1)
                        previewText.font = font
                    }
                }
            }
            
            // enable button
            bratifyButton.isEnabled = true
            
        } else {
            previewText.text = "preview"
            // set font size to 42
            previewText.font = previewText.font?.withSize(42)
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
