@echo off
cls
echo ************************
echo Warning! After patching you must download the following file and
echo and and put it into your Toolbar 2000 sources folder:
echo http://cvs.jrsoftware.org/view/tb2k/Source/Attic/TB2Acc.pas?only_with_tag=msaa-dev-branch
echo ************************
pause
@patch -p0 < patch.txt
pause