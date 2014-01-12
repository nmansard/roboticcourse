# Copyright Projet LAGADIC, 2004
#   http://www.irisa.fr/lagadic
#
#   File: Makefile
#   Author: Nicolas Mansard
#
#   Compilation des sources .tex en .dvi, .ps ...
#
#   Version Control
#     $Id: Makefile,v 1.3 2004/08/27 10:03:23 nmansard Exp $

RM := rm -f
MV := mv
CP := cp -f
AR := ar
TEX2DVI := latex
DVI2PS := dvips -Ppdf -G0 -tletter
PS2PDF := ps2pdf -dCompatibilityLevel=1.3 -dMAxSubsetPct=100 -dSubsetFonts=true -dEmbedAllFonts=true -sPAPERSIZE=letter 
BIBTEX := bibtex
GZIP := gzip -c
XDVI := xdvi 
TGZ	= tar -czvf 


# ---------------------------------------------
# --- REPERTOIRES -----------------------------
# ---------------------------------------------

WORK_NAME	 	= croit
PROJECT_DIR		= .
ROOT_DIR		= .
IMG_DIR      		= $(ROOT_DIR)
BIB_DIR   		= ..

# ---------------------------------------------
# --- OBJETS ----------------------------------
# ---------------------------------------------

OBJS	=	chap1
BIB	=	

OBJS_TEX	=	$(OBJS:%=%.tex)
OBJS_DVI	=	$(OBJS:%=%.dvi)
OBJS_PS 	=	$(OBJS:%=%.ps)
OBJS_PS_GZ	=	$(OBJS:%=%.ps.gz)
OBJS_PDF	=	$(OBJS:%=%.pdf)
TGZ_FILE	= 	../$(WORK_NAME)$(VERSION:%=_%).tgz


IMPRIMANTE	=	cCjaune1 # mCjaune0 #

# ---------------------------------------------
# --- REGLES ----------------------------------
# ---------------------------------------------

# --->
# ---> Regle generale
# --->

.PHONY = all 
all: 

dvi: $(OBJS_DVI)

ps: $(OBJS_PS)

psgz: $(OBJS_PS_GZ)

pdf: $(OBJS_PDF)

print: $(OBJS_PS) 
	lpr -P $(IMPRIMANTE) $^
	@touch print

view: dvi
	$(XDVI) $(OBJS_DVI) &

view_pdf: pdf
	acroread $(OBJS_DVI) &

edit:
	emacs $(OBJS_TEX) &
# --->
# ---> Regles generiques
# --->

%.dvi: %.tex $(BIB)
	$(TEX2DVI) $< 

.PHONY = bib
bib: 
	@echo "->$(BIBTEX) $(OBJS)"
#	$(BIBTEX) $(OBJS)
	$(TEX2DVI) $(OBJS_TEX) 
	$(TEX2DVI) $(OBJS_TEX)

%.ps: %.dvi
	$(DVI2PS) $< -o $@

%.pdf: %.ps
	$(PS2PDF) $< $@

%.ps.gz: %.ps
	$(GZIP) $< > $@


# --->
# --->
# ---> Regles de nettoyage
# --->

.PHONY = clean
clean: 
	$(RM) *.aux *.blg *.dvi *.log *.bbl
	$(RM) *~ 
	$(RM) core 
	$(RM) print
	$(RM) -r auto

.PHONY = clean_all
clean_all: clean 
	$(RM) *.ps *.pdf

.PHONY : tgz
tgz: $(TGZ_FILE)

$(TGZ_FILE): clean_all
	@echo "Creation de $@"
	$(TGZ) $(TGZ_FILE) $(ROOT_DIR) $(BIB)

