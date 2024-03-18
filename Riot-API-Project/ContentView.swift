//
//  ContentView.swift
//  Riot-API-Project
//
//  Created by Micah Howard on 12/20/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var task = NetworkManager()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(task.PUID)
        }.onAppear {
            task.fetchPUIDs(completionHandler: {_ in })
        }
        .padding()
    }
}
   

#Preview {
    ContentView()
}
