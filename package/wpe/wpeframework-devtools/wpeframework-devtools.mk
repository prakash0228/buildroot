ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_TEST_CYCLICINSPECTOR),y)
WPEFRAMEWORK_CONF_OPTS += -DWPEFRAMEWORK_TEST_APPS=ON -DWPEFRAMEWORK_TEST_CYCLICINSPECTOR=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_TEST_LOADER),y)
WPEFRAMEWORK_CONF_OPTS += -DWPEFRAMEWORK_TEST_APPS=ON -DWPEFRAMEWORK_TEST_LOADER=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_NETWORKTEST),y)
WPEFRAMEWORK_CONF_OPTS += -DWPEFRAMEWORK_TEST_APPS=ON -DWPEFRAMEWORK_TEST_NETWORKTEST=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_TEST_RPCLINK),y)
WPEFRAMEWORK_CONF_OPTS += -DWPEFRAMEWORK_TEST_RPCLINK=ON -DWPEFRAMEWORK_RPC=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_LINUX_ONEWIRE),y)
WPEFRAMEWORK_CONF_OPTS += -DWPEFRAMEWORK_TEST_APPS=ON -DWPEFRAMEWORK_TEST_LINUX1W=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_TEST_UNITTESTS),y)
WPEFRAMEWORK_DEPENDENCIES += gtest
WPEFRAMEWORK_CONF_OPTS += -DBUILD_TESTS=ON
#install the test binaries
define WPEFRAMEWORK_INSTALL_UNITTESTS
    $(INSTALL) -D -m 0755 $(@D)/Tests/tests/WPEFramework_test_tests $(TARGET_DIR)/usr/bin/WPEFramework_test_tests
    $(INSTALL) -D -m 0755 $(@D)/Tests/core/WPEFramework_test_core $(TARGET_DIR)/usr/bin/WPEFramework_test_core
    $(INSTALL) -D -m 0755 $(WPEFRAMEWORK_PKGDIR)/run-wpeframework_unittests.sh $(TARGET_DIR)/usr/share/WPEFramework/run-wpeframework_unittests.sh
endef
WPEFRAMEWORK_POST_INSTALL_TARGET_HOOKS += WPEFRAMEWORK_INSTALL_UNITTESTS
endif
