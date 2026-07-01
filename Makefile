HOG_DO:=./Hog/Do
PRJ:=blink
PRJ_FILE:=./Projects/$(PRJ)/$(PRJ).xpr

.PHONY: clean clean-petalinux

all: $(PRJ_FILE)
	$(HOG_DO) WORKFLOW $(PRJ)

gui: $(PRJ_FILE)
	vivado $(PRJ_FILE)

$(PRJ_FILE):
	$(HOG_DO) CREATE $(PRJ)

clean-all: clean clean-petalinux

clean:
	rm -rf ./SimulationLib/
	rm -rf ./bin/
	rm -rf ./Projects/
	rm -rf *.jou
	rm -rf *.log
	rm -rf *.str

clean-petalinux:
	rm -rf ./petalinux/blink/build
