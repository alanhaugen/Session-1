.PHONY: all docs clean run

PDF = Haugen_HansAlanWhitburn_Compulsory2.pdf

all: app $(PDF)

FLEX  ?= flex
BISON ?= bison

CC     = g++
CFLAGS = -g -Wall

#PARSERS  = $(wildcard source/*.yacc)
#SCANNERS = $(wildcard source/*.lex)

SOURCES = $(wildcard source/*.cpp)
GENERATED_SOURCES = $(PARSERS:.y=.tab.cpp) $(SCANNERS:.lex=.cpp) 
SOURCES += $(GENERATED_SOURCES)
OBJS = $(SOURCES:.cpp=.o)

source/principia.cpp: source/calc.o #source/calc.tab.o

app: $(OBJS)
	$(CC) $(OBJS) $(CFLAGS) -o app

%o: %cpp
	$(CC) $(CFLAGS) -c $*cpp -o $@

%.tab.cpp: %.yacc
	$(BISON) -o $*.tab.cpp -d $<

#Flex can generate a header file with prototypes for you:
#Code:
#flex  --header-file=lex.h ex1.
#This will produce `lex.h' file. You can include it and use `yy_switch_to_buffer()' etc. in bison file.

%.cpp: %.lex 
	$(FLEX) --header-file=$*.h -o $*.cpp $*.lex

clean:
	rm $(OBJS) app

run: app
	./app

$(PDF): README.md
	pandoc README.md -f markdown -t pdf -o $(PDF)

docs:
	doxygen docs
