//
//  RootView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject private var session: SessionManager
    
    @State private var showSplash = true
    
    var body: some View {
        
        Group {
            
            if showSplash {
                SplashView()
            } else {
                if session.isLoggedIn {
                    ContentView()
                } else {
                    AppView()
                }
            }
        }
        .onAppear{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                
                withAnimation{
                    showSplash = false
                }            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(SessionManager())
}
