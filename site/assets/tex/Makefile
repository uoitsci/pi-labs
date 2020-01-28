ENGINE=xelatex
E_ARGS=-interaction nonstopmode -halt-on-error
BASE_FILE=diagrams.tex
DIAGRAMS=full-adder.png half-adder.png

all : $(DIAGRAMS)

# Ignore all errors

diagrams.pdf : $(BASE_FILE)
	-$(ENGINE) $(E_ARGS) $(BASE_FILE)

full-adder.pdf : full-adder.tex diagrams.pdf
	-$(ENGINE) $(E_ARGS) --jobname=full-adder $(BASE_FILE)

half-adder.pdf : half-adder.tex diagrams.pdf
	-$(ENGINE) $(E_ARGS) --jobname=half-adder $(BASE_FILE)

full-adder.png : full-adder.pdf
	convert -density 800 full-adder.pdf -resize 25% full-adder@2x.png
	convert -density 400 full-adder.pdf -resize 25% full-adder.png

half-adder.png : half-adder.pdf
	convert -density 800 half-adder.pdf -resize 25% half-adder@2x.png
	convert -density 400 half-adder.pdf -resize 25% half-adder.png

clean :
	$(RM) *.aux *.log *.pdf
