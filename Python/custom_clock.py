import tkinter as tk
from time import strftime
import math
import random
import netifaces
import threading
import os
import time

class CPUMonitor:
    def __init__(self):
        self.prev_stats = None
        self.prev_time = None

    def get_cpu_usage(self):
        """无延时的 CPU 使用率计算（需连续调用）"""
        current_stats = self._read_cpu_stats()
        current_time = time.time()

        if self.prev_stats is None:
            self.prev_stats = current_stats
            self.prev_time = current_time
            return 0.0  # 首次调用返回0

        # 计算差值
        total_diff = sum(current_stats) - sum(self.prev_stats)
        idle_diff = current_stats[3] - self.prev_stats[3]
        time_diff = current_time - self.prev_time

        # 保存状态
        self.prev_stats = current_stats
        self.prev_time = current_time

        if total_diff == 0 or time_diff <= 0:
            return 0.0
        return round(100 * (total_diff - idle_diff) / total_diff, 1)

    def _read_cpu_stats(self):
        with open("/proc/stat") as f:
            line = f.readline().split()
        return list(map(int, line[1:]))

class CustomClock:
    def __init__(self):
        # 窗口初始化
        self.root = tk.Tk()
        self.root.attributes("-fullscreen", True)
        self.root.configure(bg='black')
        self.root.config(cursor='none')
        self.root.attributes("-alpha", 0.3)
        self.root.bind("<Button-1>", self.safe_exit)  # 点击退出绑定

        # 屏幕参数
        self.screen_width = self.root.winfo_screenwidth()
        self.screen_height = self.root.winfo_screenheight()

        # 字体系统
        self.target_text_width = self.screen_width // 2
        self.init_font_size = 100
        self.time_font = self.find_optimal_font()
        self.date_font = (self.time_font[0], self.time_font[1]//3, 'bold')
        self.sys_font = (self.time_font[0], self.time_font[1]//5, 'bold')
        self.ip_font = (self.time_font[0], self.time_font[1]//4, 'bold')
        self.margin = int(self.time_font[1] * 0.5)

        self.cpu_monitor = CPUMonitor()

        # 顶部状态栏
        self.top_bar_height = 50
        self.vertical_padding = (self.top_bar_height - self.date_font[1]) // 2

        # 日期标签
        self.date_label = tk.Label(
            self.root,
            text="",
            font=self.date_font,
            fg="#666666",
            bg="black",
            anchor='ne'
        )
        self.date_label.place(relx=0.98, y=self.vertical_padding, anchor='ne')

        # 网络标签
        self.ip_label = tk.Label(
            self.root,
            text="",
            font=self.ip_font,
            fg="#00FF00",
            bg="black",
            anchor='nw'
        )
        self.ip_text = ""
        self.prev_ip_text = ""
        self.ip_label.place(x=10, y=self.screen_height - self.margin)

        # 时间标签
        self.time_label = tk.Label(
            self.root,
            text="00:00:00",
            font=self.time_font,
            bg="black"
        )
        self.time_label.place(x=0, y=self.top_bar_height)

        self.status_label = tk.Label(
            self.root,
            text='',
            font=self.sys_font,
            fg="#1CBEB3",
            bg="black",
        )
        self.status_label.place(x=10, y=self.vertical_padding)

        self.root.update_idletasks()
        self.label_width = self.time_label.winfo_width()
        self.label_height = self.time_label.winfo_height()

        # 弹球参数
        self.x = random.randint(self.margin, self.screen_width-self.margin-self.label_width)
        self.y = random.randint(
            self.top_bar_height + self.margin,
            self.screen_height - self.margin - self.label_height
        )
        self.dx = random.choice([-2, 2])
        self.dy = random.choice([-1, 1])

        # 状态参数
        self.breath_phase = 0
        self.breath_speed = 0.03
        self.need_scroll = False
        self.scroll_offset = 0
        self.check_interval = 2

        # 监控线程
        self.monitor_active = True
        threading.Thread(target=self.network_monitor, daemon=True).start()
        threading.Thread(target=self.sys_resource_monitor, daemon=True).start()

        self.update_network_display()
        self.update_clock()
        self.check_fullscreen()
        self.root.mainloop()

    def check_fullscreen(self):
        """检查是否成功应用全屏，如果没有则重试"""
        actual_width = self.root.winfo_width()
        actual_height = self.root.winfo_height()
        expected_width = self.root.winfo_screenwidth()
        expected_height = self.root.winfo_screenheight()

        # 如果窗口尺寸不匹配屏幕尺寸，重新应用全屏
        if (actual_width < expected_width * 0.9 or actual_height < expected_height * 0.9):
            self.root.attributes("-fullscreen", False)
            self.root.update_idletasks()
            self.root.attributes("-fullscreen", True)
            self.root.update_idletasks()
            self.root.after(500, self.check_fullscreen)

    def get_cpu_temperature(self):
        res = os.popen('vcgencmd measure_temp').readline()
        return(res.replace("temp=","").replace("\n", ""))

    def get_mem_usage(self):
        """获取内存使用百分比"""
        with open("/proc/meminfo") as f:
            meminfo = {line.split(':')[0]: line.split(':')[1].strip()
                    for line in f.readlines()}

        total = int(meminfo["MemTotal"].split()[0])
        available = int(meminfo.get("MemAvailable", meminfo["MemFree"]).split()[0])

        return round(100 * (total - available) / total, 1)

    def get_cpu_use(self):
        return(self.cpu_monitor.get_cpu_usage())

    def sys_resource_monitor(self):
        while self.monitor_active:
            # 获取当前 CPU 和内存使用率
            mem_percent = self.get_mem_usage()
            temp = self.get_cpu_temperature()
            cpu = self.get_cpu_use()

            # 格式化显示
            status = f"tem: {temp} | cpu: {cpu}% | mem: {mem_percent}%"

            self.status_label.config(text=status)
            threading.Event().wait(self.check_interval)

    def network_monitor(self):
        """网络状态持续监控"""
        while self.monitor_active:
            new_ip = self.get_network_info()
            if new_ip != self.prev_ip_text:
                self.prev_ip_text = new_ip
                self.ip_text = new_ip
                self.root.after(0, self.update_network_display)
            threading.Event().wait(self.check_interval)

    def update_network_display(self):
        """更新网络显示"""
        self.ip_label.config(text=self.ip_text)
        self.root.update_idletasks()

        text_width = self.ip_label.winfo_reqwidth()
        available_width = self.screen_width - self.margin
        new_need_scroll = text_width > available_width

        if new_need_scroll != self.need_scroll:
            self.need_scroll = new_need_scroll
            if self.need_scroll:
                self.scroll_offset = 0
                self.start_scroll()

    def find_optimal_font(self):
        """动态计算最佳字体"""
        test_font = ('Helvetica', self.init_font_size, 'bold')
        temp_label = tk.Label(self.root, text="00:00:00", font=test_font)
        temp_label.place(x=-1000, y=-1000)
        self.root.update_idletasks()

        low, high = 10, 300
        best_size = 50

        while low <= high:
            mid = (low + high) // 2
            test_font = ('Helvetica', mid, 'bold')
            temp_label.config(font=test_font)
            width = temp_label.winfo_reqwidth()

            if width < self.target_text_width:
                best_size = mid
                low = mid + 1
            else:
                high = mid - 1

        temp_label.destroy()
        return ('Helvetica', best_size, 'bold')

    def get_network_info(self):
        """获取网络信息（支持多接口）"""
        info = []

        prefixs = ['wlan', 'eth']
        for ifs in netifaces.interfaces():
            for prefix in prefixs:
                if ifs.find(prefix) == 0:
                    try:
                        addr = netifaces.ifaddresses(ifs).get(netifaces.AF_INET, [{}])[0].get('addr')
                        if addr:
                            info.append(f"{ifs}: {addr}")
                            break
                    except (ValueError, KeyError):
                        continue

        return "  |  ".join(info) if info else "No Network Connection"

    def start_scroll(self):
        """启动滚动效果"""
        if not self.need_scroll:
            return

        self.scroll_offset -= 1
        text_width = self.ip_label.winfo_reqwidth()

        if self.scroll_offset < -text_width:
            self.scroll_offset = self.screen_width

        current_y = self.screen_height - self.margin
        self.ip_label.place(x=self.scroll_offset, y=current_y)
        self.root.after(20, self.start_scroll)

    def update_position(self):
        """更新弹球位置"""
        if self.x + self.label_width >= self.screen_width - self.margin:
            self.dx = -abs(self.dx)
        elif self.x <= self.margin:
            self.dx = abs(self.dx)

        if self.y + self.label_height >= self.screen_height - self.margin:
            self.dy = -abs(self.dy)
        elif self.y <= self.top_bar_height + self.margin:
            self.dy = abs(self.dy)

        self.x += self.dx
        self.y += self.dy
        self.time_label.place(x=self.x, y=self.y)

    def update_color(self):
        """更新呼吸灯颜色"""
        self.breath_phase += self.breath_speed
        brightness = (math.sin(self.breath_phase) + 1) / 2

        r = int(255 * brightness)
        g = int(255 * (1 - abs(brightness - 0.5) * 2))
        b = int(255 * (1 - brightness))

        self.time_label.config(fg=f"#{r:02x}{g:02x}{b:02x}")

    def update_clock(self):
        """主更新循环"""
        current_time = strftime("%H:%M:%S")
        current_date = strftime("%Y-%m-%d %A")

        self.time_label.config(text=current_time)
        self.date_label.config(text=current_date)

        self.update_position()
        self.update_color()
        self.root.after(30, self.update_clock)

    def safe_exit(self, event=None):
        """安全退出程序"""
        self.monitor_active = False
        self.root.destroy()

if __name__ == "__main__":
    CustomClock()
