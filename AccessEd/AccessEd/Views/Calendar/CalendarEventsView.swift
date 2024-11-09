//
//  CalendarEventsView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-09.
//

import SwiftUI

struct CalendarEventsView: View {
    var body: some View {
        VStack {
            List{
                ForEach(0..<10) { index in
                    Text("\(index) --> event")
                }
            }
        }
    }
}

#Preview {
    CalendarEventsView()
}
