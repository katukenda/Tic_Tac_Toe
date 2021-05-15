//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Janitha Katukenda on 2021-05-15.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
  static  let humanWin = AlertItem(title: Text("You Win"),
                             message: Text("Your Are Smart. You beat your own AI."),
                             buttonTitle: Text("Hello yeah!"))
  static  let computerWin = AlertItem(title: Text("You Lost"),
                             message: Text("Your programe a super AI"),
                             buttonTitle: Text("Rematch"))
  static  let drow = AlertItem(title: Text("Drow"),
                             message: Text("What a battle of with we have heare...."),
                             buttonTitle: Text("Try Again"))
    
}
