//
//  Extensions.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 17/09/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit


// MARK:  View extensions

extension UIView {
    
    public func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}

// MARK:  TableView extensions

extension UITableView {
    
    func scrollToBottom(animated: Bool) {
        var y: CGFloat = 0.0
        if self.contentSize.height > UIScreen.main.bounds.height {
            y = self.contentSize.height - UIScreen.main.bounds.height
        }
        self.setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
}


