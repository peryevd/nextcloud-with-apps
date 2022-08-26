### Install:
##### Run 
``` bash
./set_configuration.sh
```

##### Add trusted domains

 - Go to container "app-server"
```bash
 vi config/config.php 
 ```
 - add your ip to trusted_domains
 - restart the container