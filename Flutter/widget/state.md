# [State](https://api.flutter.dev/flutter/widgets/State-class.html)

### Desc
```
The logic and internal state for a StatefulWidget.

State is information that (1) can be read synchronously when the widget is built and (2) might change during the lifetime of the widget. It is the responsibility of the widget implementer to ensure that the State is promptly notified when such state changes, using State.setState.

State objects are created by the framework by calling the StatefulWidget.createState method when inflating a StatefulWidget to insert it into the tree. Because a given StatefulWidget instance can be inflated multiple times (e.g., the widget is incorporated into the tree in multiple places at once), there might be more than one State object associated with a given StatefulWidget instance. Similarly, if a StatefulWidget is removed from the tree and later inserted in to the tree again, the framework will call StatefulWidget.createState again to create a fresh State object, simplifying the lifecycle of State objects.

StatefulWidget 的逻辑和内部状态。

状态是（1）可以在构建小部件时同步读取的信息，以及（2）可能在小部件的生命周期内发生变化的信息。 小部件实现者有责任使用 State.setState 确保在此类状态更改时及时通知状态。

状态对象是由框架通过调用 StatefulWidget.createState 方法来创建的，当对 StatefulWidget 进行渲染以将其插入到树中时。 因为给定的 StatefulWidget 实例可以多次渲染（例如，小部件一次在多个位置合并到树中），所以可能有多个 State 对象与给定的 StatefulWidget 实例相关联。 类似地，如果一个 StatefulWidget 从树中移除，然后再次插入到树中，框架将再次调用 StatefulWidget.createState 来创建一个新的 State 对象，从而简化 State 对象的生命周期。
```