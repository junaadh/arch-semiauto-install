# auto-install-arch

## Instruction

* You need an internet connection on your archiso.
  You can check connectivity using : 
 ```
 ping -c 5 archlinux.org
 ``` 


* Installing git
```
curl -o perl-timedate.pkg.tar.zst -L https://archlinux.org/packages/extra/any/perl-timedate/download
curl -o perl-mailtools.pkg.tar.zst -L https://archlinux.org/packages/extra/any/perl-mailtools/download
curl -o perl-error.pkg.tar.zst -L https://archlinux.org/packages/extra/any/perl-error/download
curl -o git.pkg.tar.zst -L https://archlinux.org/packages/extra/x86_64/git/download
pacman -U perl-timedate.pkg.tar.zst perl-mailtools.pkg.tar.zst perl-error.pkg.tar.zst git.pkg.tar.zst
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
