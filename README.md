# Mybashtools
This repository is used to store every bash tools that I could create.

## extractLogs\.sh
### Description
This script is used to extract all logs in journalctl. These logs are sorted in multiple files according to their identifiers. Moreover, each identifier without logs is listed in an additional file, with the suffix *extractInfo*.

This scipt requier 1 argument, this argument will be the prefix of every file created by this script.

### Exemple
If journalctl has the identifier *kernel*, *systemd* and *sudo*, with *sudo* having zero logs.
If the chosen sufix is *exemple* then the prompt will be as follow : bash extractLogs\.sh exemple
3 files will be created, *exemple_kernel*, *exemple_systemd* and *exemple_extractInfo*. 
*exemple_extractInfo* will inform that there is no log with *sudo*