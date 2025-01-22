      ctl-opt option(*nodebugio:*srcstmt) ;
      ctl-opt dftactgrp(*no) actgrp(*caller);
      
       //*******************************************************************
       //
       //  Program:      SHL0200R
       //
       //  Description:  xxxxxxxxxxxx Inquiry/Maintenance
       //
       //  Programmer:   xxxxxxxxxxxxxxxxxx
       //
       //  Date:         xx/xx/xx
       //
       //*******************************************************************
       //                   Modification Log
       //
       //  Initials  Date      Description
       //-------------------------------------------------------------------
       //   xxx    xx/xx/xx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
       //
       //
       //
       //****************************************************************
       // Field Definitions                                             *
       //                                                               *
       // Prefix                                                        *
       // ww     - Program described work fields                        *
       // cc     - Program described constants                          *
       // wi     - APPL *ENTRY input parameters                         *
       // ws     - Subfile fields                                       *
       // wc     - Subfile control fields                               *
       // hd     - Hidden fields                                        *
       // ax     - APPx output parameters for called programs           *
       // ds     - Data structure fields                                *
       // cc     - Constants
       //                                                               *
       //                                                               *
       // Display Record Format Definitions                             *
       //                                                               *
       // Prefix                                                        *
       // SCRNS  - Subfile                                              *
       // SCRNC  - Subfile control                                      *
       // SCRNK  - Command key                                          *
       // SCRNR  - Standard display                                     *
       // WNDWB  - window border                                        *
       // WNDWR  - Standard window display                              *
       // MSGCTL - Message subfile control                              *
       //                                                               *
       //****************************************************************
       //PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP
       //P          P  R  O  G  R  A  M    S  P  E  C  S                P
       //PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP

       //------------------------------------------------
       //--Define the files
>>>>   dcl-f Shl0200D workstn SFILE(SCRNS01:wwRRN1) INFDS(INFDS);

       // Optional - Put any extra files that you need to access here.
>>>>   // dcl-f FileXXX1 usage(*input) keyed;

>>>>   dcl-ds dsFileXXX2
>>>>     extname('FILEXXX2');
       end-ds;

>>>>   dcl-ds dsFileXXX3
>>>>     extname('FILEXXX3');
       end-ds;

       //----------------
       //--Parameter definitions
       dcl-ds dsJld
         extname('DSJLD');
       end-ds;

       //------------------------------------------------
       //--Entry Prototype
>>>>   dcl-pr Shl0200r extpgm('SHL0200R');
         wiJld like(dsJld);
         wiApp1 like(dsApp1);
       end-pr;

>>>>   dcl-pi Shl0200r;
         wiJld like(dsJld);
         wiApp1 like(dsApp1);
       end-pi;

       //------------------------------------------------
       //--Prototypes For Called Programs

       // Write message to screen
       dcl-pr WrtErrMsg extpgm('ERMSG1');
         wiMsgi like(wwMsgi);
       end-pr;

       // Remove error messages
       dcl-pr RmvErrMsg extpgm('ERMSG2');
         wiDsPgnm like(DSPGMN);
       end-pr;

       // Set program security
       dcl-pr SetSecurity extpgm('SEC0100R');
         wiPGM char(10);
         wiSecInd like(a1Sec);
       end-pr;

       // xxxxxx xxxxx xxxxxx Maintenance/Display
>>>>   dcl-pr Xxx0071r extpgm('XXX0071R');
         wiCrdGrp# char(5);
         wiOpt char(1);
       end-pr;

       // xxxxxx xxx xxxxxxx
>>>>   dcl-pr Xxx0121r extpgm('XXX0121R');
         wiJld like(dsJld);
         wiAPP2 like(dsApp2);
       end-pr;

       // New Credit Group prompt
