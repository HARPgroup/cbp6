************************************************************************
***** PARAMETER FILE  -- changing this file changes the parameters in **
***** the entire pre- and post-processors ( recompile necessary )     **
*** lwat always means water and is a reserved land use name.  It      **
**  must always be the last land use listed
************************************************************************


      integer nlu

      integer lCRP,lFOR,lINR,lIRX,lMOX,lPAS,lTCI,lTCT,lTGX
      integer lWAT,lWLF,lWLO

********* parameters to size the problem
      parameter (nlu=12)                               ! number of land uses
 
******** the following parameters correspond to nlu
      parameter (lCRP = 1)
      parameter (lFOR = 2)
      parameter (lINR = 3)
      parameter (lIRX = 4)
      parameter (lMOX = 5)
      parameter (lPAS = 6)
      parameter (lTCI = 7)
      parameter (lTCT = 8)
      parameter (lTGX = 9)
      parameter (lWAT = 10)
      parameter (lWLF = 11)
      parameter (lWLO = 12)

      character*3 luname(nlu)

      data luname /'CRP','FOR','INR','IRX','MOX','PAS','TCI','TCT',
     .   'TGX','WAT','WLF','WLO'/

**************** this could be replaced by a nlumax parameter and a data file
****************  that could be read whenever needed
      
