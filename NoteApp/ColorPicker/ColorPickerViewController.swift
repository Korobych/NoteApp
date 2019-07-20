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
    func getChangedNote(note: Note)
}

class ColorPickerViewController: UIViewController {
    
    private var lastSelectedColor: UIColor? = nil
    var selectedNote: Note? = nil
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
        guard let selectedColor = lastSelectedColor else {return}
        if let selectedNote = selectedNote {
            let changedNote = Note(uid: selectedNote.uid, title: selectedNote.title, content: selectedNote.content, color: selectedColor, importance: Importance.basic, selfDestructionDate: selectedNote.selfDestructionDate)
            delegate?.getChangedNote(note: changedNote)
        } else {
//            // setting new note
//            let newNote = Note(title: "", content: "", color: selectedColor, selfDestructionDate: nil)
//            delegate?.getChangedNote(note: newNote)
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        if let selectedColor = selectedNote?.color {
            lastSelectedColor = selectedColor
            colorHexLabel.text = selectedColor.toHexString()
            colorPreView.backgroundColor = selectedColor
            guard let alphaComponent = selectedColor.getRGBAComponents()?.alpha else {return}
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
