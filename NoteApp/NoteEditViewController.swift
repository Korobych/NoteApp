//
//  ViewController.swift
//  NoteApp
//
//  Created by Sergey Korobin on 30/06/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import UIKit

class NoteEditViewController: UIViewController {
    
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
            print("\nswitch is ON")
            print(destroyDateView.frame)
            destroyDateViewHeight.constant += 216
            
            let datePicker = UIDatePicker()
            datePicker.minimumDate = Date()
            datePicker.datePickerMode = .dateAndTime
            destroyDateView.addSubview(datePicker)
            
            destroyDateView.layoutIfNeeded()
            datePicker.frame = CGRect(x: destroyDateView.bounds.origin.x, y: destroyDateView.bounds.origin.y + destroyDateSwitch.frame.height, width: destroyDateView.bounds.width, height: destroyDateView.bounds.height)
            print(destroyDateView.frame)
            
//            destroyDateView.translatesAutoresizingMaskIntoConstraints = false
//            let horizontalLeadingConstraint = NSLayoutConstraint(item: datePicker, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: destroyDateView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
//            let horizontalTrailingConstraint = NSLayoutConstraint(item: datePicker, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: destroyDateView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
//            let verticalTopSpaceContraint = NSLayoutConstraint(item: datePicker, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: destroyDateSwitch, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
//            NSLayoutConstraint.activate([horizontalLeadingConstraint, horizontalTrailingConstraint, verticalTopSpaceContraint])
            
            
        } else {
            print("\nswitch is OFF")
            destroyDateViewHeight.constant -= 216
            for view in destroyDateView.subviews{
                if view is UIDatePicker{
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
