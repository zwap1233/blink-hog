HOG_DO:=./Hog/Do
PRJ:=blink
PRJ_FILE:=./Projects/$(PRJ)/$(PRJ).xpr

all: $(PRJ_FILE)
	$(HOG_DO) WORKFLOW $(PRJ)

gui: $(PRJ_FILE)
	vivado $(PRJ_FILE)

$(PRJ_FILE):
	$(HOG_DO) CREATE $(PRJ)

clean:
	rm -rf ./SimulationLib/
	rm -rf ./bin/
	rm -rf ./Projects/
	rm -rf *.jou
	rm -rf *.log
	rm -rf *.str