>>>>   dcl-pr Xxx0122r extpgm('XXX0122R');
         wiJld like(dsJld);
         wiAPP3 like(dsApp3);
       end-pr;

       // Incoming entry parms:
       dcl-ds dsApp1 len(512);
         a1Sec char(5);       // Security
         a1Sel char(1);       // Select a record
         a1View zoned(2:0);   // Screen to display
>>>>     a1xxx1 zoned(6:0);
>>>>     a1xxx2 char(10);
>>>>     a1xxx3 char(10);
       end-ds;

       // Xxxx121R Parms
       dcl-ds dsApp2 len(512);
         a2Sec char(5);       // Security
         a2Iuse char(10);     // In Use Flag
         a2Inlr char(1);      // Turn on LR indicator
>>>>     a2Actn char(10);     // Define Action
>>>>     a2xxx1 zoned(5:0);
       end-ds;

        // Xxx0122r Parms
       dcl-ds dsApp3 len(512);
         a3Sec char(5);
         a3Sel char(1);
         a3View zoned(2:0);
>>>>     a3xxx1 zoned(5:0);
>>>>     a3xxx2 zoned(5:0);
       end-ds;

       // Split option indicator and action code:
       dcl-ds dsSplt len(12);
         wwZZ zoned(2:0) pos(1);
         dsActn char(10) pos(3);
       end-ds;

       dcl-ds INFDS;
         SFLLOC bindec(4) pos(378);
       end-ds;

       dcl-ds dsPgmDs PSDS;
         dsPgmn *PROC;
         dsUser char(10) pos(254);
       end-ds;

       // General constants:
       dcl-c ccLOAD const('LOAD');
       dcl-c ccERROR const('ERROR');
       dcl-c ccINUSE const('INUSE');
       dcl-c ccSELECT const('SELECT');
       dcl-c ccADD const('ADD');
       dcl-c ccCHANGE const('CHANGE');
       dcl-c ccCOPY const('COPY');
       dcl-c ccDELETE const('DELETE');
       dcl-c ccDISPLAY const('DISPLAY');
       dcl-c ccCPYCUST const('CPYCUST');
       dcl-c ccWRKWTH const('WRKWTH');
       dcl-c ccNO const('N');
       dcl-c ccYES const('Y');

       // Max number of 'position to':
       dcl-c cc#POS const(03);

       // Number of records to fill S/F page:
       dcl-c ccPGSZ const(10);

       // Case conversion
       dcl-c ccLowerCase const('abcdefghijklmnopqrstuvwxyz');
       dcl-c ccUpperCase const('ABCDEFGHIJKLMNOPQRSTUVWXYZ');

       // Quote for building SQL statement
       dcl-c ccQuote const('''');

       // Definitions from Screen
       dcl-s wwRRN1 like(hdSFLP);
       dcl-s wwRRN# like(hdSFLP);
       dcl-s wwcRRN like(hdSFLP);

       dcl-s wwCnt1 zoned(2:0);
       dcl-s wwCPOS zoned(2:0) inz(1);
       dcl-s wwCTAB char(3);
       dcl-s wwCKEY char(27);
       dcl-s wwNFND char(1);
       dcl-s wwFRST char(1) inz(ccYES);
       dcl-s wwLOAD char(1) inz(ccYES);
       dcl-s wwERR1 char(10);
       dcl-s wwERR2 char(10);
       dcl-s wwERR3 char(1);
       dcl-s wwRCDE char(10);
       dcl-s wwX zoned(2:0);
       dcl-s wwZ like(wwX);
       dcl-s wwMsgi char(10);
       dcl-s wwCrdGrp# char(5);
       dcl-s wwCorpGrp# char(5);

       // -Sql Statement
       dcl-s wwSelect varchar(1024);
       dcl-s wwFrom varchar(1024);
       dcl-s wwJoin varchar(1024);
       dcl-s wwWhere varchar(1024);
       dcl-s wwGroup varchar(1024);
       dcl-s wwOrder varchar(1024);
       dcl-s wwFor varchar(1024);
       dcl-s wwSqlTxt varchar(6144);

       // Monitor nulls for dsRd3
       dcl-s dsRdNullArr int(5:0) dim(6);
       dcl-s wwUsrNull int(5:0);

       // Header screen Action desriptions:
       dcl-s wwOpt char(1) dim(12) ctdata perrcd(1);
       dcl-s wwInmd char(12) dim(12) alt(wwOpt);

       //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
       //M                 M  A  I  N  L  I  N  E                       M
       //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM

       // Main loop:
       DOU *in03 = *ON;

         // Reload subfile, if requested:
         if wwLOAD = ccYES;
           exsr $INSFL;
           wwLOAD = ccNO;
         endif;

         // Display screen:
         write MSGCTL1;
         write SCRNK01;

         if *in32 = *OFF;
           write SCRNR01;
         endif;

         exfmt SCRNC01;

         *in69 = THEFLD;
         if wwFRST = ccYES;
           wwFrst = ccNO;
         endif;

         hdsFlp = SflLoc;

         // clear messages:
         RmvErrMsg(DSPGMN);

         // Set off all error indicators here:
         *in36 = *off;
         *in38 = *off;
         *in71 = *off;

         // If not exiting program the process user action taken
         if *in03 = *OFF;
           exsr $UserAction;
         endif;

       enddo;

       // Close cursor
       exec sql
         close Csr_Read;

       // Close called programs:
       a2Inlr = ccYES;

       // End the maintenance program:
>>>>   //--Xxx0121(dsJld : dsApp2);

       *inlr = *on;

       //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
       //$              S  U  B  R  O  U  T  I  N  E  S                 $
       //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
       //
       //------------------------------------------------
       //*  $INSFL  ** - Initialize Subfile
       //------------------------------------------------
       begsr $INSFL;

         clear wwRRN1;
         hdsFlp = 1;
         wwNFnd = ccNO;

         // clear subfile:
         if *in32 = *ON;
           *in32 = *off;
           *in30 = *on;
           write SCRNC01;
           *in30 = *off;
         endif;

         // Check for subfile control errors:
         select;
           when wwFrst = ccNO;
             exsr $Error01;
         endsl;

         // Build needed SQL statement based upon Position To
         exsr $Sql;

         // Load subfile:
         exsr $LoadSFL;

         // Send message if records do not exist for loading SFL
         if wwRRN1 = *zero;
           wwMsgi = 'SHL0011';
           WrtErrMsg(wwMsgi);
         endif;

       endsr;

       //------------------------------------------------
       //*  $LoadSFL  ** - Load Subfile
       //------------------------------------------------
       begsr $LoadSFL;

         clear wwCnt1;
         *in34 = *off;

         // Load one page at a time:
         dow wwCnt1 < ccPGSZ
           and SQLCODE = 0;
           //****************************************************************

           // wwUsrNull needed to accept a null value for this field since
           //  the join result can return null if user data not found.

           exec sql
             fetch from Csr_Read
>>>>           into :wsFld1, :wsFld2, :wsFld3, :wsfld4, :wsFld5, :wsFld6,
>>>>                :wsFld7;

           if SQLCODE = 0;
             clear wsOPT#;
             *in61 = *off;

             wwRRN1 += 1;
             wwCnt1 += 1;

             if wwCnt1 = 1;
               hdSFLP = wwRRN1;
             endif;

             write SCRNS01;

           endif;

         enddo;

         if wwRRN1 > *ZERO;
           *in32 = *on;
         endif;

         // No more records found then display bottom
         if SQLCODE <> 0;
           *in34 = *on;
         endif;

         *in25 = *off;

       endsr;

       //------------------------------------------------
       //*  $SQL    ** - Build selection for dynamic SQL statement
       //------------------------------------------------
       begsr $SQL;

         exec sql
           close Csr_Read;

         wwSelect = *blank;
         wwFrom   = *blank;
         wwJoin   = *blank;
         wwWhere  = *blank;
         wwGroup  = *blank;
         wwOrder  = *blank;
         wwFor    = *blank;
         wwSqlTxt = *blank;

         // Replace all fields with fields from tables.
>>>>     wwSelect = 'Select F1Fld1, F1Fld2, F2Fld1, F2Fld3, +
>>>>        F2Fld7, F1Fld6';

         //               ********
>>>>     wwFrom   = 'From MainFile';

         //          ****      ********    *****    *****
>>>>     wwJoin   = 'Left Join JoinFile on F1Key  = F2Key ';

         // Build where clause based upon Position To screen
         exsr $SqlWhere;

         select;
           when wwCPOS = 1;
         //                      ******
>>>>         wwOrder = 'Order By F1Fld1';

           when wwCPOS = 2;
         //                      *****
>>>>         wwOrder = 'Order By F2Fld4';

           when wwCPOS = 3;
         //                      ******
>>>>         wwOrder = 'Order By F1Fld6';
         endsl;

         //                    **
>>>>     wwFor = 'Optimize for 10 Rows';

         wwSqlTxt = %trim(wwSelect)
            + ' ' + %trim(wwFrom)
            + ' ' + %trim(wwJoin)
            + ' ' + %trim(wwWhere)
            + ' ' + %trim(wwOrder)
            + ' ' + %trim(wwFor);

         exec sql
           Prepare DynCsr_Read From :wwSqlTxt;

         exec sql
           Declare Csr_Read Cursor For DynCsr_Read;

         exec sql
           Open Csr_Read;

       endsr;

       //------------------------------------------------
       //*  $SqlWhere - Build the where clause
       //------------------------------------------------
       begsr $SqlWhere;

         select;
           when wwCPOS = 1
       //        *******
>>>>         and WCPos1  > *zero;
       //                     ******              *******
>>>>         wwWhere = 'Where F1Fld5 >= ' + %char(WCPos1);

           when wwCPOS = 2
       //        ******
>>>>         and WCPos2 > *blank;
       //                           ******
>>>>         wwWhere = 'Where upper(F1Fld2) like ' + ccQuote + '%' +
       //            ******
>>>>           %trim(WCPos2) + '%' + ccQuote;

           when wwCPOS = 3
       //        ******
>>>>         and WCPos3 > *blank;
       //                           ******
>>>>         wwWhere = 'Where upper(F2Fld7) like ' + ccQuote + '%' +
       //            ******
>>>>           %trim(WCPos3) + '%' + ccQuote;

         endsl;

       endsr;

       //------------------------------------------------
       //*  $UserAction  ** - Process Function Keys or SFL options
       //------------------------------------------------
       begsr $UserAction;

           // Process command keys:
           select;

             // F10 = Position to:
             when *in10 = *ON;
               exsr $PositionTo;

             // F5 or 'position to' field value change (*in40) - reload S/F:
             when *in05 = *ON
             OR *in40 = *ON;
               exsr $INSFL;

             // Rollup (if records exist in S/F - *in32):
             when *in25 = *ON
             and *in32 = *ON;
               exsr $LoadSFL;

             // F6 = Add a record:
             when *in06 = *on;
               exsr $AddRecord;

             // F12= Cancel
             when *in12 = *ON;
               *in03=*on;
>>>>   // Put other function keys here
             other;

             // Enter:
             exsr $READC;

           endsl;

       endsr;
       //------------------------------------------------
       //*  $Error01  ** - Control Screen Validity Checking
       //------------------------------------------------
       begsr $Error01;

         clear wwERR1;

       endsr;

       //------------------------------------------------
       //*  $PositionTo  ** - Position To
       //------------------------------------------------
       begsr $PositionTo;

         // clear all 'position to' fields here:
>>>>     clear wcPOS1;
>>>>     clear wcPOS2;
>>>>     clear wcPOS3;

         clear wwRRN1;
         clear hdSFLP;

         // clear subfile:
         if *in32 = *ON;
           *in32 = *off;
           *in30 = *on;
           write SCRNC01;
           *in30 = *off;
         endif;

         // Position cursor:
         *in36 = *on;

         // Toggle to next 'position to' field:
         wwCPOS += 1;

         if wwCPOS > cc#Pos;
           wwCPOS = 1;
         endif;

         // Set 'position to' field display indicator:
         *in41 = *off;
         *in42 = *off;
         *in43 = *off;

         select;

           when wwCPOS = 1;
             *in41 = *on;

           when wwCPOS = 2;
             *in42 = *on;

           when wwCPOS = 3;
             *in43 = *on;
>>>>     // If there are more than 3 "position to" options.
         endsl;

         // Force SFL to reload for new Position To
         wwLOAD = ccYES;

       endsr;

       //------------------------------------------------
       //*  $AddRecord  ** - Add a record
       //------------------------------------------------
       begsr $AddRecord;

         // Maint pgm does not follow new standards so a popup window is used.
         wwLOAD = ccYES;
         clear dsApp2;

         a2Sec = a1Sec;
         a2Actn = ccADD;
         a2xxx1 = *zero;

         // Call add record prompt program
>>>>     // Xxx0121r(dsJld : dsApp2);

         // The following will allow you to reposition the subfile
         // with the new record at the top.
>>>>     if a2xxx1 > *zero;
>>>>       wcxxx1 = a2xxx1;
           exsr $INSFL;
         endif;

       endsr;

       //------------------------------------------------
       //*  $READC  ** - Process Subfile Requests
       //------------------------------------------------
       begsr $READC;

         clear wwERR2;
         clear wwRCDE;
         clear wwRRN#;

         // Save current RRN:
         wwcRRN = wwRRN1;

         // Read all records in the S/F:
         dow (wwRRN# < wwcRRN) and (wwERR2 <> ccERROR)
           and (wwRCDE <> ccINUSE) and (*in03 = *OFF);

           wwRRN# += 1;

           chain wwRRN# SCRNS01;

           if %found;
             *in61 = *off;

             // Option number was entered:
             if wsOPT# <> *BLANKS;

               // Check for subfile option errors:
               exsr $Error02;
               hdSFLP = wwRRN1;

               // Error occurred, return to mainline:
               select;
                 when wwERR2 = ccERROR;
                   *in61 = *on;

                 // Options 2,5 for this and called program are the same.
                 when (dsActn = ccCHANGE) or (dsActn = ccDISPLAY);
>>>>               //wwCrdGrp# = %editc(wsGrp#:'X');
>>>>               //Xxx0071r(wwCrdGrp# :wsOpt#);

                 // Delete option
                 when dsActn = ccDELETE;
>>>>               //wwCrdGrp# = %editc(wsGrp#:'X');
>>>>               //Xxx0071r(wwCrdGrp# :wsOpt#);
                   // Force reload of SFL
                   wwLOAD = ccYES;

                 // Work with option
                 when dsActn = ccWRKWTH;
                   clear dsApp3;
                   a3Sec = a1Sec;
                   a3View = 1;
>>>>               //a3xxx1 = wsxxx1;
>>>>               //Xxx0122r(dsJld :dsApp3);

               endsl;

               clear wsOPT#;
               update SCRNS01;

             endif;
           endif;

         enddo;

         // Reset current RRN:
         wwRRN1 = wwcRRN;

         clear wwRCDE;

       endsr;
       //
       //------------------------------------------------
       //*  $Error02  ** - Subfile Validity Checking
       //------------------------------------------------
       begsr $Error02;

         // Check for valid option:
         wwX = %lookup(wsOpt# : wwOpt);
         if wwX > *zero;
           dsSplt = wwINMD(wwX);
         else;
           clear DSSPLT;
         endif;

         select;

           // if indicator 90 is off, option number is not valid.
           // if indicator wwZZ is off, user is not authorized to option.

           when (wwX = *zero) or (*in(wwZZ)) = *OFF;
             wwMsgi = 'SHL0008';
             WrtErrMsg(wwMsgi);
             wwERR2 = ccERROR;

         endsl;

       endsr;

       //------------------------------------------------
       //*  *inZSR  ** - Initialize Program
       //------------------------------------------------
       begsr *inZSR;

         dsApp1 = wiApp1;

         // clear message subfile:
         RmvErrMsg(DSPGMN);

         // Default to the first 'position to' view if value not passed
         // to this program:
         // Set initial 'position to' display indicator. Also load
         // 'position to' values passed to this program (wiXXX1,2), if
         // applicable:

         wwCPOS = a1VIEW;

         select;
           when wwCPOS = *zero;
             wwCPOS = 1;
             *in40 = *on;
             *in41 = *on;
>>>>         wcXXXX1 = *zero;

           when wwCPOS = 1;
             *in40 = *on;
             *in41 = *on;
>>>>         wcXXX1 = a1xxx1;

           when wwCPOS = 2;
             *in40 = *on;
             *in42 = *on;
>>>>         wcXXX2 = a1xxx2;

           when wwCPOS = 3;
             *in40 = *on;
             *in43 = *on;
>>>>         wcXXX3 = a1xxx3;

         endsl;
         //****************************************************************
         // Field wiSEC is a 5 byte logical indicator field used to control
         // user access to all maintenance functions (eg; change, delete).
         // Each byte will have a value of either '0'(not authorized) or
         // '1'(authorized). This field will be moved into indicator
         // array *in,81.
         //
         //
         //  wiSEC = '00000'                  *in81 = Add/Copy
         //           |||||___ Work with      *in82 = Change
         //         Add|||     (Extra)        *in83 = Delete
         //            |||                    *in84 = Display
         //       Change||                    *in85 = Work with
         //             ||
         //        Delete|
         //              |
         //        Display
         //
         //****************************************************************

         // Set up security options:
         if a1Sec = *BLANKS;
           SetSecurity(dsPgmn : a1Sec);
         endif;

         // User not setup in security file:
         if a1SEC = '99999';
           a1Sec = '00000';
           wwLoad = ccNO;
           wwMsgi = 'SHL0009';
           WrtErrMsg(wwMsgi);

         else;
           // clear messages:
           RmvErrMsg(DSPGMN);

           // Set indicators 81-85
           for wwX = 1 to 5;
             wwZ = 80 + wwX;
             *in(wwZ) = %subst(a1Sec:wwX:1);
           EndFor;

           // if program is called to select a record, turn off all
           // maintenance functions:
           if a1Sel = ccYES;
             *in86 = *on;
             *in81 = *off;
             *in82 = *off;
             *in83 = *off;
             *in84 = *on;
             *in85 = *off;
           endif;

         endif;

         //****************************************************************
         // All users are authorized to any *in89 option from table wwOpt:
         //
         //        Option Named
         //            Constant
         //              |    |
         // Authorization|    |
         //     Indicator|    |
         //            |||    |
         //      Option|||    |
         //          |||||    |
         //   eg ;    282CHANGE
         //          2 82CHANGE
         //           789ITMINQ
         //          7 89ITMINQ
         //           989POINQ
         //          9 89POINQ
         //
         //  In this example, option 2 to change a record is available
         //  only to users which have authorization (*in82). option 7 to
         //  view the item inquiry and option 9 to view the PO inquiry are
         //  setup in the table with indicator *in89, therefore will be
         //  available to all users, without restriction.
         //
         //****************************************************************

         *in89 = *on;
         *in36 = *on;

       endsr;

**
186SELECT
282CHANGE
381COPY
483DELETE
584DISPLAY
885CPYCUST
984WRKWTH
