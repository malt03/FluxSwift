//
//  RegisteredStore.swift
//  FluxSwift
//
//  Created by Koji Murata on 2020/01/10.
//

import RxSwift
import RxRelay

public final class RegisteredStore<StoreType: StoreBase>: ObservableType {
    public typealias Element = StoreType
    
    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, Observer.Element == StoreType {
        relay.subscribe(observer)
    }
    
    public var entity: StoreType { relay.value }
    
    public func any() -> AnyRegisteredStore { AnyRegisteredStore(self) }
    
    private let relay: BehaviorRelay<StoreType>
    
    func apply<ActionType: Action>(action: ActionType) where ActionType.StoreType == StoreType {
        updateStore(action.reduce(store: entity))
    }
    
    func apply<ActionType: ThrowsAction>(action: ActionType) throws where ActionType.StoreType == StoreType {
        updateStore(try action.reduce(store: entity))
    }
    
    func apply<ActionType: AsyncAction>(action: ActionType) -> Single<StoreType> where ActionType.ActionType.StoreType == StoreType {
        Single<StoreType>.create { (observer) -> Disposable in
            action.createAction(store: self.entity) { [weak self] in
                guard let s = self else { return }
                let store = $0.reduce(store: s.entity)
                s.updateStore(store)
                observer(.success(store ?? s.entity))
            }
            return Disposables.create()
        }
    }
    
    private func updateStore(_ store: StoreType?) {
        guard let store = store else { return }
        
        relay.accept(store)
        observeChildren()
    }
    
    private var childrenBag = DisposeBag()
    private func observeChildren() {
        let disposables = entity.childStores.map {
            $0.didUpdate.subscribe(onNext: { [weak self] _ in
                guard let s = self else { return }
                s.updateStore(s.entity)
            })
        }
        childrenBag = DisposeBag(disposing: disposables)
    }
    
    init(entity: StoreType) {
        self.relay = BehaviorRelay<StoreType>(value: entity)
        observeChildren()
    }
    
    var didUpdate: Observable<Void> { relay.skip(1).map { _ in } }
}
