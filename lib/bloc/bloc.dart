import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'transition.dart';
import 'bloc_supervisor.dart';

abstract class Bloc<Event, State> {
  final PublishSubject<Event> _eventSubject = PublishSubject<Event>();
  BehaviorSubject<State> _stateSubject;

  // Return the initial value
  State get initialState;

  // Return the last element emited by the stream of the state subject
  State get currentState => _stateSubject.value;

  Stream<State> get state => _stateSubject.stream;

  Bloc() {
    _stateSubject = BehaviorSubject<State>.seeded(initialState);
    _bindStateSubject();
  }

  @mustCallSuper
  void dispose() {
    _eventSubject.close();
    _stateSubject.close();
  }

  void onTransition(Transition<Event, State> transition) => null;

  void onError(Object error, StackTrace stackTrace) => null;

  void onEvent(Event event) => null;

  // Add events to bloc
  void dispatch(Event event) {
    try {
      BlocSupervisor.delegate.onEvent(this, event);
      onEvent(event);
      _eventSubject.sink.add(event);
    } catch (error) {
      _handleError(error);
    }
  }

  Stream<State> transform(
    Stream<Event> events,
    Stream<State> next(Event event),
  ) {
    return events.asyncExpand(next);
  }

  Stream<State> mapEventToState(Event event);

  void _bindStateSubject() {
    Event currentEvent;

    transform(
      _eventSubject,
      (Event event) {
        currentEvent = event;
        return mapEventToState(currentEvent).handleError(_handleError);
      },
    ).forEach(
      (State nextState) {
        if (currentState == state || _stateSubject.isClosed) return;

        final transition = Transition(
          currentState: currentState,
          event: currentEvent,
          nextState: nextState,
        );

        BlocSupervisor.delegate.onTransition(this, transition);

        onTransition(transition);

        _stateSubject.sink.add(nextState);
      },
    );
  }

  void _handleError(Object error, [StackTrace stackTrace]) {
    BlocSupervisor.delegate.onError(this, error, stackTrace);
    onError(error, stackTrace);
  }
}
