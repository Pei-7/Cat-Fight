//
//  Sign.swift
//  Cat Fight
//
//  Created by 陳佩琪 on 2023/6/5.
//

import Foundation

enum Sign {
    case rock, paper, scissors
    
    var string: String {
        switch self {
        case .rock:
            return "rock"
        case .paper:
            return "paper"
        case .scissors:
            return "scissors"
        }
    }
    
    var emoji: String{
        switch self {
        case .rock:
            return "✊"
        case .paper:
            return "🖐️"
        case .scissors:
            return "✌️"
        }
    }
    
    static var array :[Sign] = [.rock, .paper, .scissors]
    
}

func randomSign() -> Sign {
    let index = Int.random(in: 0...2)
    switch index {
    case 0:
        return .rock
    case 1:
        return .paper
    default:
        return .scissors
    }
}



