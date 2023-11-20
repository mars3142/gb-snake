#
# A Makefile that compiles all .c and .s files in "src" and "res" 
# subdirectories and places the output in a "obj" subdirectory
#

# If you move this project you can change the directory 
# to match your GBDK root directory (ex: GBDK_HOME = "C:/GBDK/"
GBDK_HOME = ${HOME}/SDK/gbdk/

LCC = $(GBDK_HOME)bin/lcc 
PNG2ASSET = $(GBDK_HOME)bin/png2asset 

# You can set flags for LCC here
# For example, you can uncomment the line below to turn on debug output
# LCCFLAGS += -debug # Uncomment to enable debug output
# LCCFLAGS += -v     # Uncomment for lcc verbose output
LCCFLAGS +=-Wa-l -Wl-m -Wl-j -Wf--debug


# You can set the name of the .gb ROM file here
PROJECTNAME    = snake

DSTDIR		= dist
GENDIR 		= gen
SRCDIR      = src
OBJDIR      = obj
RESDIR      = res
BINS	    = $(OBJDIR)/$(PROJECTNAME).gb
CSOURCES    = $(foreach dir,$(SRCDIR),$(notdir $(wildcard $(dir)/*.c))) $(foreach dir,$(GENDIR),$(notdir $(wildcard $(dir)/*.c)))
ASMSOURCES  = $(foreach dir,$(SRCDIR),$(notdir $(wildcard $(dir)/*.s)))
OBJS       = $(CSOURCES:%.c=$(OBJDIR)/%.o) $(ASMSOURCES:%.s=$(OBJDIR)/%.o)

all:	clean prepare png2asset $(BINS)

compile.bat: Makefile
	@echo "REM Automatically generated from Makefile" > compile.bat
	@make -sn | sed y/\\//\\\\/ | sed s/mkdir\ -p\/mkdir\/ | grep -v make >> compile.bat

# Compile .c files in "src/" to .o object files
$(OBJDIR)/%.o:	$(SRCDIR)/%.c
	$(LCC) $(LCCFLAGS) -I${GENDIR} -c -o $@ $<

# Compile .c files in "gen/" to .o object files
$(OBJDIR)/%.o:	$(GENDIR)/%.c
	$(LCC) $(LCCFLAGS) -c -o $@ $<

# Compile .s assembly files in "src/" to .o object files
$(OBJDIR)/%.o:	$(SRCDIR)/%.s
	$(LCC) $(LCCFLAGS) -c -o $@ $<

# If needed, compile .c files in "src/" to .s assembly files
# (not required if .c is compiled directly to .o)
$(OBJDIR)/%.s:	$(SRCDIR)/%.c
	$(LCC) $(LCCFLAGS) -S -o $@ $<

# Link the compiled object files into a .gb ROM file
$(BINS):	$(OBJS)
	$(LCC) $(LCCFLAGS) -o $(BINS) $(OBJS)

png2asset:
	${PNG2ASSET} ${RESDIR}/splash_screen.png -c ${GENDIR}/splash_screen.c -map -source_tileset $(RESDIR)/splash_screen_tileset.png -noflip
	${PNG2ASSET} ${RESDIR}/splash_screen_tileset.png -c ${GENDIR}/splash_screen_tileset.c -tiles_only -map -noflip

prepare:
	mkdir -p $(DSTDIR)
	mkdir -p $(OBJDIR)
	mkdir -p $(GENDIR)

clean:
	rm -f  $(DSTDIR)/*.*
	rm -f  $(OBJDIR)/*.*
	rm -f  $(GENDIR)/*.*
	rm -f *.o *.lst *.map *.gb *.ihx *.sym *.cdb *.adb *.asm
