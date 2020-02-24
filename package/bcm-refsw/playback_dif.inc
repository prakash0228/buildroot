
define BCM_REFSW_DIF_PATCHES
    $(APPLY_PATCHES) $(@D) $(BCM_REFSW_PKGDIR)/dif 9996-zlib-change_gcc_tools_for_native_build.patch.conditional 
    $(APPLY_PATCHES) $(@D) $(BCM_REFSW_PKGDIR)/dif 9997-protobuf-change_gcc_tools_for_native_build.patch.conditional
    $(APPLY_PATCHES) $(@D) $(BCM_REFSW_PKGDIR)/dif 9998-dif-force-job-count-for-widevine-build.patch.conditional
endef

define BCM_REFSW_PLAYBACK_DIF_SHARED_LIBRARY
    $(APPLY_PATCHES) $(@D) $(BCM_REFSW_PKGDIR)/dif 9999-dif.examples-allow_shared_library_build.patch.conditional
endef

define BCM_REFSW_BUILD_DIF
    PLATFORM=${BCM_REFSW_PLATFORM} \
    $(TARGET_CONFIGURE_OPTS) \
 	$(TARGET_MAKE_ENV) \
 	$(BCM_REFSW_CONF_OPTS) \
 	$(BCM_REFSW_MAKE_ENV) \
	$(MAKE) -C $(@D)/BSEAV/lib/security/dif
endef

define BCM_REFSW_INSTALL_DIF_HEADERS
    $(INSTALL) -m 644 -D $(@D)/BSEAV/lib/security/dif/examples/playback/playback_dif.h \
            $(1)/usr/include
endef

define BCM_REFSW_INSTALL_DIF_LIBS
    $(INSTALL) -m 755 -D $(BCM_REFSW_OUTPUT)/nexus/bin/libbcrypt.so             $(1)/usr/lib
    $(INSTALL) -m 755 -D $(BCM_REFSW_OUTPUT)/nexus/bin/libcmndrm.so             $(1)/usr/lib
    $(INSTALL) -m 755 -D $(BCM_REFSW_OUTPUT)/nexus/bin/libcmndrm_tl.so          $(1)/usr/lib
    $(INSTALL) -m 755 -D $(BCM_REFSW_OUTPUT)/nexus/bin/libcmndrmprdy.so         $(1)/usr/lib
    $(INSTALL) -m 755 -D $(BCM_REFSW_OUTPUT)/nexus/bin/libplayreadypk_host.so   $(1)/usr/lib
    $(INSTALL) -m 755 -D $(BCM_REFSW_OUTPUT)/nexus/bin/liboemcrypto_tl.so       $(1)/usr/lib
    $(INSTALL) -m 755 -D $(BCM_REFSW_OUTPUT)/nexus/bin/libwvcdm.so              $(1)/usr/lib
    $(INSTALL) -m 755 -D $(BCM_REFSW_OUTPUT)/nexus/bin/libprotobuf-lite.so.9    $(1)/usr/lib
    $(INSTALL) -m 755 -D $(BCM_REFSW_OUTPUT)/nexus/bin/libdif.so                $(1)/usr/lib
    
    if [[ ! -f $(1)/usr/lib/libprotobuf-lite.so ]]; then \
        ln -s $(1)/usr/lib/libprotobuf-lite.so.9 $(1)/usr/lib/libprotobuf-lite.so ; \
    fi ; \
    
endef

define BCM_REFSW_DIF_INSTALL
    $(INSTALL) -m 755 -D $(BCM_REFSW_OUTPUT)/nexus/bin/libdif.so                $(1)/usr/lib
    $(call BCM_REFSW_INSTALL_DIF_LIBS, $(1))
endef

ifeq ($(BR2_PACKAGE_BCM_REFSW_PLAYBACK_DIF),y)

define BCM_REFSW_BUILD_PLAYBACK_DIF
    PLATFORM=${BCM_REFSW_PLATFORM} \
    $(TARGET_CONFIGURE_OPTS) \
 	$(TARGET_MAKE_ENV) \
 	$(BCM_REFSW_CONF_OPTS) \
 	$(BCM_REFSW_MAKE_ENV) \
    BUILD_SHARED=y \
	$(MAKE) -C $(@D)/BSEAV/lib/security/dif/examples
endef

define BCM_REFSW_PLAYBACK_DIF_INSTALL
    $(INSTALL) -m 755 -D $(BCM_REFSW_OUTPUT)/BSEAV/lib/security/dif/examples/bin/final/* $(1)/usr/lib
endef

endif
