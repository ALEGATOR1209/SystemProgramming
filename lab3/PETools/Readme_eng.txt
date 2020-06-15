==========================================================================
PE Tools v1.5.400.2003 Xmas Edition (for WinAll), by NEOx
Copyright [c] 2003 Underground InformatioN Center
==========================================================================

Contents:

1. The description of the program.
2. Features.
3. Configuration.
4. Command line use.
5. General notes.
6. History.
7. Credits.

1. The description of the program.
-----------------------------------
This is a fully-functional utility for working with PE/PE +(64bit) files.
Including:  Editor PE  of files,  Task Viewer, Win32 PE files  optimizer,
detector of compiler/packer and many other things.

The basic functions of the program:
+ Task Viewer
   - Dump Full
   - Dump Partial
   - Dump Region
   - Ability to dump .NET CLR processes
   - Automatic removal of protection "Anti Dump Protection"
   - Change of a priority of process
   - Kill process 
   - Loading of process into PE Editor and PE Sniffer
   - Generic OEP Finder

+ PE Sniffer
   - Search of the compiler/packer used 
   - Ability to update signature base
   - Ability to scan directories

+ PE Rebuilder
   - Optimization of a PE file
   - Change of PE address base of a file

+ PE Editor
   - Editing of DOS heading 
   - Support of new PE+(64bit) format
   - CRC correction
   - Viewing and editing tables of import/export

ATTENTION: The  Design of  this program  is very  similar to  LordPE (from
Yoda). This is done deliberately so that people which have previously used
LordPE could  easily migrate  to our  program because  PE Tools has better
functionality! Anyone disagreeing? Send your comments  to:  NEOx@Pisem.net

2. Features.
-----------------------------------
- Task viewer
  - Dump modules full
  - Dump modules partial
  - Dump process regions
  - Modify process priority
  - Anti dump protection stuff
  - Which can dump .NET CLR processes
  - Kill processes
  - Generic OEP Finder

- PE Editor
  - Editing DOS of heading
  - Support of new format PE+(64bit)
    - Edit SubSystem flag
    - Edit TimeDateStamp
    - Correct checksum
    - Edit characteristics
    - Get correct SizeOfHeaders

  - Section Table viewer
    - Edit Section Headers
      - Edit Section Header characteristics
    - DumpFixer
    - Add Section Headers
    - Delete Section Headers
    - Save Sections to disk
    - Load Sections from disk

  - Directory Table viewer
    - Export Table viewer
      - Edit Export Table
      - Edit Exported items    
    - Import Table viewer
      - Edit ImageImportDescriptors
      - Delete ImageImportDescriptors
      - Delete OriginalFirstThunk's
      - Edit thunks of ImageImportDescriptors
    - Resource Directory viewer
    - Advanced Relocation viewer
    - Tls Table editor
    - Debug Directory viewer
    - Bound Import viewer
      - Edit Load Config Directory
  - Compare PE files

- Break & Enter
  - Break at the EntryPoint of PE exe files

- PE Rebuilder
  - Dumpfix
  - Rebuilding
  - Wipe relocation
  - Validate PE (make a PE work on win2k)
  - Bind Imports
  - Change ImageBase
  
- PE Tools Dumper Server (plugin interface)


3. Configuration.
-----------------------------------
[ General ]
 - Always on top                     - Above all windows
 - Restore last directory on startup - says for itself
 - Restore last main window position - says for itself
 - Automatically check for updates   - Automatically check for updates (every day)

 Drag'n Dropped files are... - Drag'n Dropped file will be loaded in:
   - ...for the PE Editor      PE Editor
   - ...for the PE Rebuilder   PE Rebuilder
   - ...for the PE Sniffer     PE Sniffer

