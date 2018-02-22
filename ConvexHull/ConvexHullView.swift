//
//  ConvexHullView.swift
//  ConvexHull
//
//  Created by Takanari Hayama on 2018/02/20.
//  Copyright © 2018年 IGEL Co.,Ltd. All rights reserved.
//

import UIKit

class ConvexHullView: UIView {
    var positions = [CGPoint]()
    var paths = [CGPoint]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var dotColor: UIColor = .red
    @IBInspectable var pathColor: UIColor = .blue
    @IBInspectable var dotRadius: CGFloat = 2.5
    @IBInspectable var pathWidth: CGFloat = 3.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func reset() {
        positions = []
        paths = []
        setNeedsDisplay()
    }
    
    private func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let position = sender.location(in: self)
            positions.append(position)
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        if paths.count > 1 {
            let lines = UIBezierPath()
            pathColor.setStroke()
            lines.lineWidth = pathWidth
            
            lines.move(to: paths[0])
            for p in paths.suffix(paths.count - 1) {
                lines.addLine(to: p)
            }
            lines.addLine(to: paths[0])
            lines.stroke()
        }

        if !positions.isEmpty {
            let dots = UIBezierPath()
            dotColor.setFill()
            for p in positions {
                dots.move(to: p)
                dots.addArc(withCenter: p, radius: dotRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            }
            dots.fill()
        }
    }
}
