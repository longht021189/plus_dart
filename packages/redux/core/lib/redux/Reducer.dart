abstract class Reducer<State, Action> {
  State get initialState;
  Future<State> onUpdate(State state, Action action);
  Future close() async {}
}