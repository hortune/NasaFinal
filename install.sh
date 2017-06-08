for package in $(cat wsarch.list)
do
	pacman -S --noconfirm $package
done
