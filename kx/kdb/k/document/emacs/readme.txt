

Installing EMACS on 95/98/NT
============================
                        revision 1 - 2/17/1999

1. Go to the web at "http://www.cs.washington.edu/homes/voelker/ntemacs.html".
2. Click on the link "Where can I get precompiled versions?".
    (This is currently the second link under question 6.)
3. Choose "i386".  This takes you to an FTP site:
    ftp://ftp.cs.washington.edu/pub/ntemacs/latest/i386/
4. Choose "emacs-20.3.1-bin-i386.tar.gz".
5. The file MAY come down under a different name.  It is VERY
    important that the file name be of the form xxxxx.tar.gz.
    Rename it if necessary. You can set the name of the file
    before confirming the start of the download process.
    ** These instructions will assume you have downloaded ** 
    ** the file with the name: emacs-20_3_1.tar.gz        **                                 
6. This will begin a download of the above file to your C:\ directory.
    It takes 15 minutes on an ISDN line at 58,000 bps.  
    The file size is around 8MB.
7. Choose "Up to higher level directory".
    This will move you to: ftp://ftp.cs.washington.edu/pub/ntemacs/latest/
8. Choose "utilities"; then choose "i386".
    This will move you to: ftp://ftp.cs.washington.edu/pub/ntemacs/latest/utilities/i386/
9. Download gunzip-1.2.4-i386.exe and tar-1.11.2a.exe.  
    Rename them to gunzip.exe and tar.exe respectively.
10. In MSDOS C:\ do "gunzip emacs-20_3_1.tar.gz" to turn it into
    "emacs-20_3_1.tar" i.e. to "unzip" (decompress) it.
11. In MSDOS C:\ do "tar xvfm emacs-20_3_1.tar" to untar this.
    It will create an "emacs-20.3" directory in C:\.
12. In MSDOS C:\ do "emacs-20.3\bin\addpm.exe C:\emacs-20.3" which creates an icon
    and does some unseen but necessary installation thingies.
13. When the C:\WINNT\Profiles\... box comes up, COPY the icon with
    RIGHT MOUSE DRAG to a blank part of the desktop.
    (The directory will be different in Windows 95).
14. Right click on the new icon, select properties and append the following
    to the "Target line": " -bg black -fg limegreen -cr yellow -font fixedsys"
    ALSO, change the path in target to be "emacs-20.3" instead of "emacs".
15. Change the "Start in" line to "C:\k" or "D:\" or something else you like.
16. Put the text below (between the -cut here- lines) in a file
    named c:\.emacs *** This is VERY important ***
17. Double-click the Emacs kitchen sink icon on the desktop that 
    you made in step 13 to start the program.
18. See the file tutorial.txt at http://www.kx.com/a/k/release/emacs/ to
    learn how to use Emacs with k.  For a quick start, once Emacs is open,
    type escape,x,shell and hit enter to get a shell started in the Emacs
    window. At the $ prompt, type k, hit enter, and start having fun.

(setq explicit-shell-file-name "c:/emacs-20.3.1/bin/cmdproxy.exe")
------------cut here-----------------------------------------------------------


(setq explicit-cmdproxy.exe-args '("/q"))

(setq process-coding-system-alist
      '(("cmdproxy" . (raw-text-dos . raw-text-dos))))

(defun switch-to-previous-buffer ()
  "Switch to the previous buffer"
  (interactive)
  (switch-to-buffer (other-buffer)))

(fset 'kcopy
   [0 f7 23 25 end 25 f8])

(fset 'switch-to-buffer-return
   [-8388488 115 119 105 116 99 104 45 116 111 45 98 117 102 102 101 114
return return])

(global-set-key [f1]  'goto-line)
(global-set-key [f2]  'find-file)
(global-set-key [f3]  'write-file)
(global-set-key [f4]  'bury-buffer)
(global-set-key [f5]  'advertised-undo)
(global-set-key [f6]  'fundamental-mode)
(global-set-key [f7]  'beginning-of-line)
(global-set-key [f8]  'end-of-line)
(global-set-key [f9]  'split-window-vertically)
(global-set-key [f10] 'delete-other-windows)
(global-set-key [f11] 'other-window)
(global-set-key [f12] 'switch-to-previous-buffer)

(global-set-key [mouse-3] 'kcopy)

(setq shell-prompt-pattern ">+")

(setq auto-save-mode 0)

(setq mail-self-blind t)

(put 'eval-expression 'disabled nil)

(setq message-log-max nil)
(kill-buffer "*Messages*")

(setq default-frame-alist '((width . 80) (height . 46))) 
 