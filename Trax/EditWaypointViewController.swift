//
//  EditWaypointViewController.swift
//  Trax
//
//  Created by Malcolm Macleod on 30/07/2015.
//  Copyright (c) 2015 Malcolm Macleod. All rights reserved.
//

import UIKit

class EditWaypointViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
        {
        didSet {
            nameTextField.delegate = self
        }
    }
    
    
    @IBOutlet weak var infoTextField: UITextField! {
        didSet {
            infoTextField.delegate = self
        }
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var waypointToEdit : EditableWaypoint? {
        didSet {
            updateUI()
        }
    }
    
    var ntfObserver : NSObjectProtocol?
    var itfObserver : NSObjectProtocol?
    
    func updateUI () {
        nameTextField?.text = waypointToEdit?.name
        infoTextField?.text = waypointToEdit?.info
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField?.becomeFirstResponder()

        // Do any additional setup after loading the view.
        updateUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        observeTextFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let observer = ntfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        
        if let observer = itfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func observeTextFields() {
        let centre = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        self.ntfObserver = centre.addObserverForName(UITextFieldTextDidChangeNotification, object: nameTextField, queue: queue) {
            notification in
            if let waypoint = self.waypointToEdit {
                waypoint.name = self.nameTextField.text
            }
        }
        
        self.itfObserver = centre.addObserverForName(UITextFieldTextDidChangeNotification, object: infoTextField, queue: queue) {
            notification in
            if let waypoint = self.waypointToEdit {
                waypoint.info = self.infoTextField.text
            }
        }
    }
    
}
