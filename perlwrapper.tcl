bind msgm - "tule" msg_join
bind msgm - "mene" msg_part

bind pubm - "*" pub_perlwrapper
bind msgm - "*" msg_perlwrapper

proc pub_perlwrapper {nick uhost handle chan text} {
    global lastbind
    set badchars {\>}
    set badsubs {}
    regsub -all $badchars $text $badsubs text
    set reply [ exec /home/users/rahikpa1/eggdrop/scripts-perl/perlwrapper -p $nick $uhost $handle $chan $text ]
    set lines [ split $reply "\n" ]
    foreach line $lines {
	putserv "PRIVMSG $chan :$line"
    }
    return 1
}

proc msg_perlwrapper {nick uhost handle text} {
    global lastbind
    set badchars {\>}
    set badsubs {}
    regsub -all $badchars $text $badsubs text
    set reply [ exec /home/users/rahikpa1/eggdrop/scripts-perl/perlwrapper -m $nick $uhost $handle $text ]
    set lines [ split $reply "\n" ]
    foreach line $lines {
	putserv "PRIVMSG $nick :$line"
    }
    return 1
}

proc msg_join {nick uhost handle chan arg} {
	channel add [lindex $arg 0]
}

proc msg_part {nick uhost handle chan arg} {
 	if {![validchan [lindex $arg 0]]} {
  		return 0
 	}
 	channel remove $chan
}
