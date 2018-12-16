//
//  UIView+FluidStyleAutoLayout.swift
//
//  Created by smg on 2016. 10. 18..
//  Copyright © 2016년 grutech. All rights reserved.
//

import UIKit

// MARK: - Fluid Style AutoLayout
extension UIView
{
    public func fs_contentHuggingPriority(priority: UILayoutPriority,
                                   layoutConstraintAxis: NSLayoutConstraint.Axis) -> Self
    {
        setContentHuggingPriority(priority, for: layoutConstraintAxis)
        return self
    }
    
    public func fs_contentCompressionResistancePriority(priority: UILayoutPriority,
                                                 layoutConstraintAxis: NSLayoutConstraint.Axis) -> Self
    {
        setContentCompressionResistancePriority(priority, for: layoutConstraintAxis)
        return self
    }
    
    public func fs_translatesAutoresizingMaskIntoConstraints(isActive: Bool) -> Self
    {
        self.translatesAutoresizingMaskIntoConstraints = isActive
        return self
    }
    
    public func fs_centerXAnchor(equalTo: NSLayoutXAxisAnchor,
                          constant: CGFloat = 0,
                          isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: equalTo,
                                 constant: constant).isActive = isActive
        return self
    }
    
    public func fs_centerYAnchor(equalTo: NSLayoutYAxisAnchor,
                          constant: CGFloat = 0,
                          isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: equalTo,
                                 constant: constant).isActive = isActive
        return self
    }
    
    
    public func fs_leftAnchor(equalTo: NSLayoutXAxisAnchor,
                       constant: CGFloat = 0,
                       isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: equalTo,
                              constant: constant).isActive = isActive
        return self
    }
    
    
    public func fs_leftAnchor(equalTo: NSLayoutXAxisAnchor,
                       constant: CGFloat = 0,
                       constraint: AutoreleasingUnsafeMutablePointer<NSLayoutConstraint?>,
                       isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        let anchor = leftAnchor.constraint(equalTo: equalTo,
                                           constant: constant)
        anchor.isActive = isActive
        constraint.pointee = anchor
        
        return self
    }

    
    public func fs_rightAnchor(equalTo: NSLayoutXAxisAnchor,
                        constant: CGFloat = 0,
                        isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        rightAnchor.constraint(equalTo: equalTo,
                               constant: constant).isActive = isActive
        return self
    }
    
    public func fs_topAnchor(equalTo: NSLayoutYAxisAnchor,
                      constant: CGFloat = 0,
                      isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: equalTo,
                             constant: constant).isActive = isActive
        return self
    }
    
    public func fs_topAnchor(equalTo: NSLayoutYAxisAnchor,
                      constant: CGFloat = 0,
                      identifier: String? = nil,
                      constraint: AutoreleasingUnsafeMutablePointer<NSLayoutConstraint?>,
                      isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = topAnchor.constraint(equalTo: equalTo,
                                          constant: constant)
        
        if let identifier = identifier { anchor.identifier = identifier }
        anchor.isActive = isActive
        constraint.pointee = anchor

        return self
    }
    
    
    public func fs_bottomAnchor(equalTo: NSLayoutYAxisAnchor,
                         constant: CGFloat = 0,
                         isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: equalTo,
                                constant: constant).isActive = isActive
        return self
    }
    
    public func fs_bottomAnchor(equalTo: NSLayoutYAxisAnchor,
                         constant: CGFloat = 1.0,
                         identifier: String? = nil,
                         constraint: AutoreleasingUnsafeMutablePointer<NSLayoutConstraint?>,
                         isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = bottomAnchor.constraint(equalTo: equalTo, constant: constant)
        
        if let identifier = identifier { anchor.identifier = identifier }
        anchor.isActive = isActive
        constraint.pointee = anchor
        
        return self
    }
    
    public func fs_widthAnchor(equalTo: NSLayoutDimension,
                        constant: CGFloat = 0,
                        multiplier: CGFloat = 1.0,
                        identifier: String? = nil,
                        constraint: AutoreleasingUnsafeMutablePointer<NSLayoutConstraint?>,
                        isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = widthAnchor.constraint(equalTo: equalTo,
                                            multiplier: multiplier,
                                            constant: constant)
        
        if let identifier = identifier { anchor.identifier = identifier }
        anchor.isActive = isActive
        constraint.pointee = anchor
        
        return self
    }
    
    
    public func fs_widthAnchor(equalTo: NSLayoutDimension,
                        constant: CGFloat = 0,
                        multiplier: CGFloat = 1.0,
                        identifier: String? = nil,
                        isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = widthAnchor.constraint(equalTo: equalTo,
                                            multiplier: multiplier,
                                            constant: constant)
        
        if let identifier = identifier { anchor.identifier = identifier }
        anchor.isActive = isActive
        
        return self
    }
    
    public func fs_widthAnchor(equalToConstant: CGFloat,
                        identifier: String? = nil,
                        isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = widthAnchor.constraint(equalToConstant: equalToConstant)
        
        if let identifier = identifier { anchor.identifier = identifier }
        anchor.isActive = isActive
        
        return self
    }
    
    public func fs_heightAnchor(equalTo: NSLayoutDimension,
                         constant: CGFloat = 0,
                         multiplier: CGFloat = 1.0,
                         identifier: String? = nil,
                         constraint: AutoreleasingUnsafeMutablePointer<NSLayoutConstraint?>,
                         isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = heightAnchor.constraint(equalTo: equalTo,
                                             multiplier: multiplier,
                                             constant: constant)
        if let identifier = identifier { anchor.identifier = identifier }
        anchor.isActive = isActive
        constraint.pointee = anchor
        
        return self
    }
    
    public func fs_heightAnchor(equalTo: NSLayoutDimension,
                         constant: CGFloat = 0,
                         multiplier: CGFloat = 1.0,
                         identifier: String? = nil,
                         isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = heightAnchor.constraint(equalTo: equalTo,
                                             multiplier: multiplier,
                                             constant: constant)
        if let identifier = identifier { anchor.identifier = identifier }
        anchor.isActive = isActive
        
        return self
    }
    
    public func fs_heightAnchor(equalToConstant: CGFloat,
                         identifier: String? = nil,
                         isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = heightAnchor.constraint(equalToConstant: equalToConstant)
        if let identifier = identifier { anchor.identifier = identifier }
        anchor.isActive = isActive
        
        return self
    }
    
    public func fs_heightAnchor(equalToConstant: CGFloat,
                         identifier: String? = nil,
                         constraint: AutoreleasingUnsafeMutablePointer<NSLayoutConstraint?>,
                         isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = heightAnchor.constraint(equalToConstant: equalToConstant)
        if let identifier = identifier { anchor.identifier = identifier }
        anchor.isActive = isActive
        constraint.pointee = anchor
        
        return self
    }
    
    
    public func fs_heightAnchor(equalToConstant: CGFloat,
                         priority: UILayoutPriority,
                         isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = heightAnchor.constraint(equalToConstant: equalToConstant)
        anchor.priority = priority
        anchor.isActive = isActive
        
        return self
    }
    
    public func fs_heightAnchor(greaterThanOrEqualToConstant: CGFloat,
                         priority: UILayoutPriority,
                         isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        let anchor = heightAnchor.constraint(greaterThanOrEqualToConstant: greaterThanOrEqualToConstant)
        anchor.priority = priority
        anchor.isActive = isActive
        
        return self
    }
    
    
    public func fs_heightAnchor(greaterThanOrEqualToConstant: CGFloat,
                         isActive: Bool = true) -> Self
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(greaterThanOrEqualToConstant: greaterThanOrEqualToConstant).isActive = isActive
        
        return self
    }
    
    public func fs_endSetup(){}
}












