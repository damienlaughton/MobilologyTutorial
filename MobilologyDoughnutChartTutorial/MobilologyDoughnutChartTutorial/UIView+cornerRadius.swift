//
//  UIView+cornerRadius.swift
//  MobilologyDoughnutChartTutorial
//
//  Created by Damien Laughton on 18/04/2016.
//  Copyright © 2016 Damien Laughton. All rights reserved.
//
//  Originally by Nate Cook @nnnnnnnn
//  http://nshipster.com/ibinspectable-ibdesignable/
//


import UIKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
}

