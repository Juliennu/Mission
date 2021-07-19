//
//  BingoLogic.swift
//  Mission
//
//  Created by Juri Ohto on 2021/07/15.
//

import Foundation

public class BingoLogic {
    
    let isDone: Bool
    let bingoWidth: Int

    
    init(isDone: Bool, bingoWidth: Int) {
        self.isDone = isDone
        self.bingoWidth = bingoWidth
    }
    
    func bingo() {
        let numberOftasks = bingoWidth * bingoWidth
        
        if numberOftasks == 9 {
            
        }
        
    }
    
    func judgeBingo() {
        
        var clearCount = 0
        if isDone == true {
            clearCount += 1
        }
        
        if clearCount == bingoWidth {
            print("Bingo!!")
        }else if clearCount == bingoWidth - 1 {
            print("Reach!")
        }
        
    }
    
    
    
    
    
    
    
}
