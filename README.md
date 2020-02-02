## Lime
Lime is a work in progress package manager for iOS Devices.

### Installing for Developers
1. Set the ``LIME_IP`` variable either using ``export LIME_IP=*ip*`` or adding it to your bash or zsh profile.
2. If you are using ``iproxy`` or some other proxy tool to make your device ssh'able from ``localhost``, you can set the port using the ``LIME_PORT`` variable. Example: ``export LIME_IP=2222``
3. Make sure you are in the root of the Lime project, *the folder that contains the Makefile*.
4. Run the following command: ``make clean do``
5. Wait for UI Cache to finish and enjoy!
