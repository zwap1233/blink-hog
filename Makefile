HOG_DO:=./Hog/Do
PRJ:=blink
PRJ_FILE:=./Projects/$(PRJ)/$(PRJ).xpr

all: $(PRJ_FILE)
	$(HOG_DO) WORKFLOW $(PRJ)

$(PRJ_FILE):
	$(HOG_DO) CREATE $(PRJ)

gui:
	vivado $(PRJ_FILE)

clean:
	rm -rf ./SimulationLib/
	rm -rf ./bin/
	rm -rf ./Projects/

