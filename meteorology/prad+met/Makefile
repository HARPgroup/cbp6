PROG1 =  wdm_insert_ALL

SRCS =	wdm_insert_ALL.f 

OBJS =	wdm_insert_ALL.o

LIBS =  /bluefish/archive/modeling/b532/code/src/data_import/usgs_climate_scen/wdmcsvin/lib3.2/lib/utillib.a /bluefish/archive/modeling/b532/code/src/data_import/usgs_climate_scen/wdmcsvin/lib3.2/lib/wdmlib.a \
        /bluefish/archive/modeling/b532/code/src/data_import/usgs_climate_scen/wdmcsvin/lib3.2/lib/adwdmlib.a /bluefish/archive/modeling/b532/code/src/lib/util_lib.a

FC = f77
FFLAGS = -W -Wall -pedantic -Wsurprising -fbounds-check 
#FFLAGS = -W -Wall -Wsurprising -pedantic    
LDFLAGS =   


all: $(PROG1)
	cp $(PROG1) ../../../bin/

$(PROG1): $(OBJS)
	$(FC) $(LDFLAGS) -o wdm_insert_ALL $(OBJS) $(LIBS)

clean:
	rm -f $(PROG1) $(OBJS)
