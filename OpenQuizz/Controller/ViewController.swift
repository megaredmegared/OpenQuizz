//
//  ViewController.swift
//  OpenQuizz
//
//  Created by megared on 09/04/2018.
//  Copyright © 2018 OpenClassrooms. All rights reserved.
//



import UIKit

class ViewController: UIViewController {
    
    var game = Game()
    
    
    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
        
        startNewGame()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(draguQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        
        questionView.title = game.currentQuestion.title
    }
    
    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameButton.isHidden = true
        
        questionView.title = "Loading..."
        questionView.style = .standard
        
        scoreLabel.text = "0 / 10"
        
        game.refresh()
    }
    @objc func draguQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
    }
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let screenWidth = UIScreen.main.bounds.width
        let transformPercent = translation.x/(screenWidth/2)
        let rotationAngle = (CGFloat.pi / 6) * transformPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform
        
        if translation.x > 10 {
            questionView.style = .correct
        } else if translation.x < -10 {
            questionView.style = .incorrect
        } else {
            questionView.style = .standard
        }
    }
    
    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
           break
        }
        
        animateScore()
        
        let screenWidth = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else if questionView.style == .incorrect {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        if questionView.style == .correct || questionView.style == .incorrect {
            UIView.animate(withDuration: 0.3, animations: {
                self.questionView.transform = translationTransform
            }) { (success) in
                if success {
                    self.showQuestionView()
                }
            }
        } else {
            questionView.transform = .identity
        }
        

    }

    
    private func showQuestionView() {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        questionView.style = .standard
        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
        }
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
        }, completion: nil)
    }
    private func animateScore() {

        scoreLabel.text = "\(game.score) / 10"

        if game.scoreChanged == true  {
   
            scoreLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.scoreLabel.transform = .identity
            }, completion: nil)

            
            game.scoreChanged = false
        }
    }
}

