//
//  ColorPickerViewController.swift
//  NoteApp
//
//  Created by Sergey Korobin on 12/07/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {

    // MARK: ColorPreView
    @IBOutlet weak var colorFullPreView: UIView!{
        didSet{
            colorFullPreView.layer.borderColor = UIColor.black.cgColor
            colorFullPreView.layer.borderWidth = 1.0
            colorFullPreView.layer.cornerRadius = 10.0
        }
    }
    @IBOutlet weak var colorHexLabel: UILabel!{
        didSet{
            colorHexLabel.text = UIColor.white.toHexString()
        }
    }
    @IBOutlet weak var colorPreView: UIView!{
        didSet{
            colorPreView.layer.borderColor = UIColor.black.cgColor
            colorPreView.layer.borderWidth = 1.0
            colorPreView.layer.cornerRadius = 10.0
        }
    }
    
    // MARK: BrightnessView
    @IBOutlet weak var horizontalSlider: UISlider!
    @IBAction func horizontalSliderTapped(_ sender: UISlider) {
    }
    
    @IBOutlet weak var colorPickerView: ColorPickerView!{
        didSet{
            colorPickerView.layer.borderColor = UIColor.black.cgColor
            colorPickerView.layer.borderWidth = 1.0
            colorPickerView.whenColorDidChange = { [weak self] color in
                self?.colorHexLabel.text = color.toHexString()
                self?.colorPreView.backgroundColor = color
            }
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
  
}
