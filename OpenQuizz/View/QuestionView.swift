//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by megared on 10/04/2018.
//  Copyright © 2018 OpenClassrooms. All rights reserved.
//

import UIKit

class QuestionView: UIView {

    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    enum Style {
        case correct, incorrect, standard
    }
    
    var style: Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    private func setStyle(_ style: Style) {
        switch style {
        case .correct:
            icon.image = #imageLiteral(resourceName: "Icon Correct")
            icon.isHidden = false
            backgroundColor = #colorLiteral(red: 0.7890971303, green: 0.9263128638, blue: 0.6260950565, alpha: 1)
        case .incorrect:
            icon.image = #imageLiteral(resourceName: "Icon Error")
            icon.isHidden = false
            backgroundColor = #colorLiteral(red: 0.9528579116, green: 0.5297288895, blue: 0.5837079883, alpha: 1)
        case .standard:
            icon.isHidden = true
            backgroundColor = #colorLiteral(red: 0.7482330203, green: 0.7723199725, blue: 0.793117702, alpha: 1)
        }
    }
    var title = "" {
        didSet {
            label.text = title
        }
    }
}
