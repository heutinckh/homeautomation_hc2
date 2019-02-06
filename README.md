# homeautomation_hc2

Home automation project based on yocto (thud)
i.c.w. odroid support layers

Goal:

- I - Release Reproducability:
    - a: Fresh Yocto based build (thud at the moment)
          - Prepare and build scripts: DONE
          
    - b: Resulting image directly transferrable / installable on uSD
          - Deploy script: BUSY

    - c: Verified on Odroid XU4-HC2

- II - Domoticz Integration
    - a: Domoticz part of release
    - b: influxdb: Receiving all detailed forwarded data from domoticz
- III - Stability/Security/Performance
    - a: Partitioning considerations on SDD for updates
           e.g. [IMAGE_A]||[IMAGE_B]||[DATA]||[LOGGING] partition setup
    - b: Read-only rootfilesystem 
           e.g.: Ramfs based (e.g. via initramfs)
    - c: Bootable directly from SSD
    
- IV - Smart power management
- V - ...



Status:
Deployed image does not boot device (or at least no output on console seen
 -> check u-boot configuration files (u-boot.ini/scr)
