#!/bin/bash

launcher_path='/Systemapps/arris/launcher'
nexus_mod_path='Systemapps/arris/nexus.ko'

p_error() {
    echo -e "---> [Error] $1"
}

p_info_msg() {
    echo -e "---> $1"
}

p_warning() {
    echo -e "---> $1"
}

p_info_msg "Adding nexus kernel module"
insmod $nexus_mod_path

p_info_msg "Copying over some necessary files"
cp -f /usr/bin/sage/sage_* /usr/bin/bcm-drm-examples/pr/
cp -f /tmp/playready3x.bin /usr/bin/bcm-drm-examples/pr/playready3x.bin
cp -f /Systemapps/arris/nexus.client /usr/bin/bcm-drm-examples/wv/
cp -f /Systemapps/arris/nxclient.sh /usr/bin/bcm-drm-examples/wv/
cp -f /usr/bin/sage/sage_ta_widevine.bin /usr/bin/bcm-drm-examples/wv/

if [[ -e "/Systemapps/arris/launcher" ]]; then
    p_info_msg "Attempting to override middleware launch in: $launcher_path"
    grep -q "\.\/run\.sh$" $launcher_path
    if [[ $(echo $?) -eq 0 ]]; then
        sed -i 's/\.\/run\.sh$/''/' $launcher_path
        sed -i 's/Launching Middleware\.\.\./Skipping middleware\.\.\./' $launcher_path
        p_info_msg "Overriding done"
    else
        p_warning "Failed to override the middleware launch. \nVerify that the file exists and contains the './run.sh' command." 
    fi
fi

cp /UserApps/metrological/usr/bin/drmplayer /usr/bin/

p_info_msg "Launching nxsever"

exec $launcher_path

p_info_msg "All done. You can run the test app with the command - drmplayer"