[ PE Rebuilder ]
 - Register Shell Extension - Put "Rebuild PE" into Windows context menu
 - Dump fix                 - Correction of PE file after memory dump
                              (this is necessary to make sure the file dumped from
                              memory will function correctly)
 - Wipe Relocation          - Removal of relocations
   - ... in Dll             - remove relocations from DLL
 - Validate PE              - Header correction to make sure fill will run on Win2k
 - Rebuild PE               - File optimization
   - ... save overlay       - overlay will be saved
                              (required for optimization of installers and SFX archives)
   - File Alignment         - set new File Alignment (default 0x200)
 - Bind Imports             - unification of imports
 - Change ImageBase to      - Alteration of file image base (only with presence of relocations)

[ Task Viewer ]
 - Full Dump: paste header from disk       - Replace PE header with copy from disk
 - Full Dump: paste import table from disk - Replace import table with copy from disk
 - Full Dump: fix header                   - PE file correction
 - Force RAW mode                          - Forced optimisation of process dump
                                             (Use when PE Tools crashes)
 - Full Dump: Force RAW mode               - PE file correction
 - Full Dump: rebuild image                - File optimization
 - Agreement required for terminations     - Confirmation needed to kill the process
 - Delete temp files                       - Delete temporary files after loading dump into PE Editor

[ PE Editor ]
 - Register Shell Extension                - Put "Load into PE Editor" into Windows context menu
 - Create backup copy (BAK-file)           - Creation of backup copy of file
 - Read Only                               - Open all files in read-only mode
 - Section Table: autofix SizeOfImage      - Automatic correction of SizeOfImage
 - Optional Header: autofix Checksum       - Automatic correction of Checksum
 - Optional Header: autofix SizeOfHeaders  - Automatic correction of SizeOfHeaders

[ PE Sniffer ]
 - Register Shell Extension - Put "Load into PE Sniffer" into Windows context menu

[ Break & Enter ]
 - Register Shell Extension                - Put "Break & Enter" into Windows context menu

4. Command line use.
-----------------------------------
PETools.exe:

/PEEDITOR pefile.exe
Loading file in PE Editor.
Only window of the editor will be displayed!

/PESNIFFER pefile.exe 
Loading file in PE Sniffer.

/REBUILDPE pefile.exe
Loading file in Rebuild PE.

/BREAKENTER pefile.exe
Loading file in Break and Enter.


5. General notes.
------------------------------------
ATTENTION! Editing PE+(64bit) files was not completely tested.


