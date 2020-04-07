PREFIX = /usr/local
INSTALL = install
MANPAGE_XSL = /sw/share/xml/xsl/docbook-xsl/manpages/docbook.xsl

BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man

VERSION = 1.0.2

DEBUG = -g
OPTIMIZE = -O2
#PROFILE = -pg

MACOS_LDOPTS = -L/sw/lib
MACOS_CCOPTS = -I/sw/include

FORMATDEFS = -DRWIMG_JPEG -DRWIMG_PNG -DRWIMG_GIF

LDOPTS = $(MACOS_LDOPTS) -L/usr/X11R6/lib $(PROFILE) $(DEBUG)
CCOPTS = $(MACOS_CCOPTS) -I/usr/X11R6/include -I/usr/X11R6/include/X11 -I. -Irwimg -Wall $(OPTIMIZE) $(DEBUG) $(PROFILE) -DMETAPIXEL_VERSION=\"$(VERSION)\"
CC = gcc
#LIBFFM = -lffm

export CCOPTS CC FORMATDEFS

LISPREADER_OBJS = lispreader.o pools.o allocator.o
OBJS = moviepixel.o vector.o zoom.o $(LISPREADER_OBJS) getopt.o getopt1.o
CONVERT_OBJS = convert.o $(LISPREADER_OBJS) getopt.o getopt1.o
IMAGESIZE_OBJS = imagesize.o

all : moviepixel moviepixel.1 convert moviepixel-imagesize

moviepixel : $(OBJS) librwimg
	$(CC) $(LDOPTS) -o moviepixel $(OBJS) rwimg/librwimg.a -lpng -ljpeg -lgif $(LIBFFM) -lm -lz

moviepixel.1 : moviepixel.xml
	xsltproc --nonet $(MANPAGE_XSL) moviepixel.xml

convert : $(CONVERT_OBJS)
	$(CC) $(LDOPTS) -o convert $(CONVERT_OBJS)

moviepixel-imagesize : $(IMAGESIZE_OBJS) librwimg
	$(CC) $(LDOPTS) -o moviepixel-imagesize $(IMAGESIZE_OBJS) rwimg/librwimg.a -lpng -ljpeg -lgif -lm -lz

zoom : zoom.c librwimg
	$(CC) -o zoom $(OPTIMIZE) $(PROFILE) $(MACOS_CCOPTS) -DTEST_ZOOM zoom.c $(MACOS_LDOPTS) rwimg/librwimg.a -lpng -ljpeg -lgif -lm -lz

%.o : %.c
	$(CC) $(CCOPTS) $(FORMATDEFS) -c $<

librwimg :
	$(MAKE) -C rwimg

install : moviepixel moviepixel.1
	$(INSTALL) -d $(BINDIR)
	$(INSTALL) moviepixel $(BINDIR)
	$(INSTALL) moviepixel-prepare $(BINDIR)
	$(INSTALL) moviepixel.1 $(MANDIR)/man1
	$(INSTALL) moviepixel-imagesize $(BINDIR)
	$(INSTALL) moviepixel-sizesort $(BINDIR)

clean :
	rm -f *.o moviepixel convert moviepixel-imagesize *~
	$(MAKE) -C rwimg clean

realclean : clean
	rm -f moviepixel.1

dist : moviepixel.1
	rm -rf moviepixel-$(VERSION)
	mkdir moviepixel-$(VERSION)
	mkdir moviepixel-$(VERSION)/rwimg
	cp Makefile README NEWS COPYING *.[ch] moviepixel-prepare moviepixel-sizesort \
		moviepixel.xml moviepixel.1 moviepixelrc moviepixel.spec \
			moviepixel-$(VERSION)/
	cp rwimg/Makefile rwimg/*.[ch] moviepixel-$(VERSION)/rwimg/
	tar -zcvf moviepixel-$(VERSION).tar.gz moviepixel-$(VERSION)
	rm -rf moviepixel-$(VERSION)
