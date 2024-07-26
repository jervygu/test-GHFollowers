//
//  FollowerView.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/26/24.
//

import SwiftUI

struct FollowerView: View {
    
    var follower: Follower
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: follower.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
//                Image("avatar-placeholder")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
                Image(.avatarPlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .clipShape(Circle())
            
            Text(follower.login)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
    }
}

#Preview {
    FollowerView(follower: Follower(login: "jervygu", avatarUrl: ""))
}

// BEFORE iOS 17
//struct FollowerView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            FollowerView(follower: Follower(login: "jervygu", avatarUrl: ""))
//        }
//    }
//}
