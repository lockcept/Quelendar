# Makefile variables
FLUTTER_CMD = flutter
FLUTTER_FLAGS = run
FLUTTER_TARGET = lib/main.dart

# Makefile targets
.PHONY: all build run clean

all: build

build:
	@$(FLUTTER_CMD) build $(filter-out $@,$(MAKECMDGOALS))

run:
	$(FLUTTER_CMD) $(FLUTTER_FLAGS) $(FLUTTER_TARGET)

clean:
	$(FLUTTER_CMD) clean