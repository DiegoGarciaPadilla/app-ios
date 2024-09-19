//
//  RodadasView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct RodadasView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ActivityCardView(
                    activityTitle: "Rodada Nocturna",
                    level: "Nivel 1",
                    date: "Sábado 24 agosto 2024",
                    time: "19:00",
                    duration: "1 hrs",
                    location: "Centro histórico",
                    attendees: 67
                )
                
                ActivityCardView(
                    activityTitle: "Rodada Matutina",
                    level: "Nivel 2",
                    date: "Miércoles 28 agosto 2024",
                    time: "9:00",
                    duration: "1 hrs",
                    location: "Centro histórico",
                    attendees: 83
                )
            }
            .padding(.horizontal)
        }
    }
}

struct RodadasView_Previews: PreviewProvider {
    static var previews: some View {
        RodadasView()
    }
}


