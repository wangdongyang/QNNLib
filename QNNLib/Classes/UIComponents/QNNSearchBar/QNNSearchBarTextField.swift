//
//  QNNSearchBarTextField.swift
//  QNN
//
//  Created by wdy on 2018/9/3.
//  Copyright © 2018年 qianshengqian. All rights reserved.
//

import UIKit

/**
 * Internal UITextField subclass to be able to overwrite the *rect functions. 
 * This makes it possible to exactly control all margins.
 */
public class QNNSearchBarTextField: UITextField {

    /// The SHSearchbarConfig that holds the configured raster size, which is important for rect calculation.
    var config: QNNSearchBarConfig {
        didSet {
            setNeedsLayout()
        }
    }

    /**
     * The designated initializer to initialize the configuration object.
     * - parameter config: The initial SHSearchBarConfig object that holds the raster size.
     */
    init(config: QNNSearchBarConfig) {
        self.config = config
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        leftView = config.leftView
    }

    /**
     * The initializer for use with storyboards.
     * - parameter coder: A NSCoder instance.
     * - note: This initializer is not implementes and will raise an exception when called.
     */
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Overrides

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rectForBounds(rect, originalBounds: bounds)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rectForBounds(rect, originalBounds: bounds)
    }

    /**
     * Calculates the text bounds depending on the visibility of left and right views.
     * - parameter bounds: The bounds of the textField after subtracting margins for left and/or right views.
     * - parameter originalBounds: The current bounds of the textField.
     * - returns: The bounds inside the textField so that the text does not overlap with the left and right views.
     */
    private func rectForBounds(_ bounds: CGRect, originalBounds: CGRect) -> CGRect {
        var minX: CGFloat = 0
        var width: CGFloat = 0

        if bounds.width == originalBounds.width {
            // no left and no right view
            minX = config.rasterSize
            width = bounds.width - config.rasterSize * 2
            
        } else if bounds.minX > 0 && bounds.width == originalBounds.width - bounds.minX {
            // only left view
            minX = bounds.minX
            width = bounds.width - config.rasterSize

        } else if bounds.minX == 0 && bounds.width < originalBounds.width {
            // only right view
            minX = config.rasterSize
            width = bounds.width - config.rasterSize

        } else {
            // left & right view
            minX = bounds.minX
            width = bounds.width
        }
        return CGRect(x: minX, y: 0.0, width: width, height: bounds.height)
    }
}
