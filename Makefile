# Paths
SRCDIR := src
OBJDIR := build
SRC := $(wildcard $(SRCDIR)/*.bas)
PRG := $(SRC:$(SRCDIR)/%.bas=$(OBJDIR)/%.prg)
D64 := $(OBJDIR)/bas_snippets.d64

# Commands
MKPRG = petcat -w2 -o $@ --
RM := rm -rf
MKDIR := mkdir -p
MKD64 := c1541 -format 'basic snippets,bs' d64

# Rules
$(OBJDIR)/%.prg: $(SRCDIR)/%.bas
	$(MKPRG) $<

# Targets
.PHONY: all d64 prg clean

all: d64

prg: $(PRG)

d64: $(PRG)
	$(MKD64) $(D64) -attach $(D64) $(foreach p,$(PRG),-write $(p) $(subst .prg,,$(subst build/,,$(p))))

$(SRC): | $(OBJDIR)

$(OBJDIR):
	$(MKDIR) $(OBJDIR)

clean:
	$(RM) $(OBJDIR)
