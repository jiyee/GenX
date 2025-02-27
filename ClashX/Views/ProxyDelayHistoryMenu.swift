//
//  ProxyDelayHistoryMenu.swift
//  ClashX
//
//  Created by yicheng on 2020/4/25.
//  Copyright © 2020 west2online. All rights reserved.
//

import Cocoa
import FlexibleDiff

class ProxyDelayHistoryMenu: NSMenu {
    var currentHistory: [ClashProxySpeedHistory]?

    init(proxy: ClashProxy) {
        super.init(title: "")
        updateHistoryMenu(proxy: proxy)
        NotificationCenter.default.addObserver(self, selector: #selector(proxyInfoDidUpdate(note:)), name: .proxyUpdate(for: proxy.name), object: nil)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func proxyInfoDidUpdate(note: Notification) {
        guard let info = note.object as? ClashProxy else { return }
        updateHistoryMenu(proxy: info)
    }

    private func updateHistoryMenu(proxy: ClashProxy) {
        let histories = Array(proxy.history.reversed())
        let change = Changeset(previous: currentHistory, current: histories, identifier: { $0.time })
        currentHistory = histories
        if change.moves.count == 0 && change.mutations.count == 0 {
            change.removals.reversed().forEach { idx in
                removeItem(at: idx)
            }
            change.inserts.forEach { idx in
                let his = histories[idx]
                let item = NSMenuItem(title: his.displayString, action: nil, keyEquivalent: "")
                insertItem(item, at: idx)
            }
        } else {
            histories.map { his in
                NSMenuItem(title: his.displayString, action: nil, keyEquivalent: "")
            }.forEach { item in
                addItem(item)
            }
        }
    }
}

extension ClashProxySpeedHistory: Equatable {
    static func == (lhs: ClashProxySpeedHistory, rhs: ClashProxySpeedHistory) -> Bool {
        return lhs.displayString == rhs.displayString
    }
}
