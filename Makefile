# 定义项目根目录
THEOS_PROJECT_DIR := $(shell pwd)

# 配置 Theos 路径
export THEOS ?= /theos

# 先加载 Theos 核心配置
include $(THEOS)/makefiles/common.mk

# 构建选项
export DEBUG = 0
export FINALPACKAGE = 1

# 项目名称
TWEAK_NAME = WeChatEnhance

# 根据 SCHEME 变量设置包方案
ifeq ($(SCHEME),roothide)
    export THEOS_PACKAGE_SCHEME = roothide
else ifeq ($(SCHEME),rootless)
    export THEOS_PACKAGE_SCHEME = rootless
else ifeq ($(SCHEME),rootful)
    export THEOS_PACKAGE_SCHEME = rootful
else
    # 默认使用 rootless 方案
    export THEOS_PACKAGE_SCHEME = rootless
endif

# 目标设备配置
export ARCHS = arm64 arm64e
export TARGET = iphone:clang:16.5:15.0

# 源文件
WeChatEnhance_FILES = $(wildcard Hooks/*.xm) \
                     $(wildcard Controllers/*.m) 

# 编译标志
WeChatEnhance_CFLAGS = -fobjc-arc \
                       -I$(THEOS_PROJECT_DIR)/Headers \
                       -I$(THEOS_PROJECT_DIR)/Hooks \
                       -Wno-error \
                       -Wno-unused-variable \
                       -Wno-unused-function

# 框架依赖
WeChatEnhance_FRAMEWORKS = UIKit Foundation LocalAuthentication

# 加载 tweak 编译规则
include $(THEOS_MAKE_PATH)/tweak.mk

# 清理操作
clean::
	@echo -e "\033[31m==>\033[0m 正在清理......"
	@rm -rf .theos packages

# 打包后操作
after-package::
	@echo -e "\033[32m==>\033[0m 编译完成！生成deb包：$$(ls -t packages/*.deb | head -1)"
	@echo -e "\033[32m==>\033[0m 请运行 ./install.sh 将插件安装到设备"
