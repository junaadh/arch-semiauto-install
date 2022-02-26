# auto-install-arch

## Instruction

* You need an internet connection on your archiso.
  You can check connectivity using : 
 ```
 ping -c3 archlinux.org
 ``` 


* Installing git
```
pacman --noconfirm -Sy archlinux-keyring git
```

* Cloning the repository
```
git clone https://github.com/junaadh/arch-semiauto-install.git
```

* Running the script
```
cd arch-semiauto-install
./arch-install.sh
```
