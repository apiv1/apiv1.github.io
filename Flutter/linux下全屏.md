linux/my_application.cc
```dart
- gtk_window_set_default_size(window, 1280, 720);
+ gtk_window_fullscreen(GTK_WINDOW(window));
```