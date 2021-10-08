include $(TOPDIR)/rules.mk

PKG_NAME:=go-aliyundrive-webdav
PKG_VERSION:=v1.0.1
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
#PKG_SOURCE_URL:=https://codeload.github.com/LinkLeong/go-aliyun-webdav/tar.gz/$(PKG_VERSION)?
#PKG_HASH:=f18f4f7e9bad5fa45dc21b3f5561a6671dcf75c51f0ef577c99d6f8f4f05a009
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/LinkLeong/go-aliyun-webdav.git
PKG_SOURCE_DATE:=2021-10-02
PKG_SOURCE_VERSION:=d4d09994edd0ebbee8764ce27e1f9bdd02e8fb23
PKG_MIRROR_HASH:=22a3490a4daa35c7a458b2228ca8fa3a3854fc0fac391251d1fdea3d7463c614

PKG_MAINTAINER:=Link Liang <a624669980@gmail.com>
PKG_LICENSE:=APACHE V2
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=go-aliyun-webdav
GO_PKG_LDFLAGS:=-s -w
PKG_CONFIG_DEPENDS := CONFIG_$(PKG_NAME)_INCLUDE_GOPROXY

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/$(PKG_NAME)/config
config $(PKG_NAME)_INCLUDE_GOPROXY
	bool "Compiling with GOPROXY proxy"
	default y

endef

ifeq ($(CONFIG_$(PKG_NAME)_INCLUDE_GOPROXY),y)
export GO111MODULE=on
export GOPROXY=https://goproxy.io
#export GOPROXY=https://mirrors.aliyun.com/goproxy/
endif

define Package/$(PKG_NAME)
	TITLE:=A Webdav Service of Aliyun pan
	SECTION:=net
	CATEGORY:=Network
	URL:=https://github.com/LinkLeong
	DEPENDS:=$(GO_ARCH_DEPENDS) 
endef

define Package/$(PKG_NAME)/description
	A Webdav Service of Aliyun Drive
endef

define Build/Prepare
	$(call Build/Prepare/Default)
endef

define Build/Compile
	$(call GoPackage/Build/Compile)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/go-aliyun-webdav || true
endef

define Package/$(PKG_NAME)/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/go-aliyun-webdav $(1)/usr/bin/go-aliyundrive-webdav
endef

$(eval $(call GoBinPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