6. History.
------------------------------------
 - v1.5.400.2003 Xmas Edition - [08.12.2003]
   + Added Generic OEP Finder
   + DumpFixer added to Section Editor
   + New signatures added (Tnx: .Cryorb/dyn!o/DeMoNiX/Aster!x/FEUERRADER)
   + PE Sniffer code is optimized
   + Ability to increment SizeOfHeaders added
   + New plugin added - Recover UPX by Quantum
   + Added ToolBar
   + All options are saved in INI file now
   + Control elements are changed a little in Sections Editor and Directory Editor
   + Examples of plugins in MASM32/Delphi are added to SDK
   + Signature creation utility (SignMan) is now distributed along with the main package
   + PE Tools does NOT allow to edit IMAGE_DOS_HEADER if the offset to  
     IMAGE_OPTIONAL_HEADER is LESS then the size of IMAGE_DOS_HEADER
   + New version of update module (UUpdateSystem.dll)
   - MMF functions are re-written
   - Bug in File Location Calculator removed (Tnx: cyberbob)
   - Bug in Kill Section (from file) removed
   - Small bug in process dumper is removed
   - Bug in Task Viewer removed
   - Bug in Break & Enter removed
   - Bug with options saving is removed
   - PE Tools now works fine on Win95 (Tnx: Lepton)
   - Sections processing algorithm is significantly changed

 - v1.5.320.2003 - [27.08.2003]
   + New signatures added (Tnx: .Cryorb/BiDark/dyn!o/Mike/DeMoNiX/Volodya)
   + PE Sniffer code is optimized
   + Two new scanning methods are added to PE Sniffer: standard and heuristic ones
   - Several small bugs fixed
   + Sections manipulating algorithm is rewritten (Tnx: Volodya, SEN)
   - The following major bugs fixed (Tnx: cyberbob):
             - Full Dump: force RAW mode
             - Full Dump: rebuild image
             - Full Dump: paste header from disk

 - v1.5.300.2003 - [31.07.2003]
   - Several small bugs removed (Tnx: cyberbob)
   - PE Sniffer did not work on Win XP. Now solved. 
   - PE Sniffer code completely re-written 
   - Few new signatures added (Tnx: .Cryorb & BiDark) 
   - 3 context menu options added in Section Editor:
             - Kill Section (from header)
             - Kill Section (from file)
             - Fill Section 
   - New option added in Rebuild PE:
             - File Alignment 
   - Processes can now be killed by pressing Delete key 
   - "X" added to all dialogs :) 

 - v1.5.220.2003 - [21.07.2003]
   + Reloc Rebuilder plugin added
   + "Explorer..." entry added to PE Sniffer and Task Viewer menu
   + Serious bug removed from PE Sniffer
   + Some new packer signatures added
   - Bug in Debug Directory removed
   - Some fields were not displayed correctly in PE Editor, fixed now

 - v1.5.110.2003 - [13.07.2003]
   - Nasty bug corrected (error when exiting a program from Win XP)

 - v1.5.109.2003 - [10.07.2003]
   + New process priorities added: Above Normal and Below Normal (only for Win 2000)
   + "?" button added for SizeOfImage
   + Display of SoftICE status added (Loaded/Not Loaded)
   + File Location Calculator added
   + Ability to edit Load Config Directory added
   + Algorithm for process of Table Imports re-written (Tnx: Volodya/WASM.RU)
   + Signature base updated to 339 signatures (Tnx: .Cryorb & BiDark)
   + PE Sniffer can now scan whole directories
   + New options for PE Sniffer:
             - Directory Scan: Skip invalid PE files
             - Directory Scan: Scan subfolders
   + Signature base format changed a little bit
   + Procedure for identification of signatures is improved
   + New options added:
            [ General ]
               - Drag'n Dropped files are...for the PE Sniffer

            [ PE Sniffer ]
               - Register Shell Extension

            [ Task Viewer ]
               - Force RAW mode
               - Display SoftICE status

            [ PE Rebuilder ]
              - Register Shell Extension
   - Some visual bugs removed
   - Many bugs in Update System removed
   - Other small bugs removed
   - Removed Command Line bug
   + New comands added for working in Cmd Line:
              - "/PESNIFFER"
              - "/REBUILDPE"

 - v1.4.419.2003 - [21.03.2003]
   - Interface bugs corrected
   + Program can now correctly dump processes protected by tElock
   + uinC Update System added

 - v1.4.380.2003 - [08.03.2003]
   - all those little bugs removed
   - Dump Region did not work in WinXP, now fine :)
   + In PE Sniffer has more than 15 new signatures
   + In "Dump Region." "Refresh" button is added
   + Bind Imports is added in the "PE Rebuilder"
   + Refreshing list of processes/modules can now be done by pressing F5
   + Comparison of section is added (there was only PE header comparison before)
   - TimeDate Stamp converter (GMT) added
   + Additional improvements:
          [PE Editor]
             - Create backup copy (BAK-File)
             - Read only
             - Section Table: autofix SizeOfImage
             - Optional Header: autofix Checksum
             - Optional Header: autofix SizeOfHeaders [PE Rebuilder]
             - Bind Imports

          [Break and Enter]
             - Register Shell Extension

          [Task Viewer]
            - Agreement required for terminations
            - Delete temp files

   + The ability to load process dump into PE Editor
   + Ability to load process dump into PE Sniffer

 - v1.4.356.2003 Alpha - [28.01.2003]
   + No more program sourcecode is released as some people have started
     compiling my programs under their own name and then distributed them. Bastards.

   - Window size & restore bug is removed
   + The Design of the program is changed to look similar to famous utilities(ProcDump/LordPE)
     for convenience of use
   + All sourcecode completely is re-written
   + PE files processing module is completely re-written (Memory Mapped Files are used now)
   + The program is written using 95% pure(clean) API. Old versions needed MFC
   - One more bug in processing section corrected (If the name of section was 8 symbols,
     the program gave out various symbols.)
   + New options are added
   + The ability of choosing various parameters of PE header fields is added.
     (now there is no necessity to rummage in the documentation on PE format to change
     something simple, e.g. characteristics of section)
   + Support new PE+(64bit) a format is added.
   + Comparison PE of files (only for PE a format) is added.
   + Correction of file CRC is added
   + Correction of SizeOfHeaders
   + Editing the table of import/export is added
   + Editing table TLS
   + Resource Directory Viewer added
   + Bound Import viewer added
   + Bound Import viewer added
   + Debug Directory viewer added
   + Relocation Table viewer added
   + Added Task Viewer
   + Added PE Tools Dumper Server
   + Added PE Rebuilder (only for PE a format)
   + Added Break and Enter
   + Added PE Sniffer
   + PlugIn system added

 - v1.3 Build 60 - [09.12.2002]
   - Again bugs corrected in sections processing code

 - v1.3 Build 54 - [24.08.2002]
   + Now program automatically chooses a method of opening of files (Full access or Read-Only)
   + The program displays section which has entrypoint
   + It Is added Drag-Drop
   + Additional functions to work with sections are added
   + Code for PE files processing is re-written again
   - Bugs related to section processing are removed

 - v1.3 - [01.06.2002]
   * The program is renamed to PE Tools (Thanks to NiFi)
   + Now the program can edit DOS-compatible header
   + New features: backup copy creation and opening of files in read-only mode
   + Pprocedure of identification of PE-files is considerably improved
   - Bug with opening files is removed

 - v1.2 - [13.05.2002]
   - Some bugs corrected
   + Now the program does not open Read-Only files. As it causes big bug
   + Sources are now given away with the binaries

 - v1.1 - [07.05.2002]
   * First public release. GUI application
   - bug with sections is corrected
   + Functions for working with PE files are completely re-written
   + Preservation of changes warning is added
   + Process of command line is added
   + Additional types of processors in Advanced Information

 - v1.0 - [03.02.2002]
   * It was a console version, very buggy, was not distributed
   * Lots of bugs when working with sections, and many others
   * Program referred to as PE Editor

