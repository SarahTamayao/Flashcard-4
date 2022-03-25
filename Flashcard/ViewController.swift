//
//  ViewController.swift
//  Flashcard
//
//  Created by Yaw Kessey-Ankomah on 3/2/22.
//

import UIKit

class ViewController: UIViewController {
    
    struct Flashcard {
        var question: String
        var answer: String
    }
    
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    
    @IBAction func didTapOnNext(_ sender: Any) {
        // Increase current index
        currentIndex = currentIndex + 1
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
    }
    @IBAction func didTapOnPrev(_ sender: Any) {
        // Decrease current index
        if currentIndex != 0 {
        currentIndex = currentIndex - 1
        }
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
    }
    @IBAction func didTapOnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delte it?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            action in self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func deleteCurrentFlashcard(){
        // Delete current
        flashcards.remove(at: currentIndex)
    
        // Special case: Check if last card was deleted
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1
        }
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    // Current flashcard index
    var currentIndex = 0
    
    
    //Array to hold flashcards
    var flashcards = [Flashcard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Read saved flashcards
        readSavedFlashcards()
        
        //Adds initial flashcard if needed
        if flashcards.count == 0 {
            updateFlashcard(question: "What is the capital of Brazil?", answer: "Brasilia", isExisting: false)
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    func updateFlashcard(question: String, answer: String, isExisting: Bool) {
        let flashcard = Flashcard(question: question, answer: answer)
        
        if isExisting{
            flashcards[currentIndex] = flashcard
        }else {
            // Adding flashcard in the flashcards array
            flashcards.append(flashcard)
            
            print("Added new flashcard")
            print("We now have \(flashcards.count) flashcards")
            currentIndex = flashcards.count - 1
        }
        
        
        // Update buttons
        updateNextPrevButtons()
        
        // Update labels
        updateLabels()
        
        saveAllFlashcardsToDisk()
        
    }
    
    func updateNextPrevButtons() {
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels() {
        // Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
        creationController.initialQuestion = frontLabel.text
        creationController.initialAnswer = backLabel.text
        
        
    }
   
   
    
  
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        if frontLabel.isHidden == true {
            frontLabel.isHidden = false
        } else {
            frontLabel.isHidden = true
        }
    }

    func saveAllFlashcardsToDisk() {
        
        // From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in return ["question": card.question, "answer": card.answer]
        }
        //Save array on disk using
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
                
            }
            // Place these cards in our flashcard array
            flashcards.append(contentsOf: savedCards)

        }
        
    }
    
}

