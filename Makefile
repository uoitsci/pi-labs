#FRITZING=/Applications/Fritzing.app/Contents/MacOS/Fritzing
FRITZING=/Users/rdrake/workspace/gitco/deploy-app/Fritzing.app/Contents/MacOS/Fritzing
SVG2PNG=svg2png
OPTIPNG=optipng
CONVERT=convert

WIDTH=960
WIDTH_2X=1920

FZZ_FILES=$(wildcard assets/*.fzz)
PNG_BB_FILES=$(subst .fzz,_breadboard.png, $(FZZ_FILES))
PNG_FILES=$(subst _breadboard.png,.png, $(PNG_BB_FILES))
#PNG_FILES=$(subst assets/,static/images/, $(subst .fzz,.png,$(FZZ_FILES)))
P2X_FILES=$(subst .png,@2x.png, $(PNG_FILES))

all : $(PNG_BB_FILES) #$(PNG_FILES) $(P2X_FILES)
	echo $(PNG_BB_FILES)
	echo $(FZZ_FILES)
	\

pngs : $(FZZ_FILES)
	echo $(PNG_BB_FILES)
	echo $(FZZ_FILES)
	$(FRITZING) -svg $(pwd)/assets

$(PNG_FILES) : $(PNG_BB_FILES) $(FZZ_FILES)
	echo "Making $@ from $<"
	$(OPTIPNG) -o7 $@

##svg : $(FZZ_FILES) # $(SVG_FILES) $(FZZ_FILES)
##	echo "Making SVG files _again_"
##	#$(FRITZING) -svg $(PWD)/assets

##assets/%_breadboard.svg : assets/%.fzz
##	echo "Making $<"
##	$(FRITZING) -svg $(PWD)/assets

#assets/%_breadboard.png : assets/%.fzz
#	echo "Making $<"
#	$(FRITZING) -svg $(PWD)/assets

#static/images/%.png : assets/%_breadboard.png
#	#$(CONVERT) $< -resize $(WIDTH) $@
#	$(OPTIPNG) -o7 $@

##static/images/%.png : assets/%_breadboard.svg
##	$(SVG2PNG) -w $(WIDTH) $< $@
##	$(OPTIPNG) -o7 $@

##static/images/%@2x.png : assets/%_breadboard.svg
##	$(SVG2PNG) -w $(WIDTH_2X) $< $@
##	$(OPTIPNG) -o7 $@

#static/images/%@2x.png : assets/%_breadboard.png
#	$(CONVERT) $< -resize $(WIDTH_2X) $@
#	$(OPTIPNG) -o7 $@

clean :
	$(RM) assets/*_breadboard.svg assets/*_pcb.svg assets/*_schematic.svg
