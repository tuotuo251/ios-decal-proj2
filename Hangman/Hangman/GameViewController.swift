//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var w: CGFloat!
    var h: CGFloat!
    var numGuessed = 0
    var letterGuessed = [String]()
    var phrase = ""
    var incorrectGuess = [String]()

    @IBOutlet weak var reminder: UILabel!
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var hangman: UIImageView!
    @IBOutlet weak var guess: UITextField!
    @IBOutlet weak var guessButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        w = self.view.bounds.size.width
        h = self.view.bounds.size.height
        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        makephrase()
        reminder.text = "Please enter your guess. One letter only."
        updateImage()
        updateGuessedLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateImage() {
        let name = "hangman" + String(numGuessed + 1) + ".gif"
        let myImage = UIImage(named: name)
        hangman.image = myImage
    }
    
    func makephrase() {
        let p = phrase
        var index = 0
        let letterwidth = (w - 15.0) / CGFloat(p.characters.count)
        let letterheight = h / 9
        for c in p.characters {
            let v = UILabel(frame: CGRect(x: CGFloat(index) * letterwidth + 15.0, y: h * (4/9), width: letterwidth, height: letterheight))
            if letterGuessed.contains(String(c)) {
                v.text = String(c)
            }
            else if c != " " {
                v.text = String("_")
            }
            v.adjustsFontSizeToFitWidth = true
            self.view.addSubview(v)
            index += 1
        }
    }

    func updateGuessedLabel() {
        var text = "Incorrect Guesses:"
        for c in incorrectGuess {
            text = text + " " + String(c) + " "
        }
        guessLabel.text = text
    }
    
    @IBAction func pressedGuess(_ sender: Any) {
        let yourguess = guess.text!.uppercased()
        guess.text = ""
        if yourguess.characters.count != 1 {
            reminder.text = "Please enter one letter only."
        }
        else if letterGuessed.contains(yourguess) {
            reminder.text = "You already tried this letter."
        }
        else {
            if phrase.characters.contains(Character(yourguess)) {
                letterGuessed += [yourguess]
                makephrase()
                reminder.text = "Great Guess"
                checkwin()
            }
            else {
                numGuessed += 1
                letterGuessed += [yourguess]
                incorrectGuess += [yourguess]
                reminder.text = "Bad Guess"
                checklose()
                updateGuessedLabel()
                updateImage()
            }
        }
    }

    func final(alert: UIAlertAction) {
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        letterGuessed = [String]()
        incorrectGuess = [String]()
        numGuessed = 0
        reminder.text = "Please enter your guess. One letter only."
        updateImage()
        updateGuessedLabel()
        makephrase()
    }
    
    func checklose() {
        if numGuessed == 7 {
            let lose = UIAlertController(title: "You Lose", message: "It's ok! Do you want to start another game?", preferredStyle: .alert)
            let firstAction = UIAlertAction(title: "Startover", style: .default, handler: final)
            lose.addAction(firstAction)
            self.present(lose, animated: true, completion: nil)
        }
    }

    func checkwin() {
        var win = true
        for c in phrase.characters {
            if letterGuessed.contains(String(c)) == false {
                win = false
            }
        }
        if win {
            let win = UIAlertController(title: "You Win", message: "Congratulations! Do you want to start another game?", preferredStyle: UIAlertControllerStyle.alert)
            let firstAction = UIAlertAction(title: "Startover", style: .default, handler: final)
            win.addAction(firstAction)
            self.present(win, animated: true, completion: nil)
        }
    }
}
