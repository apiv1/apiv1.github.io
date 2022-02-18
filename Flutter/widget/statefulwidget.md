# StatefulWidget

一个拥有可变state的widget.

State:
  指在widget生命周期内可被读取, 且可变的信息, Widget开发者需要使用State.setState在此类状态更改时及时通知状态。

StatefulWidget通过"创建对用户界面更具体描述的其他widget"来描述部分用户界面, 构建过程递归执行, 直到对用户界面的描述已经完全构建.

StatefulWidget作用是能让你描述的部分用户界面可以动态变更.

StatefulWidget实例自身不可变更, 存储可变的state

### 理解

Widget本身不可变, 带一个可变的State, 通常Widget被插进Widget Tree就新生成一个State. State有自己的生命周期.
