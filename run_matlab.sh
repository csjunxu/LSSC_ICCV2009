
   #!/bin/sh
   export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:./libs/
   export KMP_DUPLICATE_LIB_OK=true
   matlab -nodesktop -nosplash 