7. Credits.
-----------------------------------
        NiFi/uinC           - Graphics, ideas and many other things
        Corbio/uinC         - Testing under Win2k
        SOLDIER/uinC        - Testing under Win98
        Rook/uinC           - Remarks on interface 
        Dr. Golova/uinC     - Help in creation of Break and Enter and
                              PE Rebuilder
        SunteXx             - Testing under WinXP
        http://www.geocities.com/winhider
        Vladimir Vilman     - Testing
        JFX                 - Testing
        dum0h               - Testing under WinXP
        http://flashlib.kursknet.ru
        .Cryorb             - Many thanks for timely additions to signature base of
                              PE Sniffer, also many thanks for your thorough testing
        Volodya/WASM.RU     - Thanks for bugreports, excellent ideas and etc...
        http://www.wasm.ru
        BiDark              - Thanks for your wonderful bugreports and new signatures
        spEctoRius          - Testing under WinXP
        http://www.spectorius.narod.ru/
        cyberbob            - Thanks for your wonderful bugreports
        http://www.darmozjad.host.sk
        FEUERRADER          - Testing under WinME, Unofficial PE Tools homepage
        http://www.feuerrader.tk
        .::D.e.M.o.M.i.X::. - Thanks for your bugreports and new signatures
        http://reversing.kulichki.net
        dyn!o               - Thanks for your wonderful bugreports and new signatures
        Bad_Guy             - Thanks for your bugreports and ideas
        http://cracklab.narod.ru
        Aster!x             - Thanks for your bugreports and ideas
        a_sterix_44_1@mail.ru
        lepton              - Testing under Win95


Your improvements, suggestions and bugfixes are welcomed. Happy New Year ;)
Best regards, NEOx

=== by NEOx [E-Mail: NEOx@Pisem.net] =============== 08.12.03 ============
=== [c] Underground Information Center [ http://www.uinc.ru ] ============