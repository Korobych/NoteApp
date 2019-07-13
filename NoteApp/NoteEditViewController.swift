//
//  ViewController.swift
//  NoteApp
//
//  Created by Sergey Korobin on 30/06/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import UIKit

class NoteEditViewController: UIViewController {
    
    var bufferHeight: CGFloat!
    var bufferWidth: CGFloat!
    var lastTappedColorButton: UIButton? = nil
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    // MARK: TitleView
    @IBOutlet weak var titleTextField: UITextField!{
        didSet{
            titleTextField.placeholder = "Enter title for your note"
        }
    }
    // MARK: ContentView
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentTextView: UITextView!{
        didSet{
            contentTextView.delegate = self
            contentTextView.isScrollEnabled = false
            contentTextView.layer.borderColor = UIColor.lightGray.cgColor
            contentTextView.layer.borderWidth = 1.0
        }
    }
    // MARK: DestroyDateView
    @IBOutlet weak var destroyDateView: UIView!
    @IBOutlet weak var destroyDateSwitch: UISwitch!
    @IBOutlet weak var destroyDateViewHeight: NSLayoutConstraint!
    
    @IBAction func destroyDateSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
            print("\ndestroyDate switch is ON")
            destroyDateViewHeight.constant += 216
            mainScrollView.layoutIfNeeded()
            createDatePicker(width: destroyDateView.bounds.width)
        } else {
            print("\ndestroyDate switch is OFF")
            destroyDateViewHeight.constant -= 216
            for view in destroyDateView.subviews{
                if view is UIDatePicker{
                    view.removeFromSuperview()
                }
            }
        }
    }
    // MARK: ColorView
    @IBOutlet weak var firstColorButton: UIButton!{
        didSet{
            firstColorButton.layer.borderColor = UIColor.black.cgColor
            firstColorButton.layer.borderWidth = 1.0
            firstColorButton.setTitle("", for: .normal)
            firstColorButton.backgroundColor = UIColor.white
        }
    }
    @IBOutlet weak var secondColorButton: UIButton!{
        didSet{
            secondColorButton.layer.borderColor = UIColor.black.cgColor
            secondColorButton.layer.borderWidth = 1.0
            secondColorButton.setTitle("", for: .normal)
            secondColorButton.backgroundColor = UIColor.red
        }
    }
    @IBOutlet weak var thirdColorButton: UIButton!{
        didSet{
            thirdColorButton.layer.borderColor = UIColor.black.cgColor
            thirdColorButton.layer.borderWidth = 1.0
            thirdColorButton.setTitle("", for: .normal)
            thirdColorButton.backgroundColor = UIColor.green
        }
    }
    @IBOutlet weak var fourthColorButton: UIButton!{
        didSet{
            fourthColorButton.layer.borderColor = UIColor.black.cgColor
            fourthColorButton.layer.borderWidth = 1.0
            fourthColorButton.setTitle("", for: .normal)
            fourthColorButton.setBackgroundImage(UIImage(named: "spectrumPic"), for: .normal)
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(colorPickerLongPress))
            longPress.minimumPressDuration = 1.0
            fourthColorButton.addGestureRecognizer(longPress)
        }
    }
    
    @IBAction func changeColorButtonTapped(_ sender: UIButton) {
        contentTextView.textColor = sender.backgroundColor
        // check for last tapped color button -> remove CircleViewWithTick in it
        if let lastTapped = lastTappedColorButton{
            for v in lastTapped.subviews{
                if v is CirlceViewWithTick{
                    v.removeFromSuperview()
                    break
                }
            }
        }
        lastTappedColorButton = sender
        // add new view with CoreGraphics (tick in circle)
        let cirlceView = CirlceViewWithTick(frame: sender.bounds)
        cirlceView.backgroundColor = UIColor.clear
        sender.addSubview(cirlceView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bufferHeight = view.frame.height
        bufferWidth = view.frame.width
    }
    
    func createDatePicker(width: CGFloat){
        let datePicker = UIDatePicker(frame: CGRect(x: destroyDateView.bounds.origin.x, y: destroyDateView.bounds.origin.y + destroyDateSwitch.frame.height, width: width, height: destroyDateView.bounds.height - destroyDateSwitch.frame.height))
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .dateAndTime
        destroyDateView.addSubview(datePicker)
    }
    
    @objc func colorPickerLongPress(gesture: UILongPressGestureRecognizer) {
        // Show ColorPickerViewController modally
        if gesture.state == UIGestureRecognizer.State.began {
            let storyboard = UIStoryboard(name: "ColorPicker", bundle: nil)
            let modalViewController = storyboard.instantiateViewController(withIdentifier: "colorPickerModal")
            modalViewController.modalPresentationStyle = .overCurrentContext
            present(modalViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: Keyboard Logic
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("isLandscape")
            if destroyDateSwitch.isOn{
                for view in destroyDateView.subviews{
                    if view is UIDatePicker{
                        view.removeFromSuperview()
                        createDatePicker(width: bufferHeight)
                        break
                    }
                }
            }
        } else if UIDevice.current.orientation.isPortrait{
            print("isPortrait")
            if destroyDateSwitch.isOn{
                for view in destroyDateView.subviews{
                    if view is UIDatePicker{
                        view.removeFromSuperview()
                        createDatePicker(width: bufferWidth)
                        break
                    }
                }
            }
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension NoteEditViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        contentViewHeight.constant = estimatedSize.height
    }
}
