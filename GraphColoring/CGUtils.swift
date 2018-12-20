//
//  CGUtils.swift
//  SmappSDK
//
//  Created by farhad jebelli on 12/13/18.
//

import Foundation

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func +=( lhs: inout CGPoint, rhs: CGPoint) {
    lhs = rhs + lhs
}

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func -=( lhs: inout CGPoint, rhs: CGPoint) {
    lhs = rhs - lhs
}

func innerProduct(lhs: CGPoint, rhs: CGPoint) -> CGFloat {
    return lhs.x * rhs.x + lhs.y * rhs.y
}

extension CGPoint {
    func magnitudePow2() -> CGFloat {
        return innerProduct(lhs: self, rhs: self)
    }
}


