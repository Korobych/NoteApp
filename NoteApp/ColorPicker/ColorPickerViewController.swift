//
//  ColorPickerViewController.swift
//  NoteApp
//
//  Created by Sergey Korobin on 12/07/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    
    private var lastSelectedColor: UIColor? = nil

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
    @IBOutlet weak var horizontalSlider: UISlider!{
        didSet{
            horizontalSlider.minimumValue = 0.0
            horizontalSlider.maximumValue = 1.0
            horizontalSlider.value = 1.0
        }
    }
    @IBAction func horizontalSliderTapped(_ sender: UISlider) {
        let alphaValue = horizontalSlider.value
        guard let lastSelectedColorWithAlpha = lastSelectedColor?.withAlphaComponent(CGFloat(alphaValue)) else {return}
        colorHexLabel.text = lastSelectedColorWithAlpha.toHexString()
        colorPreView.backgroundColor = lastSelectedColorWithAlpha
        // saving color to local variable
        lastSelectedColor = lastSelectedColorWithAlpha
        
    }
    
    @IBOutlet weak var colorPickerView: ColorPickerView!{
        didSet{
            colorPickerView.layer.borderColor = UIColor.black.cgColor
            colorPickerView.layer.borderWidth = 1.0
            colorPickerView.whenColorDidChange = { [weak self] color in
                guard let sliderAlhpaValue = self?.horizontalSlider.value else {return}
                let colorWithAlpha = color.withAlphaComponent(CGFloat(sliderAlhpaValue))
                self?.colorHexLabel.text = colorWithAlpha.toHexString()
                self?.colorPreView.backgroundColor = colorWithAlpha
                // saving color to local variable
                self?.lastSelectedColor = colorWithAlpha
            }
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            // send lastSelectedColor
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print(size.height, size.width)
            colorPickerView.setNeedsDisplay()

        } else if UIDevice.current.orientation.isPortrait{
            print(size.height, size.width)
            colorPickerView.setNeedsDisplay()
        }
    }
  
}
