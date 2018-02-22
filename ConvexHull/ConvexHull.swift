//
//  ConvexHull.swift
//  ConvexHull
//
//  Created by Takanari Hayama on 2018/02/20.
//  Copyright © 2018年 IGEL Co.,Ltd. All rights reserved.
//

import Foundation

extension Double {
    var square: Double { return self * self }
}

protocol Coordinate: CustomStringConvertible {
    var x: Double { get }
    var y: Double { get }
}

extension Coordinate {
    var description: String { return "(\(x), \(y))" }
}

struct ConvexHullSolver {
    struct Point: Coordinate {
        let x: Double
        let y: Double
        private(set) var cosine = 1.0

        var origin: Coordinate? {
            didSet {
                if let origin = origin {
                    let magnitude = ((x - origin.x).square + (y - origin.y).square).squareRoot()
                    if magnitude != 0.0 {
                        cosine = (x - origin.x) / magnitude
                    }
                }
            }
        }

        init(withCoordinate c: Coordinate) {
            self.x = c.x
            self.y = c.y
        }
    }
    
    let points: [Coordinate]
    private(set) var convexHull = [Coordinate]()

    init(points: [Coordinate]) {
        self.points = points
        solve()
    }
    
    /// Solve convex hull based on Graham Scan as described in https://en.wikipedia.org/wiki/Graham_scan
    mutating private func solve() {
        guard points.count > 2 else { return }

        var convexHull = points.map {
            Point(withCoordinate: $0)
        }
        
        // Find the most left bottom point
        var indexOfLeftBottomMost = 0
        for index in 1..<convexHull.count {
            let p0 = convexHull[indexOfLeftBottomMost]
            let p = convexHull[index]
            
            if p.y < p0.y || p.y == p0.y && p.x < p0.x {
                indexOfLeftBottomMost = index
            }
        }
        
        // Bring the most left bottom point to the front.
        // This point becomes the origin.
        convexHull.swapAt(0, indexOfLeftBottomMost)
        let origin = convexHull[0]
        
        // Set origin to caclcualte cosine between x-axis and the each point
        for index in convexHull.indices {
            convexHull[index].origin = origin
        }

        // Sort points around the origin in anti-clockwise order
        convexHull = convexHull.sorted { $0.cosine > $1.cosine }
        
        // Insert the last point to the top for the guard.
        convexHull.insert(convexHull.last!, at: 0)
        
        // Number of points in convex hull.
        var m = 1
        let n = convexHull.count - 1
        for var i in 2...n {
            while crossProduct(p1: convexHull[m-1], p2: convexHull[m], p3: convexHull[i]) <= 0.0 {
                if m > 1 {
                    m -= 1
                    continue
                } else if i == n {
                    break
                } else {
                    i += 1
                }
            }
            m += 1
            convexHull.swapAt(m, i)
        }
        self.convexHull = [Point](convexHull.prefix(m))
    }
    
    /// Calculate cross product of vectors (p1,p2) and (p1,p3)
    ///
    /// - Returns:
    ///     Positive value if (p1,p3) is on the left of (p1,p2).
    ///
    ///     Negative value if (p1,p3) is on the right of (p1,p2).
    ///
    ///     0, if p1, p2, and p3 are inline.
     private func crossProduct(p1: Coordinate, p2: Coordinate, p3: Coordinate) -> Double {
        return (p2.x - p1.x)*(p3.y - p1.y) - (p2.y - p1.y)*(p3.x - p1.x)
    }
}
