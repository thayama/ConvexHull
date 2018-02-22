//
//  ConvexHullViewController.swift
//  ConvexHull
//
//  Created by Takanari Hayama on 2018/02/20.
//  Copyright © 2018年 IGEL Co.,Ltd. All rights reserved.
//

import UIKit

class ConvexHullViewController: UIViewController {

    @IBOutlet weak var convexHullView: ConvexHullView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func reset(_ sender: UIBarButtonItem) {
        convexHullView.reset()
    }
    
    struct Point: Coordinate {
        let x: Double
        let y: Double
        
        init(withCGPoint point: CGPoint) {
            x = Double(point.x)
            y = Double(point.y)
        }
    }

    @IBAction func start(_ sender: UIBarButtonItem) {
//        convexHullView.paths = convexHullView.positions
        
        let points = convexHullView.positions.map {
            Point(withCGPoint: $0)
        }
        let solver = ConvexHullSolver(points: points)
        let ch = solver.convexHull
        print("solved: \(ch)")
        
        let paths = ch.map {
            CGPoint(x: $0.x, y: $0.y)
        }
        
//        convexHullView.paths = [CGPoint](paths[0...1])
//        if paths.count > 2 {
//            var n = 3
//            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] (timer) in
//                self?.convexHullView.paths = [CGPoint](paths.prefix(n))
//                n += 1
//                if n > paths.count {
//                    timer.invalidate()
//                }
//            }
//        }
        
        convexHullView.paths = paths
    }
}
