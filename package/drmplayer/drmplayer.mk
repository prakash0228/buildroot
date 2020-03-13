DRMPLAYER_VERSION = 8ddefab6cb78ad6a5e67619bf1413b2b17a2b05f
DRMPLAYER_SITE = git@github.com:Metrological/DRMPlayer.git
DRMPLAYER_SITE_METHOD = git
DRMPLAYER_INSTALL_TARGET = YES

ifeq ($(BR2_PACKAGE_DRMPLAYER_NEXUS),y)
	DRMPLAYER_DEPENDENCIES = bcm-refsw
	DRMPLAYER_CONF_OPTS += -DTARGET_TYPE="nexus"
else
	DRMPLAYER_CONF_OPTS += -DTARGET_TYPE="generic"
	DRMPLAYER_DEPENDENCIES =
endif

define DRMPLAYER_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/drmplayer $(TARGET_DIR)/usr/bin
endef

$(eval $(cmake-package))
