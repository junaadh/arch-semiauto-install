# auto-install-arch

*****Instruction**

1.You need an internet connection on your archiso. \n
You can check connectivity using : \n 
 ```ping -c 5 archlinux.org``` \n 

\n

2.Installing git \n
```curl -o perl-timedate.pkg.tar.zst -L https://archlinux.org/packages/extra/any/perl-timedate/download \n
curl -o perl-mailtools.pkg.tar.zst -L https://archlinux.org/packages/extra/any/perl-mailtools/download \n
curl -o perl-error.pkg.tar.zst -L https://archlinux.org/packages/extra/any/perl-error/download \n 
```curl -o git.pkg.tar.zst -L https://archlinux.org/packages/extra/x86_64/git/download```
\n
```pacman -U perl-timedate.pkg.tar.zst perl-mailtools.pkg.tar.zst perl-error.pkg.tar.zst git.pkg.tar.zst``` \n 
\n
3.Cloning the repository \n 
```git clone https://github.com/junaadh/arch-semiauto-install.git``` \n 
\n
4.Running the script \n
```cd arch-semiauto-install \n
./arch-install.sh \n```
