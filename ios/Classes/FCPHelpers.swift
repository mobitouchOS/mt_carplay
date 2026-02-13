//
//  FCPHelpers.swift
//  mt_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

func makeFCPChannelId(event: String?) -> String {
  return "net.mobitouch.mt_carplay" + event!
}
