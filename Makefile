include VERSION

DESTDIR=$(shell pwd)/debian/fai
DEB_HOST_ARCH=$(MACHTYPE)
export DOCDIR = $(DESTDIR)/usr/share/doc/fai
LIBDIR = $(DESTDIR)/usr/lib/fai
SHAREDIR = $(DESTDIR)/usr/share/fai
SCRIPTSDIR = $(LIBDIR)/sbin
SCRIPTS = rcS_fai setup_harddisks faireboot dhclient-perl dhclient-script  device2grub
USRSBIN_SCRIPTS = make-fai-nfsroot make-fai-bootfloppy fai-setup fcopy ftar bootsector install_packages fai-chboot
SBIN= fai-start-stop-daemon
USRBIN_SCRIPTS = fai-class fai-do-scripts
CONFDIR= $(SHAREDIR)/etc
CONFFILES= apt.conf dhclient.conf fai_modules_off
ADEXAMPLE=$(DOCDIR)/examples/advanced
SIEXAMPLE=$(DOCDIR)/examples/simple

# files with variable KERNLEVERSION in it; this string will be substituted
KVERSION_FILES =  $(DESTDIR)/etc/fai/fai.conf $(SIEXAMPLE)/class/DEFAULT.var $(SIEXAMPLE)/class/ATOMCLIENT.var

all:
	$(MAKE) -C doc all

clean:
	$(MAKE) -C doc clean

veryclean: clean
	$(MAKE) -f debian/rules clean

install: 
	$(MAKE) -C doc install
	-install -m755 lib/* $(LIBDIR)
	cd scripts ; install $(SBIN) $(DESTDIR)/sbin
	cd scripts ; install $(USRSBIN_SCRIPTS) $(DESTDIR)/usr/sbin
	cd scripts ; install $(USRBIN_SCRIPTS) $(DESTDIR)/usr/bin
	cd scripts ; install $(SCRIPTS) $(SCRIPTSDIR)
	install -m755 share/subroutines* $(SHAREDIR)
	install -m644 share/Fai.pm $(DESTDIR)/usr/share/perl5/Debian
	cd conf ; install -m644 $(CONFFILES) $(CONFDIR)
	install -m644 conf/fai.conf conf/sources.list $(DESTDIR)/etc/fai/
	cp -a examples $(DOCDIR)
	cp -a utils $(DOCDIR)/examples
	cp -a templates/* $(DOCDIR)/examples/advanced
	cd $(DOCDIR)/examples/advanced/scripts ; mv NETWORK1 NETWORK; mv DEFAULT1 DEFAULT
	perl -pi -e 's/_KERNELVERSION_/$(KERNELVERSION)/' $(KVERSION_FILES)
	perl -pi -e 's/FAIVERSIONSTRING/$(VERSIONSTRING)/' $(SCRIPTSDIR)/rcS_fai
	ln -fs installimage_3com $(DESTDIR)/boot/fai/bigfoot
	ln -fs installimage_3com $(DESTDIR)/boot/fai/atom_install
	ln -fs atom_install $(DESTDIR)/boot/fai/atom01

.PHONY: clean veryclean
