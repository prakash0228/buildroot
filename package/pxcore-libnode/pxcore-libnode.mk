################################################################################
#
# pxcore-libnode
#
################################################################################

PXCORE_LIBNODE_VERSION = 51333037650ecee44191492b541106efa573cc35
PXCORE_LIBNODE_SITE_METHOD = git
PXCORE_LIBNODE_SITE = git://github.com/pxscene/pxCore
PXCORE_LIBNODE_DEPENDENCIES = host-python openssl
PXCORE_LIBNODE_INSTALL_STAGING = YES
PXCORE_LIBNODE_LICENSE = MIT (core code); MIT, Apache and BSD family licenses (Bundled components)
PXCORE_LIBNODE_LICENSE_FILES = LICENSE
PXCORE_LIBNODE_DEPENDENCIES = openssl host-qemu
PXCORE_LIBNODE_CONF_OPTS = \
        --shared \
	--without-snapshot \
	--dest-os=linux \
        --shared-openssl \
        --without-intl

ifeq ($(BR2_i386),y)
PXCORE_LIBNODE_CPU = ia32
else ifeq ($(BR2_x86_64),y)
PXCORE_LIBNODE_CPU = x64
else ifeq ($(BR2_mips),y)
PXCORE_LIBNODE_CPU = mips
else ifeq ($(BR2_mipsel),y)
PXCORE_LIBNODE_CPU = mipsel
else ifeq ($(BR2_arm),y)
PXCORE_LIBNODE_CPU = arm
else ifeq ($(BR2_aarch64),y)
PXCORE_LIBNODE_CPU = arm64
# V8 needs to know what floating point ABI the target is using.
PXCORE_LIBNODE_ARM_FP = $(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
endif

# MIPS architecture specific options
ifeq ($(BR2_mips)$(BR2_mipsel),y)
ifeq ($(BR2_MIPS_CPU_MIPS32R6),y)
PXCORE_LIBNODE_MIPS_ARCH_VARIANT = r6
PXCORE_LIBNODE_MIPS_FPU_MODE = fp64
else ifeq ($(BR2_MIPS_CPU_MIPS32R2),y)
PXCORE_LIBNODE_MIPS_ARCH_VARIANT = r2
else ifeq ($(BR2_MIPS_CPU_MIPS32),y)
PXCORE_LIBNODE_MIPS_ARCH_VARIANT = r1
endif
endif

PXCORE_LIBNODE_VER = 10.15.3
PXCORE_LIBNODE_LIB_VER = 64
PXCORE_LIBNODE_GYP_PATH = tools/gyp
PXCORE_LIBNODE_DIRECTORY = libnode-v$(PXCORE_LIBNODE_VER)
PXCORE_LIBNODE_PATH = examples/pxScene2d/external

define PXCORE_LIBNODE_PATCHING
    echo "Test" ; \
    patch -p1 <$(PXCORE_LIBNODE_PATH)/node-v$(PXCORE_LIBNODE_VER)_mods.patch; \
    patch -p1 <$(PXCORE_LIBNODE_PATH)/node-v$(PXCORE_LIBNODE_VER)_qemu_wrapper.patch; \
    patch -p1 <$(PXCORE_LIBNODE_PATH)/openssl_1.0.2_compatibility.patch; \
    sed -i "s:KERNEL_VERSION:$(BR2_TOOLCHAIN_HEADERS_AT_LEAST):g" $(@D)/$(PXCORE_LIBNODE_PATH)/$(PXCORE_LIBNODE_DIRECTORY)/v8-qemu-wrapper.sh; \
    sed -i "s:STAGING:$(STAGING_DIR):g" $(@D)/$(PXCORE_LIBNODE_PATH)/$(PXCORE_LIBNODE_DIRECTORY)/v8-qemu-wrapper.sh; \
    sed -i "s:ARCH:$(PXCORE_LIBNODE_CPU):g" $(@D)/$(PXCORE_LIBNODE_PATH)/$(PXCORE_LIBNODE_DIRECTORY)/v8-qemu-wrapper.sh; \
    chmod +x $(@D)/$(PXCORE_LIBNODE_PATH)/$(PXCORE_LIBNODE_DIRECTORY)/v8-qemu-wrapper.sh;
endef

define PXCORE_LIBNODE_COPY_PATCH
    cp package/pxcore-libnode/node-v$(PXCORE_LIBNODE_VER)_mods.patch.file $(@D)/$(PXCORE_LIBNODE_PATH)/node-v$(PXCORE_LIBNODE_VER)_mods.patch; \
    cp package/pxcore-libnode/node-v$(PXCORE_LIBNODE_VER)_qemu_wrapper.patch.file $(@D)/$(PXCORE_LIBNODE_PATH)/node-v$(PXCORE_LIBNODE_VER)_qemu_wrapper.patch; \
    cp package/pxcore-libnode/openssl_1.0.2_compatibility.patch.file $(@D)/$(PXCORE_LIBNODE_PATH)/openssl_1.0.2_compatibility.patch \
    cp package/pxcore-libnode/v8-qemu-wrapper.sh $(@D)/$(PXCORE_LIBNODE_PATH)/$(PXCORE_LIBNODE_DIRECTORY)/;
endef

define PXCORE_LIBNODE_EXTRACT
        $(PXCORE_LIBNODE_COPY_PATCH) \
        cd $(@D)/; \
        find . -name examples -prune -o -type f -exec rm -rf {} +; \
        find . -name examples -prune -o -type d -exec rm -rf {} +; \
        $(PXCORE_LIBNODE_PATCHING) \
        mv $(PXCORE_LIBNODE_PATH)/$(PXCORE_LIBNODE_DIRECTORY)/* $(@D)/; \
        rm -rf examples/; \
        touch $(@D)/.stamp_downloaded \
        touch $(@D)/.stamp_extracted
endef
PXCORE_LIBNODE_POST_EXTRACT_HOOKS += PXCORE_LIBNODE_EXTRACT

define PXCORE_LIBNODE_CONFIGURE_CMDS
	mkdir -p $(@D)/bin
	ln -sf $(HOST_DIR)/usr/bin/python2 $(@D)/bin/python

	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		PATH=$(@D)/bin:$(BR_PATH) \
		LD="$(TARGET_CXX)" \
		PYTHON=$(HOST_DIR)/usr/bin/python2 \
		$(HOST_DIR)/usr/bin/python2 ./configure \
		--prefix=/usr \
		--dest-cpu=$(PXCORE_LIBNODE_CPU) \
		$(if $(PXCORE_LIBNODE_ARM_FP),--with-arm-float-abi=$(PXCORE_LIBNODE_ARM_FP)) \
		$(if $(PXCORE_LIBNODE_MIPS_ARCH_VARIANT),--with-mips-arch-variant=$(PXCORE_LIBNODE_MIPS_ARCH_VARIANT)) \
		$(if $(PXCORE_LIBNODE_MIPS_FPU_MODE),--with-mips-fpu-mode=$(PXCORE_LIBNODE_MIPS_FPU_MODE)) \
		$(PXCORE_LIBNODE_CONF_OPTS) \
	)

	# use host version of mkpeephole
	sed "s#<(mkpeephole_exec)#$(HOST_DIR)/usr/bin/mkpeephole#g" -i $(@D)/deps/v8/gypfiles/v8.gyp

endef

define PXCORE_LIBNODE_BUILD_CMDS
	$(TARGET_MAKE_ENV) PYTHON=$(HOST_DIR)/usr/bin/python2 \
		$(MAKE) -C $(@D) \
		$(TARGET_CONFIGURE_OPTS) \
		PATH=$(@D)/bin:$(BR_PATH) \
		LD="$(TARGET_CXX)"
endef

define PXCORE_LIBNODE_INSTALL_SHARED
        $(INSTALL) -m 755 $(@D)/out/Release/lib.target/libnode.so.$(PXCORE_LIBNODE_LIB_VER) $(1)/usr/lib/
        ln -sf libnode.so.$(PXCORE_LIBNODE_LIB_VER) $(1)/usr/lib/libnode.so
endef

define PXCORE_LIBNODE_INSTALL_STAGING_CMDS
        $(TARGET_MAKE_ENV) PYTHON=$(HOST_DIR)/usr/bin/python2 \
                HEADERS_ONLY=1 \
                $(MAKE) -C $(@D) install \
                DESTDIR=$(STAGING_DIR) \
                PATH=$(@D)/bin:$(BR_PATH) \
                LD="$(TARGET_CXX)"
        $(call PXCORE_LIBNODE_INSTALL_SHARED,$(STAGING_DIR))
        #cp $(@D)/src/node_contextify_mods.h $(STAGING_DIR)/usr/include/
        $(PXCORE_LIBNODE_INSTALL_MODULES)
endef
define PXCORE_LIBNODE_INSTALL_TARGET_CMDS
        $(call PXCORE_LIBNODE_INSTALL_SHARED,$(TARGET_DIR))
        $(PXCORE_LIBNODE_INSTALL_MODULES)
endef

$(eval $(generic-package))
