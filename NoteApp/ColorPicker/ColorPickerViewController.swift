//
//  ColorPickerViewController.swift
//  NoteApp
//
//  Created by Sergey Korobin on 12/07/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import UIKit

// Delegate protocol
protocol ModalToNoteEditVCDelegate: class {
    func loadColor()
}

class ColorPickerViewController: UIViewController {
    
    private var lastSelectedColor: UIColor? = nil
    weak var delegate: ModalToNoteEditVCDelegate?

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
        if let selectedColor = self.lastSelectedColor{
            UserDefaults.standard.set(selectedColor, forKey: "selectedColor")
        }
        delegate?.loadColor()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load locally stored color value
        if let storedColor = UserDefaults.standard.color(forKey: "selectedColor"){
            colorHexLabel.text = storedColor.toHexString()
            colorPreView.backgroundColor = storedColor
            guard let alphaComponent = storedColor.getRGBAComponents()?.alpha else {return}
            horizontalSlider.value = Float(alphaComponent)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            colorPickerView.setNeedsDisplay()
        } else if UIDevice.current.orientation.isPortrait{
            colorPickerView.setNeedsDisplay()
        }
    }
  
}

// MARK: UserDefaults custom methods to load/read UIColor 
extension UserDefaults {
    
    func color(forKey key: String) -> UIColor? {
        
        guard let colorData = data(forKey: key) else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }
        
    }
    
    func set(_ value: UIColor?, forKey key: String) {
        
        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }
        
    }
}
