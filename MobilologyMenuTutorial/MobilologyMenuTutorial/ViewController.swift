//
//  ViewController.swift
//  MobilologyMenuTutorial
//
//  Created by Damien Laughton on 20/03/2016.
//  Copyright © 2016 Damien Laughton. All rights reserved.
//

import UIKit

struct ScreenSize
{
  static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
  static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
  static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
  static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

enum UnderlayType {
  case UnderlayTypeNone, UnderlayTypeMenu, UnderlayTypeSettings
}

typealias CompletionHandler = () -> ()

class ViewController: UIViewController {

  var currentUnderlayType: UnderlayType = UnderlayType.UnderlayTypeNone
  
  @IBOutlet weak var overlayContainerView: UIView?
  @IBOutlet weak var menuContainerView: UIView?
  @IBOutlet weak var settingsContainerView: UIView?
  
  @IBOutlet weak var overlayContainerCenterXConstraint: NSLayoutConstraint?
  @IBOutlet weak var settingsButton: UIButton?
  @IBOutlet weak var menuButton: UIButton?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - IBAction(s)
  
  @IBAction func menuTapped(sender: UIButton) {
    
    currentUnderlayType = .UnderlayTypeMenu
    
    animateOverlay()
  }
  
  @IBAction func settingsTapped(sender: UIButton) {
    
    currentUnderlayType = .UnderlayTypeSettings
    
    animateOverlay()
  }
  
  @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
    let translation = recognizer.translationInView(self.view)
    
//    print(translation.x)
    
    if recognizer.state == .Began {
      if isOverlayCentered() {
        
        currentUnderlayType = .UnderlayTypeNone
        
        if translation.x > 0.0 {
          currentUnderlayType = .UnderlayTypeMenu
        }
        
        if translation.x < 0.0 {
          currentUnderlayType = .UnderlayTypeSettings
        }
      }
    }
    
    ensureCorrectUnderlayWillBeVisible()
    
    if let _ = recognizer.view {
      if let constraint = overlayContainerCenterXConstraint {
        
        switch(currentUnderlayType) {
          
        case .UnderlayTypeMenu:
          
          let maxOffset:CGFloat = ScreenSize.SCREEN_WIDTH * 2.0 / 3.0
          let possibleNewConstant = max(0.0, constraint.constant + translation.x)
          
          constraint.constant = min(maxOffset, possibleNewConstant)
          
          if recognizer.state == .Ended {
            
            let minOffset:CGFloat = ScreenSize.SCREEN_WIDTH / 6.0
            
            if constraint.constant <= minOffset {
              animateOverlayLeft(currentUnderlayType)
            }
          }
          
          break
        case .UnderlayTypeSettings:
          
          let minOffset:CGFloat = -1.0 * ScreenSize.SCREEN_WIDTH * 2.0 / 3.0
          let possibleNewConstant = min(0.0, constraint.constant + translation.x)
          
          constraint.constant = max(minOffset, possibleNewConstant)
          
          if recognizer.state == .Ended {
            
            let minOffset:CGFloat = -1.0 * ScreenSize.SCREEN_WIDTH / 6.0
            
            if constraint.constant >= minOffset {
              animateOverlayRight(currentUnderlayType)
            }
          }
          
          break
        case .UnderlayTypeNone:
          break
          
        }
        
      }
    }
    
    recognizer.setTranslation(CGPointZero, inView: self.view)
  }
  
//  MARK: - Helper Method(s)
  
  func isOverlayCentered () -> Bool {
    
    var isOverlayCentered = true
    
    if let constraint = overlayContainerCenterXConstraint {
      
      if constraint.constant != 0.0 {
        isOverlayCentered = false
      }
    }
    
    return isOverlayCentered
  }
  
  func ensureCorrectUnderlayWillBeVisible () {
    switch(currentUnderlayType) {
      
    case .UnderlayTypeMenu:
      if let containerView = settingsContainerView {
        
        self.view.insertSubview(containerView, atIndex: 0)
      }
      break
    case .UnderlayTypeSettings:
      
      if let containerView = menuContainerView {
        
        self.view.insertSubview(containerView, atIndex: 0)
      }
      break
    case .UnderlayTypeNone:
      break
      
    }
  }
  
  // MARK: - Animation(s)
  
  func animateOverlay () {
    
    ensureCorrectUnderlayWillBeVisible()
    
    switch(currentUnderlayType) {
      
    case .UnderlayTypeMenu:
      if isOverlayCentered() {
        animateOverlayRight(currentUnderlayType)
      } else {
        animateOverlayLeft(currentUnderlayType)
      }
      break
    case .UnderlayTypeSettings:
      if isOverlayCentered() {
        animateOverlayLeft(currentUnderlayType)
      } else {
        animateOverlayRight(currentUnderlayType)
      }
      break
    case .UnderlayTypeNone:
      break
      
    }
  }
  
  func animateOverlayRight(underlayType:UnderlayType, CompletionHandler completionHandler:CompletionHandler = {}) {
    
    switch(underlayType) {
      
    case .UnderlayTypeMenu:
      
      if let constraint = overlayContainerCenterXConstraint {
        let offset:CGFloat = ScreenSize.SCREEN_WIDTH * 2.0 / 3.0
        
        constraint.constant = offset
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: {
          
          self.view.layoutIfNeeded()
          
          }, completion: { finished in
            completionHandler()
        })
        
      }
      
      break
    case .UnderlayTypeSettings:
      
      if let constraint = overlayContainerCenterXConstraint {
        let offset:CGFloat = 0.0
        
        constraint.constant = offset
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: {
          
          self.view.layoutIfNeeded()
          
          }, completion: { finished in
            self.currentUnderlayType = .UnderlayTypeNone
            completionHandler()
        })
      }
      
      break
    case .UnderlayTypeNone:
      break
      
    }
    
    
    
  }
  
  func animateOverlayLeft(underlayType:UnderlayType, CompletionHandler completionHandler:CompletionHandler = {}) {
    
    
    switch(underlayType) {
      
    case .UnderlayTypeMenu:
      
      if let constraint = overlayContainerCenterXConstraint {
        let offset:CGFloat = 0.0
        
        constraint.constant = offset
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: {
          
          self.view.layoutIfNeeded()
          
          }, completion: { finished in
            self.currentUnderlayType = .UnderlayTypeNone
            completionHandler()
        })
      }
      
      
      break
    case .UnderlayTypeSettings:
      
      if let constraint = overlayContainerCenterXConstraint {
        let offset:CGFloat = -1.0 * ScreenSize.SCREEN_WIDTH * 2.0 / 3.0
        
        constraint.constant = offset
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: {
          
          self.view.layoutIfNeeded()
          
          }, completion: { finished in
            completionHandler()
        })
        
      }
      
      
      break
    case .UnderlayTypeNone:
      break
      
    }
    
    
    
  }



}

