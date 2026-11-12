# campusflow_riverpod

CampusFlow (workshop of session 6): navigation with go_router and shared state with Riverpod, starting from the three screens of session 5.

Work done, one commit per step:

1. Starting point: the three screens with `setState`.
2. Dependencies `flutter_riverpod` and `go_router`, `ProviderScope` in `main`.
3. Shared state: `TasksNotifier` with task ids, list, detail and form connected to it.
4. Routes: `GoRouter` with a `ShellRoute` and the navigation bar, path parameter `:id`.
5. Filters: a derived provider for to do, done and overdue tasks.

## Run

```
flutter pub get
flutter run -d edge
flutter test
```
